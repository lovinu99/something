@echo off

:: ============================================================
:: Elevate to Administrator
:: ============================================================

net session >nul 2>&1

if %errorLevel% neq 0 (
    echo [INFO] Requesting Administrator privileges...

    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "Start-Process -FilePath '%~f0' -Verb RunAs"

    exit /b
)

:: ============================================================
:: Execute Embedded PowerShell
:: ============================================================

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$script=(Get-Content '%~f0' -Raw)-replace '(?s)^.*:PS_START\r?\n',''; Invoke-Command -ScriptBlock ([scriptblock]::Create($script))"

exit /b

:PS_START

function Write-Log {
    param(
        [string]$Level,
        [string]$Message
    )

    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    switch ($Level) {
        "INFO"    { $color = "Cyan" }
        "SUCCESS" { $color = "Green" }
        "WARN"    { $color = "Yellow" }
        "ERROR"   { $color = "Red" }
        default   { $color = "White" }
    }

    Write-Host "[$time][$Level] $Message" -ForegroundColor $color
}

function Install-LatestPSReadLine {

    Write-Log INFO "Checking PSReadLine installation..."

    $modules =
        Get-Module PSReadLine -ListAvailable |
        Sort-Object Version -Descending

    if ($modules) {

        foreach ($module in $modules) {

            Write-Log INFO "Found: $($module.Version) => $($module.Path)"
        }
    }

    $latestInstalled = $modules | Select-Object -First 1

    $needsUpgrade =
        (-not $latestInstalled) -or
        ($latestInstalled.Version -lt [version]'2.1.0')

    if ($needsUpgrade) {

        Write-Log WARN "PSReadLine missing or outdated."

        try {

            if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {

                Write-Log INFO "Installing NuGet provider..."

                Install-PackageProvider `
                    -Name NuGet `
                    -Scope CurrentUser `
                    -Force

                Write-Log SUCCESS "NuGet installed."
            }

            try {
                Set-PSRepository `
                    -Name PSGallery `
                    -InstallationPolicy Trusted `
                    -ErrorAction SilentlyContinue
            }
            catch {}

            Write-Log INFO "Installing latest PSReadLine..."

            Install-Module `
                -Name PSReadLine `
                -Scope CurrentUser `
                -AllowClobber `
                -Force `
                -SkipPublisherCheck

            Write-Log SUCCESS "PSReadLine installation complete."
        }
        catch {

            Write-Log ERROR "Failed to install PSReadLine."
            Write-Log ERROR $_.Exception.Message

            return $false
        }
    }

    try {

        $latest =
            Get-Module PSReadLine -ListAvailable |
            Sort-Object Version -Descending |
            Select-Object -First 1

        if (-not $latest) {

            Write-Log ERROR "PSReadLine not found after installation."
            return $false
        }

        Remove-Module PSReadLine -Force -ErrorAction SilentlyContinue

        Import-Module $latest.Path -Force

        $loaded = Get-Module PSReadLine

        Write-Log SUCCESS "Loaded PSReadLine $($loaded.Version)"
        Write-Log INFO "Path: $($loaded.Path)"

        return $true
    }
    catch {

        Write-Log ERROR "Failed to load PSReadLine."
        Write-Log ERROR $_.Exception.Message

        return $false
    }
}

Write-Log INFO "Starting setup..."

# ============================================================
# PowerShell Version
# ============================================================

Write-Log INFO "PowerShell Version: $($PSVersionTable.PSVersion)"

# ============================================================
# Execution Policy
# ============================================================

$currentPolicy = Get-ExecutionPolicy

Write-Log INFO "Execution Policy: $currentPolicy"

if ($currentPolicy -eq "Restricted") {

    try {

        Set-ExecutionPolicy `
            -ExecutionPolicy RemoteSigned `
            -Scope CurrentUser `
            -Force

        Write-Log SUCCESS "ExecutionPolicy changed to RemoteSigned."
    }
    catch {

        Write-Log ERROR "Unable to update ExecutionPolicy."
        Write-Log ERROR $_.Exception.Message
    }
}

# ============================================================
# PSReadLine
# ============================================================

$loaded = Install-LatestPSReadLine

if (-not $loaded) {

    Write-Log ERROR "PSReadLine setup failed."
    Read-Host "Press ENTER to exit"
    exit 1
}

# ============================================================
# PowerShell Profile
# ============================================================

try {

    Write-Log INFO "Profile path: $PROFILE"

    if (-not (Test-Path $PROFILE)) {

        $folder = Split-Path $PROFILE

        if (-not (Test-Path $folder)) {

            New-Item `
                -ItemType Directory `
                -Path $folder `
                -Force | Out-Null
        }

        New-Item `
            -ItemType File `
            -Path $PROFILE `
            -Force | Out-Null

        Write-Log SUCCESS "Profile created."
    }

    $profileContent =
        Get-Content `
            -Path $PROFILE `
            -Raw `
            -ErrorAction SilentlyContinue
}
catch {

    Write-Log ERROR "Cannot access PowerShell profile."
    Write-Log ERROR $_.Exception.Message

    Read-Host "Press ENTER to exit"
    exit 1
}

# ============================================================
# Profile Configuration
# ============================================================

$config = @"

# BEGIN_AUTOCOMPLETE_CONFIG

try {

    Import-Module PSReadLine -ErrorAction Stop

    `$command = Get-Command Set-PSReadLineOption

    if (`$command.Parameters.ContainsKey('PredictionSource')) {

        Set-PSReadLineOption -PredictionSource History

        if (`$command.Parameters.ContainsKey('PredictionViewStyle')) {

            Set-PSReadLineOption `
                -PredictionViewStyle ListView
        }
    }
}
catch {
}

# END_AUTOCOMPLETE_CONFIG

"@

if ($profileContent -notmatch 'BEGIN_AUTOCOMPLETE_CONFIG') {

    Add-Content `
        -Path $PROFILE `
        -Value $config

    Write-Log SUCCESS "Profile configuration added."
}
else {

    Write-Log INFO "Configuration already exists."
}

# ============================================================
# Validation
# ============================================================

try {

    $command = Get-Command Set-PSReadLineOption

    if ($command.Parameters.ContainsKey('PredictionSource')) {

        Write-Log SUCCESS "PredictionSource supported."
    }
    else {

        Write-Log WARN "PredictionSource not supported by loaded PSReadLine."
    }
}
catch {

    Write-Log WARN "Cannot verify PredictionSource support."
}

# ============================================================
# Done
# ============================================================

Write-Host ""
Write-Log SUCCESS "Setup completed successfully."
Write-Host ""

Write-Host "Restart PowerShell or Windows Terminal to apply changes."
Write-Host ""

Read-Host "Press ENTER to close"
