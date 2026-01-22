#!/bin/sh
# =============================================================================
# Helium Universal Installer
# Automatically detects OS and installs to correct path
# =============================================================================

set -e

REPO_URL="https://raw.githubusercontent.com/mss-col/helium/main/helium"

echo ""
echo "  _   _      _ _                 "
echo " | | | | ___| (_)_   _ _ __ ___  "
echo " | |_| |/ _ \ | | | | | '_ \` _ \ "
echo " |  _  |  __/ | | |_| | | | | | |"
echo " |_| |_|\___|_|_|\__,_|_| |_| |_|"
echo ""
echo " Universal DNS Ad Blocker v4.0.0"
echo ""

# Detect OS
if [ -f /etc/openwrt_release ]; then
    OS_TYPE="openwrt"
    INSTALL_PATH="/usr/sbin/helium"
    echo " Detected: OpenWrt"
elif [ -f /etc/debian_version ]; then
    OS_TYPE="debian"
    INSTALL_PATH="/usr/local/sbin/helium"
    echo " Detected: Debian/Ubuntu"
elif [ -f /etc/redhat-release ]; then
    OS_TYPE="redhat"
    INSTALL_PATH="/usr/local/sbin/helium"
    echo " Detected: RHEL/CentOS"
else
    OS_TYPE="linux"
    INSTALL_PATH="/usr/local/sbin/helium"
    echo " Detected: Linux"
fi

echo " Install path: ${INSTALL_PATH}"
echo ""

# Check root
if [ "$(id -u)" != "0" ]; then
    echo " Error: Please run as root"
    exit 1
fi

# Download
echo " Downloading Helium..."
if command -v wget >/dev/null 2>&1; then
    wget -q -O "${INSTALL_PATH}" "${REPO_URL}"
elif command -v curl >/dev/null 2>&1; then
    curl -sL -o "${INSTALL_PATH}" "${REPO_URL}"
else
    echo " Error: wget or curl required"
    exit 1
fi

# Make executable
chmod +x "${INSTALL_PATH}"

echo " Installation complete!"
echo ""
echo " Run 'helium' to start"
echo ""

# Auto-run
exec "${INSTALL_PATH}"
