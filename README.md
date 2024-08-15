# Crowdstrike-Deploy 1.0v
![Akzidenz-Grotesk (1)-modified](https://github.com/YosfanEilay/Crowdstrike-Deploy/assets/132997318/0efe4f7d-ea13-4ff3-a92a-60ba90f1a7a0)

## What is Crowdstrike Deploy?
(Short answer: This tool can deploy Crowdstrike from Microsoft Defender Live Response or Palo Alto XDR Live Terminal and even on a local machine)
</br> </br>
Have you ever been in an incident response situation where the only remote investigation tool available was something like Microsoft Defender? We all know the limitations of Microsoft Defender's Live Response, especially when it comes to executing PowerShell commands during a session.
</br> </br>
That's why I created Crowdstrike Deploy! Crowdstrike Deploy is the ultimate solution for incident responders who need to deploy Crowdstrike sensors quickly and discreetly from the client Live Terminal\Live Response EDR tool.
No longer do you have to wait for the client's IT team to find time to install your Crowdstrike sensor. With Crowdstrike Deploy, you can install the Crowdstrike sensor secretly, without triggering any alerts on the client's side.
</br> </br>
Whether your client is using Palo Alto XDR Live Terminal, Microsoft Defender Live Response, or even if there is no EDR solution in place, Crowdstrike Deploy gets the job done with a single push of a button. Save precious time, take control of the situation, and stop incidents in their tracks with Crowdstrike Deploy!
###### "Deploy Fast, Defend Faster."</br>

## Support Table
This table represents the current platforms supported by Crowdstrike Deploy.
| Operation System   | Support Status  | Cloud Service  | Support Status  | Platforms          | Support Status |
|:------------------:|:---------------:|:--------------:|:---------------:|:------------------:|:--------------:|
| Windows 10         | ✔               | OneDrive       | ✔              | Locally            | ✔              |
| Windows 11         | ✔               | Dropbox        | ✖              | Falcon Crowdstrike | ✔              |
| Linux              | ✔               | Google Drive   | ✖              | Microsoft Defender | ✔              |
| Mac                | ✖               | MEGA           | ✖              | Palo Alto XDR      | ✔              |


## How to Configure Crowdstrike Deploy?
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
