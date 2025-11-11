#!/bin/bash

source ./common.sh
check_root

dnf install nginx -y &>> $LOG_FILE
validate $? "Nginx installation"

systemctl start nginx &>> $LOG_FILE
validate $? "Starting Nginx service"
systemctl enable nginx &>> $LOG_FILE
validate $? "Enabling Nginx service at boot"

rm -rf /usr/share/nginx/html/* &>> $LOG_FILE
validate $? "Cleaning default Nginx HTML content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>> $LOG_FILE
validate $? "Downloading frontend code"

cd /usr/share/nginx/html &>> $LOG_FILE
validate $? "Changing to Nginx HTML directory"

unzip /tmp/frontend.zip &>> $LOG_FILE
validate $? "Extracting frontend code"

cp /home/ec2-user/expense-1/expense.conf /etc/nginx/conf.d/expense.conf &>> $LOG_FILE
validate $? "Copying Nginx configuration file"

systemctl restart nginx &>> $LOG_FILE
validate $? "Restarting Nginx to apply new configuration"