#!/bin/sh
# =============================================================================
# Helium Universal Installer v4.0.9
# Smart installer with upgrade detection
# =============================================================================

set -e

REPO_URL="https://raw.githubusercontent.com/mss-col/helium/main/helium"
REPO_PROVIDERS="https://raw.githubusercontent.com/mss-col/helium/main/providers.txt"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_banner() {
    echo ""
    echo "  _   _      _ _                 "
    echo " | | | | ___| (_)_   _ _ __ ___  "
    echo " | |_| |/ _ \ | | | | | '\`_ \` _ \ "
    echo " |  _  |  __/ | | |_| | | | | | |"
    echo " |_| |_|\___|_|_|\__,_|_| |_| |_|"
    echo ""
    echo " Universal DNS Ad Blocker v4.0.9"
    echo ""
}

print_green() { printf "${GREEN}%s${NC}" "$1"; }
print_red() { printf "${RED}%s${NC}" "$1"; }
print_yellow() { printf "${YELLOW}%s${NC}" "$1"; }
print_cyan() { printf "${CYAN}%s${NC}" "$1"; }

# Detect OS
detect_os() {
    if [ -f /etc/openwrt_release ]; then
        OS_TYPE="openwrt"
        INSTALL_PATH="/usr/sbin/helium"
        DNSMASQ_DIR="/etc/dnsmasq"
        echo " Detected: $(print_cyan "OpenWrt")"
    elif [ -f /etc/debian_version ]; then
        OS_TYPE="debian"
        INSTALL_PATH="/usr/local/sbin/helium"
        DNSMASQ_DIR="/etc/dnsmasq"
        echo " Detected: $(print_cyan "Debian/Ubuntu")"
    elif [ -f /etc/redhat-release ]; then
        OS_TYPE="redhat"
        INSTALL_PATH="/usr/local/sbin/helium"
        DNSMASQ_DIR="/etc/dnsmasq"
        echo " Detected: $(print_cyan "RHEL/CentOS")"
    else
        OS_TYPE="linux"
        INSTALL_PATH="/usr/local/sbin/helium"
        DNSMASQ_DIR="/etc/dnsmasq"
        echo " Detected: $(print_cyan "Linux")"
    fi
}

# Check for existing installation
check_existing() {
    EXISTING_VERSION=""
    EXISTING_PATH=""

    # Helper function to extract version (handles both v3.x and v4.x format)
    get_version() {
        file="$1"
        # Try v4.x format first (VERSION_NUMBER)
        ver=$(grep "^VERSION_NUMBER=" "$file" 2>/dev/null | cut -d'"' -f2 | head -1)
        # Fallback to v3.x format (VERSIONNUMBER)
        [ -z "$ver" ] && ver=$(grep "^VERSIONNUMBER=" "$file" 2>/dev/null | cut -d'"' -f2 | head -1)
        echo "$ver"
    }

    # Check all possible paths (both helium and helium.sh)
    for path in "/usr/sbin/helium" "/usr/local/sbin/helium" "/usr/sbin/helium.sh" "/usr/local/sbin/helium.sh"; do
        if [ -f "$path" ]; then
            EXISTING_PATH="$path"
            EXISTING_VERSION=$(get_version "$path")
            break
        fi
    done

    # Also check for config files (orphaned installation)
    if [ -z "$EXISTING_PATH" ] && [ -d "$DNSMASQ_DIR" ]; then
        if [ -f "$DNSMASQ_DIR/adblock.hosts" ] || [ -f "$DNSMASQ_DIR/providers.txt" ]; then
            EXISTING_VERSION="unknown"
        fi
    fi
}

# Download file (handles OpenWrt's busybox wget)
download_file() {
    url="$1"
    dest="$2"

    if command -v curl >/dev/null 2>&1; then
        # Prefer curl (more reliable)
        curl -sL -o "$dest" "$url"
    elif command -v wget >/dev/null 2>&1; then
        # Check if full wget or busybox wget
        if wget --help 2>&1 | grep -q "BusyBox"; then
            # BusyBox wget - use --no-check-certificate for HTTPS
            wget --no-check-certificate -q -O "$dest" "$url"
        else
            # Full wget
            wget -q -O "$dest" "$url"
        fi
    else
        echo " $(print_red "Error"): wget or curl required"
        exit 1
    fi
}

