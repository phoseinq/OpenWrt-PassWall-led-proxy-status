#!/bin/sh

SOCKS_PORT="__SOCKS_PORT__"
PROXY="socks5h://127.0.0.1:$SOCKS_PORT"

LED_R="/sys/class/leds/LED0_Red"
LED_G="/sys/class/leds/LED0_Green"
LED_B="/sys/class/leds/LED0_Blue"

cleanup_leds() {
  echo none > "$LED_R/trigger"
  echo none > "$LED_G/trigger"
  echo none > "$LED_B/trigger"
}

set_white() {
  cleanup_leds
  echo default-on > "$LED_R/trigger"
  echo default-on > "$LED_G/trigger"
  echo default-on > "$LED_B/trigger"
}

set_cyan() {
  cleanup_leds
  echo default-on > "$LED_G/trigger"
  echo default-on > "$LED_B/trigger"
}

set_purple() {
  cleanup_leds
  echo default-on > "$LED_R/trigger"
  echo default-on > "$LED_B/trigger"
}

set_red_blink() {
  cleanup_leds
  echo timer > "$LED_R/trigger"
  echo 300 > "$LED_R/delay_on"
  echo 300 > "$LED_R/delay_off"
}

boot_phase() {
  cleanup_leds
  echo default-on > "$LED_R/trigger"
  echo default-on > "$LED_G/trigger"
  sleep 60
  cleanup_leds
}

proxy_ok() {
  curl -x "$PROXY" -m 7 -s --fail https://api.github.com/zen >/dev/null 2>&1
}

google_ok() {
  ping -c 1 -W 2 google.com >/dev/null 2>&1
}

iran_ok() {
  ping -c 1 -W 2 iran.ir >/dev/null 2>&1
}

state=""
sleep_s=30

boot_phase

while true; do
  if proxy_ok; then
    [ "$state" != "white" ] && set_white && state="white"
    sleep_s=60
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
