if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

function Check-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# -----------------------------------------------------------------------------
$computerName = Read-Host 'Enter new computer name'
Write-Host "Renaming this computer to: " $computerName  -ForegroundColor Yellow
Rename-Computer -NewName $computerName
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Disabling computer sleep when plugged in..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Powercfg /Change monitor-timeout-ac 20
Powercfg /Change standby-timeout-ac 0
# -----------------------------------------------------------------------------
# To list all appx packages:
# Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName
Write-Host "Removing UWP Rubbish..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$uwpRubbishApps = @(
    "Microsoft.Messaging",
    "king.com.CandyCrushSaga",
    "Microsoft.BingNews",
    "Microsoft.BingWeather",
    "Microsoft.GetHelp",
    "Microsoft.3DViewer",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MicrosoftStickyNotes",
    "Microsoft.MSPaint",
    "Microsoft.SkypeApp",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.People",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.YourPhone",
    "Microsoft.MicrosoftOfficeHub",
    "Fitbit.FitbitCoach",
    "4DF9E0F8.Netflix")

foreach ($uwp in $uwpRubbishApps) {
    Get-AppxPackage -Name $uwp | Remove-AppxPackage
}
# -----------------------------------------------------------------------------

if (Check-Command -cmdname 'choco') {
    Write-Host "Chocolatey is already installed, skipping installation."
}
else {
    Write-Host ""
    Write-Host "Installing Chocolatey for Windows..." -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    choco feature disable --name="'showNonElevatedWarnings'"
}

Write-Host ""
Write-Host "Installing Applications via Chocolatey..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green

# -----------------------------------------------------------------------------
if (Check-Command -cmdname 'git') {
    Write-Host "Git is already installed, checking new version..."
    choco update git -y
}
else {
    Write-Host ""
    Write-Host "Installing Git for Windows..." -ForegroundColor Green
    choco install git -y
}

choco install winrar -y
choco install googlechrome -y
choco install vlc -y
choco install ffmpeg -y
choco install sysinternals -y
choco install sublimetext3.app -y
choco install filezilla -y
choco install steam -y
choco install discord -y
choco install bitwarden -y
choco install reaper -y
choco install github-desktop -y
choco install putty -y
choco install audacity -y
choco install deluge -y
choco install iobit-uninstaller -y
choco install sharex -y

# -----------------------------------------------------------------------------
Write-Host "Installing Translucent Taskbar..." -ForegroundColor Green
wget https://github.com/TranslucentTB/TranslucentTB/releases/download/2020.1/TranslucentTB-setup.exe  -OutFile C:\Users\$env:UserName\Downloads\TranslucentTB-setup.exe
Start-Process -FilePath "C:\Users\$env:UserName\Downloads\TranslucentTB-setup.exe"
# -----------------------------------------------------------------------------
Write-Host "Installing Spybot Anti-Beacon 1.6..." -ForegroundColor Green
wget https://download.spybot.info/AntiBeacon/SpybotAntiBeacon-1.6-setup.exe  -OutFile C:\Users\$env:UserName\Downloads\SpybotAntiBeacon-1.6-setup.exe
Start-Process -FilePath "C:\Users\$env:UserName\Downloads\SpybotAntiBeacon-1.6-setup.exe"
# -----------------------------------------------------------------------------
$geforceInstall = Read-Host 'Install Geforce Experience? (y/n)'
if ($geforceInstall -eq 'y') {
    Write-Host ""
    Write-Host "Installing Geforce Experience..." -ForegroundColor Green
    choco install geforce-experience -y
}
else {
    Write-Host "Skipping Geforce Experience..."
}
# -----------------------------------------------------------------------------
$razerInstall = Read-Host 'Install Razer Synapse? (y/n)'
if ($razerInstall -eq 'y') {
    Write-Host ""
    Write-Host "Installing Razer Synapse..." -ForegroundColor Green
    wget https://dl.razerzone.com/drivers/Synapse3/win/RazerSynapseInstaller_V1.0.125.158.exe  -OutFile C:\Users\$env:USERPROFILE\Downloads\RazerSynapseInstaller.exe
    Start-Process -FilePath "C:\Users\$env:USERPROFILE\Downloads\RazerSynapseInstaller.exe"
}
else {
    Write-Host "Skipping Razer Synapse..."
}
# -----------------------------------------------------------------------------
$steelSeriesInstall = Read-Host 'Install SteelSeries Engine? (y/n)'
if ($steelSeriesInstall -eq 'y') {
    Write-Host ""
    Write-Host "Installing SteelSeries Engine..." -ForegroundColor Green
    wget https://engine.steelseriescdn.com/SteelSeriesEngine3.17.4Setup.exe  -OutFile C:\Users\$env:USERPROFILE\Downloads\SteelSeriesEngineInstaller.exe
    Start-Process -FilePath "C:\Users\$env:USERPROFILE\Downloads\SteelSeriesEngineInstaller.exe"
}
else {
    Write-Host "Skipping SteelSeries Engine..."
}
# -----------------------------------------------------------------------------

Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "Setup complete! Restart required, press [ENTER] to restart computer."
Restart-Computer
