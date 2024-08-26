3##################################################################################
# Azure Automation Runbook for exporting License Usage Information with Liquit   #
# Workspace PowerShell Module and sending it to an Azure storage account         #
#          																		 #
# Created by Don van der Linde                                                   #
##################################################################################

# Variables              
$resourceGroupName = "<my-resource-group-name>"  
$StorageAccount = "<my-storage-account>"
$Container = "<my-container>" 
$TempFolder = "$env:Temp"
$date = get-date -Format "MMddyyyy"
$CSVFileName = "License_Info_$date.csv"
$KeyVaultName = "<my-keyvault-name>"
$KeyVaultSecretPwd = "<my-keyvault-secret-name>"
$KeyVaultSecretUsr = "<my-keyvault-secret-name>"
$KeyVaultSecretUrl = "<my-keyvault-secret-name>"

# Prvevent inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process | Out-Null

# Retrieving credentials with Azure Key Vault
Connect-AzAccount -Identity
	
$Key = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $KeyVaultSecretPwd -AsPlainText
$password = ConvertTo-SecureString -String $key -AsPlainText -Force
$usr = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $KeyVaultSecretUsr -AsPlainText
$url = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $KeyVaultSecretUrl -AsPlainText

# Connect to Liquit Workspace
$Credentials = New-Object System.Management.Automation.PSCredential $usr,$password
Connect-LiquitWorkspace -URI $url -Credential $credentials

# Get License Info
$info = Get-LiquitZone
$info.License | Export-CSV $TempFolder\$CSVFileName -Append -NoTypeInformation  

# Send it to  Azure Storage Account
$StorageAccount = Get-AzStorageAccount -Name $StorageAccount -ResourceGroupName $ResourceGroupName
try {
    $null = Set-AzStorageBlobContent -File $TempFolder\$CSVFileName -Container $Container -Blob $CSVFileName -Context $StorageAccount.Context -Force -ErrorAction Stop
}
catch {
    Write-Error -Exception $_ -Message "Failed to upload $CSVFileName to Azure Blob Storage"
}



