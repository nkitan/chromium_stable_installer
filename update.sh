#! /bin/bash

INSTALLER="$(pwd)"
INSTALLED="/opt/chromium"

sudo mkdir -p /opt/chromium

#LASTCHANGE_URL=""https://github.com/nkitan/chromium_stable_installer/blob/master/current_latest_revision.txt""

#REVISION=$(curl -s -S $LASTCHANGE_URL)
REVISION='812859'

echo "latest revision is $REVISION"

if [ -d $REVISION ] && [ "$1" != -f ] ; then
  echo "already have latest version"
  exit
fi

ZIP_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F$REVISION%2Fchrome-linux.zip?alt=media"
ZIP_FILE="${REVISION}-chrome-linux.zip"

echo "fetching $ZIP_URL"
 
echo "deleting previous installation"
sudo rm -rf $REVISION
sudo mkdir $REVISION
pushd $REVISION

if [ $? == 0 ] ; then
        echo "removed successfully, proceeding to install"
else
        echo "couldn't remove previous installation, exiting"
        exit
fi

sudo bash -c "curl -# $ZIP_URL > $ZIP_FILE"

echo "unzipping.."
sudo unzip $ZIP_FILE
[ $? -ne 0 ] && { printf "Error: not a valid zip file\n" ; exit 1; }

popd
sudo rm -f $INSTALLED/latest
sudo ln -s $INSTALLED/$REVISION/chrome-linux/ $INSTALLED/latest
sudo ln -s -f $INSTALLED/latest/chrome /usr/bin/chromium && sudo chmod +x /usr/bin/chromium
sudo cp $INSTALLER/chromium.desktop /usr/share/applications/chromium.desktop
 
