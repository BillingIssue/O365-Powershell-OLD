###
#Execution Policy + Local Path definition

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

###
#DEFINE YOUR COMPANY'S SITE COLLECTION

$orgName = "Input your site collection"


###
#Login into O365 and SharePoint

Import-Module MsOnline 
Connect-MsolService -Credential $credential

Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
Connect-SPOService -Url https://$orgName-admin.sharepoint.com -Credential $credential

###
#Site array gain + Export to CSV

get-sposite -includepersonalsite:$true -Limit ALL | where {$_.Url -like "*personal*"} |Select-Object Url | Export-Csv "$ScriptDir\PSCLog.csv" -NoTypeInformation
clear-host
write-host "CSV File Generated"

###
#Site URL Import from CSV + Site Deletion

$number = 1
$psc = Import-Csv -Path "$ScriptDir\PSCLog.csv"

foreach ($site in $psc) {
    
    Write-Host ""
    Remove-SPOSite -Identity $($site.Url) -NoWait -Confirmation:$false
    Write-Host "Site $($site.Url) has been moved into recycle bin - Site number $number"
    Remove-SPODeletedSite -Identity $($site.Url) -NoWait -Confirmation:$false
    Write-Host "Site $($site.Url) has been fully deleted - Site number $number"

    $number++
}

Write-Host "Script execution over" 