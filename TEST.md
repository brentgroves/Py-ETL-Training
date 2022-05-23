docker run --name send-email-docker -it brentgroves/send-email-docker:1

dig mobexglobal-com.mail.protection.outlook.com
echo "Testing msmtp from ${HOSTNAME} with mail command" | mail -s "test mail 2" bgroves@buschegroup.com
