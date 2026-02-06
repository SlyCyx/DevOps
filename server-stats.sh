#!bin/bash

while true; do
  clear

  cpuUsage() {
    ps aux | sort -nr | head -15 | tail -10
  }
  osVersion() {
    cat /etc/os-release/ | grep "^NAME"
  }
  memoryUsage() {
    ps -eo pid,comm,%mem --sort=%mem | head -n 6
  }
  usedMemory() {
    free -m | grep "^Mem"
  }

  echo "CPU Usage"
  cpuUsage
  echo "- - - - - - - - - - -"
  echo "MemoryUsage"
  memoryUsage
  echo "- - - - - - - - - - -"
  echo "OS Version"
  osVersion
  echo "- - - - - - - - - - -"
  echo "Computer was booted since:"
  uptime
  echo "- - - - - - - - - - -"
  echo "Total Memory used"
  usedMemory
  echo "- - - - - - - - - - -"
  sleep 2
done
