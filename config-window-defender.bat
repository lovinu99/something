@echo off
setlocal EnableDelayedExpansion

:: ==========================================
:: Require Administrator
:: ==========================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo.
echo ==========================================
echo Microsoft Defender Dev Optimization
echo ==========================================
echo.

:: ==========================================
:: Folder exclusions
:: ==========================================

for %%D in (
    "D:\Projects"
    "D:\Workspace"
    "C:\src"
) do (
    if exist "%%~D" (
        echo Checking folder: %%~D

        powershell -NoProfile -Command ^
        "$p='%%~D';" ^
        "if((Get-MpPreference).ExclusionPath -notcontains $p){" ^
        "Add-MpPreference -ExclusionPath $p;" ^
        "Write-Host '[ADDED] ' $p" ^
        "}else{" ^
        "Write-Host '[EXISTS]' $p" ^
        "}"
    ) else (
        echo [SKIPPED] Folder not found: %%~D
    )
)

echo.

:: ==========================================
:: Process exclusions
:: ==========================================

for %%P in (
    node.exe
    npm.exe
    pnpm.exe
    yarn.exe
    docker.exe
    git.exe
) do (

    powershell -NoProfile -Command ^
    "$p='%%P';" ^
    "if((Get-MpPreference).ExclusionProcess -notcontains $p){" ^
    "Add-MpPreference -ExclusionProcess $p;" ^
    "Write-Host '[ADDED] ' $p" ^
    "}else{" ^
    "Write-Host '[EXISTS]' $p" ^
    "}"
)

echo.

:: ==========================================
:: Reduce scan CPU usage
:: ==========================================

powershell -NoProfile -Command ^
"Set-MpPreference -ScanAvgCPULoadFactor 20"

echo [OK] ScanAvgCPULoadFactor = 20

echo.

:: ==========================================
:: Show current settings
:: ==========================================

echo ==========================================
echo Excluded Folders
echo ==========================================

powershell -NoProfile -Command ^
"(Get-MpPreference).ExclusionPath"

echo.

echo ==========================================
echo Excluded Processes
echo ==========================================

powershell -NoProfile -Command ^
"(Get-MpPreference).ExclusionProcess"

echo.

echo ==========================================
echo Defender RAM Usage
echo ==========================================

powershell -NoProfile -Command ^
"Get-Process MsMpEng -ErrorAction SilentlyContinue | Select Name,@{N='RAM(MB)';E={[math]::Round($_.WorkingSet64/1MB,1)}},CPU"

echo.
echo ==========================================
echo Completed
echo ==========================================
pause
