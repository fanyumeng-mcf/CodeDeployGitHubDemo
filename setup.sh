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

      # 



vim /var/www/html/alphasite.com/index.html 


cd /etc/httpd/conf/
#ensure last line is uncommented 
#uncomment      IncludeOptional conf.d/* .conf
     #save and exit
     
     

cd ..
cd ./conf.d 
vim domain.conf

#new httpd with below 
vim /etc/httpd/conf.d/vhost.com
#
NameVirtualHost *:80

<VirtualHost *:80>
    ServerAdmin webmaster@example.com
    ServerName example.com
    ServerAlias www.example.com
    DocumentRoot /var/www/html/example.com/public_html/
    ErrorLog /var/www/html/example.com/logs/error.log
    CustomLog /var/www/html/example.com/logs/access.log combined
</VirtualHost>

#

mkdir -p /var/www/html/example.com/{public_html,logs}
vim /var/www/html/example.com/public_html/index.html 

# insert html content here
# <h1>This is an example page Server 1 </h1>

# 

mkdir /var/www/html/example2.com
cd /var/www/html/example2.com
mkdir ./public_html
vim ./public_html/index.html 

#server2 goes here 
<h1> This is server 2 </h1> 
#

gedit /etc/hosts
#add 127.0.0.1 example.com
#add 127.0.0.1 example2.com 
# 







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






