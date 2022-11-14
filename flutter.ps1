$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8

$INITIAL_DIR = Get-Location

$DOWNLOADS = "Z:\.config\android"
$DOWNLOADS = "\\ed4depinfo\Cours\A22\3N5"
# $DOWNLOADS = $HOME + '\Downloads'

$STUDIO_URL = 'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.3.1.17/android-studio-2021.3.1.17-windows.zip'
$CMD_LINE_TOOLS_URL = 'https://dl.google.com/android/repository/commandlinetools-win-8512546_latest.zip'
$FLUTTER_PLUGIN_URL_IDEA = 'https://plugins.jetbrains.com/plugin/download?rel=true&updateId=231428'
$DART_PLUGIN_URL_IDEA = 'https://plugins.jetbrains.com/plugin/download?rel=true&updateId=233333'
$FLUTTER_PLUGIN_URL_STUDIO = 'https://plugins.jetbrains.com/plugin/download?rel=true&updateId=231426'
$DART_PLUGIN_URL_STUDIO = 'https://plugins.jetbrains.com/plugin/download?rel=true&updateId=229981'
$CURRENT_SDK_VERSION = "33"
$CURRENT_BUILD_TOOLS_VERSION = "33.0.0"

function Get-Env-Contains([string]$name, [string]$value) {
    return [System.Environment]::GetEnvironmentVariable($name, "User") -like "*$value*"
}

function Invoke-Env-Reload() {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    $env:ANDROID_SDK_ROOT = [System.Environment]::GetEnvironmentVariable("ANDROID_SDK_ROOT", "User")
    $env:ANDROID_HOME = [System.Environment]::GetEnvironmentVariable("ANDROID_HOME", "User")
}

# Source : https://stackoverflow.com/a/9701907
function Add-Shortcut([string]$source_exe, [string]$name) {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\$name.lnk")
    $Shortcut.TargetPath = $source_exe
    $Shortcut.Save()
}

function Add-Env([string]$name, [string]$value) {
    if (-Not (Get-Env-Contains $name $value) ) {
        Write-Host '    👍 Ajout de'$value' à'$name'.' -ForegroundColor Blue
        $new_value = [Environment]::GetEnvironmentVariable("$name", "User")
        if (-Not ($new_value -eq $null)) {
            $new_value += [IO.Path]::PathSeparator
        }
        $new_value += $value
        [Environment]::SetEnvironmentVariable( "$name", $new_value, "User" )
        if (Get-Env-Contains $name $new_value) {
            Invoke-Env-Reload
            Write-Host '    ✔️  '$value' ajouté à '$name'.'  -ForegroundColor Green
        }
        else {
            Set-Location $INITIAL_DIR
            Write-Host '    ❌ '$value' n''a pas été ajouté à '$name'.' -ForegroundColor Red
            exit
        }
    }
    else {
        Write-Host '    ✔️ '$value' déjà ajouté à '$name'.'  -ForegroundColor Green
    }
}

function Invoke-Download {
    Param(
        [parameter(Mandatory = $true)]
        [String]
        $Name,
        [parameter(Mandatory = $true)]
        [String]
        $Url,
        [parameter(Mandatory = $true)]
        [String]
        $ZipName
    )
    if ( -Not ( Test-Path $DOWNLOADS\$ZipName.zip)) {
        Write-Host '    👍 Téléchargement de'$Name' débuté.' -ForegroundColor Blue
        Set-Location $DOWNLOADS
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest $Url -OutFile "$ZipName.zip"
        $ProgressPreference = 'Continue'
                
        if (Test-Path $DOWNLOADS/$ZipName.zip ) {
            Write-Host '    ✔️ '$Name' téléchargé.' -ForegroundColor Green
        }
        else {
            Set-Location $INITIAL_DIR
            Write-Host '    ❌ '$Name' n''a pas pu être téléchargé.' -ForegroundColor Red
            exit
        }
    }
    else {
        Write-Host '    ✔️ '$Name' est déjà téléchargé.' -ForegroundColor Green
    }
}

function Invoke-Install() {
    Param(
        [parameter(Mandatory = $true)]
        [String]
        $Name,
        [parameter(Mandatory = $true)]
        [String]
        $InstallLocation,
        [parameter(Mandatory = $true)]
        [String]
        $FinalDir,
        [parameter(Mandatory = $true)]
        [String]
        $ZipName
    )
    Write-Host '    👍 Extraction de'$Name' débuté.' -ForegroundColor Blue
    $ZIP_LOCATION = Get-ChildItem $DOWNLOADS\"$ZipName.zip"
    $ProgressPreference = 'SilentlyContinue'
    Expand-Archive $ZIP_LOCATION $InstallLocation
    $ProgressPreference = 'Continue'
    if (Test-Path  $InstallLocation\$FinalDir ) {
        Write-Host '    ✔️ '$Name' installé.' -ForegroundColor Green
    }
    else {
        Set-Location $INITIAL_DIR
        Write-Host '    ❌  Échec lors de l''installation de'$Name'.' -ForegroundColor Red
    }
}

[void](New-Item -type directory -Path "$DOWNLOADS" -Force)

Invoke-Env-Reload

Write-Host '🕰️  Mise à jour des variables d''environnement' -ForegroundColor Blue


function Update-Flutter() {
    $INITIAL_DIR = Get-Location
    Write-Host '🐤  Flutter' -ForegroundColor Blue
    [void](git config --global --add safe.directory C:/Flutter)
    [void](flutter config --android-sdk "$HOME\AppData\Local\Android\Sdk")
    [void](flutter config --android-studio-dir="$HOME\android-studio")
    Write-Host '    👍 Mise à jour' -ForegroundColor Blue
    [void](flutter upgrade)
    Write-Host '    👍 Accepter les licenses.' -ForegroundColor Blue
    flutter doctor --android-licenses
    Set-Location $INITIAL_DIR
    Write-Host '✔️ ✔️ ✔️  Mise en place complétée ✔️ ✔️ ✔️'`n -ForegroundColor Green
    flutter doctor
}

Update-Flutter