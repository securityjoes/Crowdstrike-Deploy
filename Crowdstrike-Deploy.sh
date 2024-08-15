#!/bin/bash

# Crowdstrike-Deploy Banner
echo ""
echo "  ██████╗██████╗  ██████╗ ██╗    ██╗██████╗ ███████╗████████╗██████╗ ██╗██╗  ██╗███████╗"
echo " ██╔════╝██╔══██╗██╔═══██╗██║    ██║██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██║██║ ██╔╝██╔════╝"
echo " ██║     ██████╔╝██║   ██║██║ █╗ ██║██║  ██║███████╗   ██║   ██████╔╝██║█████╔╝ █████╗"  
echo " ██║     ██╔══██╗██║   ██║██║███╗██║██║  ██║╚════██║   ██║   ██╔══██╗██║██╔═██╗ ██╔══╝"  
echo " ╚██████╗██║  ██║╚██████╔╝╚███╔███╔╝██████╔╝███████║   ██║   ██║  ██║██║██║  ██╗███████╗"
echo "  ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚══════╝"
echo ""                                                                                       
echo "                     ██████╗ ███████╗██████╗ ██╗      ██████╗ ██╗   ██╗"                 
echo "                     ██╔══██╗██╔════╝██╔══██╗██║     ██╔═══██╗╚██╗ ██╔╝"                 
echo "                     ██║  ██║█████╗  ██████╔╝██║     ██║   ██║ ╚████╔╝"                  
echo "                     ██║  ██║██╔══╝  ██╔═══╝ ██║     ██║   ██║  ╚██╔╝"                   
echo "                     ██████╔╝███████╗██║     ███████╗╚██████╔╝   ██║"                    
echo "                     ╚═════╝ ╚══════╝╚═╝     ╚══════╝ ╚═════╝    ╚═╝"
echo ""
echo "                           Created & Maintained by: Eilay Yosfan"
echo "                                   GitHub.com/YosfanEilay"
echo "                                        Version: 1.0"
echo ""

###### Please Paste Your Information in Here ######
SensorLink='' # Crowdstrike Sensor Download Link
SensorSig1="" # Crowdstrike Sensor Hash (SHA256)
TenantCID=""  # Crowdstrike Tenant CID
TenantName="" # Crowdstrike Tenant Name
###################################################

# Prerequisite Variable Load
Hostname=$(hostname)
RunPath=$(pwd)
DstPath="$RunPath/CrowdstrikeSensor.deb"

# Check if the script is run as root (or with sudo)
if [ "$EUID" -ne 0 ]; then
    echo "[!] This script must be run as root. Please use 'sudo ./Crowdstrike-Deploy.sh'."
    exit 1
fi

# Test if Host is Connected to the internet
if ping -c 2 8.8.8.8 &> /dev/null; then
    echo "[+] Host is connected to the internet."
else
    echo "[!] Host is not connected to the internet."
    exit 1
fi

# Test Connection to OneDrive
if ping -c 2 "onedrive.live.com" &> /dev/null; then
    echo "[+] OneDrive is reachable."
else
    echo "[!] OneDrive is not reachable, might be related to host network or organization policy. Deploy might fail."
fi

# Download Crowdstrike Sensor
echo "[+] Download has started. The time required will depend on the host's bandwidth."
echo # Blank Line
curl -L -o CrowdstrikeSensor.deb -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36" "$SensorLink"

# Check if the Downloaded Sensor File is Corrupted
SensorSig2=$(openssl sha256 "$DstPath" | awk '{print $2}')
if [ "$SensorSig1" == "$SensorSig2" ]; then
    echo "[+] Crowdstrike sensor was successfully downloaded. Sensor installation started."
else
    echo "[!] The sensor file is corrupted, likely due to an interrupted download. You can try again."
    rm -f "$DstPath"
    exit 1
fi

# Start Crowdstrike Installation Process
echo # Blank Line
echo "[+] Showing installation process.. [60 seconds]"
dpkg -i "CrowdstrikeSensor.deb"
sleep 60
/opt/CrowdStrike/falconctl -s --cid="$TenantCID"
systemctl start falcon-sensor

# show that falcon crowdstrike sensor process is running using ps aux
echo # Blank Line
echo "[+] Showing that falcon is indeed running."
ps aux | grep "falcon"
echo # Blank Line

# Print Success Message
echo "[+] Done. $Hostname will be available on host management under the tenant $TenantName in 5-10 minutes."
echo ""
