#!/usr/bin/env bash

## Stabilisci il threshold delle stat di sistema

CPU_THRESHOLD=80
MEM_THRESHOLD=65
DISK_THRESHOLD=80

##Manda un avvertimento

send_alert() {
  echo "$(tput setaf 1)ATTENZIONE: $1 utilizzo supera il threshold!
  Valore attuale: $2%$(tput sgr0)"
}

while true; do {
  sleep 2

  tput home

  ##Monitora l'utilizzo della CPU
  cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 +$4}')
  cpu_usage=${cpu_usage%.*} ##Converte in intero
  echo "Utilizzo corrente CPU: $cpu_usage%"

  ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

  if ((cpu_usage >= CPU_THRESHOLD)); then
    send_alert "CPU" "$cpu_usage"
  fi

  echo "---------------------------------"

  ##Monitora l'utilizzo della memoria
  memory_usage=$(free | awk '/Mem/ {printf("%3.1f", ($3/$2) * 100)}')
  echo "Utilizzo attuale della memoria: $memory_usage%"
  memory_usage=${memory_usage%.*}

  ps -eo pid,user,comm,rss,%mem --sort=-rss | head -n 6

  if ((memory_usage >= MEM_THRESHOLD)); then
    send_alert "Memory" "$memory_usage"
  fi

  echo "---------------------------------"

  ##Monitora l'utilizzo del disco
  disk_usage=$(df -h / | awk '/\// {print $(NF-1)}')
  disk_usage=${disk_usage%?} ##Rimuove il simbolo percentuale
  echo "Utilizzo attuale del disco: $disk_usage%"
  if ((disk_usage >= DISK_THRESHOLD)); then
    send_alert "Disk" "$disk_usage"
  fi

}; done
