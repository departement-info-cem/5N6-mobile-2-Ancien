echo "password is $1"

echo telecharge client GitKraken

curl -L  https://release.gitkraken.com/darwin/installGitKraken.dmg -o kraken.dmg
curl -L "https://download.jetbrains.com/idea/ideaIC-2021.2.3-aarch64.dmg?_gl=1*1c0kz5q*_ga*NDE3OTM0OTYzLjE2MzY3NDE2OTU.*_ga_V0XZL7QHEB*MTYzNjc0MTY5NS4xLjEuMTYzNjc0MTk0NS4w&_ga=2.90621594.1048648670.1636741695-417934963.1636741695" -o intellij.dmg



echo ouvrir le DMG du Kraken

hdiutil attach kraken.dmg
cp -R /Volumes/Install\ GitKraken/GitKraken.app /Applications
# open Gitkraken first time
open -a GitKraken

hdiutil attach intellij.dmg
cp -R /Volumes/IntelliJ\ IDEA\ CE/IntelliJ\ IDEA\ CE.app /Applications/


# configure Xcode
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
open -a XCode

echo installation de Brew
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update
brew install ruby
# TODO edit path
# TODO modify current PATH
sudo gem install cocoapods
sudo gem update


echo installation de flutter
# install flutter
curl https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_2.5.3-stable.zip --output flutter.zip
echo suppresion_flutter_existant
rm -rf flutter
unzip -qq flutter.zip

echo "$1" | sudo rm -rf /opt/flutter
echo "$1" | sudo cp -R flutter /opt/
flutter doctor
echo "$1" | sudo chown -R 777 /opt/flutter
echo "$1" | sudo chmod -R 777 /opt/flutter
flutter upgrade
flutter doctor

echo install rosetta
# install Rosetta
/usr/sbin/softwareupdate --install-rosetta

# compte guest
sudo echo -e "000000\000000" | (passwd guest)
# sudo passwd guest 

sudo gem install cocoapods

echo modify-Paths

