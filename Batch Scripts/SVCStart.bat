@echo off
setlocal enabledelayedexpansion

rem List of service names to check
set "serviceNames=Spooler WSearch WMPNetworkSvc HPPrintScanDoctorService LogiFacecamService"
rem For testing, only Spooler HPPring and LogiFaceCam needs to be running


rem First loop: Start services that are not running
for %%s in (%serviceNames%) do (
    set "isRunning="
    for /f "tokens=3 delims=: " %%a in ('sc query %%s ^| findstr "        STATE"') do (
        if "%%a"=="STOPPED" (
            set "isRunning=1"
            echo Starting the service %%s...
            net start %%s >nul 2>nul
            if !errorlevel! equ 0 (
                echo The service %%s was successfully started.
            ) else (
                echo There was an error starting the service %%s.
            )
        )
    )
    if not defined isRunning (
        echo The service %%s is already running or is not installed.
    )
)

echo.
rem Second loop: Display status of all services
for %%s in (%serviceNames%) do (
    for /f "tokens=3 delims=: " %%a in ('sc query %%s ^| findstr "        STATE"') do (
        set "status=%%a"
        set "status=!status:~0!"  REM Remove trailing colon
        echo %%s - !status!
    )
)

endlocal
pause