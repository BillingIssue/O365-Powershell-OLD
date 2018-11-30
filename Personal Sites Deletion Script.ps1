###
#Main logon part

$credential = get-credential  
$orgName="INPUT YOUR SITE COLLECTION !!!!!!!"

Import-Module MsOnline 
Connect-MsolService -Credential $credential

Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
Connect-SPOService -Url https://$orgName-admin.sharepoint.com -Credential $credential

###
#Site array gain + Export to CSV

get-sposite -includepersonalsite:$true -Limit ALL | where {$_.Template -like "SPSPERS#10"} |Select-Object Url | Export-Csv ".\Personal Sites Array\PSCLog.csv" -NoTypeInformation
clear-host
write-host "CSV File Generated"

###
#Site URL Import from CSV + Site Deletion
$number = 1
$psc = Import-Csv -Path ".\PS Results\PSCLog.csv"

foreach ($site in $psc) {
    
    Write-Host ""
    Remove-SPOSite -Identity $($site.Url) -NoWait
    Write-Host "Site $($site.Url) has been moved into recycle bin - Site number $number"
    Remove-SPODeletedSite -Identity $($site.Url) -NoWait 
    Write-Host "Site $($site.Url) has been fully deleted - Site number $number"

    $number++
}