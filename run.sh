#!/bin/bash
export DEBIAN_FRONTEND=noninteractive;
export HOME="/root";
export USER="root";
cd;
#设置supervisord守护
echo "[program: firefox]" >>/root/supervisord.conf;
echo "priority=10" >>/root/supervisord.conf;
echo "directory=/" >>/root/supervisord.conf;
echo "command=firefox-esr --display=localhost:1.0 --new-tab http://www.ebesucher.com/surfbar/kmm996 " >>/root/supervisord.conf;
echo "user=root" >>/root/supervisord.conf;
echo "autostart=true" >>/root/supervisord.conf;
echo "autorestart=true" >>/root/supervisord.conf;
echo "stopsignal=QUIT" >>/root/supervisord.conf;
echo "stdout_logfile=/var/log/ff.log" >>/root/supervisord.conf;
echo "stderr_logfile=/var/log/ff.err" >>/root/supervisord.conf;
echo "[supervisord]" >>/root/supervisord.conf;

apt-get update;
apt-get install -y xorg lxde-core tightvncserver firefox-esr supervisor cron expect wget;
apt-get install -y fonts-arphic-ukai fonts-arphic-uming fonts-arphic-gbsn00lp fonts-arphic-bkai00mp fonts-arphic-bsmi00lp;

#设置vnc密码
echo '#!/usr/bin/expect' >>/root/setpwd1.sh;
echo "spawn /usr/bin/tightvncserver :1" >>/root/setpwd1.sh;
echo 'expect "Password:"' >>/root/setpwd1.sh;
echo 'send "2342344\r"' >>/root/setpwd1.sh;
echo 'expect "Verify:"' >>/root/setpwd1.sh;
echo 'send "2342344\r"' >>/root/setpwd1.sh;
echo 'expect "Would you like to enter a view-only password (y/n)?"' >>/root/setpwd1.sh;
echo 'send "n\n"' >>/root/setpwd1.sh;
echo "expect off" >>/root/setpwd1.sh;
chmod 777 /root/setpwd1.sh;
/root/setpwd1.sh;
tightvncserver -kill :1;
echo "lxterminal &" >> /root/.vnc/xstartup;
echo '/usrecho "/bin/lxsession -s LXDE &"' >> /root/.vnc/xstartup;

#Flash,装了有几率卡死，不装也没关系
#mkdir -p /usr/lib/mozilla/plugins;
#cd /usr/lib/mozilla/plugins;
#wget ftp://192.99.11.204/ebesucher/flash_player_npapi_linux.x86_64.tar.gz |tar -zx libflashplayer.so;

#挂机插件，要登录vnc手动填用户名
mkdir -p '/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}' \
&& cd '/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}' \
&& wget https://www.ebesucher.com/data/firefoxaddon/latest.xpi -O 'jid1-GxlI1BHOBUCNhw@jetpack.xpi' \
&& chmod 0755 'jid1-GxlI1BHOBUCNhw@jetpack.xpi' ;

touch /var/log/ff.log;
touch /var/log/ff.err;

#启动
echo 'pkill vnc' >>/root/re.sh;
echo 'pkill supervisord' >>/root/re.sh;
echo 'vncserver' >>/root/re.sh;
echo "/usr/bin/supervisord -c /root/supervisord.conf" >>/root/re.sh;
chmod 777 /root/re.sh;

#防止vnc挂了
echo '#!/bin/bash' >>/root/run.sh;
echo 'while [ 1 ]' >>/root/run.sh;
echo 'do' >>/root/run.sh;
echo '  ps -fe|grep Xtightvnc |grep -v grep' >>/root/run.sh;
echo '  if [ $? -ne 0 ]' >>/root/run.sh;
echo '  then' >>/root/run.sh;
echo '  echo "start ..."' >>/root/run.sh;
echo '  /root/re.sh &> /dev/null &' >>/root/run.sh;
echo '  else' >>/root/run.sh;
echo '  echo "it is running"' >>/root/run.sh;
echo '  fi' >>/root/run.sh;
echo '  sleep 30' >>/root/run.sh;
echo 'done' >>/root/run.sh;
chmod 777 /root/run.sh;


nohup bash /root/run.sh &
#30分钟kill一次Firefox
#echo "0 * * * * root pkill firefox-esr" >>/etc/crontab;
echo "*/25 * * * * root pkill firefox-esr" >>/etc/crontab;
/etc/init.d/cron restart;
