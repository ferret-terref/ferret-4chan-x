#!/bin/bash
channel=$1
mkdir -p tmp-crx
cp -r "testbuilds/crx$channel" "tmp-crx/crx$channel"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required to build signed CRX files" >&2
  exit 1
fi

if command -v chromium >/dev/null 2>&1; then
  browser=chromium
elif command -v chromium-browser >/dev/null 2>&1; then
  browser=chromium-browser
else
  echo "chromium or chromium-browser is required to build signed CRX files" >&2
  exit 1
fi

touch -d "$(jq -r '.date' version.json)" "tmp-crx/crx$channel"/*
$browser --pack-extension="tmp-crx/crx$channel" --pack-extension-key="$(dirname "$PWD")/4chan-x.keys/4chan-X.pem"
mv "tmp-crx/crx$channel.crx" "testbuilds/4chan-X$channel.crx"
rm -r 'tmp-crx/'
