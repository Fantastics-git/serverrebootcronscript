First, in order to have a command run on boot we can either create a reboot cron job, or add a line to the /etc/rc.d/rc.local file. 
Note that the crontab @reboot job may only run when the machine is rebooted, 
not from a cold-boot (like after the power goes out).
To use the crontab @reboot option, start by editing your crontab file and adding a line like 
the following (edit your crontab file with the crontab -e command):

@reboot /root/emailnotify.sh

if you instead want a script that will run every time a server is booted, 
add the link to your script in the /etc/rc.d/rc.local file:

#!/bin/sh
#
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you don't
# want to do the full Sys V style init stuff.

touch /var/lock/subsys/local
/root/emailnotify.sh

#!/bin/bash
sleep 60
#/bin/systemctl restart sendmail.service
/sbin/service sendmail restart
IP=`hostname -i`
HOSTNAME=`hostname -f`
echo "$HOSTNAME online.  IP address: $IP" > /root/email.txt
echo >> /root/email.txt
date >> /root/email.txt
mail -s "$HOSTNAME online" -r restart@server.domain.tld myemail@mydomain.tld < /root/email.txt
#cat /root/email.txt
rm -rf /root/email.txt
#/bin/systemctl restart sendmail.service
/sbin/service sendmail restart
