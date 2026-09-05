function Get-EndpointAudit {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Endpoint,

        [string]$OutputPath = ".\AuditReports"
    )

    # CHECK IF THE ENDPOINT IS ACCESSIBLE VIA ICMP (PING)
    if (-not (Test-Connection -ComputerName $Endpoint -Count 1 -Quiet)){
            $results = [PSCustomObject]@{
            "ComputerName" = $Endpoint
            "Status" = "Offline"
        }
        return $results
    } 

    # CHECK IF THE OUTPUT DIRECTORY EXISTS, IF NOT, CREATE IT
    if (-not (Test-Path -Path $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }

    $CimSession = $null

    try {

        # CREATE A CIM SESSION TO THE REMOTE ENDPOINT
        $CimSession = New-CimSession -ComputerName $Endpoint

        # RETRIEVE OPERATING SYSTEM INFORMATION
        $OperatingSystemInfo = Get-CimInstance -CimSession $CimSession -ClassName Win32_OperatingSystem

        # RETRIEVE HARDWARE AND CONFIGURATION INFORMATION
        $ComputerInfo = Get-CimInstance -CimSession $CimSession -ClassName Win32_ComputerSystem

        # RETRIEVE BIOS INFORMATION
        $BiosInfo = Get-CimInstance -CimSession $CimSession -ClassName Win32_BIOS

        # RETRIEVE PROCESSOR INFORMATION
        $ProcessorInfo = Get-CimInstance -CimSession $CimSession -ClassName Win32_Processor

        # RETRIEVE STOPPED SERVICES INFORMATION
        $StoppedServices = Get-CimInstance -CimSession $CimSession -ClassName Win32_Service |
            Where-Object { $_.State -eq "Stopped" } |
            Sort-Object -Property Name |
            Select-Object -Property Name, DisplayName, State

        # RETRIEVE TOP 5 MEMORY-CONSUMING PROCESSES
        $TopMemoryProcesses = Get-CimInstance -CimSession $CimSession -ClassName Win32_Process |
            Sort-Object -Property WorkingSetSize -Descending |
            Select-Object -First 5 -Property ProcessName, ProcessId, WorkingSetSize

        # CREATE A CUSTOM OBJECT TO HOLD THE RESULTS
        $results = [PSCustomObject]@{
            "ComputerName" = $ComputerInfo.Name
            "Status" = "Online"
            "OperatingSystem" = $OperatingSystemInfo.Caption
            "Version" = $OperatingSystemInfo.Version
            "BuildNumber" = $OperatingSystemInfo.BuildNumber
            "OSArchitecture" = $OperatingSystemInfo.OSArchitecture
            "Manufacturer" = $ComputerInfo.Manufacturer
            "Model" = $ComputerInfo.Model
            "TotalPhysicalMemory" = $ComputerInfo.TotalPhysicalMemory
            "SystemType" = $ComputerInfo.SystemType
            "BIOSManufacturer" = $BiosInfo.Manufacturer
            "BIOSVersion" = $BiosInfo.SMBIOSBIOSVersion
            "BIOSSerialNumber" = $BiosInfo.SerialNumber
            "ProcessorName" = $ProcessorInfo.Name
            "ProcessorManufacturer" = $ProcessorInfo.Manufacturer
            "MaxClockSpeed" = $ProcessorInfo.MaxClockSpeed
            "StoppedServices" = $StoppedServices
            "TopMemoryProcesses" = $TopMemoryProcesses
        }

        # EXPORT THE RESULTS TO A CSV FILE
        $ReportFileName = "$OutputPath\AuditReport_$($Endpoint)_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
        $results | Select-Object ComputerName, Status, OperatingSystem, Version, BuildNumber, OSArchitecture, Manufacturer, Model, TotalPhysicalMemory, SystemType, BIOSManufacturer, BIOSVersion, BIOSSerialNumber, ProcessorName, ProcessorManufacturer, MaxClockSpeed | 
            Export-Csv -Path $ReportFileName -Force

        # EXPORT STOPPED SERVICES TO A SEPARATE CSV FILE
        $StoppedServicesReportFileName = "$OutputPath\StoppedServices_$($Endpoint)_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"

        $StoppedServices |
            Export-Csv -Path $StoppedServicesReportFileName -NoTypeInformation -Force

        # EXPORT TOP MEMORY PROCESSES TO A SEPARATE CSV FILE
        $TopMemoryProcessesReportFileName = "$OutputPath\TopMemoryProcesses_$($Endpoint)_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"

        $TopMemoryProcesses |
            Export-Csv -Path $TopMemoryProcessesReportFileName -NoTypeInformation -Force

        return $results

    } finally {
        if ($CimSession) {
            Remove-CimSession -CimSession $CimSession
        }
    }
}