# Fresh install - clean everything first
do_fresh_install() {
    echo ""
    echo " $(print_yellow "Fresh Install Selected")"
    echo ""

    # Stop dnsmasq
    echo " [1/6] Stopping dnsmasq..."
    if [ "$OS_TYPE" = "openwrt" ]; then
        /etc/init.d/dnsmasq stop 2>/dev/null || true
    else
        systemctl stop dnsmasq 2>/dev/null || true
    fi

    # Remove old files
    echo " [2/6] Removing old installation..."
    rm -f /usr/sbin/helium /usr/sbin/helium.sh 2>/dev/null || true
    rm -f /usr/local/sbin/helium /usr/local/sbin/helium.sh 2>/dev/null || true
    rm -f /usr/local/sbin/helium_daily 2>/dev/null || true
    rm -rf "$DNSMASQ_DIR" 2>/dev/null || true

    # Remove old cron
    echo " [3/6] Removing old cron jobs..."
    if [ "$OS_TYPE" = "openwrt" ]; then
        sed -i '/helium/d' /etc/crontabs/root 2>/dev/null || true
    else
        sed -i '/helium/d' /etc/crontab 2>/dev/null || true
    fi

    # Remove helium's dnsmasq config (preserve other settings)
    echo " [4/6] Cleaning helium config..."
    if [ "$OS_TYPE" = "openwrt" ]; then
        # Only remove helium's addn-hosts entry
        sed -i '/addn-hosts.*adblock\.hosts/d' /etc/dnsmasq.conf 2>/dev/null || true
        sed -i '#addn-hosts=/etc/dnsmasq/adblock#d' /etc/dnsmasq.conf 2>/dev/null || true
        uci -q delete dhcp.@dnsmasq[0].addnhosts 2>/dev/null || true
        uci commit dhcp 2>/dev/null || true
    else
        # Only remove helium's addn-hosts entry
        sed -i '/addn-hosts.*adblock\.hosts/d' /etc/dnsmasq.conf 2>/dev/null || true
        sed -i '#addn-hosts=/etc/dnsmasq/adblock#d' /etc/dnsmasq.conf 2>/dev/null || true
    fi

    # Download new script
    echo " [5/6] Downloading Helium v4.0.9..."
    download_file "$REPO_URL" "$INSTALL_PATH"
    chmod +x "$INSTALL_PATH"

    echo " [6/6] $(print_green "Fresh install ready!")"
    echo ""
    echo " Starting Helium setup..."
    echo ""
    sleep 1

    # Run helium (will trigger first-time setup)
    exec "$INSTALL_PATH"
}

