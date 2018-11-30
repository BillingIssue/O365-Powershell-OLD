install-module msonline
import-module msonline

$UserCredential = Get-Credential
Connect-MsolService -Credential $UserCredential

$Datapath = "C:\Users\Administrator\Desktop\Pliki\TestFile.csv"

$users = Get-MsolUser -All | Where-Object {$_.isLicensed -eq $true}

$headerstringmain = "UserPrincipalName,ServiceName,ServiceStatus"
Out-File -FilePath $Datapath -InputObject $headerstringmain -Encoding UTF8 -append      
          
        foreach ($user in $users){

            $DisabledServices =  $user.Licenses.servicestatus | where {$_.provisioningstatus -like "*Pending*" } 
        
            write-host "Preparing datasheet for $($user.userprincipalname)"
            foreach ($row in $DisabledServices)  
            {  
                $headerstring = ($user.UserPrincipalName + "," + $row.ServicePlan.servicename + "," + $row.provisioningstatus) 
                Out-File -FilePath $Datapath -InputObject $headerstring -Encoding UTF8 -append 
            } 

        }

write-host "All users reworked, please review the results in "$Datapath""