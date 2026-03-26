@echo off
title Windows 11 Context Menu Switch

:: ================================
:: Check for Admin
:: ================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ================================
:: Menu
:: ================================
:menu
cls
echo ================================
echo   Windows 11 Context Menu Tool
echo ================================
echo.
echo 1. Restore OLD (Classic) Context Menu ( Windows 10 )
echo 2. Restore MODERN (Default) Context Menu ( Windows 11 )
echo 0. Exit
echo.

set /p choice=Select option (0-2): 

if "%choice%"=="1" goto classic
if "%choice%"=="2" goto modern
if "%choice%"=="0" exit

echo Invalid choice!
pause
goto menu

:: ================================
:: Classic Menu
:: ================================
:classic
echo.
echo Applying Classic Context Menu...

reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

echo Done.
echo Restarting explorer...

taskkill /f /im explorer.exe
start explorer.exe
pause
goto menu

:: ================================
:: Modern Menu
:: ================================
:modern
echo.
echo Restoring Modern Context Menu...

reg.exe delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f

echo Done.
echo Restarting explorer...

taskkill /f /im explorer.exe
start explorer.exe

pause
goto menu