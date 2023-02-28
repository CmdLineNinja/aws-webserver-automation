This is a simple project that demonstartes how to automate the installation of Apache on an EC2 instance and store logs in S3

PRE-REQUISITES
===============

1. A running EC2 instance with port 80 and 443 open

2. A bucket in Amazon S3 to store log backups

3. An IAM role with S3 Full Access policy attached to the EC2 instance

4. AWS CLI installed and configured on the EC2 server

FILES
======

1. automation.sh	-->  The main automation shell script

2. config.sh 		-->  Holds all the variables used in the automation script

3. template		-->  HTML template file copied to /var/www/html/inventory.html used for book-keeping

ver1.0
========

If the The Apache web server is not installed, it is installed, enabled and started.

A tar archive is created of the Apache access and error logs.

The archive is backed up to the S3 bucket

ver2.0
=======

An inventory file is created in /var/www/html that serves as book-keeping for the backed-up logs 

A cron job is installed that runs the automation.sh script daily	  
