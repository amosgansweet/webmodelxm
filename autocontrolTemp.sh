#!/bin/bash

TARGET_TEMP=80  # 目标最高温度
COOLDOWN_TEMP=70  # 降温到此温度恢复

while true; do
  CPU_TEMP=$(sensors | grep 'Package id 0:' | awk '{print $4}' | sed 's/+//;s/°C//')
  
  if (( $(echo "$CPU_TEMP > $TARGET_TEMP" | bc -l) )); then
    echo "[警告] 温度 $CPU_TEMP°C 超过 $TARGET_TEMP°C，暂停挖矿！"
    pkill xmrig
  fi

  if (( $(echo "$CPU_TEMP < $COOLDOWN_TEMP" | bc -l) )); then
    if ! pgrep xmrig > /dev/null; then
      echo "[恢复] 温度 $CPU_TEMP°C，重新启动挖矿。"
      ./xmrig --cpu-priority=4 --cpu-max-threads-hint=80 --background
    fi
  fi

  sleep 30
done
