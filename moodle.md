------first-srv-------
----moodle----
1)apt install apache2 php libapache2-mod-php   php-mysql php-xml  php-curl php-zip php-gd   php-intl php-mbstring php-pspell php-soap -y
2)systemctl enable --now apache2
3)systemctl status apache2
4)apt install mariadb-server mariadb-client -y
5)systemctl enable --now mariadb
6)systemctl status mariadb
7)mysql -u root
#############
CREATE DATABASE moodledb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'moodle'@'localhost' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL PRIVILEGES ON moodledb.* TO 'moodle'@'localhost';
FLUSH PRIVILEGES;
EXIT;
##############
8)wget https://download.moodle.org/download.php/direct/stable500/moodle-latest-500.tgz
9)tar xzf moodle-latest-500.tgz
10)mv moodle /var/www/html/moodle
10)mkdir /var/moodledata
11)chown -R www-data:www-data /var/www/html/moodle /var/moodledata
12)chmod -R 755 /var/www/html/moodle

15)a2ensite moodle.conf
16)a2enmod rewrite
17)systemctl reload apache2
18)nano /etc/apache2/apache2.conf
##############

#AstraMode=on -> AstraMode off

#############
19)sudo systemctl reload apache2
22)nano /etc/php/8.2/apache2/php.ini ( ctrl + w  для поиска )
#############

;max_input_vars = 1000 -> max_input_vars = 5000

##############
23)systemctl restart apache2
24)заполняем сайт по заданию
Поле	Значение	Пояснение
Database host	localhost	
Database name	moodledb	
Database user	moodle
Database password	P@ssw0rd

25) 
Username: admin

New password: P@ssw0rd

Confirm password: P@ssw0rd