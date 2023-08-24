param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

'running with full privileges'

Pause

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





