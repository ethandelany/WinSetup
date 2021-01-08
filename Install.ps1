if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# -----------------------------------------------------------------------------
$computerName = Read-Host 'Enter new computer name' -Prompt
Write-Host "Renaming this computer to: " $computerName  -ForegroundColor Yellow
Rename-Computer -NewName $computerName
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Disabling computer sleep when plugged in..." -ForegroundColor Green
powercfg /Change monitor-timeout-ac 20
powercfg /Change standby-timeout-ac 0
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Changing power plan to Ultimate Performance" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
$powerPlan = Get-WmiObject -Namespace root\cimv2\power -Class Win32_PowerPlan -Filter "ElementName = 'Ultimate Performance'"
$powerPlan.Activate()
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
    "Microsoft.ZuneMusic",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.Wallet",
    "Microsoft.ZuneVideo",
    "Microsoft.Windows.PeopleExperienceHost",
    "Microsoft.WindowsCamera",
    "Windows.CBSPreview",
    "Microsoft.Windows.Cortana",
    "Microsoft.MicrosoftOfficeHub",
    "Fitbit.FitbitCoach",
    "Microsoft.Wallet",
    "Microsoft.XboxOneSmartGlass",
    "4DF9E0F8.Netflix")

foreach ($uwp in $uwpRubbishApps) {
    Get-AppxPackage -Name $uwp | Remove-AppxPackage
}
# -----------------------------------------------------------------------------

if (Test-Command -cmdname 'choco') {
    Write-Host "Chocolatey is already installed, skipping installation."
}
else {
    Write-Host ""
    Write-Host "Installing Chocolatey for Windows..." -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    choco feature disable --name="'showNonElevatedWarnings'"
}

Write-Host ""
Write-Host "Installing Applications via Chocolatey..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green

# -----------------------------------------------------------------------------
if (Test-Command -cmdname 'git') {
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
choco install vscode -y
choco install filezilla -y
choco install steam -y
choco install discord -y
choco install bitwarden -y
choco install audacity -y
choco install deluge -y
choco install sharex -y
choco install adoptopenjdk11openj9 -y
choco install sysinternals -y
choco install wireshark -y
choco install nmap -y
choco install windirstat -y
choco install shutup10 -y
choco install translucenttb -y
choco install borderlessgaming -y
choco install powertoys -y
choco install jetbrainstoolbox -y
choco install twitch -y
choco install microsoft-windows-terminal -y
choco install maven -y

# -----------------------------------------------------------------------------
$geforceInstall = Read-Host "Install Geforce Experience? (y/n)" -Prompt
if ($geforceInstall -eq "y") {
    Write-Host ""
    Write-Host "Installing Geforce Experience..." -ForegroundColor Green
    choco install geforce-experience -y
}
else {
    Write-Host "Skipping Geforce Experience..."
}
# -----------------------------------------------------------------------------
$focusriteInstall = Read-Host "Install Focusrite Control? (y/n)" -Prompt
if ($focusriteInstall -eq "y") {
    Write-Host ""
    Write-Host "Installing Focusrite Control..." -ForegroundColor Green
    Invoke-WebRequest https://fael-downloads-prod.focusrite.com/customer/prod/s3fs-public/downloads/Focusrite%20Control%20-%203.6.0.1822.exe -OutFile $env:userprofile\Downloads\focusrite.exe
    Start-Process -FilePath "$env:userprofile\Downloads\focusrite.exe"
}
else {
    Write-Host "Skipping Focusrite Control..."
}
# -----------------------------------------------------------------------------
$steelSeriesInstall = Read-Host "Install SteelSeries Engine? (y/n)" -Prompt
if ($steelSeriesInstall -eq "y") {
    Write-Host ""
    Write-Host "Installing SteelSeries Engine..." -ForegroundColor Green
    choco install steelseries-engine -y
}
else {
    Write-Host "Skipping SteelSeries Engine..."
}
# -----------------------------------------------------------------------------
$xtuInstall = Read-Host "Install Intel Extreme Tuning Utilities? (y/n)" -Prompt
if ($xtuInstall -eq "y") {
    Write-Host ""
    Write-Host "Installing Extreme Tuning Utility..." -ForegroundColor Green
    choco install intel-xtu -y
}
else {
    Write-Host "Skipping Extreme Tuning Utility..."
}
# -----------------------------------------------------------------------------

Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "Setup complete! Don't forget to uninstall chocolatey and clean everything up!" -Foregroundcolor Green
