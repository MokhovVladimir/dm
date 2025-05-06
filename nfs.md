------ Файловое Хранилище-----------
----NFS-Server-------
0)apt install nfs-kernel-server
1)fallocate -l 1G /srv/nfs.img
2)sudo losetup --find --show /srv/nfs.img
##
/dev/loop0
##
3)sudo mkfs.ext4 /dev/loop0
#######
mke2fs 1.47.0 (5-Feb-2023)
Discarding device blocks: done                            
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: c75f5902-97ff-48e7-befb-c365e1c5e15e
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done
######
4)sudo mkdir -p /srv/nfs
5)echo "/srv/nfs.img /srv/nfs ext4 loop,nofail,defaults 0 0" | sudo tee -a /etc/fstab
6)systemctl daemon-reload
7)sudo mount -a
/dev/loop0 /srv/nfs ext4 defaults,loop 0 2
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
9)mount | grep /srv/nfs
10)chown nobody:nogroup /srv/nfs
11)chmod 777 /srv/nfs
12)echo "/srv/nfs *(rw,sync,no_subtree_check,no_root_squash)" | sudo tee /etc/exports
13)sudo exportfs -ra
14)sudo systemctl enable --now nfs-kernel-server
Synchronizing state of nfs-kernel-server.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable nfs-kernel-server
14)systemctl status nfs-kernel-server 
15)cat /etc/exports
/srv/nfs *(rw,sync,no_subtree_check,no_root_squash)

----NFS-Client-----------

1)apt install nfs-common -y
2)sudo mkdir -p /mnt/nfs
3) echo "192.168.220.133:/srv/nfs /mnt/nfs nfs defaults,nofail,_netdev,x-systemd.device-timeout=10 0 0"  | sudo tee -a /etc/fstab
####
192.168.220.133:/srv/nfs /mnt/nfs nfs defaults 0 0
####
4)systemctl daemon-reload
5)mount -a
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
6) mount | grep /mnt/nfs
###
192.168.220.133:/srv/nfs on /mnt/nfs type nfs4 (rw,relatime,vers=4.2,rsize=524288,wsize=524288,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=192.168.220.132,local_lock=none,addr=192.168.220.133)
####
7) touch /mnt/nfs/testfile
8) ls -l /mnt/nfs
итого 16
drwx------ 2 root root 16384 мая  5 16:58 lost+found
-rw-r--r-- 1 root root     0 мая  5 17:10 testfile

!!!! проверить в /etc/fstab наличие у /dev/loop0 на клиенте и сервере наличие опции nofail 