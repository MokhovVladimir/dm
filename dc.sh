#!/bin/bash

nmcli connection modify eth0 ipv4.addresses 192.168.254.141/24 ipv4.gateway 192.168.254.1 ipv4.dns 192.168.254.141 ipv4.method manual ipv6.method disabled

nmcli connection down eth0
nmcli connection up eth0

bash -c 'cat > /etc/hosts <<EOF
127.0.0.1 localhost localhost.localdomain
192.168.254.136 second-srv.it-sirius.any second-srv
EOF'

bash -c 'cat > /etc/resolv.conf <<EOF
search localdomain it-sirius.any
nameserver 192.168.254.136
nameserver 77.88.8.8
nameserver 8.8.8.8
EOF'

astra-sambadc -d it-sirius.any -p SambaAdmin2025!