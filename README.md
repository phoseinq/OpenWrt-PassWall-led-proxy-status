# LED Proxy Status for OpenWrt

Show proxy and connectivity status using router RGB LED.

## LED Colors
- White: Proxy is working
- Cyan: Proxy down, Google reachable
- Purple: Google down, Iran reachable
- Red Blinking: No connectivity

## Requirements
- OpenWrt
- RGB LED router (tested on Google WiFi AC1304)
- SOCKS5 proxy (Xray, sing-box, etc.)
- curl package

## Install
```sh
opkg update
opkg install curl
git clone https://github.com/YOUR_USERNAME/led-proxy-status.git
cd led-proxy-status
sh install.sh
