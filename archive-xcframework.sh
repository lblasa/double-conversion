#!/usr/bin/env bash

set -e
set -x

BASE_PWD="$PWD"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
FWNAME="double-conversion"

OUTPUT_DIR=$( mktemp -d )
COMMON_SETUP=" -project ${SCRIPT_DIR}/double-conversion/Double-Conversion/Double-Conversion.xcodeproj -configuration Release -quiet BUILD_LIBRARY_FOR_DISTRIBUTION=YES "

# iOS
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
	$COMMON_SETUP \
    -scheme "Double-Conversion" \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'generic/platform=iOS'

rm -rf "${OUTPUT_DIR}/iphoneos"
mkdir -p "${OUTPUT_DIR}/iphoneos"
ditto "${DERIVED_DATA_PATH}/Build/Products/Release-iphoneos/${FWNAME}.framework" "${OUTPUT_DIR}/iphoneos/${FWNAME}.framework"
rm -rf "${DERIVED_DATA_PATH}"

# iOS Simulator
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
	$COMMON_SETUP \
    -scheme "Double-Conversion" \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'generic/platform=iOS Simulator'

rm -rf "${OUTPUT_DIR}/iphonesimulator"
mkdir -p "${OUTPUT_DIR}/iphonesimulator"
ditto "${DERIVED_DATA_PATH}/Build/Products/Release-iphonesimulator/${FWNAME}.framework" "${OUTPUT_DIR}/iphonesimulator/${FWNAME}.framework"
rm -rf "${DERIVED_DATA_PATH}"

# Mac Catalyst
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
	$COMMON_SETUP \
    -scheme "Double-Conversion" \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'platform=macOS,arch=x86_64,variant=Mac Catalyst'

rm -rf "${OUTPUT_DIR}/maccatalyst"
mkdir -p "${OUTPUT_DIR}/maccatalyst"
ditto "${DERIVED_DATA_PATH}/Build/Products/Release-maccatalyst/${FWNAME}.framework" "${OUTPUT_DIR}/maccatalyst/${FWNAME}.framework"
rm -rf "${DERIVED_DATA_PATH}"

#

rm -rf "${BASE_PWD}/Frameworks/iphoneos"
mkdir -p "${BASE_PWD}/Frameworks/iphoneos"
ditto "${OUTPUT_DIR}/iphoneos/${FWNAME}.framework" "${BASE_PWD}/Frameworks/iphoneos/${FWNAME}.framework"

rm -rf "${BASE_PWD}/Frameworks/iphonesimulator"
mkdir -p "${BASE_PWD}/Frameworks/iphonesimulator"
ditto "${OUTPUT_DIR}/iphonesimulator/${FWNAME}.framework" "${BASE_PWD}/Frameworks/iphonesimulator/${FWNAME}.framework"

rm -rf "${BASE_PWD}/Frameworks/maccatalyst"
mkdir -p "${BASE_PWD}/Frameworks/maccatalyst"
ditto "${OUTPUT_DIR}/maccatalyst/${FWNAME}.framework" "${BASE_PWD}/Frameworks/maccatalyst/${FWNAME}.framework"

# XCFramework
rm -rf "${BASE_PWD}/Frameworks/${FWNAME}.xcframework"

xcrun xcodebuild -quiet -create-xcframework \
	-framework "${OUTPUT_DIR}/iphoneos/${FWNAME}.framework" \
	-framework "${OUTPUT_DIR}/iphonesimulator/${FWNAME}.framework" \
    -framework "${OUTPUT_DIR}/maccatalyst/${FWNAME}.framework" \
	-output "${OUTPUT_DIR}/Frameworks/${FWNAME}.xcframework"

# Framework directory structure flattening
# - Copy the framework in a specific way: de-referencing symbolic links on purpose
cp -rp "${OUTPUT_DIR}/Frameworks/${FWNAME}.xcframework" "${BASE_PWD}/Frameworks/"

rm -rf ${OUTPUT_DIR}
