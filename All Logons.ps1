$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force

$credential = Get-Credential

#Office365
Connect-MsolService -Credential $credential
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

#SharePoint
$domainHost="<domain host name, such as litware for litwareinc.onmicrosoft.com>"
Connect-SPOService -Url https://$domainHost-admin.sharepoint.com -credential $credential

#SfB
Import-Module SkypeOnlineConnector
$sfboSession = New-CsOnlineSession -Credential $credential
Import-PSSession $sfboSession

#EXO
$exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $credential -Authentication "Basic" -AllowRedirection
Import-PSSession $exchangeSession

#Security & Compliance Center
$SccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $credential -Authentication "Basic" -AllowRedirection
Import-PSSession $SccSession -Prefix cc