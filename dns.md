 №№ First-srv №№ 

3)nano /etc/apt/sources.list
## 
#deb cdrom:[OS Astra Linux 1.8.1.6 1.8_x86-64 DVD ]/ 1.8_x86-64 contrib main non-free non-free-firmware
deb https://download.astralinux.ru/astra/stable/1.8_x86-64/repository-main/ 1.8_x86-64 main contrib non-free non-free-firmware
#deb https://download.astralinux.ru/astra/stable/1.8_x86-64/repository-devel/ 1.8_x86-64 main contrib non-free non-free-firmware
deb https://download.astralinux.ru/astra/stable/1.8_x86-64/repository-extended/ 1.8_x86-64 main contrib non-free non-free-firmware
##
5)nano /etc/bind/named.conf.options ( Задаём пересылку на публичный DNS )
##############################
options {
    directory "/var/cache/bind";

    // пересылка всех незнакомых запросов
    forwarders {
        8.8.8.8;
        1.1.1.1;
    };

    // разрешаем запросы из наших сетей
    allow-query { any; };
    recursion yes;

    dnssec-validation no;
    auth-nxdomain no;    # conform to RFC1035
};
##№№№№№№№№№№№№№№№№№
6)nano /etc/bind/named.conf.local ( Описываем зоны) 
##№№№№№№№№№№№№№№№№№
zone "it-sirius.any" {
    type master;
    file "/etc/bind/zones/db.it-sirius.any";
    allow-update { none; };
};

zone "254.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.192.168.220";
    allow-update { none; };
};
#######################
7)cat /etc/bind/zones/db.it-sirius.any ( настраиваем прямую зону )
####################
root@first-srv:/home/user# cat /etc/bind/zones/db.it-sirius.any
$TTL 86400
@   IN  SOA ns1.it-sirius.any. admin.it-sirius.any. (
        2025050502 ; serial
        3600       ; refresh
        1800       ; retry
        604800     ; expire
        86400 )    ; minimum

    IN  NS  ns1.it-sirius.any.

; NS-сервер
ns1         IN  A   192.168.254.137

; Реальные устройства
first-srv   IN  A   192.168.254.137
second-srv  IN  A   192.168.254.136
first-cli   IN  A   192.168.254.138

; Условные
first-rtr   IN  A   192.168.254.1
second-rtr  IN  A   192.168.254.2


; CNAME
moodle      IN  CNAME   first-rtr.it-sirius.any.
wiki        IN  CNAME   first-rtr.it-sirius.any.

; ==== SRV для Samba AD DC на second-srv ====
_ldap._tcp.it-sirius.any.    3600 IN SRV 0 100 389   second-srv.it-sirius.any.
_kerberos._udp.it-sirius.any.3600 IN SRV 0 100 88    second-srv.it-sirius.any.
_gc._tcp.it-sirius.any.      3600 IN SRV 0 100 3268  second-srv.it-sirius.any.
#################
8)cat /etc/bind/zones/db.192.168.200 ( настраиваем обратную зону )
#################
$TTL 86400
@   IN  SOA ns1.it-sirius.any. admin.it-sirius.any. (
        2025050501
        3600
        1800
        604800
        86400 )

    IN  NS  ns1.it-sirius.any.

; PTR-записи
1     IN PTR  first-rtr.it-sirius.any.
2     IN PTR  second-rtr.it-sirius.any.
10    IN PTR  first-cli.it-sirius.any.
132   IN PTR  first-srv.it-sirius.any.
133   IN PTR  second-srv.it-sirius.any.
#################
9)sudo named-checkconf (проверка и перезапуск)
10)sudo named-checkzone it-sirius.any    /etc/bind/zones/db.it-sirius.any
11)sudo named-checkzone 254.168.192.in-addr.arpa /etc/bind/zones/db.192.168.254
12)sudo systemctl restart bind9
 №№ SECOND-SRV/Client №№
13) nano /etc/resolv.conf (настраиваем адрес ДНС)
################
search it-sirius.any
nameserver 192.168.220.132 
################
13)dig @192.168.254.137 first-rtr.it-sirius.any +short 
