###
#Execution Policy + Local Path definition

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

clear-host

###
#Login into O365 and Exchange Online

Install-Module MSOnline
Import-Module MsOnline 
$credential = get-credential  
Connect-MsolService -Credential $credential   
$ExchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $credential -Authentication "Basic" –AllowRedirection  
Import-PSSession $ExchangeSession 

clear-host

###
#Pull all Teams into CSV file

Get-UnifiedGroup -ResultSize Unlimited |where-object {$_.HiddenFromExchangeClientsEnabled -eq $True}| Select DisplayName, PrimarySmtpAddress, HiddenFromExchangeClientsEnabled | Export-csv -Path $ScriptDir\HiddenTeamsArray.csv -NoTypeInformation
Write-Host "HiddenTeamsArray File Generated in the same place you have placed your script for further usage as database for script"

###
#Import data from CSV

$Groups = Import-Csv -Path $ScriptDir\HiddenTeamsArray.csv

clear-host
Write-Host "Processing $($Groups.Count) Teams"

###
#Change the attrib to make Teams visible in Exchange

ForEach ($G in $Groups) {
    
    Write-Host ""
    Write-Host "Processing $($G.DisplayName)"

    If ($G.HiddenFromExchangeClientsEnabled -eq $False) { 
        Write-Host "Team $($G.DisplayName) is visible in Exchange and will not be processed"
        Write-Host ""}

    Else { 
        Set-UnifiedGroup -Identity $G.PrimarySmtpAddress -HiddenFromExchangeClientsEnabled:$False
        Write-Host "Showing $($G.DisplayName) Team in Exchange"
        Write-Host ""}

        }

Write-Host "All groups have been processed"

###
#Drop a CSV result file

Get-UnifiedGroup -ResultSize Unlimited | Select DisplayName, PrimarySmtpAddress, HiddenFromExchangeClientsEnabled | Export-csv -Path $ScriptDir\ShownTeamsArray.csv -NoTypeInformation

Write-Host "ShownGroupsArray File Generated in the same place you have placed your script for results comparison" 