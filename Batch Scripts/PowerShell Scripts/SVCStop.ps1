$serviceNames = "Spooler", "WSearch", "WMPNetworkSvc", "HPPrintScanDoctorService", "LogiFacecamService"

foreach ($serviceName in $serviceNames) {
    $serviceStatus = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($serviceStatus) {
        if ($serviceStatus.Status -eq "Running") {
            Write-Host "Stopping the service $serviceName..." -NoNewline
            Stop-Service -Name $serviceName
            $serviceStatus = Get-Service -Name $serviceName
            if ($serviceStatus.Status -eq "Stopped") {
                Write-Host "The service $serviceName was successfully stopped." -ForegroundColor Green
            } else {
                Write-Host "There was an error stopping the service $serviceName." -ForegroundColor Red
            }
        } else {
            Write-Host "The service $serviceName is not running."
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
In this PowerShell script:

The $serviceNames array contains the names of the services you want to work with. Adjust this array to match your needs.

The script iterates through each service name in the list.

For each service, it checks if the service is running, stops it if needed, and provides color-coded output for success or failure.

The Write-Host cmdlet is used with -ForegroundColor to set the text color to green for successful stops and red for errors.

After the first loop, a blank line is added for separation.

The second loop displays the status of all services in the list using color-coded text. If a service is running, its status will be displayed in green; if not, it will be displayed in white.

The Pause command keeps the PowerShell console window open after the script completes, allowing you to review the output.

This script should provide the desired functionality of stopping services and displaying their status with color-coded text.





