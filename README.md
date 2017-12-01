# Get-SMART-Report
Monitors and generates an email report regarding the SMART status of physical drives on the system.

The email will include a warning when one or more physical drives return a SMART status other than 'OK'.

## Usage
Fill in email settings within the .ps1 script. Then manually run, or set the script to run on a schedule.

.\Get-SMART-Report.ps1

## Compatibility
This script currently only works with Windows.