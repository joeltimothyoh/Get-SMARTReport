function Get-SMARTReport {
    <#
    .SYNOPSIS
    Generates a report regarding the SMART status of physical drives on the system.

    .DESCRIPTION
    The report will include a warning when one or more physical drives return a SMART status other than 'OK'.

    .EXAMPLE
    Powershell "C:\scripts\Get-SMARTReport\Get-SMARTReport.ps1"
    Runs the Get-SMARTReport.ps1 script in an instance of PowerShell.

    .EXAMPLE
    Get-SMARTReport >> "C:\logs\smart-report.log"
    Runs the Get-SMARTReport module, appending the output to the specified log file.

    .LINK
    https://github.com/joeltimothyoh/Get-SMARTReport
    #>

    [CmdletBinding()]
    Param()

    try {
        # Get info of each physical drive on system
        $Physical_Drives_Info = Get-WmiObject -Class Win32_DiskDrive | Sort-Object DeviceID

        # Count the number of physical drives with a SMART status other than 'OK'
        $faulty_drives = $Physical_Drives_Info | Where-Object { $_.Status -ne 'OK'}

        # Generate a table containing each physical drive with their respective capacities and SMART statuses
        $smart_status_table = $Physical_Drives_Info | Format-Table `
            DeviceID,                                                                    # DeviceID for physical drive unique identifier
            Model,                                                                       # Model for physical drive model name
        # MediaType,                                                                   # MediaType for physical drive type
        # SerialNumber,                                                                # SerialNumber for physical drive serial number
            @{ Name = "Size (GB)"; Expression = { [math]::Round($_.Size/1GB,1) } },      # Size for physical drive storage capacity
            @{ Name = "SMART Status"; Expression = { $_.Status }; Alignment="right" }    # Status for physical drive SMART status

        # Trim newlines in the formatted table
        $smart_status_table = ($smart_status_table | Out-String).Trim()

        # Module name to appear in title
        $module_name = "[Get-SMARTReport]"

        # Format title of report
        $title = "$module_name "
        if ($faulty_drives.Count -gt 0) {
            $title += "$($faulty_drives.Count) Drive(s) may be faulty/failing."
        } else {
            $title += "No problems found."
        }

        # Format body of report
        $smart_status_report = @(
            "Smart Status Check as of: $(Get-Date)"
            $smart_status_table
        )

        # Print report to stdout
        Write-Output $title
        Write-Output $smart_status_report
        Write-Output "-"

    } catch {
        throw
    }

}

# Export the members of the module
Export-ModuleMember -Function Get-SMARTReport
