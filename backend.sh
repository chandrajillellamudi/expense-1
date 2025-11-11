#!/bin/bash

source ./common.sh
check_root
dnf module disable nodejs -y &>> $LOG_FILE
validate $? "Disabling NodeJS module"
dnf module enable nodejs:20 -y &>> $LOG_FILE
validate $? "Enabling NodeJS 20 module"
dnf install nodejs -y &>> $LOG_FILE
validate $? "NodeJS installation"
id expense 
if [ $? -ne 0 ]; then   
    useradd expense &>> $LOG_FILE
    validate $? "Creating expense user"
else
    echo -e "${Y}User expense already exists..${N}SKIPPING"
fi
mkdir -p /app &>> $LOG_FILE
validate $? "Creating /app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>> $LOG_FILE
validate $? "Downloading backend code"

cd /app &>> $LOG_FILE
validate $? "Changing to /app directory"

rm -rf /app/* &>> $LOG_FILE
validate $? "Cleaning /app directory"   

unzip /tmp/backend.zip &>> $LOG_FILE
validate $? "Unzipping backend code"

npm install &>> $LOG_FILE
validate $? "Installing backend dependencies"

cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>> $LOG_FILE
validate $? "Copying backend systemd service file"

systemctl daemon-reload &>> $LOG_FILE
validate $? "Reloading systemd daemon"

systemctl start backend &>> $LOG_FILE
validate $? "Starting backend service"

systemctl enable backend &>> $LOG_FILE
validate $? "Enabling backend service at boot"

dnf install mysql -y &>> $LOG_FILE
validate $? "MySQL client installation"

mysql -h db.chandradevops.online -uexpense -pExpenseApp@1 < /app/schema/backend.sql
validate $? "Importing backend database schema"

systemctl restart backend &>> $LOG_FILE
validate $? "Restarting backend service"

# mysql -h db.chandradevops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql