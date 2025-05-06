)apt install docker docker-compose -y

)docker compose -f wiki.yml up -d

)docker ps 

)http://<ip>:8080

)настройка пользователя по заданию ( в конце  Загрузить  ""LocalSettings.php "")

)cp /home/sirius/Загрузки/LocalSettings.php . ( добавить пхп которое скачали)

) cat LocalSettings.php | grep -i wgUpgradeKey

)docker-compose -f wiki.yml down

)nano wiki.yml ( добавить пхп в качестве волюма) 

)docker-compose -f wiki.yml up -d --build

)http://<ip>:8080 (Заглавная страница нашей вики) 

history -c
rm ~/.bash_history