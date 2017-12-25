# Get-SMART-Report

Generates a report regarding the SMART status of physical drives on the system.

## Description

The report will include a warning when one or more physical drives return a SMART status other than 'OK'.

## Usage

Get-SMART-Report can be used as a script or module. Scripts allow for greater portability and isolation, while modules allow for greater accessibility, scalability and upgradability.

The `Get-SMART-Report.ps1` script has the additional ability to email reports.

### Script

* Specify email settings within the `Get-SMART-Report.ps1` script.
* Run the script to get a report and send it via email.

### Module

* Install the `Get-SMART-Report.psm1` module. Refer to Microsoft's documentation on installing PowerShell modules.
* Call the module via `Get-SMART-Report` in PowerShell to get a report.

## Scheduling

The `Get-SMART-Report.ps1` script can be scheduled to periodically notify on the operational status of physical drives on the system.

* Set up the script to be run.
* In *Task Scheduler*, create a task with the following *Action*:
  * *Action*: `Start a program`
  * *Program/script*: `Powershell`
  * *Add arguments (optional)*: `C:\path\to\script.ps1`
* Repeat the steps for each script that is to be scheduled.

Refer to Microsoft's documentation or guides for further help on using *Task Scheduler*.

## Parameters

```
Get-SMART-Report [<CommonParameters>]

PARAMETERS
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).
```

### Examples

#### Example 1

Runs the `Get-SMART-Report.ps1` script in an instance of PowerShell.

```
Powershell "C:\scripts\Get-SMART-Report\Get-SMART-Report.ps1"
```

#### Example 2

Runs the `Get-SMART-Report` module, appending the output to the specified log file.

```
Get-SMART-Report >> "C:\logs\smart-report.log"
```

## Security

Unverified scripts are restricted from running on Windows by default. In order to use Get-SMART-Report, you will need to allow the execution of unverified scripts. To do so, open PowerShell as an *Administrator*. Then run the command:

```
Set-ExecutionPolicy Unrestricted -Force
```

If you wish to revert the policy, run the command:

```
Set-ExecutionPolicy Undefined -Force
```

## Requirements

* Windows with <a href="https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell?view=powershell-5.1" target="_blank" title="PowerShell">PowerShell v3 or higher</a>.