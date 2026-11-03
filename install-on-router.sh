#!/bin/sh
# Installs a PREBUILT APK. Package creation must happen with the OpenWrt SDK, not on the router.
set -eu
fail() { echo "ERROR: $*" >&2; exit 1; }
[ "$(id -u)" = 0 ] || fail 'Run as root.'
[ -r /etc/openwrt_release ] || fail 'OpenWrt release file not found.'
. /etc/openwrt_release
[ "${DISTRIB_RELEASE:-}" = '25.12.6' ] || fail "Expected 25.12.6; found ${DISTRIB_RELEASE:-unknown}."
[ "${DISTRIB_TARGET:-}" = 'ipq40xx/chromium' ] || fail "Expected ipq40xx/chromium; found ${DISTRIB_TARGET:-unknown}."
[ "${DISTRIB_ARCH:-}" = 'arm_cortex-a7_neon-vfpv4' ] || fail "Unexpected architecture: ${DISTRIB_ARCH:-unknown}."
if [ "$#" -ge 1 ]; then
    APK=$1
else
    APK=$(find /tmp -maxdepth 1 -type f -name 'luci-app-windscribe-bootstrap*.apk' 2>/dev/null | head -n 1)
fi
[ -n "${APK:-}" ] && [ -s "$APK" ] || fail 'Prebuilt APK not found in /tmp. Copy the SDK output there or pass its full path.' 
command -v apk >/dev/null 2>&1 || fail 'apk command not found.'
apk add --allow-untrusted "$APK"
rm -f /tmp/luci-indexcache /tmp/luci-modulecache 2>/dev/null || true
echo 'Installed diagnostics foundation. This is not a working Windscribe VPN client.'
echo 'Uninstall: apk del luci-app-windscribe-bootstrap'
