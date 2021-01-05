#!/bin/bash

    CC=aarch64-linux-gnu-gcc \
    CXX=aarch64-linux-gnu-g++ \
    PKG_CONFIG=aarch64-linux-gnu-pkg-config \
	USE_CODEC_VORBIS=0 \
	USE_CODEC_OPUS=0 \
	USE_CURL=0 \
	USE_CURL_DLOPEN=0 \
	USE_OPENAL=1 \
	USE_OPENAL_DLOPEN=1 \
	USE_RENDERER_DLOPEN=0 \
	USE_VOIP=0 \
	USE_LOCAL_HEADERS=1 \
	USE_INTERNAL_JPEG=1 \
	USE_INTERNAL_OPUS=1 \
	USE_INTERNAL_ZLIB=1 \
	USE_OPENGLES=1 \
	USE_BLOOM=0 \
    USE_AUTOAIM=1 \
	USE_MUMBLE=0 \
	BUILD_GAME_SO=1 \
	BUILD_RENDERER_REND2=0 \
	ARCH=aarch64 \
	PLATFORM=linux \
	COMPILE_ARCH=x86_64 \
	COMPILE_PLATFORM=linux \
	make $*

# Create pk3 files with the modded UI and CFG files
rm -f build/sp_pak_*.pk3
cd assets; zip -r  ../build/sp_pak_ui.pk3 ./ui
           zip -rj ../build/sp_pak_settings.pk3 defaults/
cd ..

# Deploy rg351_default.cfg as default.cfg
zipnote -w build/sp_pak_settings.pk3 << EOF
@ rg351_default.cfg
@=default.cfg
EOF

# Clear the release deployment folder
rm -rf release
mkdir -p release/iortcw/main

# Deploy licenses, binaries and assets
cp build/release-linux-aarch64/iowolfsp.aarch64 COPYING.txt README.txt release/iortcw/
cp build/release-linux-aarch64/main/*.so build/sp_pak*.pk3             release/iortcw/main/

cat << EOF >> "release/Return to Castle Wolfenstein.sh"
	#!/bin/sh

	/roms/ports/iortcw/iowolfsp.aarch64
EOF

# Package everything up
if GIT_VERSION=$(git rev-parse --short -q HEAD); then
	RELEASE_FILENAME=../arkos-iortcw_${GIT_VERSION}.zip
	rm -f $RELEASE_FILENAME
	cd release; zip -r $RELEASE_FILENAME *; cd ..
else
	echo "Warning: git rev-parse failed, this means your release package has no version information attached"
	echo "Consider manually tagging your release version and authorship instead."
	rm -f ../arkos-iortcw_UNVERSIONED.zip
	cd release; zip -r ../arkos-iortcw_UNVERSIONED.zip *; cd ..
fi
