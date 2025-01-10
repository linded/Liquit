#!/bin/sh
# This script will install Application Workspace Universal Agent on macOS with the Bootstrapper.
# Author Donny van der Linde
# Version 1.0
# Date created 08-01-2025
# Copyright 2025 Recast Software

# This code is provided "as is," with no guarantees or warranties of any kind
# The user assumes all risks associated with the use and results of this code.

# Set variables
destinationFolder="/tmp/ApplicationWorkspace/"
bootstrapper_download_url="https://download.liquit.com/extra/Bootstrapper/"
container_url="https://liquittest.blob.core.windows.net/donny/"
sas_token="<my-sas-token>"

container="macOS/"
strapper="AgentBootstrapper-Mac-2.1.0.2"
cert="AgentRegistration.cer"
config="Agent.json"

# Check if Application Workspace is already installed
if [ -d “/Applications/Liquit.app” ]; then
exit 0
fi

# Create folder /tmp/Liquit/
if [ ! -d "$destinationFolder" ]; then
    mkdir -p "$destinationFolder"
fi

# Download the files
curl -o "${destinationFolder}${strapper}" "${bootstrapper_download_url}${strapper}"
curl -o "${destinationFolder}${cert}" "${container_url}${cert}${sas_token}"
curl -o "${destinationFolder}${config}" "${container_url}${container}${config}${sas_token}"

# Install with Liquit Agent BootStrapper
sudo chmod +x "${destinationFolder}${strapper}"
sudo xattr -dr com.apple.quarantine "${destinationFolder}${strapper}"
cd "$destinationFolder" || exit
sudo ./"${strapper}" --startDeployment --waitForDeployment --logPath="${destinationFolder}" --certificate="./${cert}"

exit 0
