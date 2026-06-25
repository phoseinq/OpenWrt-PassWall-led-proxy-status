#!/bin/sh

SOCKS_PORT="__SOCKS_PORT__"
PROXY="socks5h://127.0.0.1:$SOCKS_PORT"
LED_DIR="/sys/class/leds"

first_led() {
  for d in $1; do [ -d "$d" ] && { printf '%s\n' "$d"; return 0; }; done
  return 1
}

LED_R=$(first_led "$LED_DIR/*[Rr]ed*")
LED_G=$(first_led "$LED_DIR/*[Gg]reen*")
LED_B=$(first_led "$LED_DIR/*[Bb]lue*")
[ -n "$LED_R" ] || LED_R="$LED_DIR/LED0_Red"
[ -n "$LED_G" ] || LED_G="$LED_DIR/LED0_Green"
[ -n "$LED_B" ] || LED_B="$LED_DIR/LED0_Blue"

logger -t led-status "LED paths: R=$LED_R G=$LED_G B=$LED_B"

wr() { [ -e "$1" ] && echo "$2" > "$1" 2>/dev/null; }

breathe_pid=""

stop_breathe() {
  if [ -n "$breathe_pid" ]; then
    kill "$breathe_pid" 2>/dev/null
    wait "$breathe_pid" 2>/dev/null
    breathe_pid=""
  fi
}

cleanup_leds() {
  stop_breathe
  for L in "$LED_R" "$LED_G" "$LED_B"; do wr "$L/trigger" none; wr "$L/brightness" 0; done
}

# Fade out current color to ~2% brightness (never goes fully dark)
fade_out() {
  stop_breathe
  for L in "$LED_R" "$LED_G" "$LED_B"; do wr "$L/trigger" none; done
  if [ "$state" = "white" ]; then
    r=220; g=220; bv=220
  else
    r=$(cat "$LED_R/brightness" 2>/dev/null); r=${r:-0}
    g=$(cat "$LED_G/brightness" 2>/dev/null); g=${g:-0}
    bv=$(cat "$LED_B/brightness" 2>/dev/null); bv=${bv:-0}
  fi
  wr "$LED_R/brightness" "$r"; wr "$LED_G/brightness" "$g"; wr "$LED_B/brightness" "$bv"
  i=30
  while [ "$i" -ge 1 ]; do
    wr "$LED_R/brightness" $(( r * i / 30 ))
    wr "$LED_G/brightness" $(( g * i / 30 ))
    wr "$LED_B/brightness" $(( bv * i / 30 ))
    sleep 0.02
    i=$(( i-1 ))
  done
}

# Boot phase: 1s solid yellow, then exponential easing breathe (~35s total)
boot_phase() {
  cleanup_leds
  wr "$LED_R/brightness" 220
  wr "$LED_G/brightness" 220
  sleep 1
  for step in 8 4 2 1; do
    b=5
    while [ "$b" -le 220 ]; do wr "$LED_R/brightness" "$b"; wr "$LED_G/brightness" "$b"; sleep 0.04; b=$(( b+step )); done
    b=220
    while [ "$b" -ge 5 ]; do wr "$LED_R/brightness" "$b"; wr "$LED_G/brightness" "$b"; sleep 0.04; b=$(( b-step )); done
  done
  cleanup_leds
}

# Cyan breathing (proxy down, Google reachable) - min brightness 5
_breathe_cyan() {
  while true; do
    b=5; while [ "$b" -le 220 ]; do wr "$LED_G/brightness" "$b"; wr "$LED_B/brightness" "$b"; sleep 0.03; b=$(( b+1 )); done
    b=220; while [ "$b" -ge 5 ]; do wr "$LED_G/brightness" "$b"; wr "$LED_B/brightness" "$b"; sleep 0.03; b=$(( b-1 )); done
  done
}

# Purple breathing (international internet blocked) - min brightness 5
_breathe_purple() {
  while true; do
    b=5; while [ "$b" -le 220 ]; do wr "$LED_R/brightness" "$b"; wr "$LED_B/brightness" "$b"; sleep 0.03; b=$(( b+1 )); done
    b=220; while [ "$b" -ge 5 ]; do wr "$LED_R/brightness" "$b"; wr "$LED_B/brightness" "$b"; sleep 0.03; b=$(( b-1 )); done
  done
}

set_white() {
  fade_out
  b=5
  while [ "$b" -le 220 ]; do
    for L in "$LED_R" "$LED_G" "$LED_B"; do wr "$L/brightness" "$b"; done
    sleep 0.02; b=$(( b+5 ))
  done
  for L in "$LED_R" "$LED_G" "$LED_B"; do wr "$L/brightness" 220; done
}

set_cyan() {
  fade_out
  wr "$LED_R/brightness" 0
  _breathe_cyan &
  breathe_pid=$!
}

set_purple() {
  fade_out
  wr "$LED_G/brightness" 0
  _breathe_purple &
  breathe_pid=$!
}

set_red_blink() {
  fade_out
  for L in "$LED_R" "$LED_G" "$LED_B"; do wr "$L/brightness" 0; done
  wr "$LED_R/trigger" timer
  wr "$LED_R/delay_on" 300
  wr "$LED_R/delay_off" 300
}

proxy_ok() { curl -x "$PROXY" -m 7 -s http://ifconfig.me >/dev/null 2>&1; }
google_ok() { ping -c 1 -W 2 google.com >/dev/null 2>&1; }
iran_ok()   { ping -c 1 -W 2 176.102.251.1 >/dev/null 2>&1; }

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
