1) apt install dnsutils network-manager fly-admin-ad-client

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

4) fly-admin-ad-client