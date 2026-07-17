<#
.SYNOPSIS
    Detection script for Proactive Remediations: checks Entra SSO auto-accept registry value.

.DESCRIPTION
    Exits 0 (compliant) if HKLM\SOFTWARE\Policies\Microsoft\Windows\AAD!AutoAcceptSsoPermission = 1.
    Exits 1 (non-compliant) otherwise, triggering the paired remediation script
    (Set-AutoAcceptSsoPermission.ps1) to run.

    Use with: Devices > Scripts and remediations > Proactive remediations > Create script package
      Detection script:   Detect-AutoAcceptSsoPermission.ps1 (this file)
      Remediation script: Set-AutoAcceptSsoPermission.ps1
      Run using logged-on credentials: No
      Run in 64-bit PowerShell: Yes
#>

$regPath   = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AAD"
$valueName = "AutoAcceptSsoPermission"
$desiredValue = 1

try {
    $current = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction SilentlyContinue

    if ($null -ne $current -and $current.$valueName -eq $desiredValue) {
        Write-Output "Compliant: $valueName is set to $desiredValue."
        exit 0
    }

    Write-Output "Non-compliant: $valueName is not set to $desiredValue."
    exit 1
}
catch {
    Write-Output "Non-compliant: unable to read $regPath\$valueName - $($_.Exception.Message)"
    exit 1
}
