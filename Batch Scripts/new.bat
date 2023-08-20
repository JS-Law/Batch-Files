@echo off
setlocal

set "serviceName=wuauserv"

sc query %serviceName% >nul 2>nul
if %errorlevel% equ 1 (
    echo The service %serviceName% is installed.
) else (
    echo The service %serviceName% is not installed.
)

endlocal
pause