<div dir="rtl" align="right">

# چراغ وضعیت پروکسی — OpenWrt

چراغ RGB روتر شما وضعیت پروکسی را نشان می‌دهد.

| رنگ | یعنی چه |
|-----|---------|
| 🟡 زرد | دارد روشن می‌شود |
| ⚪ سفید | پروکسی کار می‌کند |
| 🔵 فیروزه‌ای | پروکسی قطع، اینترنت وصل |
| 🟣 بنفش | اینترنت خارجی قطع |
| 🔴 قرمز چشمک‌زن | اینترنت کاملاً قطع |

---

## نصب

در SSH روتر این دستور را بزنید:

```bash
cd /tmp && wget --no-check-certificate -O install.sh https://raw.githubusercontent.com/phoseinq/OpenWrt-PassWall-led-proxy-status/main/install.sh && sh install.sh
```

وقتی پورت پرسید، پورت پروکسی SOCKS5 خود را بنویسید (مثلاً `1080`).

---

## اگر روتر به گیتهاب وصل نمی‌شود

اگر روتر شما به گیتهاب دسترسی ندارد (مثلاً در ایران)، از پروکسی SOCKS5 برای دانلود استفاده کنید.  
به جای `user`، `pass`، `IP` و `PORT` اطلاعات پروکسی خود را بگذارید:

```bash
cd /tmp
curl --socks5-hostname user:pass@IP:PORT -L -o install.sh https://raw.githubusercontent.com/phoseinq/OpenWrt-PassWall-led-proxy-status/main/install.sh
curl --socks5-hostname user:pass@IP:PORT -L -o led-status-daemon.sh https://raw.githubusercontent.com/phoseinq/OpenWrt-PassWall-led-proxy-status/main/led-status-daemon.sh
echo "1080" | sh install.sh
```

---

[📖 راهنمای کامل دوزبانه](ADVANCED.md)

</div>