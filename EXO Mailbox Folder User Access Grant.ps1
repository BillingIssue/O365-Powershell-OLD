
###
#Basic Script Directory, Execution Policy and Credential Setup

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$credential = get-credential  

###
##
#FILLABLE DATA

#Person whose folders will be accessed
$Identity = "xxx@xxx.com"

#Person who will be accessing
$Identity2 = "xxx@xxx.com"

#What folders you want to access? Check Folders.csv file or use:<< Get-MailboxFolderStatistics -Identity <Mailbox email> -FolderScope All | Select-Object folderpath >> to determine
$FolderFilter = "*xxx*"

#FILLABLE DATA
##
###

clear-host

###
#Main logon

Install-Module MSOnline
Import-Module MsOnline 
Connect-MsolService -Credential $credential   
$ExchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $credential -Authentication "Basic" –AllowRedirection  
Import-PSSession $ExchangeSession 

clear-host

###
#Folderpath array receive & reimport

Write-host "Dropping all found folders to CSV file"
Get-MailboxFolderStatistics -Identity $Identity -FolderScope All | Select-Object folderpath | where {$_.folderpath -like "$FolderFilter"} | % {$_.folderpath.replace('/','\')} |Out-File "$ScriptDir\Folders.csv" -Encoding UTF8
Write-host "Importing database back to powershell"
$folderarray = Get-Content "$ScriptDir\Folders.csv"

###
#Main AccessRights OP part
clear-host

ForEach ($folder in $folderarray) {
    write-host ""
    write-host "Working on $folder"
    Add-MailboxFolderPermission -Identity ($($Identity)+":"+$($folder)) -User $Identity2 -AccessRights Owner -Confirm:$false
    write-host ""
}

###
#Script execution confirm
    write-host "All folders for mailbox $Identity have been configured with Access Rights for User $Identity2"

###
#Final check

#Get-MailboxFolderPermission -Identity $Identity | fl User,AccessRights,FolderName