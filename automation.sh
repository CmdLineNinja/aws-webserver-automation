#!/bin/bash

# Update the system package list

apt-get update

# Install the Apache Web Server if it is not installed

dpkg --get-selections | grep "apache2" > /dev/null
if [[ $? -gt 0 ]]
then
	apt-get install apache2 -y
fi

# Start the Apache service if it is not running

if [ $(systemctl is-active apache2 | grep "\bactive\b" | wc -w) -eq 0 ]
then
	systemctl start apache2
fi

# Enable the Apache service if it is not

if [ $(systemctl is-enabled apache2) != "enabled" ]
then
	systemctl enable apache2
fi

# Source the Project variables from config file

source $(dirname "$0")/config.sh

# Create a TAR archive of Apache log files

tar -cvf /tmp/${MY_NAME}-httpd-logs-${TIMESTAMP}.tar  ${LOGFILES}

# Upload the archived logs to S3

aws s3 cp /tmp/ "s3://${S3_BUCKET}/" --recursive --exclude "*" --include "*.tar"

# Add book-keeping to the script by keeping a record of all the files backed up to S3
# Create a HTML file called inventory.html which Apache serves

# Use the HTML template file to create, if file exists skip this step

if [[ ! -f ${INVENTORY} ]]
then
	cp ${TEMPLATE} ${INVENTORY}
fi

# Record size of the latest tar backup file with other info. in inventory

size=$(ls -lth /tmp/*tar | head -2 | tail -n 1| tr -s " " |  cut -d " " -f5)
sed -i '/Log Type/a <h4>Httpd-Logs<h4>' ${INVENTORY}
sed -i "/Creation/a <h4>$(date)<h4>" ${INVENTORY}
sed -i '/File Type/a <h4>Tar Archive<h4>' ${INVENTORY}
sed -i "/Size/a <h4>${size}<h4>" ${INVENTORY}

# Install a cron job to run this script hourly every day of the week

if [[ ! -f ${CRONJOB_FILE} ]]
then
	touch ${CRONJOB_FILE}
	chmod 600 ${CRONJOB_FILE}	
	echo "00	*	*	*	*	 /root/Automation_Project/automation.sh" > ${CRONJOB_FILE}
fi

