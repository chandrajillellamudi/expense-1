#!/bin/bash

source ./common.sh
check_root

dnf install nginx -y &>> $LOG_FILE
validate $? "Nginx installation"

