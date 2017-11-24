<#
# SmartStatusMonitor.ps1 - 
# This script monitors and generates an email report regarding the SMART status of drives on a system. 
# The email will include a warning when 1 or more drives return a SMART status other than 'OK'. 
#>

# Get info of all drives on system
$Drive_Info = Get-WmiObject -Class Win32_DiskDrive

# Count the number of drives with a SMART status other than 'OK'
$faulty_drives = $Drive_Info | Where-Object { $_.Status -ne 'OK'} | Measure-Object

# Generate a table containing all drives with their respective capacities and SMART statuses
$smart_status_report = $Drive_Info | 
    Format-Table DeviceID, 
    # Caption                   # Use Caption for drive model name 
    @{ Name = "Size (GB)"; Expression = { [math]::Round($_.Size/1GB,1) } },
    @{ Name = "SMART Status"; Expression = { $_.Status }; Alignment="right"; }  

# Include path to email config file
. "C:/scripts/email/config.ps1"

# Define module name for report
$module_name = "[SmartStatusCheck]"

# Format title of report
$title = "$email_title_tag $module_name "
if ($faulty_drives.Count -gt 0) {
    $title += "$($faulty_drives.Count) Drive(s) may be faulty/failing."
} else {
    $title += "No problems found."
}

# Format body of report
$body = @()
$body += "Smart Status Check as of: $(Get-Date)"
$body += $smart_status_report

# Print report to console
$title + "`n"
$body

# Email the report
Send-Mailmessage -to $email_to -subject $title -Body ( $body | Out-String ) -SmtpServer $smtp_server -from $smtp_email -Port $smtp_port -UseSsl -Credential $credential

# Debug
Write-Host "Faulty drive count: $($faulty_drives.Count)"

<# Misc
# Find SMART status with WMIC
    WMIC DiskDrive GET Caption,status

# Non-formatted using Win32_DiskDrive
$WMI = Get-WMIObject -Class Win32_DiskDrive 
ForEach ($Drive in $WMI) {
     $Drive.Caption + ": " + $Drive.Status
     #$Drive.DeviceID + " (" + [math]::Round($Drive.Size/1GB,1) + " GB): " + $Drive.Status   # Use $Drive.Caption for drive model name 
}
#>