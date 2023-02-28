#!/bin/bash

# This file serves as a CONFIG file for the Automation Project
# It defines the variables used in the Project

MY_NAME="Mahesh"
S3_BUCKET="upgrad-assignment-mahesh"
LOGFILES="/var/log/apache2/*.log"
TIMESTAMP=$(date '+%d%m%Y-%H%M%S')

CRONJOB_FILE="/etc/cron.d/schedule-automation"
TEMPLATE="/root/Automation_Project/template"
INVENTORY="/var/www/html/inventory.html"
