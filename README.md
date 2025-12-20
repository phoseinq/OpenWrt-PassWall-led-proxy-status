<div align="center">
  
# 🚦 LED Proxy Status for OpenWrt

<img src="https://img.shields.io/badge/OpenWrt-00B5E2?style=for-the-badge&logo=openwrt&logoColor=white" alt="OpenWrt">
<img src="https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Shell Script">
<img src="https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge" alt="License">

**Visual proxy & network status monitoring using your router's RGB LED**  
 **نمایش وضعیت اتصال پروکسی با چراغ های روتر**

[English](#english) | [فارسی](#فارسی)

---

</div>

## English

### 📖 Description

**LED Proxy Status** is a lightweight, real-time monitoring script for OpenWrt routers that transforms your RGB LED into a visual status indicator for your SOCKS5 proxy and internet connectivity. No more guessing if your proxy is working - just look at your router!

**Key Features:**
- 🎨 **Color-coded status** - Instant visual feedback
- ⚡ **Lightweight** - Minimal resource usage
- 🔄 **Real-time monitoring** - Checks every 10 seconds
- 🛠️ **Easy setup** - One-command installation
- 🔧 **Customizable** - Configure your SOCKS5 proxy port
- 📱 **Works with** - Xray, sing-box, v2ray, and other SOCKS5 proxies

**Tested on:** Google WiFi (OnHub AC1304)  
**Compatible with:** Most OpenWrt routers with RGB LED support

---

### 🎨 LED Status Colors

| Color | Status | Meaning |
|-------|--------|---------|
| ⚪ **White** | ✅ All Good | Proxy is working perfectly |
| 🔵 **Cyan** | ⚠️ Proxy Down | Proxy failed, but Google is reachable |
| 🟣 **Purple** | 🚫 International internet down | Google blocked, but Iran servers are reachable |
| 🔴 **Blinking Red** | ❌ No Internet | Complete internet connectivity loss |

---

### 📋 Requirements

Before installation, make sure you have:
- ✅ OpenWrt installed on your router
- ✅ Router with RGB LED support
- ✅ Active SOCKS5 proxy (Xray, sing-box, v2ray, etc.)
- ✅ `curl` package (will be installed automatically)
- ✅ `git` package (will be installed automatically)

---

### 🚀 Quick Installation

Copy and paste this **single command** into your router's SSH terminal:

```bash
cd /tmp
opkg install wget-ssl unzip
wget --no-check-certificate https://codeload.github.com/phoseinq/OpenWrt-PassWall-led-proxy-status/zip/refs/heads/main -O led.zip
unzip led.zip
cd OpenWrt-PassWall-led-proxy-status-main
chmod +x install.sh
sh install.sh
```

**During installation:**
1. The script will prompt you for your SOCKS5 proxy port
2. Example: If your proxy runs on `127.0.0.1:1070`, enter `1070`
3. The service will start automatically after installation

---

### 🎮 Service Management

#### Start the service:
```bash
/etc/init.d/led-status start
```

#### Stop the service:
```bash
/etc/init.d/led-status stop
```

#### Restart the service:
```bash
/etc/init.d/led-status restart
```

#### Check if service is running:
```bash
/etc/init.d/led-status status
```
Or:
```bash
ps | grep led-status-daemon | grep -v grep
```

#### Enable auto-start on boot:
```bash
/etc/init.d/led-status enable
```

#### Disable auto-start:
```bash
/etc/init.d/led-status disable
```

---

### 🔧 Configuration

The proxy port is stored in `/etc/config/led-status-port`. To change it:

```bash
echo "1080" > /etc/config/led-status-port
/etc/init.d/led-status restart
```

---

### 🗑️ Uninstallation

To completely remove LED Proxy Status:

```bash
/etc/init.d/led-status stop
/etc/init.d/led-status disable
rm -f /usr/bin/led-status-daemon.sh
rm -f /etc/init.d/led-status
rm -f /etc/config/led-status-port
```

---

### 🐛 Troubleshooting

**LED not changing colors?**
- Check if service is running: `/etc/init.d/led-status status`
- Verify your router has RGB LED: `ls /sys/class/leds/`
- Check logs: `logread | grep led-status`

**Proxy not detected?**
- Verify proxy is running: `netstat -tulpn | grep YOUR_PORT`
- Test proxy manually: `curl -x socks5://127.0.0.1:YOUR_PORT https://www.google.com`
- Check port configuration: `cat /etc/config/led-status-port`

**Service won't start?**
- Check permissions: `chmod +x /usr/bin/led-status-daemon.sh`
- Check init script: `chmod +x /etc/init.d/led-status`
- Restart router: `reboot`

---

### 📝 How It Works

1. **Proxy Check** - Tests SOCKS5 proxy by connecting to Google
2. **Google Check** - Direct connection test to Google servers
3. **Iran Check** - Fallback test to Iranian servers
4. **LED Control** - Updates LED color based on results
5. **Loop** - Repeats every 10 seconds

**Connection Priority:**
```
Proxy (Google) → Direct (Google) → Direct (Iran) → No Internet
```

---

### 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

### 🤝 Contributing

Contributions are welcome! Feel free to:
- 🐛 Report bugs
- 💡 Suggest features
- 🔧 Submit pull requests

---

### ⭐ Support

If this project helped you, please consider:
- ⭐ Starring the repository
- 🐛 Reporting issues
- 📢 Sharing with others

---

</div>

<div dir="rtl" align="right">

## فارسی

### 📖 معرفی

**LED Proxy Status** یک اسکریپت سبک و در زمان واقعی برای روترهای OpenWrt است که چراغ RGB روتر شما را به یک نمایشگر بصری برای وضعیت پروکسی SOCKS5 و اتصال اینترنت تبدیل می‌کند. دیگه نیازی نیست حدس بزنی پروکسیت کار می‌کنه یا نه - فقط به روترت نگاه کن! 🚀

**امکانات کلیدی:**
- 🎨 **نمایش رنگی وضعیت** - بازخورد بصری فوری
- ⚡ **سبک و کم‌حجم** - استفاده حداقلی از منابع
- 🔄 **مانیتورینگ لحظه‌ای** - بررسی هر 10 ثانیه
- 🛠️ **نصب آسان** - نصب با یک دستور
- 🔧 **قابل تنظیم** - پیکربندی پورت پروکسی
- 📱 **سازگاری** - Xray، sing-box، v2ray و سایر پروکسی‌های SOCKS5

**تست شده روی:** Google WiFi (OnHub AC1304)  
**سازگار با:** اکثر روترهای OpenWrt با پشتیبانی LED RGB

---

### 🎨 رنگ‌های چراغ LED

| رنگ | وضعیت | معنی |
|-----|-------|------|
| ⚪ **سفید** | ✅ همه چیز عالیه | پروکسی کامل کار می‌کنه |
| 🔵 **فیروزه‌ای** | ⚠️ پروکسی قطعه | پروکسی افتاده، ولی گوگل در دسترسه |
| 🟣 **بنفش** | 🚫 اینترنت خارجی قطعه (اینترنت ملی شده) | گوگل فیلتره، ولی سرورهای ایران در دسترسن |
| 🔴 **قرمز چشمک‌زن** | ❌ اینترنت قطعه | اینترنت کلاً قطعه |

---

### 📋 پیش‌نیازها

قبل از نصب، مطمئن شو که اینا رو داری:
- ✅ OpenWrt روی روتر نصب باشه
- ✅ روتر چراغ RGB داشته باشه
- ✅ پروکسی SOCKS5 فعال (Xray، sing-box، v2ray و غیره)
- ✅ پکیج `curl` (خودکار نصب می‌شه)
- ✅ پکیج `git` (خودکار نصب می‌شه)

---

### 🚀 نصب سریع

این **یک دستور** رو کپی کن و توی ترمینال SSH روترت بزن:

```bash
cd /tmp
opkg install wget-ssl unzip
wget --no-check-certificate https://codeload.github.com/phoseinq/OpenWrt-PassWall-led-proxy-status/zip/refs/heads/main -O led.zip
unzip led.zip
cd OpenWrt-PassWall-led-proxy-status-main
chmod +x install.sh
sh install.sh
```

**در حین نصب:**
1. اسکریپت ازت پورت پروکسی SOCKS5 رو می‌پرسه
2. مثلاً اگه پروکسیت روی `127.0.0.1:1070` اجراست، عدد `1070` رو وارد کن
3. سرویس بعد از نصب خودکار استارت می‌شه

---

### 🎮 مدیریت سرویس

#### استارت سرویس:
```bash
/etc/init.d/led-status start
```

#### توقف سرویس:
```bash
/etc/init.d/led-status stop
```

#### ری‌استارت سرویس:
```bash
/etc/init.d/led-status restart
```

#### چک کردن اینکه سرویس اجراست یا نه:
```bash
/etc/init.d/led-status status
```
یا:
```bash
ps | grep led-status-daemon | grep -v grep
```

#### فعال‌سازی اجرای خودکار با ریستارت روتر:
```bash
/etc/init.d/led-status enable
```

#### غیرفعال‌سازی اجرای خودکار:
```bash
/etc/init.d/led-status disable
```

---

### 🔧 تنظیمات

پورت پروکسی در `/etc/config/led-status-port` ذخیره می‌شه. برای تغییرش:

```bash
echo "1080" > /etc/config/led-status-port
/etc/init.d/led-status restart
```

---

### 🗑️ حذف کامل

برای پاک کردن کامل LED Proxy Status:

```bash
/etc/init.d/led-status stop
/etc/init.d/led-status disable
rm -f /usr/bin/led-status-daemon.sh
rm -f /etc/init.d/led-status
rm -f /etc/config/led-status-port
```

---

### 🐛 رفع مشکلات

**چراغ LED رنگش عوض نمی‌شه؟**
- چک کن سرویس اجراست: `/etc/init.d/led-status status`
- بررسی کن روترت LED RGB داره: `ls /sys/class/leds/`
- لاگ‌ها رو نگاه کن: `logread | grep led-status`

**پروکسی تشخیص داده نمی‌شه؟**
- بررسی کن پروکسی اجراست: `netstat -tulpn | grep YOUR_PORT`
- پروکسی رو دستی تست کن: `curl -x socks5://127.0.0.1:YOUR_PORT https://www.google.com`
- پورت تنظیم شده رو چک کن: `cat /etc/config/led-status-port`

**سرویس استارت نمی‌شه؟**
- دسترسی‌ها رو چک کن: `chmod +x /usr/bin/led-status-daemon.sh`
- اسکریپت init رو بررسی کن: `chmod +x /etc/init.d/led-status`
- روتر رو ریستارت کن: `reboot`

---

### 📝 نحوه کار

1. **تست پروکسی** - اتصال به گوگل از طریق پروکسی SOCKS5
2. **تست گوگل** - اتصال مستقیم به سرورهای گوگل
3. **تست ایران** - تست بک‌آپ به سرورهای ایرانی
4. **کنترل LED** - آپدیت رنگ LED بر اساس نتایج
5. **حلقه** - تکرار هر 10 ثانیه

**اولویت اتصال:**
```
پروکسی (گوگل) ← مستقیم (گوگل) ← مستقیم (ایران) ← بدون اینترنت
```

---

### 📄 لایسنس

این پروژه تحت لایسنس MIT منتشر شده - فایل [LICENSE](LICENSE) رو برای جزئیات ببین.

---

### 🤝 مشارکت

مشارکت‌ها خوش‌آمدن! می‌تونی:
- 🐛 باگ گزارش کنی
- 💡 ایده بدی
- 🔧 پول ریکوئست بفرستی

---

### ⭐ حمایت

اگه این پروژه بهت کمک کرد، لطفاً:
- ⭐ ستاره بده به ریپازیتوری
- 🐛 مشکلات رو گزارش کن
- 📢 با دیگران به اشتراک بذار

---

</div>

<div align="center">

---

**Made with ❤️ for the OpenWrt Community**

[Report Bug](https://github.com/YOUR_USERNAME/led-proxy-status/issues) · [Request Feature](https://github.com/YOUR_USERNAME/led-proxy-status/issues)

</div>
