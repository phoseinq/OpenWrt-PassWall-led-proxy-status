#!/bin/sh

SOCKS_PORT="__SOCKS_PORT__"
PROXY="socks5h://127.0.0.1:$SOCKS_PORT"

LED_DIR="/sys/class/leds"

# Pick the first existing LED directory matching a glob pattern.
first_led() {
  for d in $1; do
    [ -d "$d" ] && { printf '%s\n' "$d"; return 0; }
  done
  return 1
}

# Auto-detect the red/green/blue LED nodes (names differ between devices and
# OpenWrt versions), then fall back to the Google WiFi / OnHub names.
LED_R=$(first_led "$LED_DIR/*[Rr]ed*")
LED_G=$(first_led "$LED_DIR/*[Gg]reen*")
LED_B=$(first_led "$LED_DIR/*[Bb]lue*")
[ -n "$LED_R" ] || LED_R="$LED_DIR/LED0_Red"
[ -n "$LED_G" ] || LED_G="$LED_DIR/LED0_Green"
[ -n "$LED_B" ] || LED_B="$LED_DIR/LED0_Blue"

logger -t led-status "LED paths: R=$LED_R G=$LED_G B=$LED_B"
if [ ! -d "$LED_R" ] && [ ! -d "$LED_G" ] && [ ! -d "$LED_B" ]; then
  logger -t led-status "no RGB LEDs found. Available: $(ls "$LED_DIR" 2>/dev/null | tr '\n' ' ')"
fi

# Write a value to a sysfs attribute only if it exists (avoids errors/spinning).
wr() { [ -e "$1" ] && echo "$2" > "$1" 2>/dev/null; }

cleanup_leds() {
  for L in "$LED_R" "$LED_G" "$LED_B"; do
    wr "$L/trigger" none
    wr "$L/brightness" 0
  done
}

set_white() {
  cleanup_leds
  for L in "$LED_R" "$LED_G" "$LED_B"; do wr "$L/trigger" default-on; done
}

set_cyan() {
  cleanup_leds
  wr "$LED_G/trigger" default-on
  wr "$LED_B/trigger" default-on
}

set_purple() {
  cleanup_leds
  wr "$LED_R/trigger" default-on
  wr "$LED_B/trigger" default-on
}

set_red_blink() {
  cleanup_leds
  wr "$LED_R/trigger" timer
  wr "$LED_R/delay_on" 300
  wr "$LED_R/delay_off" 300
}

boot_phase() {
  cleanup_leds
  wr "$LED_R/trigger" default-on
  wr "$LED_G/trigger" default-on
  sleep 60
  cleanup_leds
}

proxy_ok() {
  curl -x "$PROXY" -m 7 -s http://ifconfig.me >/dev/null 2>&1
}

google_ok() {
  ping -c 1 -W 2 google.com >/dev/null 2>&1
}

iran_ok() {
  ping -c 1 -W 2 176.102.251.1 >/dev/null 2>&1
}

state=""
sleep_s=30

boot_phase

while true; do
  if proxy_ok; then
    [ "$state" != "white" ] && set_white && state="white"
    sleep_s=30
  elif google_ok; then
    [ "$state" != "cyan" ] && set_cyan && state="cyan"
    sleep_s=30
  elif iran_ok; then
    [ "$state" != "purple" ] && set_purple && state="purple"
    sleep_s=10
  else
    [ "$state" != "redblink" ] && set_red_blink && state="redblink"
    sleep_s=5
  fi
  sleep "$sleep_s"
done
