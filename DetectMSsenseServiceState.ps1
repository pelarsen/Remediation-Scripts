#=============================================================================================================================
#
# Script Name:     DetectMSsenseServiceState.ps1
# Description:     Purpose of this script is to detect if MSsense feature is enabled and further if "MSSense" is running
# Notes:           No variable substitution should be necessary
#
#=============================================================================================================================

# Define Variables
$svcCur = "Sense"

# Main script
   
   
If ($(Get-Service -Name "Sense" -ErrorAction SilentlyContinue).Status) {
 
	Write-Output -InputObject "Service Exist"
  }
    Else{
        Write-Error "Error: " + $errMsg
        exit 1
 }

Try{        
    $svcCTRSvc = Get-Service $svcCur
    $curSvcStat = $svcCTRSvc.Status
}

Catch{    
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}

If ($curSvcStat -eq "Running"){
    Write-Output $curSvcStat
    exit 0                        
}
Else{
    If($curSvcStat -eq "Stopped"){
        Write-Output $curSvcStat
        exit 1     
    }
    Else{
        Write-Error "Error: " + $errMsg
        exit 1
    } 

} 

