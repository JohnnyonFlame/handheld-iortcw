#!/bin/bash

DEFAULT_CFG="assets/defaults/$1_default.cfg"
if [ "$#" -ne 1 ]; then
    echo "Error: Unspecified platform for 'make-assets.sh'."
    exit 1
fi

if [ ! -f "$DEFAULT_CFG" ]; then
    echo "Error: Missing defaults for platform '$1'."
    exit 1
fi

# Create pk3 files with the modded UI and CFG files
rm -f build/sp_pak_*.pk3
cd assets; zip -r  ../build/sp_pak_ui.pk3 ./ui
           zip -rj ../build/sp_pak_settings.pk3 defaults/
cd ..

# Rename DEFAULT_CFG to default.cfg
zipnote -w build/sp_pak_settings.pk3 << EOF
@ $1_default.cfg
@=default.cfg
EOF