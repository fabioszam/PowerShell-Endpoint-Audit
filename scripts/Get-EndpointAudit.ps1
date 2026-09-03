function Get-EndpointAudit {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Endpoint
    )

    # Check if the endpoint is reachable
    if (Test-Connection -ComputerName $Endpoint -Count 1 -Quiet) {
        Write-Output "Endpoint $Endpoint is reachable."
        
        # Retrieve system information
        $systemInfo = Get-CimInstance -Class Win32_OperatingSystem -ComputerName $Endpoint
        Write-Output "Operating System: $($systemInfo.Caption)"
        Write-Output "Version: $($systemInfo.Version)"
        Write-Output "Build Number: $($systemInfo.BuildNumber)"
        Write-Output "OS Architecture: $($systemInfo.OSArchitecture)"
    } else {
        Write-Output "Endpoint $Endpoint is not reachable."
    }
}