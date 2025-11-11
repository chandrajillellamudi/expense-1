#!/bin/bash

source ./common.sh
check_root

dnf install nginx -y &>> $LOG_FILE
validate $? "Nginx installation"

systemctl start nginx &>> $LOG_FILE
validate $? "Starting Nginx service"