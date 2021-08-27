# Get-SMARTReport

Generates a report regarding the SMART status of physical drives on the system.

## Deprecation notice

This script / module outputs the SMART status of physical drives on the system in a custom format as array of strings rather than as objects for consumption further down a pipeline, making it unmodular and very much anthetical to PowerShell's general design and approach in dealing with objects rather than strings.

To get the same SMART statuses of physical drives, simply use PowerShell's built-in `Get-WmiObject`:

```powershell
# Get disk drive objects, selecting property 'Status'
Get-WmiObject -Class Win32_DiskDrive | Select-Object Status
# In tabular format
Get-WmiObject -Class Win32_DiskDrive | Select-Object Partitions,DeviceID,Model,Size,Caption,Status | Sort-Object DeviceID | Format-Table -AutoSize
```

Having used the script in production for a daily report on several systems for a number of years, the status of drives have never reported as anything else other than `OK` despite a number of hard drives failing during the period. I believe `OK` statuses are consistent with Windows' general behavior of not reporting on failing drives even when they are screeching to a halt with the only indication of impending disk failure being especially high read/write durations and Windows Explorer becoming unresponsive. SMART detection as a feature is likely deliberately left out of the operating system to create a market for the existence of third party disk management software.

If you're a consumer, consider using tools such as `CrystalDiskInfo` for interactively checking the health of physical disks on a system. For production uses, consider using more reliable forms of storage such as mid-range SSDs or NVMe drives rather than hard drives, or, if possible, remote or cloud storage solutions where disks are managed by storage providers.

Also, instead of relying on emails, consider using tools (e.g. Prometheus) for monitoring and alerting at scale.

## Description

The report will include a warning when one or more physical drives return a SMART status other than 'OK'.

## Usage

Get-SMARTReport can be used as a script or module. Scripts allow for greater portability and isolation, while modules allow for greater accessibility, scalability and upgradability.

The `Get-SMARTReport.ps1` script has the additional ability to email reports.

### Script

* Specify email settings within the `Get-SMARTReport.ps1` script.
* Run the script to get a report and send it via email.

### Module

* Install the `Get-SMARTReport.psm1` module. Refer to Microsoft's documentation on installing PowerShell modules.
* Call the module via `Get-SMARTReport` in PowerShell to get a report.

## Scheduling

The `Get-SMARTReport.ps1` script can be scheduled to periodically notify on the operational status of physical drives on the system.

* Set up the script to be run.
* In *Task Scheduler*, create a task with the following *Action*:
  * *Action*: `Start a program`
  * *Program/script*: `Powershell`
  * *Add arguments (optional)*: `"C:\path\to\script.ps1"`
* Repeat the steps for each script that is to be scheduled.

Refer to Microsoft's documentation or guides for further help on using *Task Scheduler*.

## Parameters

```powershell
Get-SMARTReport [<CommonParameters>]

PARAMETERS
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).
```

### Examples

#### Example 1

Runs the `Get-SMARTReport.ps1` script in an instance of PowerShell.

```powershell
Powershell "C:\scripts\Get-SMARTReport\Get-SMARTReport.ps1"
```

#### Example 2

Runs the `Get-SMARTReport` module, appending the output to the specified log file.

```powershell
Get-SMARTReport >> "C:\logs\smart-report.log"
```

## Security

Unverified scripts are restricted from running on Windows by default. In order to use `Get-SMARTReport`, you will need to allow the execution of unverified scripts. To do so, open PowerShell as an *Administrator*. Then run the command:

```powershell
Set-ExecutionPolicy Unrestricted -Force
```

If you wish to revert the policy, run the command:

```powershell
Set-ExecutionPolicy Undefined -Force
```

## Requirements

* Windows with <a href="https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell?view=powershell-5.1" target="_blank" title="PowerShell">PowerShell v3 or higher</a>.