# Crowdstrike-Deploy Banner
#region
Write-Output ""
Write-Output "  ██████╗██████╗  ██████╗ ██╗    ██╗██████╗ ███████╗████████╗██████╗ ██╗██╗  ██╗███████╗"
Write-Output " ██╔════╝██╔══██╗██╔═══██╗██║    ██║██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██║██║ ██╔╝██╔════╝"
Write-Output " ██║     ██████╔╝██║   ██║██║ █╗ ██║██║  ██║███████╗   ██║   ██████╔╝██║█████╔╝ █████╗"  
Write-Output " ██║     ██╔══██╗██║   ██║██║███╗██║██║  ██║╚════██║   ██║   ██╔══██╗██║██╔═██╗ ██╔══╝"  
Write-Output " ╚██████╗██║  ██║╚██████╔╝╚███╔███╔╝██████╔╝███████║   ██║   ██║  ██║██║██║  ██╗███████╗"
Write-Output "  ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚══════╝"
Write-Output ""                                                                                       
Write-Output "                     ██████╗ ███████╗██████╗ ██╗      ██████╗ ██╗   ██╗"                 
Write-Output "                     ██╔══██╗██╔════╝██╔══██╗██║     ██╔═══██╗╚██╗ ██╔╝"                 
Write-Output "                     ██║  ██║█████╗  ██████╔╝██║     ██║   ██║ ╚████╔╝"                  
Write-Output "                     ██║  ██║██╔══╝  ██╔═══╝ ██║     ██║   ██║  ╚██╔╝"                   
Write-Output "                     ██████╔╝███████╗██║     ███████╗╚██████╔╝   ██║"                    
Write-Output "                     ╚═════╝ ╚══════╝╚═╝     ╚══════╝ ╚═════╝    ╚═╝"
Write-Output ""
Write-Output "                           Created & Maintained by: Eilay Yosfan"
Write-Output "                                   GitHub.com/YosfanEilay"
Write-Output "                                        Version: 1.0"
Write-Output ""
#endregion


###### Please Paste Your Information in Here ######
$SensorLink = "" # Crowdstrike Sensor Download Link
$OriginalSensorHash = "" # Crowdstrike Sensor Hash (SHA256)
$TenantName = "" # Crowdstrike Tenant Name
$TenantCID  = "" # Crowdstrike Tenant CID
###################################################


# Prerequisite Variable Load
$Hostname = hostname
$RunPath  = Get-Location
$DstPath  = "$RunPath\CrowdstrikeSensor.exe"


# Test if Host is Connected to the internet
$PingStatus = Test-Connection -ComputerName 8.8.8.8 -Count 2 -ErrorAction SilentlyContinue | Select-Object -Property *
if ($PingStatus) {
    Write-Output "[+] Host is connected to the internet."
}
else {
    Write-Output "[!] Host is not connected to the internet."
    exit
}


# Test Connection to OneDrive
$PingStatus = Test-Connection -ComputerName "onedrive.live.com" -Count 2 -ErrorAction SilentlyContinue | Select-Object -Property *
if ($PingStatus) {
    Write-Output "[+] OneDrive is reachable."
}
else {
    Write-Output "[!] OneDrive is not reachable, might be related to host network or organization policy. Deploy might fail."
}


# Download Crowdstrike Sensor
Write-Output "[+] Download has started. The time required will depend on the host's bandwidth."
(New-Object System.Net.WebClient).DownloadFile($SensorLink, $DstPath)


# Check if the Downloaded Sensor File is Corrupted
$DownloadedSensorHash = (Get-FileHash -Algorithm SHA256 -Path $DstPath).hash
if ($OriginalSensorHash -eq $DownloadedSensorHash) {
    Write-Output "[+] Crowdstrike sensor was successfully downloaded. Sensor installtion started."
}
else {
    Write-Output "[!] The sensor file is corrupted, likely due to an interrupted download. you can try again."
    Remove-Item -Path $DstPath -Force -ErrorAction SilentlyContinue | Out-Null
    exit
}


# Start Crowdstrike Installation Process
.$DstPath /install /quiet CID=$TenantCID
Start-Sleep -Seconds 60


# Print Success Message
Write-Output "[+] Done. $Hostname will be available on host management under the tenant $TenantName in 5-10 minutes."
Write-Output ""