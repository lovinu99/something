@echo off

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

setlocal

reg add "HKCR\ms-gamebar" /f /ve /d "URL:ms-gamebar" >nul 2>&1
reg add "HKCR\ms-gamebar" /f /v "URL Protocol" /d "" >nul 2>&1
reg add "HKCR\ms-gamebar" /f /v "NoOpenWith" /d "" >nul 2>&1
reg add "HKCR\ms-gamebar\shell\open\command" /f /ve /d "\"%SystemRoot%\System32\systray.exe\"" >nul 2>&1

reg add "HKCR\ms-gamebarservices" /f /ve /d "URL:ms-gamebarservices" >nul 2>&1
reg add "HKCR\ms-gamebarservices" /f /v "URL Protocol" /d "" >nul 2>&1
reg add "HKCR\ms-gamebarservices" /f /v "NoOpenWith" /d "" >nul 2>&1
reg add "HKCR\ms-gamebarservices\shell\open\command" /f /ve /d "\"%SystemRoot%\System32\systray.exe\"" >nul 2>&1

echo Xbox Game Bar protocol handlers disabled.
pause
