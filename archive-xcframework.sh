#!/usr/bin/env bash

set -e
set -x

BASE_PWD="$PWD"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
FWNAME="double-conversion"

COMMON_SETUP=" -project ${SCRIPT_DIR}/double-conversion/Double-Conversion/Double-Conversion.xcodeproj -configuration Release -quiet "

# iOS
xcrun xcodebuild archive \
    $COMMON_SETUP \
    -scheme "Double-Conversion" \
    -destination 'generic/platform=iOS' \
    -archivePath 'Frameworks/iphoneos.xcarchive' \
    SKIP_INSTALL=NO

# iOS Simulator
xcrun xcodebuild archive \
    $COMMON_SETUP \
    -scheme "Double-Conversion" \
    -destination 'generic/platform=iOS Simulator' \
    -archivePath 'Frameworks/iphonesimulator.xcarchive' \
    SKIP_INSTALL=NO

# Mac Catalyst
xcrun xcodebuild archive \
    $COMMON_SETUP \
    -scheme "Double-Conversion" \
    -destination 'platform=macOS,arch=x86_64,variant=Mac Catalyst' \
    -archivePath 'Frameworks/maccatalyst.xcarchive' \
    SKIP_INSTALL=NO

xcrun xcodebuild -quiet -create-xcframework \
    -framework "Frameworks/iphoneos.xcarchive/Products/Library/Frameworks/${FWNAME}.framework" \
    -framework "Frameworks/iphonesimulator.xcarchive/Products/Library/Frameworks/${FWNAME}.framework" \
    -framework "Frameworks/maccatalyst.xcarchive/Products/Library/Frameworks/${FWNAME}.framework" \
    -output "${BASE_PWD}/Frameworks/${FWNAME}.xcframework"
