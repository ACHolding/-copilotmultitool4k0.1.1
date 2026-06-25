@echo off
title AC's Tool 0.1.1
color 0a

:menu
cls
echo ============================================
echo            AC's TOOL 0.1.1
echo     Multitool Network Diagnostic Suite
echo ============================================
echo.
echo 1. DNS Checkup
echo 2. Port Scanner
echo 3. Launch Nmap (if installed)
echo 4. Exit
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto dns
if "%choice%"=="2" goto portscan
if "%choice%"=="3" goto nmap
if "%choice%"=="4" exit
goto menu

:dns
cls
echo ================================
echo          DNS CHECKUP
echo ================================
echo.
set /p domain=Enter domain to check: 
echo.
echo Checking DNS records for %domain%...
echo.

echo --- A Record ---
nslookup -type=A %domain%
echo.

echo --- AAAA Record ---
nslookup -type=AAAA %domain%
echo.

echo --- MX Record ---
nslookup -type=MX %domain%
echo.

echo --- NS Record ---
nslookup -type=NS %domain%
echo.

pause
goto menu

:portscan
cls
echo ================================
echo          PORT SCANNER
echo ================================
echo.
set /p target=Enter target IP or hostname: 
set /p startPort=Enter start port: 
set /p endPort=Enter end port: 

echo.
echo Scanning %target% from port %startPort% to %endPort%...
echo Results will be saved to portscan_results.txt
echo.

echo Port Scan Results for %target% > portscan_results.txt
echo Port Range: %startPort%-%endPort% >> portscan_results.txt
echo. >> portscan_results.txt

for /l %%p in (%startPort%,1,%endPort%) do (
    powershell -command ^
        "$r = Test-NetConnection -ComputerName '%target%' -Port %%p -WarningAction SilentlyContinue; ^
         if ($r.TcpTestSucceeded) { Write-Output 'Port %%p OPEN' } else { Write-Output 'Port %%p closed' }" > temp.txt

    set /p result=<temp.txt
    echo %result%
    echo %result% >> portscan_results.txt
)

del temp.txt
echo.
echo Scan complete.
pause
goto menu

:nmap
cls
echo ================================
echo            NMAP LAUNCHER
echo ================================
echo.

where nmap >nul 2>&1
if %errorlevel% neq 0 (
    echo Nmap not found on system.
    echo Install from: https://nmap.org/download.html
    pause
    goto menu
)

set /p nmapTarget=Enter target for Nmap scan: 
echo.
echo Select scan type:
echo 1. Quick scan (nmap -T4 -F)
echo 2. Intense scan (nmap -T4 -A)
echo 3. Full port scan (nmap -p-)
echo.
set /p scanChoice=Choice: 

if "%scanChoice%"=="1" set scanCmd=nmap -T4 -F %nmapTarget%
if "%scanChoice%"=="2" set scanCmd=nmap -T4 -A %nmapTarget%
if "%scanChoice%"=="3" set scanCmd=nmap -p- %nmapTarget%

echo.
echo Running: %scanCmd%
echo.
%scanCmd%
echo.
pause
goto menu
