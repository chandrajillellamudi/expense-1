#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$( echo $0 | cut -d'.' -f1)
LOG_FILE=/tmp/${SCRIPT_NAME}_${TIMESTAMP}.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $ID -ne 0 ]; then
    echo -e "${R}Please run as root user${N}"
    exit 1
else
    echo -e "${G}Running as root user${N}"
fi
validate(){
    if [ $1 -ne 0 ]; then
        echo -e "${R}$2.. failed${N}"
        exit 1
    else
        echo -e "${G}$2.. successful${N}"
    fi
}