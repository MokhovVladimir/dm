1)sudo apt install rsyslog
2)sudo nano /etc/rsyslog.conf
И раскомментируй строки:

lua
Копировать код
module(load="imudp")
input(type="imudp" port="514")

module(load="imtcp")
input(type="imtcp" port="514")
3)sudo nano /etc/rsyslog.d/10-remote.conf
template(name="RemoteLogs" type="string" string="/opt/%HOSTNAME%/%PROGRAMNAME%.log")

if ($fromhost-ip != "127.0.0.1") and ($syslogseverity <= 4) then {
        action(type="omfile" dynaFile="RemoteLogs")
        stop
}
4)проверяем конфигу 
sudo rsyslogd -N1
5)sudo systemctl restart rsyslog.service

6)паралельно качаем рсилог на серевер 2 

и создаем хуету 2 
user777@second-srv:~$ sudo nano /etc/rsyslog.d/50-default.conf

и вставляем это туда 
*.* @192.168.подсеть ваша.X:514

sudo rsyslogd -N1
проверяем конфигу

неастройка клиента микрота 
/system logging action add name=remote target=remote remote=192.168.220.132 remote-port=514
/system logging add topics=info action=remote
/system logging add topics=warning action=remote
/system logging add topics=error action=remote

6)sudo nano /etc/logrotate.d/remote-logs
создаем еще хуету
и пишем туда 
/opt/*/*.log {
    rotate 4
    compress
    missingok
    notifempty
    size 10M
    create 640 root adm
    sharedscripts
    postrotate
        systemctl reload rsyslog > /dev/null
    endscript
}

7)sudo logrotate --debug /etc/logrotate.d/remote-logs