# Upgrade - preserve user data
do_upgrade() {
    echo ""
    echo " $(print_yellow "Upgrade Selected")"
    echo ""

    # Backup user data
    echo " [1/5] Backing up user data..."
    [ -f "$DNSMASQ_DIR/whitelist.hosts" ] && cp "$DNSMASQ_DIR/whitelist.hosts" /tmp/whitelist.hosts.bak
    [ -f "$DNSMASQ_DIR/blacklist.hosts" ] && cp "$DNSMASQ_DIR/blacklist.hosts" /tmp/blacklist.hosts.bak
    [ -f "$DNSMASQ_DIR/providers.txt" ] && cp "$DNSMASQ_DIR/providers.txt" /tmp/providers.txt.bak

    # Stop dnsmasq
    echo " [2/5] Stopping dnsmasq..."
    if [ "$OS_TYPE" = "openwrt" ]; then
        /etc/init.d/dnsmasq stop 2>/dev/null || true
    else
        systemctl stop dnsmasq 2>/dev/null || true
    fi

    # Remove old script (but keep config dir)
    echo " [3/5] Removing old script..."
    rm -f /usr/sbin/helium /usr/sbin/helium.sh 2>/dev/null || true
    rm -f /usr/local/sbin/helium /usr/local/sbin/helium.sh 2>/dev/null || true
    rm -f /usr/local/sbin/helium_daily 2>/dev/null || true

    # Download new script
    echo " [4/5] Downloading Helium v4.0.9..."
    download_file "$REPO_URL" "$INSTALL_PATH"
    chmod +x "$INSTALL_PATH"

    # Restore user data
    echo " [5/5] Restoring user data..."
    [ ! -d "$DNSMASQ_DIR" ] && mkdir -p "$DNSMASQ_DIR"
    [ -f /tmp/whitelist.hosts.bak ] && mv /tmp/whitelist.hosts.bak "$DNSMASQ_DIR/whitelist.hosts"
    [ -f /tmp/blacklist.hosts.bak ] && mv /tmp/blacklist.hosts.bak "$DNSMASQ_DIR/blacklist.hosts"

    # Check if providers.txt needs update (old format vs new)
    if [ -f /tmp/providers.txt.bak ]; then
        # Check if old format (no | separator means old format)
        if ! grep -q '|' /tmp/providers.txt.bak 2>/dev/null; then
            echo "   $(print_yellow "Note"): Old provider format detected, downloading new providers list"
            download_file "$REPO_PROVIDERS" "$DNSMASQ_DIR/providers.txt"
        else
            mv /tmp/providers.txt.bak "$DNSMASQ_DIR/providers.txt"
        fi
    fi

    echo ""
    echo " $(print_green "Upgrade complete!")"
    echo ""
    echo " Starting Helium..."
    echo ""
    sleep 1

    # Run helium
    exec "$INSTALL_PATH"
}

# Main
main() {
    print_banner

    # Check root
    if [ "$(id -u)" != "0" ]; then
        echo " $(print_red "Error"): Please run as root"
        exit 1
    fi

    # Detect OS
    detect_os
    echo " Install path: $(print_cyan "$INSTALL_PATH")"
    echo ""

    # Check existing installation
    check_existing

    if [ -n "$EXISTING_VERSION" ]; then
        echo " ┌─────────────────────────────────────────────┐"
        echo " │  $(print_yellow "Existing Installation Detected")            │"
        echo " └─────────────────────────────────────────────┘"
        echo ""

        if [ "$EXISTING_VERSION" = "unknown" ]; then
            echo "   Version: $(print_yellow "Unknown (config files found)")"
        else
            echo "   Version: $(print_cyan "v${EXISTING_VERSION}")"
        fi
        [ -n "$EXISTING_PATH" ] && echo "   Path: $(print_cyan "$EXISTING_PATH")"
        echo ""
        echo " ─────────────────────────────────────────────"
        echo ""
        echo "  [1] $(print_green "Upgrade") - Update script, keep whitelist/blacklist"
        echo "  [2] $(print_yellow "Fresh Install") - Remove everything, start clean"
        echo "  [3] $(print_red "Cancel") - Exit without changes"
        echo ""
        printf "  Enter choice [1-3]: "
        read -r choice < /dev/tty

        case "$choice" in
            1) do_upgrade ;;
            2) do_fresh_install ;;
            3|"")
                echo ""
                echo " Installation cancelled."
                exit 0
                ;;
            *)
                echo ""
                echo " Invalid choice. Installation cancelled."
                exit 1
                ;;
        esac
    else
        # No existing installation - proceed with fresh install
        echo " No existing installation found."
        echo ""
        printf " Install Helium now? [Y/n]: "
        read -r confirm < /dev/tty

        case "$confirm" in
            n|N|no|NO)
                echo ""
                echo " Installation cancelled."
                exit 0
                ;;
            *)
                echo ""
                echo " Downloading Helium..."
                download_file "$REPO_URL" "$INSTALL_PATH"
                chmod +x "$INSTALL_PATH"

                echo " $(print_green "Download complete!")"
                echo ""
                echo " Starting Helium setup..."
                echo ""
                sleep 1

                exec "$INSTALL_PATH"
                ;;
        esac
    fi
}

main "$@"
