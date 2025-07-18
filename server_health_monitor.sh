#!/bin/bash

# CONFIGURATION
SNS_TOPIC_ARN="arn:aws:sns:us-east-1:245140949275:sever-health-monitor"
CPU_THRESHOLD=1
MEM_THRESHOLD=1
DISK_THRESHOLD=1

# Server info
SERVER_NAME=$(hostname)
DATE_TIME=$(date '+%Y-%m-%d %H:%M:%S')

# GET SYSTEM METRICS 

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
DISK_FREE=$(df / | tail -1 | awk '{print $4}')
DISK_SIZE=$(df / | tail -1 | awk '{print $2}')
DISK_FREE_PERCENT=$(awk "BEGIN {print ($DISK_FREE/$DISK_SIZE)*100}")

#  MONITOR AND ALERT 

ALERT_MSG="Server: $SERVER_NAME 
Date: $DATE_TIME

"
TRIGGERED=0

if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    ALERT_MSG+="ALERT: CPU high: $CPU_USAGE
    "
    TRIGGERED=1
fi

if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
    ALERT_MSG+="ALERT: Memory high: $MEM_USAGE
    "
    TRIGGERED=1
fi

if (( $(echo "$DISK_FREE_PERCENT < $DISK_THRESHOLD" | bc -l) )); then
    ALERT_MSG+="ALERT: Disk space low: $DISK_FREE_PERCENT
    "
    TRIGGERED=1
fi

# SEND ALERT IF NEEDED 

if [ $TRIGGERED -eq 1 ]; then
    echo -e "$ALERT_MSG"
    aws sns publish \
        --topic-arn "$SNS_TOPIC_ARN" \
        --message "$ALERT_MSG" \
        --subject "SERVER HEALTH ALERT"
else
    echo "All system health metrics are normal."
fi

#  END 
