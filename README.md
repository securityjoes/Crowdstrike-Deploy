# Crowdstrike-Deploy 1.1v
![Akzidenz-Grotesk (1)-modified](https://github.com/YosfanEilay/Crowdstrike-Deploy/assets/132997318/0efe4f7d-ea13-4ff3-a92a-60ba90f1a7a0)

## What is Crowdstrike Deploy?
Have you ever been in an incident response situation where the only remote investigation tool available was something like Microsoft Defender? We all know the limitations of Microsoft Defender's Live Response, especially when it comes to executing live PowerShell/Bash scripts during an IR.
</br> </br>
That’s why I created Crowdstrike Deploy — a cross-platform toolkit designed for incident responders. It enables fast, discreet deployment of the CrowdStrike sensor across Linux, Windows, and macOS environments
</br> </br>
No longer do you have to wait for the client's IT team to coordinate Crowdstrike installations for you, now you can do it secretly by yourself. Whether you're working through Palo Alto XDR Live Terminal, Microsoft Defender Live Response, or on any EDR solution that you don't really like to work with, Crowdstrike Deploy empowers you to take control and deploy it!
</br> </br>
This repository includes a wide variety of deployment methods, so read the whole `README.md` and choose what method fits your case.
###### "Deploy Fast, Defend Faster."</br>

## Method 1
First, you need to configure the following variable inside the Crowdstrike-Deploy.ps1 code:
 
```PowerShell
###### Please Paste Your Information in Here ######
$SensorLink = "" # Crowdstrike Sensor Download Link
$SensorSig1 = "" # Crowdstrike Sensor Hash (SHA256)
$TenantCID  = "" # Crowdstrike Tenant CID
$TenantName = "" # Crowdstrike Tenant Name
###################################################
```
1. Create a OneDrive direct download link for your Crowdstrike sensor, and paste it inside `$SensorLink = ""`. </br>
  1.1 [How to download Crowdstrike sensor.](https://www.dell.com/support/kbdoc/en-il/000156053/how-to-download-the-crowdstrike-falcon-sensor). </br>
  1.2 [How to create a OneDrive direct download link.](https://www.youtube.com/watch?v=eUF8NZPuM_4&t=88s) </br>

2. Create a SHA256 file signature for your Sensor file and paste it inside `$SensorSig1 = ""`. </br>
 2.1 [How to create a SHA256 file signature.](https://www.se.com/my/en/faqs/FAQ000244427/)

3. Copy your tenant CID and paste it inside `$TenantCID  = ""`. </br>
 3.1 [How to get your tenant CID.](https://www.dell.com/support/kbdoc/en-us/000129349/how-to-obtain-the-crowdstrike-cid) </br>

4. Copy your tenant name and paste it inside `$TenantName = ""`. </br>

## How to use Crowdstrike Deploy?
After you finished configuring the necessary variables inside the code, </br>
you can now execute the tool in any supported environment you want! </br>

#### Local Machine Deploy Guild
1. Open PowerShell and execute Crowdstrike-Deploy.ps1, that's it.

#### Microsoft Defender Deploy Guide
1. Choose a machine and initiate a Live Response session.
2. Upload Crowdstrike-Deploy.ps1 to the Defender library.
3. Run the script from the Live Response session.
4. Done.

#### Palo Alto XDR Deploy Guild
1. Choose a machine and initiate Live a Live Terminal.
2. From the Live Terminal upload Crowdstrike-Deploy.ps1 to the machine.
3. Click on "PowerShell" and execute Crowdstrike-Deploy.ps1.
4. Done.
   
## How to use Crowdstrike Deploy on Linux?
Just drop the file locally on your machine or any platform mentioned above </br>
and run the "Crowdstrike-Deploy.sh" bash script as root, like in this example:
```
eilay@UBUSRV01:~$ sudo ./Crowdstrike-Deploy.sh
```

## Need Help?
Found a bug? Need help? do you want to add a feature? </br>
Don't hesitate to contact me by [creating an issue](https://github.com/YosfanEilay/Crowdstrike-Deploy/issues/new).
