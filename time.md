--- FIRST-RTR ---
/system ntp server set enabled=yes

/system ntp server
    set enabled=yes broadcast=yes multicast=yes
    set manycast=yes server-dns-names=pool.ntp.org

/system clock set time-zone-autodetect=no
/system clock set time-zone=+03:00

/ip firewall filter
add chain=input protocol=udp dst-port=123 action=accept comment="NTP Server"


--- SRV ---

sudo apt update && sudo apt install -y chrony

nano /etc/chrony/chrony.conf
----------------
server 192.168.254.1 iburst  
pool pool.ntp.org offline minpoll 8
makestep 1.0 3
-----------------

sudo systemctl restart chrony


--- Scond-RTR ---

/system ntp client
set enabled=yes
primary-ntp=192.168.254.1

/ip firewall filter
add chain=output protocol=udp dst-port=123 action=accept comment="NTP Client"

/system ntp client print
/system clock print