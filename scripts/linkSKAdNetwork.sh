#!/usr/bin/env bash

if [ "$1" = ""  ]; then
  echo "1st argument SKAdNetwork name is required"
  exit 0;
fi

SK_AD_NETWORK="${1}.skadnetwork"
RN_ROOT_DIR="${2-.}"
INFO_PLIST_PATH_DEV="$RN_ROOT_DIR/ios/$(find $RN_ROOT_DIR/ios -maxdepth 1 -name *.xcworkspace | xargs -L1 -I{} basename "{}" .xcworkspace)/Info.plist"
INFO_PLIST_PATH_LIVE="$RN_ROOT_DIR/ios/$(find $RN_ROOT_DIR/ios -maxdepth 1 -name *.xcworkspace | xargs -L1 -I{} basename "{}" .xcworkspace)/live.plist"

if ! [ -f "$INFO_PLIST_PATH_DEV" ]; then
  echo "Coundn't find Info.plist file. Manual linking of $SK_AD_NETWORK is required. See https://developers.ironsrc.com/ironsource-mobile/ios/ios-14-network-support/ for details";
  exit 0;
fi

if ! [ -f "$INFO_PLIST_PATH_LIVE" ]; then
  echo "Coundn't find live.plist file. Manual linking of $SK_AD_NETWORK is required. See https://developers.ironsrc.com/ironsource-mobile/ios/ios-14-network-support/ for details";
  exit 0;
fi

ARRAY_FOUND_DEV=$(plutil -p "$INFO_PLIST_PATH_DEV" | grep "SKAdNetworkItems" | wc -l | xargs)
ENTRY_FOUND_DEV=$(plutil -p "$INFO_PLIST_PATH_DEV" | grep "$SK_AD_NETWORK" | wc -l | xargs)

if [[ ARRAY_FOUND_DEV -eq 0 ]]; then
  plutil -insert SKAdNetworkItems -xml "<array />" "$INFO_PLIST_PATH_DEV"
fi

if [[ ENTRY_FOUND_DEV -eq 0 ]]; then
  echo "Adding $SK_AD_NETWORK to Info.plist. Please commit this change";
  plutil -insert SKAdNetworkItems.0 -xml "<dict>
        <key>SKAdNetworkIdentifier</key>
        <string>$SK_AD_NETWORK</string>
    </dict>" "$INFO_PLIST_PATH_DEV"
fi

ARRAY_FOUND_LIVE=$(plutil -p "$INFO_PLIST_PATH_LIVE" | grep "SKAdNetworkItems" | wc -l | xargs)
ENTRY_FOUND_LIVE=$(plutil -p "$INFO_PLIST_PATH_LIVE" | grep "$SK_AD_NETWORK" | wc -l | xargs)

if [[ ARRAY_FOUND_LIVE -eq 0 ]]; then
  plutil -insert SKAdNetworkItems -xml "<array />" "$INFO_PLIST_PATH_LIVE"
fi

if [[ ENTRY_FOUND_LIVE -eq 0 ]]; then
  echo "Adding $SK_AD_NETWORK to live.plist. Please commit this change";
  plutil -insert SKAdNetworkItems.0 -xml "<dict>
        <key>SKAdNetworkIdentifier</key>
        <string>$SK_AD_NETWORK</string>
    </dict>" "$INFO_PLIST_PATH_LIVE"
fi
