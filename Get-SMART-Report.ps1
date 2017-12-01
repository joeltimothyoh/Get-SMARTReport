<#
.SYNOPSIS
Monitors and generates an email report regarding the SMART status of physical drives on the system.

.DESCRIPTION
The email will include a warning when one or more physical drives return a SMART status other than 'OK'.

.EXAMPLE
.\Get-SMART-Report.ps1

#>

##########################   Email Settings   ###########################

# SMTP Server
$smtp_server = 'smtp.server.com'

# SMTP port (usually 465 or 587)
$smtp_port = '587'

# SMTP email address
$smtp_email = 'sender@address.com'

# SMTP password
$smtp_password = 'Password'

# Destination email address
$email_to = 'recipient@address.com'

# Source email address (usually matching SMTP email address)
$email_from = 'sender@address.com'

# Email title prefix
$email_title_prefix = '[MachineName]'

#########################################################################

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

    # Module name to appear in title
    $module_name = "[Get-SMART-Report]"

    # Format title of report
    $title = "$module_name "
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

    # Format title of email report
    $email_title = "$email_title_prefix $title"

    # Format body of email report
    $email_body = @()
    $email_body += "<pre><p style='font-family: Courier New; font-size: 11px;'>"
    $email_body += $smart_status_report
    $email_body += "</p></pre>"

    # Secure credentials
    $encrypted_password = $smtp_password | ConvertTo-SecureString -AsPlainText -Force
    $credentials = New-Object System.Management.Automation.PSCredential( $smtp_email, $encrypted_password )
    
    # Email the report
    Send-Mailmessage -to $email_to -subject $email_title -Body ( $email_body | Out-String ) -from $email_from -SmtpServer $smtp_server -Port $smtp_port -Credential $credentials -UseSsl -BodyAsHtml
    
    # Debug
    Write-Host "Faulty drive count: $($faulty_drives.Count)"
}

# Call function
Get-SMART-Report