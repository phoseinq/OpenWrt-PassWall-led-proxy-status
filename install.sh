#!/bin/sh

echo "=== LED Proxy Status Installer ==="
printf "Enter SOCKS5 proxy port (example: 1070): "
read PORT

if [ -z "$PORT" ]; then
  echo "Error: Port is required"
  exit 1
fi

echo "[+] Installing with SOCKS port $PORT"

sed "s/__SOCKS_PORT__/$PORT/g" led-status-daemon.sh > /usr/bin/led-status-daemon.sh
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

echo "[✓] Installation complete"
