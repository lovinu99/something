```bat
@echo off
setlocal EnableExtensions

:: =====================================================
:: CONFIGURATION
:: =====================================================

set "DIR=%ProgramData%\LocalDNS"
set "CADDY=%DIR%\caddy.exe"
set "CONFIG=%DIR%\Caddyfile"
set "HOSTS=%SystemRoot%\System32\drivers\etc\hosts"

:: =====================================================
:: ADMIN
:: =====================================================

net session >nul 2>&1
if errorlevel 1 (
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: =====================================================
:: PREPARE
:: =====================================================

if not exist "%DIR%" mkdir "%DIR%"

echo.
echo ========================================
echo          LOCAL DNS MANAGER
echo ========================================

:: =====================================================
:: GENERATE CONFIGURATION
:: =====================================================

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop';" ^
 "$dir='%DIR%';" ^
 "$config='%CONFIG%';" ^
 "$hosts='%HOSTS%';" ^
 "$apps=@(" ^
 "  @{Domain='local.9r';Port=20128}," ^
 "  @{Domain='local.dashboard';Port=20129}" ^
 ");" ^
 "$caddy=@();" ^
 "foreach($app in $apps) {" ^
 "  Write-Host ('[MAP] http://'+$app.Domain+' -> 127.0.0.1:'+ $app.Port);" ^
 "  $caddy += 'http://'+$app.Domain+' {';" ^
 "  $caddy += '    bind 127.0.0.1';" ^
 "  $caddy += '    reverse_proxy 127.0.0.1:'+$app.Port;" ^
 "  $caddy += '}';" ^
 "  $caddy += '';" ^
 "};" ^
 "[IO.File]::WriteAllLines($config,$caddy,[Text.Encoding]::UTF8);" ^
 "$marker='# LOCAL-DNS-MANAGED';" ^
 "$lines=@([IO.File]::ReadAllLines($hosts) | Where-Object { $_ -notlike ('*'+$marker) });" ^
 "foreach($app in $apps) { $lines += '127.0.0.1 '+$app.Domain+' '+$marker };" ^
 "Copy-Item $hosts ($hosts+'.backup') -Force;" ^
 "[IO.File]::WriteAllLines($hosts,$lines,[Text.Encoding]::ASCII);"

if errorlevel 1 (
    echo [ERROR] Configuration generation failed.
    pause
    exit /b 1
)

:: =====================================================
:: DOWNLOAD CADDY
:: =====================================================

if not exist "%CADDY%" (
    echo [INFO] Downloading Caddy...

    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
      "Invoke-WebRequest 'https://caddyserver.com/api/download?os=windows&arch=amd64' -OutFile '%CADDY%'"

    if errorlevel 1 (
        echo [ERROR] Download failed.
        pause
        exit /b 1
    )
)

:: =====================================================
:: VALIDATE
:: =====================================================

echo.
echo [INFO] Validating Caddyfile...

"%CADDY%" validate --config "%CONFIG%"

if errorlevel 1 (
    echo [ERROR] Invalid Caddyfile.
    pause
    exit /b 1
)

:: =====================================================
:: START / RELOAD
:: =====================================================

echo.
echo [INFO] Applying Caddy configuration...

"%CADDY%" reload --config "%CONFIG%" >nul 2>&1

if errorlevel 1 (
    tasklist /FI "IMAGENAME eq caddy.exe" | find /I "caddy.exe" >nul

    if not errorlevel 1 (
        echo [ERROR] Caddy reload failed.
        pause
        exit /b 1
    )

    netstat -ano | findstr /R /C:":80 .*LISTENING" >nul

    if not errorlevel 1 (
        echo [ERROR] Port 80 is occupied.
        pause
        exit /b 1
    )

    start "Local DNS" /min "%CADDY%" run --config "%CONFIG%"
)

ipconfig /flushdns >nul

echo.
echo ========================================
echo CONFIGURATION SUCCESS
echo ========================================
echo.
echo http://local.9r        -^> 20128
echo http://local.dashboard -^> 20129
echo.
echo Caddyfile: %CONFIG%
echo Hosts backup: %HOSTS%.backup
echo.
pause
```
