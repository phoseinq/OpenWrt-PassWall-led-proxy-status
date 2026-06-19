#!/bin/sh
# LED Proxy Status installer.
# Works on both opkg (OpenWrt <= 24.10) and apk (OpenWrt 25.x and newer).

echo "=== LED Proxy Status Installer ==="

# The daemon needs curl to test the SOCKS5 proxy. Install it with whatever
# package manager this OpenWrt build ships (apk on 25.x+, opkg before that).
if ! command -v curl >/dev/null 2>&1; then
  echo "[+] curl not found, trying to install it ..."
  if command -v apk >/dev/null 2>&1; then
    apk update 2>/dev/null; apk add curl 2>/dev/null
  elif command -v opkg >/dev/null 2>&1; then
    opkg update 2>/dev/null; opkg install curl 2>/dev/null
  fi
fi
command -v curl >/dev/null 2>&1 || \
  echo "[!] curl is still missing — install it by hand or the proxy check won't work."

printf "Enter SOCKS5 proxy port (example: 1070): "
read PORT
if [ -z "$PORT" ]; then
  echo "Error: Port is required"
  exit 1
fi

echo "[+] Installing with SOCKS port $PORT"

# led-status-daemon.sh must sit next to this script.
SRC_DIR=$(dirname "$0")
if [ ! -f "$SRC_DIR/led-status-daemon.sh" ]; then
  echo "Error: led-status-daemon.sh not found next to install.sh"
  exit 1
fi

sed "s/__SOCKS_PORT__/$PORT/g" "$SRC_DIR/led-status-daemon.sh" > /usr/bin/led-status-daemon.sh
chmod +x /usr/bin/led-status-daemon.sh

cat > /etc/init.d/led-status <<'EOF'
#!/bin/sh /etc/rc.common
USE_PROCD=1
START=99

start_service() {
  procd_open_instance
  procd_set_param command /usr/bin/led-status-daemon.sh
  procd_set_param respawn 3600 5 5
  procd_close_instance
}
EOF

chmod +x /etc/init.d/led-status

/etc/init.d/led-status enable
/etc/init.d/led-status restart

echo "[✓] Installation complete."
echo "    Watch it pick the LED paths with:  logread -e led-status"
