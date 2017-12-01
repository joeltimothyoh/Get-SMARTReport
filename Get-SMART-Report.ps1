<#
.SYNOPSIS
This script monitors and generates an email report regarding the SMART status of physical drives on the system.

.DESCRIPTION
The email will include a warning when 1 or more drives return a SMART status other than 'OK'.

.EXAMPLE
Get-SMART-Report.ps1

.NOTES

#>

Param()

function Get-SMART-Report {

    # Get info of each physical drive on system
    $Physical_Drives_Info = Get-WmiObject -Class Win32_DiskDrive | Sort-Object DeviceID

    # Count the number of physical drives with a SMART status other than 'OK'
    $faulty_drives = $Physical_Drives_Info | Where-Object { $_.Status -ne 'OK'} | Measure-Object

    # Generate a table containing each physical drive with their respective capacities and SMART statuses
    $smart_status_table = $Physical_Drives_Info | 
        Format-Table DeviceID, 
                    #Caption,          # Use Caption for drive model name 
                    @{ Name = "Size (GB)"; Expression = { [math]::Round($_.Size/1GB,1) } },
                    @{ Name = "SMART Status"; Expression = { $_.Status }; Alignment="right"; }

    # Include path to email config file
    . "C:/scripts/email/config.ps1"

    # Define module name for report
    $module_name = "[Get-SMART-Report]"

    # Format title of report
    $title = "$email_title_tag $module_name "
    if ($faulty_drives.Count -gt 0) {
        $title += "$($faulty_drives.Count) Drive(s) may be faulty/failing."
    } else {
        $title += "No problems found."
    }

    # Format body of report
    $smart_status_report = @()
    $smart_status_report += "Smart Status Check as of: $(Get-Date)"
    $smart_status_report += $smart_status_table

    # Print report the stdout
    Write-Output $title
    Write-Output $smart_status_report

    # Format body of email
    $body = @()
    $body += "<pre><p style='font-family: Courier New; font-size: 11px;'>"
    $body += $smart_status_report
    $body += "</p></pre>"

    # Email the report
    Send-Mailmessage -to $email_to -subject $title -Body ( $body | Out-String ) -SmtpServer $smtp_server -from $smtp_email -Port $smtp_port -UseSsl -Credential $credential -BodyAsHtml

    # Debug
    Write-Host "Faulty drive count: $($faulty_drives.Count)"
}

# Call function
Get-SMART-Report