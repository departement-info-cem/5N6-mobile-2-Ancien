$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8

$INITIAL_DIR = Get-Location

$DOWNLOADS = "Z:\.config\android"
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

Add-Env "ANDROID_SDK_ROOT" "$HOME\AppData\Local\Android\Sdk"
Add-Env "ANDROID_HOME" "$env:ANDROID_SDK_ROOT"
Add-Env "Path" "$env:ANDROID_SDK_ROOT\cmdline-tools\version\bin"

Write-Host '🕹️  Command Line Tools' -ForegroundColor Blue

if (-Not ( Test-Path $env:ANDROID_SDK_ROOT\cmdline-tools\version\bin )) {
    Invoke-Download "Command Line Tools" $CMD_LINE_TOOLS_URL "commandlinetools"
    # Créer hiérarchie pour tools
    [void](New-Item -type directory -Path "$env:ANDROID_SDK_ROOT\cmdline-tools\" -Force)
    Invoke-Install "Command Line Tools" $env:ANDROID_SDK_ROOT\cmdline-tools "cmdline-tools" "commandlinetools"
    Rename-Item "$env:ANDROID_SDK_ROOT\cmdline-tools\cmdline-tools" "version"
}
else {
    Write-Host '    ✔️  Command Line Tools est déjà installé.' -ForegroundColor Green
}

Write-Host '🧮  Installation des outils de développement d''Android' -ForegroundColor Blue

Write-Host '    👍 Installation démarrée.' -ForegroundColor Blue

sdkmanager 'platform-tools' "platforms;android-$CURRENT_SDK_VERSION" "system-images;android-$CURRENT_SDK_VERSION;google_apis;x86_64" "build-tools;$CURRENT_BUILD_TOOLS_VERSION" "cmdline-tools;latest"

Write-Host '    ✔️  Outils installé' -ForegroundColor Green

Write-Host '👾  Création de la machine virtuelle' -ForegroundColor Blue

if (-Not ($(avdmanager list avd) -is [array])) {
    avdmanager -s create avd -n pixel -k "system-images;android-$CURRENT_SDK_VERSION;google_apis;x86_64" --device "pixel_5"
    Write-Host '    ✔️  La machine virtuelle a été créée.' -ForegroundColor Green
}
else {
    Write-Host '    ✔️  La machine virtuelle existe déjà.' -ForegroundColor Green
}

Write-Host '🤖  Android Studio' -ForegroundColor Blue

if (-Not ( Test-Path $HOME\android-studio )) {
    Invoke-Download "Android Studio" $STUDIO_URL "android-studio"
    Invoke-Install "Android Studio" "$HOME" "android-studio\bin" "android-studio"
    Add-Shortcut $HOME\android-studio\bin\studio64.exe "Android Studio"
}
else {
    Write-Host '    ✔️  Android Studio est déjà installé.'  -ForegroundColor Green
}

Add-Env "Path" "$HOME\android-studio\bin"

if (-Not(Test-Path $HOME\android-studio\plugins\flutter-intellij)) {
    Invoke-Download "plugin Flutter" $FLUTTER_PLUGIN_URL_STUDIO "plugin-flutter-android-studio"
    Invoke-Install "plugin Flutter" "$HOME\android-studio\plugins" "flutter-intellij" "plugin-flutter-android-studio"
}
else {
    Write-Host '    ✔️  Le plugin Flutter est déjà installé.'  -ForegroundColor Green
}

if (-Not(Test-Path $HOME\android-studio\plugins\dart)) {
    Invoke-Download "plugin Dart" $DART_PLUGIN_URL_STUDIO "plugin-dart-android-studio"
    Invoke-Install "plugin Dart" "$HOME\android-studio\plugins" "dart" "plugin-dart-android-studio"
}
else {
    Write-Host '    ✔️  Le plugin Dart est déjà installé.'  -ForegroundColor Green
}

Write-Host '🧠  IntelliJ' -ForegroundColor Blue

if (-Not ( Test-Path $HOME\idea )) {
    Invoke-Download "IntelliJ" "https://data.services.jetbrains.com/products/download?platform=windowsZip&code=IIU" "idea"
    Invoke-Install "IntelliJ" "$HOME\idea" "bin" "idea"
    Add-Shortcut $HOME\idea\bin\idea64.exe "IntelliJ IDEA Ultimate"
}
else {
    Write-Host '    ✔️  IntelliJ est déjà installé.'  -ForegroundColor Green
}

Add-Env "Path" "$HOME\idea\bin"

if (-Not(Test-Path $HOME\idea\plugins\flutter-intellij)) {
    Invoke-Download "plugin Flutter" $FLUTTER_PLUGIN_URL_IDEA "plugin-flutter-idea"
    Invoke-Install "plugin Flutter" "$HOME\idea\plugins" "flutter-intellij" "plugin-flutter-idea"
}
else {
    Write-Host '    ✔️  Le plugin Flutter est déjà installé.'  -ForegroundColor Green
}

if (-Not(Test-Path $HOME\idea\plugins\dart)) {
    Invoke-Download "plugin Dart" $DART_PLUGIN_URL_IDEA "plugin-dart-idea"
    Invoke-Install "plugin Dart" "$HOME\idea\plugins" "dart" "plugin-dart-idea"
}
else {
    Write-Host '    ✔️  Le plugin Dart est déjà installé.'  -ForegroundColor Green
}

Write-Host '🐤  Flutter' -ForegroundColor Blue

[void](git config --global --add safe.directory C:/Flutter)
[void](flutter config --android-sdk "$HOME\AppData\Local\Android\Sdk")
[void](flutter config --android-studio-dir="C:\Users\po.brillant\android-studio")

Write-Host '    👍 Mise à jour' -ForegroundColor Blue

[void](flutter upgrade)

Write-Host '    👍 Accepter les licenses.' -ForegroundColor Blue

flutter doctor --android-licenses

Set-Location $INITIAL_DIR

Write-Host '✔️ ✔️ ✔️  Mise en place complétée ✔️ ✔️ ✔️'`n -ForegroundColor Green

flutter doctor
