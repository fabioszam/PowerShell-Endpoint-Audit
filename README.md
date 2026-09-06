# PowerShell Endpoint Audit

A PowerShell tool for auditing a specific Windows endpoint and collecting system, hardware, BIOS, processor, service, and process information.

## Overview

**PowerShell Endpoint Audit** is a diagnostic and inventory tool designed to assist IT Support and Infrastructure Analysts when investigating a specific Windows endpoint.

Before collecting information, the tool verifies endpoint reachability through ICMP and then attempts to establish a CIM session. Once connected, it collects relevant operating system, hardware, BIOS, processor, service, and process information.

The collected data can be exported to CSV and JSON reports for further analysis.

## Use Case

This project is intended for scenarios where an analyst needs to quickly inspect a specific endpoint during troubleshooting or infrastructure investigation.

Typical use cases include:

* Endpoint troubleshooting
* Initial support and infrastructure diagnostics
* Hardware and operating system inventory
* Identification of stopped Windows services
* Identification of processes consuming the most memory

## Current Features

The current version of the tool provides:

* ICMP connectivity check before starting the audit
* CIM session creation and reuse during the audit
* Windows operating system information
* Hardware and computer configuration information
* BIOS information
* Processor information
* List of stopped Windows services
* Top 5 memory-consuming processes
* Endpoint summary CSV export
* Stopped services CSV export
* Top memory-consuming processes CSV export
* Complete endpoint audit JSON export
* Structured handling of CIM communication errors
* Handling of unexpected errors
* Advanced PowerShell function using `CmdletBinding()`

## Requirements

* Windows
* PowerShell 7+
* WinRM / WS-Management available on the target endpoint
* Permissions required to query the relevant CIM classes

## Usage

Load the script into the current PowerShell session:

```powershell
. .\scripts\Get-EndpointAudit.ps1
```

Run the audit against an endpoint:

```powershell
Get-EndpointAudit -Endpoint "localhost"
```

A custom output directory can be specified:

```powershell
Get-EndpointAudit -Endpoint "localhost" -OutputPath ".\AuditReports"
```

The function returns the collected information as a PowerShell object and generates report files in the configured output directory.

Because the function is an advanced PowerShell function, common parameters such as `-Verbose` and `-ErrorAction` are also available.

Example:

```powershell
Get-EndpointAudit -Endpoint "localhost" -Verbose
```

## Output

The tool generates separate reports for the different types of information collected during the audit.

### Endpoint Summary

The endpoint summary contains:

* Computer name
* Status
* Operating system
* OS version
* OS build
* OS architecture
* Manufacturer
* Model
* Total physical memory
* System type
* BIOS manufacturer
* BIOS version
* BIOS serial number
* Processor name
* Processor manufacturer
* Maximum processor clock speed

### Stopped Services

The stopped services report contains:

* Service name
* Display name
* Service state

### Top Memory Processes

The top memory processes report contains:

* Process name
* Process ID
* Working set size

`WorkingSetSize` is reported in bytes.

### JSON Audit

The JSON report preserves the complete audit structure, including:

* Endpoint information
* System information
* Hardware information
* BIOS information
* Processor information
* Stopped services
* Top memory-consuming processes

## Project Structure

```text
PowerShell-Endpoint-Audit
├── scripts
│   └── Get-EndpointAudit.ps1
├── Reports
├── Screenshots
├── README.md
└── .gitignore
```

Generated reports are excluded from Git tracking to avoid committing machine-specific information.

## Technical Implementation

The project currently uses the following PowerShell technologies and concepts:

* PowerShell functions and parameters
* Advanced functions with `CmdletBinding()`
* PowerShell objects and `PSCustomObject`
* Pipeline processing
* CIM / WMI classes
* `CimSession`
* `Where-Object`
* `Select-Object`
* `Sort-Object`
* CSV serialization with `Export-Csv`
* JSON serialization with `ConvertTo-Json`
* JSON deserialization with `ConvertFrom-Json`
* Structured error handling with `try`, `catch`, and `finally`
* `ErrorRecord`
* `ThrowTerminatingError()`

## Versioning

The project uses Git for source control and semantic versioning for release tags.

The project initially used version references in commit messages while the implementation was being developed.

Formal release tags were introduced starting with:

**v0.6.0**

## Development History

The project has been developed incrementally through the following stages:

| Version | Development                                                                      |
| ------- | -------------------------------------------------------------------------------- |
| v0.1    | Initial endpoint audit                                                           |
| v0.2    | Computer and hardware information                                                |
| v0.3    | BIOS and processor information                                                   |
| v0.4    | Stopped services                                                                 |
| v0.5    | Top memory-consuming processes                                                   |
| v0.5.1  | CIM session reuse                                                                |
| v0.6.0  | Reporting, JSON export, advanced function support, and structured error handling |

> Note: versions prior to `v0.6.0` are represented in the Git commit history rather than formal release tags.

## Project Status

**Current release: v0.6.0**

The project is under active development.

The current implementation focuses on endpoint auditing, structured reporting, CIM-based data collection, and reliable error handling.

Future versions may expand the tool with additional diagnostic and infrastructure-oriented capabilities.
