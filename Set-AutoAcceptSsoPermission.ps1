#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Enables the Windows Entra SSO permission prompt auto-accept setting for managed devices.

.DESCRIPTION
    Sets HKLM\SOFTWARE\Policies\Microsoft\Windows\AAD!AutoAcceptSsoPermission = 1 (REG_DWORD).

    This registry value cannot be delivered via a custom ADMX ingested through Intune, because
    Windows blocks MDM ADMX ingestion from writing to most subkeys under
    Software\Policies\Microsoft (see Microsoft Learn: "Win32 and Desktop Bridge app ADMX policy
    Ingestion"). Software\Policies\Microsoft\Windows\AAD is not on the documented allow-list, so
    the value must instead be pushed directly, e.g. via this Intune Platform script (Devices >
    Scripts and remediations > Platform scripts), running in SYSTEM context.

    Reference:
    https://techcommunity.microsoft.com/blog/windows-itpro-blog/now-available-admin-control-for-sso-prompts-in-windows/4534613
    https://learn.microsoft.com/en-us/windows/client-management/win32-and-centennial-app-policy-configuration

.NOTES
    Deploy as an Intune Platform script:
      Devices > Scripts and remediations > Platform scripts > Add
      Run this script using the logged-on credentials: No
      Enforce script signature check: No
      Run script in 64-bit PowerShell host: Yes
    Assign to your Windows 11 24H2/25H2 (July 2026 update or later) device group.
#>

$ErrorActionPreference = "Stop"

$regPath  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AAD"
$valueName = "AutoAcceptSsoPermission"
$desiredValue = 1

try {
    if (-not (Test-Path -Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
        Write-Output "Created registry key: $regPath"
    }

    $current = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction SilentlyContinue

    if ($null -ne $current -and $current.$valueName -eq $desiredValue) {
        Write-Output "$valueName already set to $desiredValue. No change needed."
        exit 0
    }

    New-ItemProperty -Path $regPath -Name $valueName -Value $desiredValue -PropertyType DWord -Force | Out-Null
    Write-Output "Set $regPath\$valueName = $desiredValue"
    exit 0
}
catch {
    Write-Error "Failed to set $valueName at $regPath : $($_.Exception.Message)"
    exit 1
}
