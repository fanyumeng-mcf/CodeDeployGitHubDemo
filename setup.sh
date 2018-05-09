#!/bin/bash

#log in as root
#check internet 
dhclient
#update existing packages
sudo yum -y update
sudo yum -y install yum-utils  #supplement yum


#install wget, curl, and vim 
sudo yum -y install wget
sudo yum -y install curl 
sudo yum -y install vim


#install python3.6
sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm
sudo yum -y update #update yum after IUS repository install 

sudo yum -y install redhat-lsb-core net-tools epel-release kernal-header kernal-devel python36u python36u-libs python36u-devel python36u-pip
#pip3.6 is installed above.  

#checking pip3.6
pip3.6 -V

#Check if Python is install correctly
python3.6 -V

#install pip (alternative pip if python 3.4) 
sudo yum -y install python34-setuptools
sudo easy_install-3.4 pip

nmcli conn show
nmcli conn up enp0s3
sed -i s/ONBOOT=no/ONBOOT=yes/ /etc/sysconfig/network-scripts/ifcfg-enp0s3 

#setting up a HTTP server and web browser 
yum install -y httpd links w3m

systemctl start httpd.service 

#check if active
systemctl is-active httpd.service

#check syntax of server 
apachectl configtest 

#add contents to wepage
cd /var/www/html/
echo "<h1>This is a webpage.  Welcome. </h2>" > /var/www/html/index.html
 


#add http to firewall
firewall-cmd --permanent --add-service http

#check firewall configuration
firewall-cmd --list-all
#http should appear in services after addition of rule 

#install manual for Apache (install after server up). Restart of http without shutting off open ports 
yum install -y httpd-manual
apachectl graceful 

#set up virtual host 
cd /var/www/html/
mkdir alphasite.com
mkdir betasite.com
mv index.html ./alphasite.com
cp index.html ../betasite.com 
mv index.html ./betasite.com
chmod -R 755 /var/www/html/alphasite.com/index.html
chmod -R 755 /var/www/html/betasite.com/index.html 
vim /var/www/html/alphasite.com/index.html 
      # 



vim /var/www/html/alphasite.com/index.html 


cd /etc/httpd/conf/
#ensure last line is uncommented 

cd ..
cd ./conf.d 
vim domain.conf

#new httpd with below 
<VirtualHost *:80>
  ServerAdmin admin@alphasite.com
  DocumentRoot /var/www/html/alphasite.com/index.html
  ServerName www.alphasite.com
  ServerAlias www.alphasite.com alphasite.com 
  ErrorLog /var/www/html/alphasite.com/error.log
  LogFormat "%v %l %u %t \ "%r\" %>s %b" myvhost
  CustomLog /var/www/html/alphaiste.com/access.log   myvhost
</VirtualHost>
<VirtualHost *:80>
  ServerAdmin admin@betasite.com
  DocumentRoot /var/www/html/betasite.com/index.html
  ServerName www.betasite.com
  ServerAlias www.betasite.com betasite.com 
  ErrorLog /var/www/html/betasite.com/error.log
  LogFormat "%v %l %u %t \ "%r\" %>s %b" myvhost
  CustomLog /var/www/html/betaiste.com/access.log   myvhost
</VirtualHost>




#to view logs
cat /var/log/httpd/server1_access

#FTP SERVER 
sudo yum -y install vsftpd ftp 
sudo systemctl start vsftpd && systemctl enable vsftpd
sudo systemctl start ftp

#backup config files
cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orig

#anonymous_enable=YES
#no_anon_password=YES
#local_enable=NO
#write_enable=NO
#listen=YES
#ftpd_banner=Welcome to the FTP server!  
systemctl restart vsftpd
firewall-cmd --add-service=ftp --permanent

#allow FTP through iptables
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A IPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -p tcp --sport 20 -m state --state RELATED,ESTABLISHED -j ACCEPT
modprobe ip_conntrack_ftp
IP_MODULES="ip_conntrack_ftp" 

#to create a pdf
yum install -y ghostscript
man -t vsftpd.conf | ps2pdf /var/ftp/vstpd.conf.pdf
w3m ftp://192.168.61.124
#save to directory using arrow keys
#press 'q' to quit w3m 

#access the file
ftp localhost
#log in as anonymous 
get vsftpd.conf.pdf 

#install logwatch
sudo yum install -y logwatch
cp /usr/share/logwatch/default.conf/logwatch.conf /usr/share/logwatch/default.conf/logwatch.orig.conf
cd /usr/share/logwatch/default.conf/
vim logwatch.conf
        Details = Medium
        #Service= ALL
        #Service = "-zz-network"
        #Service = "-zz-sys"
        #Service = "-eximstats"
        Service = ftpd-messages
        Service = ftpd-xferlog
        Service = http

        #Esc :x

#to run a logwatch report at any time manually
logwatch --detail Medium --mailto fanyumeng.mcf@gmail.com --service ftpd-messages --range All

#install a GUI to make Linux more visually appealing 
yum groupinstall "GNOME Desktop" -y 
systemctl set-default graphical.target
systemctl isolate graphical.target 






