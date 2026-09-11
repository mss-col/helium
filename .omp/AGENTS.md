# AGENTS.md — helium

> Fail konteks projek: `PROJECT.md`, `README.md`.
> Ringkasan operasi untuk agent kod — bukan pengganti dokumen di atas.
> Dijana 2026-09-12 daripada kod, commit `0559b44 chore: bump version to 4.2.6 - HTM template fix for QWRT`. Jana semula jika kod berubah.

## Apa ini

**Helium** adalah universal DNS-based ad blocker untuk Linux servers dan OpenWrt routers. Guna dnsmasq untuk block ads, trackers, malware, dan phishing.

_(dipetik daripada `PROJECT.md`)_

⚠ **Dokumen sumber boleh lapuk.** Sahkan versi dan bilangan terhadap kod — manifest sebenar dan seksyen *Kiraan komponen* di bawah. Kes sebenar: dokumen projek menyebut stack yang kod sudah tukar.

## Perintah

### Perintah dalam skrip projek (petikan verbatim)

```bash
systemctl stop dnsmasq 2>/dev/null
```

## Struktur direktori

Senarai aras 1–2. Kalau sesuatu tidak kelihatan di sini, sahkan dahulu dengan `ls` — jangan simpulkan ia tiada.

```
.gitignore
.mcp.json
AbiDarwishList.txt
AbiDarwishYTList.txt
LICENSE.md
PROJECT.md
README.md
cm_qr.jpg
dead.hosts
dnsmasq.conf
helium
index.html
install.sh
providers.txt
providers_adblock.txt
.code-review-graph/
```

## Fail konteks projek

| Fail | Saiz | Dikemas kini |
|---|---|---|
| `PROJECT.md` | 8 KB | 2026-01-26 |
| `README.md` | 7 KB | 2026-02-06 |

## Konvensyen dan perangkap

Dipetik verbatim daripada dokumen projek. Sahkan terhadap kod.

_Tiada amaran tersurat dijumpai dalam dokumen projek._

## Di mana mencari apa

| Perlu | Fail |
|---|---|
| Gambaran projek | `PROJECT.md` |
| Gambaran projek | `README.md` |

## Peraturan kerja

- **Bukti diperlukan** — tulis "diuji dan disahkan", bukan "patut jalan".
- **Jangan `git push`** tanpa kelulusan Boss.
- **Jangan cipta** fail `.md`/dokumen/skrip baharu tanpa kelulusan Boss.
- **Baca fail konteks projek dahulu** sebelum mengubah kod.