# Helium

[![Version](https://img.shields.io/badge/version-4.0.0-green.svg)](https://github.com/mss-col/helium)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20OpenWrt-lightgrey.svg)](https://github.com/mss-col/helium)

**Helium** is a universal DNS-based ad blocker that works on both Linux servers and OpenWrt routers. It uses dnsmasq to block ads, trackers, malware, phishing, and more.

## What's New in v4.0.0

- **Universal Script** - Single script works on Linux (Debian/Ubuntu/RHEL) and OpenWrt
- **POSIX Compliant** - Pure `/bin/sh` compatibility, works on busybox (no bash required)
- **Auto OS Detection** - Automatically detects and adapts to your environment
- **Multi-Format Parser** - Supports hosts, AdBlock, wildcard, and domain-only formats
- **Smart Deduplication** - Removes duplicate entries before saving
- **CLI Arguments** - Scriptable commands for automation and cron jobs
- **IP Validation** - Validates custom DNS input
- **Robust Downloads** - Proper status checking with retry mechanism
- **Cross-Platform Cron** - Auto daily updates for both Linux and OpenWrt

## Quick Install

### Linux Server (Debian/Ubuntu/RHEL)

```bash
wget -qO- https://mss-col.github.io/helium/install.sh | sh
```

Or manual install:
```bash
wget -O /usr/local/sbin/helium https://cdn.jsdelivr.net/gh/mss-col/helium@main/helium
chmod +x /usr/local/sbin/helium
helium
```

### OpenWrt Router

```bash
wget -qO- https://mss-col.github.io/helium/install.sh | sh
```

Or manual install:
```bash
wget -O /usr/sbin/helium https://cdn.jsdelivr.net/gh/mss-col/helium@main/helium
chmod +x /usr/sbin/helium
helium
```

### LuCI Web Interface (Optional)

Install the web UI for managing Helium from OpenWrt's LuCI interface.

**Option 1: Add Repository (Recommended)**
```bash
echo "src/gz helium https://raw.githubusercontent.com/mss-col/openwrt-packages/main/packages/all" >> /etc/opkg/customfeeds.conf && opkg update && opkg install luci-app-helium
```

**Option 2: Direct Download**
```bash
wget -O /tmp/luci-app-helium.ipk https://github.com/mss-col/openwrt-packages/raw/main/packages/all/luci-app-helium_1.1.1-1_all.ipk && opkg install /tmp/luci-app-helium.ipk
```

After installation, access Helium from **Services → Helium** in LuCI.

## Features

| Feature | Linux | OpenWrt |
|---------|:-----:|:-------:|
| Block Ads & Trackers | ✓ | ✓ |
| Block Malware & Phishing | ✓ | ✓ |
| Provider Management | ✓ | ✓ |
| Whitelist Domains | ✓ | ✓ |
| Blacklist Domains | ✓ | ✓ |
| Change DNS Server | ✓ | - |
| Clean Dead Hosts | ✓ | - |
| Toggle IPv6 | - | ✓ |
| Auto Daily Update | ✓ | ✓ |

## CLI Commands

Helium supports command-line arguments for scripting and automation:

```bash
helium                   # Interactive menu
helium --update, -u      # Update blocklist database
helium --upgrade, -U     # Update Helium script from repository
helium --status, -s      # Show current status
helium --version, -v     # Show version
helium --uninstall, -X   # Force uninstall (restore original state)
helium --help, -h        # Show help
```

### Examples

```bash
# Update blocklist silently (for cron)
helium --update

# Upgrade to latest version
helium --upgrade

# Check if Helium is running
helium --status

# Emergency uninstall (no confirmation, restore original state)
helium --uninstall
```

## Manual Cron Setup

If you prefer to set up cron manually, use these commands:

### Linux (Debian/Ubuntu/RHEL)

```bash
# Edit crontab
sudo crontab -e

# Add this line for daily update at 4 AM
0 4 * * * /usr/local/sbin/helium --update >/dev/null 2>&1

# Or use /etc/crontab
echo "0 4 * * * root /usr/local/sbin/helium --update >/dev/null 2>&1" | sudo tee -a /etc/crontab
```

### OpenWrt

```bash
# Edit crontab
crontab -e

# Add this line for daily update at 4 AM
0 4 * * * /usr/sbin/helium --update >/dev/null 2>&1

# Or directly append to cron file
echo "0 4 * * * /usr/sbin/helium --update >/dev/null 2>&1" >> /etc/crontabs/root

# Restart cron service
/etc/init.d/cron restart
```

### macOS (if adapted)

```bash
# Edit crontab
crontab -e

# Add this line
0 4 * * * /usr/local/bin/helium --update >/dev/null 2>&1
```

### Weekly Script Upgrade (Optional)

To automatically upgrade Helium script weekly:

```bash
# Linux
echo "0 5 * * 0 root /usr/local/sbin/helium --upgrade >/dev/null 2>&1" | sudo tee -a /etc/crontab

# OpenWrt
echo "0 5 * * 0 /usr/sbin/helium --upgrade >/dev/null 2>&1" >> /etc/crontabs/root
/etc/init.d/cron restart
```

## Supported Platforms

### Linux
- Debian 10/11/12
- Ubuntu 20.04/22.04/24.04
- RHEL/CentOS/Rocky 8/9

### OpenWrt
- QWRT
- NSS-based OpenWrt
- Arcadyan AW1000

## Blocklist Providers

Helium uses curated blocklists from trusted sources:

- **HaGeZi** - Multi-tier protection (Light/Normal/Pro/Ultimate)
- **OISD** - Internet's #1 domain blocklist
- **Steven Black** - Unified hosts file
- **AdGuard DNS** - AdGuard's DNS filter
- **EasyList/EasyPrivacy** - Classic ad & privacy lists
- **1Hosts** - Aggressive ad blocking
- And 40+ more regional & specialized lists

## Uninstall

From the Helium menu, select **Uninstall** option.

Or manually:
```bash
# Linux
rm -f /usr/local/sbin/helium /usr/local/sbin/helium_daily
rm -rf /etc/dnsmasq
sed -i '/helium/d' /etc/crontab

# OpenWrt
rm -f /usr/sbin/helium
rm -rf /etc/dnsmasq
sed -i '/helium/d' /etc/crontabs/root
/etc/init.d/cron restart
```

## Credits

- **Original Author**: [Abi Darwish](https://github.com/abidarwish)
- **Enhanced by**: [MSS](https://github.com/mss-col)
- **Blocklist Providers**: HaGeZi, OISD, Steven Black, AdGuard, EasyList, and others

## License

This project is licensed under the GPL v3 License - see the [LICENSE](LICENSE.md) file for details.

## Links

- **Website**: [mss-col.github.io/helium](https://mss-col.github.io/helium)
- **Issues**: [Report Bug](https://github.com/mss-col/helium/issues)
- **Telegram**: [@abidarwish](https://t.me/abidarwish)
