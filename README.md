# Crowdstrike-Deploy 1.0v
![Akzidenz-Grotesk (1)-modified](https://github.com/YosfanEilay/Crowdstrike-Deploy/assets/132997318/0efe4f7d-ea13-4ff3-a92a-60ba90f1a7a0)

## What is Crowdstrike Deploy?
Have you ever been in an incident response situation where the only remote investigation tool available was something like Microsoft Defender? We all know the limitations of Microsoft Defender's Live Response, especially when it comes to executing PowerShell commands during a session.
</br> </br>
That's why I created Crowdstrike Deploy! Crowdstrike Deploy is the ultimate solution for incident responders who need to deploy Crowdstrike sensors quickly and discreetly. No longer do you have to wait for the client's IT team to find time to install your Crowdstrike sensor? With Crowdstrike Deploy, you can install the Crowdstrike sensor secretly, without triggering any alerts on the client's side.
</br> </br>
Whether your client is using Palo Alto XDR Live Terminal, Microsoft Defender Live Response, or even if there is no EDR solution in place, Crowdstrike Deploy gets the job done with a single push of a button. Save precious time, take control of the situation, and stop incidents in their tracks with Crowdstrike Deploy!
###### "Deploy Fast, Defend Faster."</br>

## Support Table
This table represents the current platforms supported by Crowdstrike Deploy.
| Operation System   | Support Status  | Cloud Service  | Support Status  |     
|:------------------:|:---------------:|:---------------:|:---------------:|
| Windows 10         | ✔               | OneDrive        | ✔              |
| Windows 11         | ✔               | Dropbox         | ✖              |
| Linux              | ✖               | Google Drive    | ✖              |
| Mac                | ✖               | MEGA            | ✖              |

## How to Configure Crowdstrike Deploy?
To start working with Crowdstrike Deploy you need to configure the following inside the code:
 
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
