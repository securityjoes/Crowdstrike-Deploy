# Crowdstrike-Deploy 1.1v
###### “Don’t settle for anything less — be the best when it matters most.” </br>
![ChatGPT Image Apr 9, 2025, 10_21_17 AM](https://github.com/user-attachments/assets/befbe76a-c2d5-4951-b2b8-bfdff873482a)
###### Created & Maintained by: [Eilay Yosfan](https://github.com/YosfanEilay#-eilay-yosfan)

## What is Crowdstrike Deploy?
Have you ever been in an incident response situation where the only remote investigation tool available was something like Microsoft Defender? We all know the limitations of Microsoft Defender's Live Response, especially when it comes to executing live PowerShell/Bash scripts during an IR.
</br> </br>
That’s why I created Crowdstrike Deploy — a cross-platform toolkit designed for incident responders. It enables fast, discreet deployment of the CrowdStrike sensor across Linux, Windows, and macOS environments
</br> </br>
No longer do you have to wait for the client's IT team to coordinate Crowdstrike installations for you, now you can do it secretly by yourself. Whether you're working through Palo Alto XDR Live Terminal, Microsoft Defender Live Response, or on any EDR solution that you don't really like to work with, Crowdstrike Deploy empowers you to take control and deploy it!
</br> </br>
This repository includes a wide variety of deployment methods, so read the whole `README.md` and choose what method fits your case.
###### "Deploy Fast, Defend Faster."</br>

## Method 1 - Deploying Crowdstrike From Dropbox
This method involves uploading the CrowdStrike sensor installation file to Dropbox, then using a script to download the sensor from Dropbox and install it on the host.
1. Download the latest version of `CrowdStrike-Deploy` by clicking the green `<> Code` button, then selecting `Download ZIP`.
2. Select your operating system, navigate to the `Method_1` folder, and download the corresponding deployment script.
3. Open the script in a text editor and configure the following 4 variables:

```
# These variables are from the Windows script, but they are the same for Linux and macOS.
###### Please Paste Your Information in Here ######
$SensorLink = "" # Crowdstrike Sensor Download Link
$SensorSig1 = "" # Crowdstrike Sensor Hash (SHA256)
$TenantCID  = "" # Crowdstrike Tenant CID
$TenantName = "" # Crowdstrike Tenant Name
###################################################
```
- [How to configure - $SensorLink](https://www.youtube.com/watch?v=k6xvaop8qBE)
- [How to configure - $SensorSig1](https://www.sharepointdiary.com/2022/08/how-to-get-file-hash-using-powershell.html)
- [How to configure - $TenantCID](https://www.dell.com/support/kbdoc/en-il/000129349/how-to-obtain-the-crowdstrike-cid)
- How to configure - $TenantName (Just paste the tenant name.)

4. That’s it, you can now run the tool. If no errors occur, CrowdStrike has been successfully installed.

## Method 2 - Split Sensor into Parts, Rebuild it, Deploy it
###### The below example is how to deploy Falcon Crowdstrike from Microsoft Defender live terminal on a Linux Ubuntu machine.
This method is intended for situations where the host you want to deploy CrowdStrike on is behind a WAF and a policy that disables the use of third-party cloud storage. In such cases, you can't use Method 1—for example, if the host is unable to download files from Dropbox due to the WAF restrictions, so this method is perfect for you.
1. Download the latest version of `CrowdStrike-Deploy` by clicking the green `<> Code` button, then selecting `Download ZIP`.
2. Select your operating system, navigate to the `Method_2` folder, and download the corresponding deployment script.
3. Open the script in a text editor and configure the following 6 variables:

```
####################### Please Paste Your Information in Here ##############
Operation=""             # Choose operation: "Split" or "Deploy"
Parts=""                 # Number of parts to split the file into
OriginalFilePath=""      # Full path to the original file (for splitting)
SplittedFilesLocation="" # Path where split parts are stored (for deploying)
CrowdstrikeCID=""        # Tenant CID string
TenantName=""            # Display name for tenant (for logging)
############################################################################
```
So why this method is working like this? in Microsoft defender there is a library upload limit, somthing like 10MB, so you can't upload the Crowdstrike sensor to the Defender library and just deploy it. so this method make it work.
1. This part your are doing on your own Linux host, not the host you want to deploy Crowdstrike on, so start by editing the script, change `Operation` to "Split" `Parts` to "6" and `OriginalFilePath` to the sensor path.
2. Run the script, and upload the 6 parts to Defender library and then upload them from Defender library in to the host. (the default library upload path on Defender is "/var/opt/microsoft/mdatp/response")
3. Edit the script to "Deploy" and fill in the rest of the information, and run the tool again, deploy mode is not only rebuilds the sensor it is also automatically initiates a sensor installation
And that's it, now you have CrowdStrike on this host.
Important Notice: In `SplittedFilesLocation` use this location "/var/opt/microsoft/mdatp/response" as this is the default path that stores the file you upload from Defender library 

## Need Help?
Found a bug? Need help? do you want to add a feature? </br>
Don't hesitate to contact me by [creating an issue](https://github.com/YosfanEilay/Crowdstrike-Deploy/issues/new).
