$serviceNames = "Spooler", "WSearch", "WMPNetworkSvc", "HPPrintScanDoctorService", "LogiFacecamService"
# For testing, only Spooler, HPPrint, and LogiFaceCam need to be running

foreach ($serviceName in $serviceNames) {
    $serviceStatus = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($serviceStatus) {
        if ($serviceStatus.Status -eq "Stopped") {
            Write-Host "Starting the service $serviceName..." -NoNewline
            Start-Service -Name $serviceName
            $serviceStatus = Get-Service -Name $serviceName
            if ($serviceStatus.Status -eq "Running") {
                Write-Host "The service $serviceName was successfully started." -ForegroundColor Green
            } else {
                Write-Host "There was an error starting the service $serviceName."
            }
        }
    } else {
        Write-Host "The service $serviceName is not installed."
    }
}

Write-Host ""
# Display status of all services
foreach ($serviceName in $serviceNames) {
    $serviceStatus = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($serviceStatus) {
        $statusColor = "White"
        if ($serviceStatus.Status -eq "Running") {
            $statusColor = "Green"
        }
        Write-Host "$serviceName - $($serviceStatus.Status)" -ForegroundColor $statusColor
    } else {
        Write-Host "$serviceName - Not installed"
    }
}

Pause