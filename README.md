# Crowdstrike-Deploy 1.1v
![ChatGPT Image Apr 9, 2025, 10_21_17 AM](https://github.com/user-attachments/assets/befbe76a-c2d5-4951-b2b8-bfdff873482a)
###### “Don’t settle for anything less — be the best when it matters most.” </br>
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
This method involves uploading the CrowdStrike sensor to Dropbox, then using a script to download the sensor from Dropbox and install it on the host.
1. Download the latest version of `CrowdStrike-Deploy` by clicking the green `<> Code` button, then selecting `Download ZIP`.
2. Select your operating system, navigate to the `Method_1` folder, and download the corresponding deployment script.
3. Open the script in a text editor and configure the following 4 variables:

```
# this variables is from the windows script but its the same for Linux/Mac
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

## Need Help?
Found a bug? Need help? do you want to add a feature? </br>
Don't hesitate to contact me by [creating an issue](https://github.com/YosfanEilay/Crowdstrike-Deploy/issues/new).
