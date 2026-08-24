<#
.SYNOPSIS
    Datto RMM Component: Disk Space Alert
.DESCRIPTION
    Checks free space on C: against a threshold (default 15%) and exits
    non-zero when below threshold, so Datto RMM can flag/alert on it.
    Intended to run as a Script or Monitor component in Datto RMM.
.NOTES
    Datto RMM exposes component-level UDFs as environment variables
    prefixed "usr" — define "ThresholdPercent" as a UDF in the component
    editor and it arrives here as $env:usrThresholdPercent.
#>

param(
    [int]$ThresholdPercent = $(if ($env:usrThresholdPercent) { [int]$env:usrThresholdPercent } else { 15 })
)

$drive = Get-PSDrive -Name C
$freePercent = [math]::Round(($drive.Free / ($drive.Free + $drive.Used)) * 100, 1)

$freeGB = [math]::Round($drive.Free / 1GB, 1)
Write-Host "C: free space: $freePercent% ($freeGB GB) (threshold: $ThresholdPercent%)"

Write-Host "C: free space: $freePercent% (threshold: $ThresholdPercent%)"

if ($freePercent -lt $ThresholdPercent) {
    Write-Host "ALERT: Free space below threshold."
    exit 1
} else {
    Write-Host "OK: Free space within threshold."
    exit 0
}