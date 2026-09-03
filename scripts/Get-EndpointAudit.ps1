function Get-EndpointAudit {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Endpoint
    )

    # CHECK IF THE ENDPOINT IS ACCESSIBLE VIA ICMP (PING)
    if (Test-Connection -ComputerName $Endpoint -Count 1 -Quiet) {
        
        # RETRIEVE OPERATING SYSTEM INFORMATION
        $OperatingSystemInfo = Get-CimInstance -Class Win32_OperatingSystem -ComputerName $Endpoint

        # RETRIEVE HARDWARE AND CONFIGURATION INFORMATION
        $ComputerInfo = Get-CimInstance -Class Win32_ComputerSystem -ComputerName $Endpoint

        # RETRIEVE BIOS INFORMATION
        $BiosInfo = Get-CimInstance -Class Win32_BIOS -ComputerName $Endpoint

        # RETRIEVE PROCESSOR INFORMATION
        $ProcessorInfo = Get-CimInstance -Class Win32_Processor -ComputerName $Endpoint

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
        }

        return $results

    } else {
        $results = [PSCustomObject]@{
            "ComputerName" = $Endpoint
            "Status" = "Offline"
        }
        return $results
    }
}