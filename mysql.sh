#!/bin/bash
source ./common.sh
check_root

dnf install mysql-server -y &>> $LOG_FILE
validate $? "MySQL installation"

systemctl start mysqld &>> $LOG_FILE
validate $? "Starting MySQL service"    

systemctl enable mysqld &>> $LOG_FILE
validate $? "Enabling MySQL service at boot"    

mysql_secure_installation --set-root-pass ExpenseApp@1 &>> $LOG_FILE
validate $? "Securing MySQL installation"

mysql -uroot -pExpenseApp@1 < /home/ec2-user/expense-shell/backend.sql &>> $LOG_FILE
validate $? "Importing Database Schema"