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

# Create an TAR archive of Apache log files

tar -cvf /tmp/${MY_NAME}-httpd-logs-${TIMESTAMP}.tar  ${LOGFILES}

# Upload the archived logs to S3

aws s3 cp /tmp/*tar s3://${S3_BUCKET}/

