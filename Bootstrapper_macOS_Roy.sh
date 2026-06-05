#!/bin/sh
# Check if Application Workspace is already installed
if [ -d "/Applications/Liquit.app" ]; then
exit 0
fi
#
# Create folder /tmp/ApplicationWorkspace/
if [ ! -d "/tmp/ApplicationWorkspace/" ]; then
    mkdir -p "/tmp/ApplicationWorkspace/"
fi
#
#==================================================================================================
# De waarden die gewijzigd moeten worden bevinden zich hieronder
#
# Dit zijn het Certificaat, identitySource en als laatse de waarde van --zone in de opdrachtregel
#
#==================================================================================================
#
# -------------------------------
# WRITE CERTIFICATE
# -------------------------------
cat <<'EOF' > "/tmp/ApplicationWorkspace/AgentRegistration.cer"
-----BEGIN CERTIFICATE-----
hjhjkhjkjhkhkhkhkhkhkhkhkhkhkh
-----END CERTIFICATE-----
EOF
#
# -------------------------------
# AGENT JSON
# -------------------------------
cat <<'EOF' > "/tmp/ApplicationWorkspace/Agent.json"
{
    "zone": "https://donny.liquit.com/",
    "restrictZones": true,
    "registration": {
        "type": "Certificate"
    },
    "login": {
        "sso": true,
        "identitySource": "DonnyFunny"
    },
    "log": {
        "level": "Debug"
    },
    "deployment": {
        "enabled": true,
        "start": false,
        "autoStart": {
            "enabled": true,
            "deployment": "macOS Deployment"
        }
    }
}
EOF
#
#
# Download the files
curl -o "/tmp/ApplicationWorkspace/AgentBootstrapper-Mac-4.4.4130.3708" "https://download.liquit.com/extra/Bootstrapper/AgentBootstrapper-Mac-4.4.4130.3708"
#
# Install with Liquit Agent BootStrapper
sudo chmod +x "/tmp/ApplicationWorkspace/AgentBootstrapper-Mac-4.4.4130.3708"
sudo xattr -dr com.apple.quarantine "/tmp/ApplicationWorkspace/AgentBootstrapper-Mac-4.4.4130.3708"
cd "/tmp/ApplicationWorkspace/" || exit
sudo /tmp/ApplicationWorkspace/AgentBootstrapper-Mac-4.4.4130.3708 --registrationType Certificate --logPath /tmp/ApplicationWorkspace --wait --certificate /tmp/ApplicationWorkspace/AgentRegistration.cer --startDeployment

exit 0