Bash Server Health Monitor with AWS SNS
This Bash script monitors your Linux system’s CPU, memory, and disk usage, and sends a real-time email alert using AWS Simple Notification Service (SNS) if anything crosses your chosen thresholds. The script is fully automated: it runs at startup and every 30 minutes using cron, and logs every check for auditing.

Features

Monitors CPU, memory, and disk usage on Linux

Sends instant email alerts via AWS SNS when a metric crosses your set threshold

Uses AWS cloud for reliable notifications

Runs at every reboot and every 30 minutes using cron

Logs all script runs to a local log file

How to Use

Clone the repository and enter the project directory.

Open server_health_monitor.sh in a text editor. Find the SNS_TOPIC_ARN line and set it to your actual SNS Topic ARN from AWS. Optionally, adjust CPU, memory, or disk thresholds as you like.

Set up AWS SNS:

Create a Standard SNS Topic in the AWS SNS Console.

Create a subscription for your topic with protocol "Email" and your email address as the endpoint.

Check your email inbox and confirm the subscription using the link AWS sends you.

Copy your topic’s ARN from the SNS console and update it in your script.

Make the script executable using chmod +x and the full path to the script.

Set up cron jobs:

Open your crontab (crontab -e).

Add two lines:
@reboot [full path to script] >> [full path to log file] 2>&1
*/30 * * * * [full path to script] >> [full path to log file] 2>&1

Replace [full path to script] and [full path to log file] with your actual locations.

You can also run the script manually anytime to test. If any metric is above your thresholds, you’ll get an email.

Sample Alert Email

Server: archlinux
Date: 2025-07-17 20:34:32

ALERT: CPU high: 12.2
ALERT: Memory high: 4.46186

Security Notes

Never upload AWS access keys or secrets to public repositories.

Use a placeholder or dummy ARN in public code if sharing.

Do not post your real email or credentials in screenshots.

Tech Stack

Bash
Linux
Cron
AWS SNS

Project Motivation

This project was built to practice real-world DevOps automation, cloud integration, and Linux scripting. You can extend it to monitor more metrics (like network, battery, or temperature), or alert using SMS, Slack, Telegram, and more.
