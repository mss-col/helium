# Helium

[![Version](https://img.shields.io/badge/version-4.0.0-green.svg)](https://github.com/mss-col/helium)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20OpenWrt-lightgrey.svg)](https://github.com/mss-col/helium)

**Helium** is a universal DNS-based ad blocker that works on both Linux servers and OpenWrt routers. It uses dnsmasq to block ads, trackers, malware, phishing, and more.

## What's New in v4.0.0

- **Universal Script** - Single script works on Linux (Debian/Ubuntu/RHEL) and OpenWrt
- **POSIX Compliant** - Pure `/bin/sh` compatibility, no bash required
- **Auto OS Detection** - Automatically detects and adapts to your environment
- **Enhanced Features** - Whitelist, Blacklist, Provider management, DNS switching
- **Robust Error Handling** - Better reliability with fallback mechanisms

## Quick Install

### Linux Server (Debian/Ubuntu/RHEL)

```bash
wget -qO- https://mss-col.github.io/helium/install.sh | sh
```

Or manual install:
```bash
wget -O /usr/local/sbin/helium https://raw.githubusercontent.com/mss-col/helium/main/helium
chmod +x /usr/local/sbin/helium
helium
```

### OpenWrt Router

```bash
wget -qO- https://mss-col.github.io/helium/install.sh | sh
```

Or manual install:
```bash
wget -O /usr/sbin/helium https://raw.githubusercontent.com/mss-col/helium/main/helium
chmod +x /usr/sbin/helium
helium
```

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
| Auto Daily Update | ✓ | - |

## Screenshots

### Efficiency Test
Test Helium at [d3ward AdBlock Tester](https://d3ward.github.io/toolz/adblock.html)

<p align="center">
  <img src="d3ward2.png" alt="AdBlock Test Result">
</p>

### Menu Interface

<p align="center">
  <img src="menu2.png" alt="Helium Menu">
</p>

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

## Commands

After installation, run:
```bash
helium
```

## Uninstall

From the Helium menu, select **Uninstall** option.

Or manually:
```bash
# Linux
rm -f /usr/local/sbin/helium /usr/local/sbin/helium_daily
rm -rf /etc/dnsmasq

# OpenWrt
rm -f /usr/sbin/helium
rm -rf /etc/dnsmasq
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
