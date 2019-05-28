#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

echo ""
echo ""
echo "Starting Sim Bank Scheduler Server install "
echo ""
echo ""

if id | grep root > /dev/null
then
        :
else
        echo "You must be root to install these tools."
        exit 1
fi

if [ ! -d smb_scheduler ]
then
	echo "Please change smb_scheduler_install directory "
	exit 1
fi

######Identify if this is a Ubuntu/Debian system##########
if grep -i -E 'ubuntu|debian' /etc/*release* > /dev/null
then 
    DISTRIBUTION=DEB
    APACHE_PATH="/etc/apache2/sites-enabled"
    [ ! -L /var/lib/mysql/mysql.sock ] && ln -s /var/run/mysqld/mysqld.sock /var/lib/mysql/mysql.sock  
elif grep -i -E 'CentOS Linux release 7' /etc/*release* > /dev/null
then 
    DISTRIBUTION=centos7
    APACHE_PATH="/etc/httpd/conf.d"
    chmod +x /etc/rc.local
else
    APACHE_PATH="/etc/httpd/conf.d"
fi
########################################################

echo "Configure httpd config:"
echo "Enter the httpd config file PATH: (default: $APACHE_PATH)"
echo "Defautl press Enter"
read HTTP_PATH
if [ "${HTTP_PATH}" = "" ] 
then
	HTTP_PATH=$APACHE_PATH
fi

if [ ! -d ${HTTP_PATH} ]
then
	echo "${HTTP_PATH} do not exist"
	exit 1
fi

echo ""
echo ""





echo '
Alias /smb_scheduler "/var/www/smb_scheduler"
<Directory "/var/www/smb_scheduler">
    Options FollowSymLinks Indexes MultiViews
    AllowOverride None
    Order allow,deny
    Allow from all
</Directory>
' > $HTTP_PATH/smb_scheduler.conf
echo "Copying file to /usr/local/smb_scheduler"
if ps aux | grep "smb_scheduler" | grep -v "grep" > /dev/null
then
    killall smb_scheduler && killall xchanged
fi
cp -r smb_scheduler /usr/local/
chmod -R 777 /usr/local/smb_scheduler
[ ! -L /var/www/smb_scheduler ] && ln -s /usr/local/smb_scheduler /var/www/smb_scheduler

[ -f "/etc/conf.d/local.start" ] && local="/etc/conf.d/local.start";
[ -f "/etc/rc.d/rc.local" ] && local="/etc/rc.d/rc.local"
[ -f "/etc/rc.local" ] && local="/etc/rc.local"


rclocaltmp=`mktemp /tmp/rclocal.XXXXXXXXXX`

if grep -q "smb_scheduler" $local
then
        sed /smb_scheduler/d $local > $rclocaltmp
        cat $rclocaltmp > $local
        rm -f $rclocaltmp
fi

if grep -q "^exit 0$" $local
then
    sed -i '/exit\ 0/i\/usr\/local\/smb_scheduler\/run_scheduler' /etc/rc.local
else
    echo "/usr/local/smb_scheduler/run_scheduler" >> $local
fi

/usr/local/smb_scheduler/run_scheduler

echo "Install finish."
echo "Please restart your httpd"
echo "Sim Bank Scheduler Server URL: http://your_ip/smb_scheduler"

