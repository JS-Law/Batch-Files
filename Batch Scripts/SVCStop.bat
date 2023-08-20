@echo off
setlocal enabledelayedexpansion

rem List of service names to check
set "serviceNames=Spooler WSearch WMPNetworkSvc HPPrintScanDoctorService LogiFacecamService"

rem First loop: Stop services that are running
for %%s in (%serviceNames%) do (
    set "isRunning="
    for /f "tokens=3 delims=: " %%a in ('sc query %%s ^| findstr "        STATE"') do (
        if "%%a"=="RUNNING" (
            set "isRunning=1"
            echo Stopping the service %%s...
            net stop %%s >nul 2>nul
            if !errorlevel! equ 0 (
                echo The service %%s was successfully stopped.
            ) else (
                echo There was an error stopping the service %%s.
            )
        )
    )
    if not defined isRunning (
        echo The service %%s is not running or is not installed.
    )
)

echo.
rem Second loop: Display status of all services
for %%s in (%serviceNames%) do (
    for /f "tokens=3 delims=: " %%a in ('sc query %%s ^| findstr "        STATE"') do (
        set "status=%%a"
        set "status=!status:~0!"  REM Remove trailing colon
        echo %%s - !status!
        echo.
    )
)

endlocal
pause