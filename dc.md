## Установка пакетов
1) apt install dnsutils network-manager astra-sambadc

2) nano /etc/hosts



//
127.0.0.1 localhost localhost.localdomain
192.168.254.136 second-srv.it-sirius.any second-srv
//


3) nano  /etc/resolv.conf

//
search localdomain it-sirius.any
nameserver 192.168.254.136
nameserver 77.88.8.8
nameserver 8.8.8.8
//


Находим наше устройство связи

4) sudo nmcli connection modify enp1s0 ipv4.addresses 192.168.254.136/24 ipv4.gateway 192.168.254.1 ipv4.dns 192.168.254.136 ipv4.method manual ipv6.method disabled
Адреса свои
5) sudo nmcli connection down enp1s0
6) sudo nmcli connection up enp1s0


## Поднятие домена

7) astra-sambadc -d it-sirius.any -p SambaAdmin2025!