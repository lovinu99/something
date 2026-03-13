@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "$script = (Get-Content '%~f0' -Raw) -replace '(?s)^.*:PS_START\r?\n', ''; Invoke-Command -ScriptBlock ([scriptblock]::Create($script))"
exit /b

:PS_START

if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
    Write-Host "Installing PSReadLine..." -ForegroundColor Cyan
    Install-Module PSReadLine -Force -SkipPublisherCheck
}

if (-not (Test-Path -Path $PROFILE)) {
    New-Item -Path $PROFILE -ItemType File -Force | Out-Null
}

$profileContent = Get-Content -Path $PROFILE -Raw -ErrorAction SilentlyContinue

if ($null -eq $profileContent -or $profileContent -notmatch "PredictionSource History") {
    $config = "`r`nImport-Module PSReadLine`r`nSet-PSReadLineOption -PredictionSource History`r`nSet-PSReadLineOption -Colors @{ InlinePrediction = 'Green' }`r`n"
    Add-Content -Path $PROFILE -Value $config
    Write-Host "Configuration added successfully!" -ForegroundColor Green
}
else {
    Write-Host "Configuration already exists. Skipping." -ForegroundColor Yellow
}

Write-Host "Setup complete! Closing in 5 seconds..." -ForegroundColor Green
Start-Sleep -Seconds 5