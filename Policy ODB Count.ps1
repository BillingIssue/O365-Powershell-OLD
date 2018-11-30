# Block required for connection to Security & Compliance Center
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

# Define your Retention Policy Name
$RetentionPolicyName = "PLEASE FILL WITH YOUR POLICY NAME"

# Variable definition
$Array = $(Get-RetentionCompliancePolicy "$RetentionPolicyName" -Distributiondetail).onedrivelocation

# Show ODB Sites amount
write-host "Currently there are $($Array.onedrivelocation.Count) ODB Sites attached to this Retention Policy"

# Show all sites and their owners
$Array | format-table Displayname,Name

# Export all sites and their owners to CSV file
$Array | Select Displayname,Name | Export-Csv "SPECIFY FILEPATH"
