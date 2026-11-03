#!/bin/sh
# Reproducible package build using the exact OpenWrt 25.12.6 ipq40xx/chromium SDK.
set -eu
SDK_FILE='openwrt-sdk-25.12.6-ipq40xx-chromium_gcc-14.3.0_musl_eabi.Linux-x86_64.tar.zst'
SDK_URL="https://downloads.openwrt.org/releases/25.12.6/targets/ipq40xx/chromium/$SDK_FILE"
SDK_SHA256='4226c554ae78bf9ade6b6f282dc5961d0e4f56209b4970db3a87c1363b60eda2'
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
WORK="${WORKDIR:-$HERE/.build}"
mkdir -p "$WORK" "$HERE/dist"
command -v zstd >/dev/null 2>&1 || { echo 'ERROR: install zstd first' >&2; exit 1; }
command -v make >/dev/null 2>&1 || { echo 'ERROR: make is required' >&2; exit 1; }
if [ ! -s "$WORK/$SDK_FILE" ]; then
  command -v curl >/dev/null 2>&1 || { echo 'ERROR: curl is required to download SDK' >&2; exit 1; }
  curl -fL --retry 3 "$SDK_URL" -o "$WORK/$SDK_FILE"
fi
printf '%s  %s\n' "$SDK_SHA256" "$WORK/$SDK_FILE" | sha256sum -c -
mkdir -p "$WORK/sdk"
if [ ! -f "$WORK/sdk/.unpacked" ]; then
  tar --zstd -xf "$WORK/$SDK_FILE" -C "$WORK/sdk" --strip-components=1
  touch "$WORK/sdk/.unpacked"
fi
SDK="$WORK/sdk"
rm -rf "$SDK/package/luci-app-windscribe-bootstrap"
cp -a "$HERE/package" "$SDK/package/luci-app-windscribe-bootstrap"
make -C "$SDK" package/luci-app-windscribe-bootstrap/compile V=s
find "$SDK/bin/packages" -type f -name 'luci-app-windscribe-bootstrap*.apk' -exec cp -f {} "$HERE/dist/" \;
set -- "$HERE"/dist/luci-app-windscribe-bootstrap*.apk
[ -s "$1" ] || { echo 'ERROR: SDK produced no APK package' >&2; exit 1; }
APK_PATH="$1"
APK_NAME=$(basename "$APK_PATH")
(
  cd "$HERE/dist"
  sha256sum "$APK_NAME" > "$APK_NAME.sha256"
)
echo "Built package: $1"
