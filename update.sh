#! /bin/bash

cd $(dirname $0) 

#LASTCHANGE_URL=""https://github.com/nkitan/chromium_stable_installer/blob/master/current_latest_revision.txt""

#REVISION=$(curl -s -S $LASTCHANGE_URL)
REVISION='812859'

echo "latest revision is $REVISION"

if [ -d $REVISION ] ; then
  echo "already have latest version"
  exit
fi

ZIP_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F$REVISION%2Fchrome-linux.zip?alt=media"
ZIP_FILE="${REVISION}-chrome-linux.zip"

echo "fetching $ZIP_URL"
 
echo "deleting previous installation"
rm -rf $REVISION
mkdir $REVISION
pushd $REVISION

if [ $? == 0 ] ; then
        echo "removed successfully, proceeding to install"
else
        echo "couldn't remove previous installation, exiting"
        exit
fi

curl -# $ZIP_URL > $ZIP_FILE
echo "unzipping.."
unzip $ZIP_FILE
[ $? -ne 0 ] && { printf "Error: not a valid zip file\n" ; exit 1; }

popd
rm -f ./latest
ln -s $REVISION/chrome-linux/ ./latest

