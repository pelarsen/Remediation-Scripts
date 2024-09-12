#=============================================================================================================================
#
# Script Name:     RemediateMSsenseServiceInstalled.ps1
# Description:     Purpose of this script is to enable MSsense feature.
#       Notes:     No variable substitution needed             
#
#=============================================================================================================================

# Define Variables
$svcCur = "Sense1"

# We'll going to install the capability.
Try{        
    If ($(Get-Service -Name "Sense" -ErrorAction SilentlyContinue).Status) {
 
	Write-Output -InputObject "Service Exist"
    }
  }
Catch{    
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    Exit 1
    }
      
# Okay, We'll going to install the capability
Try{        
Add-WindowsCapability -Online -Name "Microsoft.Windows.Sense.Client~~~~"    
     
    }

Catch{    
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    Exit 1
    }
  
