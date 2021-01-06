#!/bin/bash -e
./make-aarch64.sh $*
./make-assets.sh rg351

# Clear the release deployment folder
rm -rf release
mkdir -p release/iortcw/main

# Deploy licenses, binaries, scripts and assets
cp build/release-linux-aarch64/iowolfsp.aarch64 COPYING.txt README.txt release/iortcw/
cp build/release-linux-aarch64/main/*.so build/sp_pak*.pk3             release/iortcw/main/
cp 'assets/scripts/arkos/Return to Castle Wolfenstein.sh'              release/

# Package everything up
if GIT_VERSION=$(git rev-parse --short -q HEAD); then
	RELEASE_FILENAME=../arkos-iortcw_${GIT_VERSION}.zip
	rm -f $RELEASE_FILENAME
	cd release; zip -r $RELEASE_FILENAME *; cd ..
else
	RELEASE_FILENAME=../arkos-iortcw.zip
	echo "Warning: git rev-parse failed, this means your release package has no version information attached"
	echo "Consider manually tagging your release version and authorship instead."
fi

echo "Deploying '${RELEASE_FILENAME:3}'..."
cd release; zip -r $RELEASE_FILENAME *; cd ..
echo "Package '${RELEASE_FILENAME:3}' deployed."
