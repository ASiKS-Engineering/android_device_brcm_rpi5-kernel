#!/bin/bash
# Downloads the kernel Image from the GitHub release pinned in IMAGE_RELEASE.
# Run this once before building (also after every repo sync that changes IMAGE_RELEASE).
# ASSET_URL can override the download location (e.g. file:///path/to/Image).
set -euo pipefail
cd "$(dirname "$0")"

# shellcheck source=IMAGE_RELEASE
source ./IMAGE_RELEASE
URL="${ASSET_URL:-https://github.com/ASiKS-Engineering/android_device_brcm_rpi5-kernel/releases/download/${TAG}/Image}"
OUT=Image

if [ -f "$OUT" ] && echo "${SHA256}  ${OUT}" | sha256sum -c --status; then
    echo "$OUT is up to date (${TAG})"
    exit 0
fi

tmp=$(mktemp "${OUT}.XXXXXX")
trap 'rm -f "$tmp"' EXIT
curl -fL --retry 3 -o "$tmp" "$URL"
if ! echo "${SHA256}  ${tmp}" | sha256sum -c --status; then
    echo "Checksum mismatch for ${URL}" >&2
    exit 1
fi
chmod 755 "$tmp"
mv -f "$tmp" "$OUT"
trap - EXIT
echo "Downloaded $OUT (${TAG})"
