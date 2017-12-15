# Get-SMART-Report
Generates and emails a report regarding the SMART status of physical drives on the system.

The report will warn when one or more physical drives return a SMART status other than 'OK'.

## Usage
Fill in email settings within the .ps1 script. Then manually run, or set the script to run on a schedule.

## Example
`.\Get-SMART-Report.ps1`

## Compatibility
Get-SMART-Report currently only works with Windows.