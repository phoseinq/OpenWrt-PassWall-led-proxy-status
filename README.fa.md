<div dir="rtl" align="right">

# راهنمای نصب — چراغ وضعیت پروکسی برای OpenWrt

این اسکریپت چراغ RGB روتر شما را به یک چراغ وضعیت تبدیل می‌کند.  
با یک نگاه می‌فهمید پروکسی کار می‌کند یا نه.

---

## رنگ‌ها چه معنایی دارند؟

| رنگ | یعنی چه |
|-----|---------|
| 🟡 زرد (نفس‌نفس‌زنان) | روتر دارد روشن می‌شود |
| ⚪ سفید | پروکسی کار می‌کند — همه چیز خوب است |
| 🔵 فیروزه‌ای (نفس‌نفس‌زنان) | پروکسی قطع است ولی اینترنت وصل است |
| 🟣 بنفش (نفس‌نفس‌زنان) | اینترنت خارجی قطع است (اینترنت ملی فعال) |
| 🔴 قرمز چشمک‌زن | اینترنت کاملاً قطع است |

---

## پیش‌نیازها

قبل از نصب این‌ها را داشته باشید:

- ✅ روتری که OpenWrt روی آن نصب باشد
- ✅ روتر باید چراغ RGB داشته باشد
- ✅ یک پروکسی SOCKS5 فعال (مثل Xray یا PassWall)
- ✅ دسترسی SSH به روتر

---

## نصب

### روش معمولی (اگر روتر به گیتهاب وصل می‌شود)

در SSH روتر این دستور را بزنید:

```bash
cd /tmp && wget --no-check-certificate -O install.sh https://raw.githubusercontent.com/phoseinq/OpenWrt-PassWall-led-proxy-status/main/install.sh && sh install.sh
```

وقتی پرسید «پورت پروکسی چیست» عدد پورت را بنویسید (مثلاً `1080`) و Enter بزنید.

---

### روش جایگزین (اگر روتر به گیتهاب وصل نمی‌شود)

اگر روتر شما در ایران است و به گیتهاب دسترسی ندارد، از این روش استفاده کنید.  
به جای `YOUR_PROXY` اطلاعات پروکسی خود را بنویسید:

```bash
cd /tmp
curl --socks5-hostname user:pass@IP:PORT -L -o install.sh https://raw.githubusercontent.com/phoseinq/OpenWrt-PassWall-led-proxy-status/main/install.sh
curl --socks5-hostname user:pass@IP:PORT -L -o led-status-daemon.sh https://raw.githubusercontent.com/phoseinq/OpenWrt-PassWall-led-proxy-status/main/led-status-daemon.sh
echo "PORT_NUMBER" | sh install.sh
```

---

## مدیریت سرویس

```bash
# شروع
/etc/init.d/led-status start

# توقف
/etc/init.d/led-status stop

# ری‌استارت
/etc/init.d/led-status restart

# چک کردن وضعیت
/etc/init.d/led-status status
```

---

## تغییر پورت پروکسی

```bash
echo "1080" > /etc/config/led-status-port
/etc/init.d/led-status restart
```

---

## حذف کامل

```bash
/etc/init.d/led-status stop
/etc/init.d/led-status disable
rm -f /usr/bin/led-status-daemon.sh /etc/init.d/led-status /etc/config/led-status-port
echo none > /sys/class/leds/LED0_Red/trigger
echo none > /sys/class/leds/LED0_Green/trigger
echo none > /sys/class/leds/LED0_Blue/trigger
```

---

## مشکل دارید؟

**چراغ رنگ نمی‌شود؟**
```bash
ls /sys/class/leds/
logread | grep led-status
```

**پروکسی تشخیص داده نمی‌شود؟**
```bash
curl -x socks5://127.0.0.1:PORT https://www.google.com
```

---

[راهنمای کامل به انگلیسی](README.md)

</div>
