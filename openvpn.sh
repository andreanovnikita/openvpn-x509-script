new_client () {
        {
        cat /путь/к/удостоверяющему/центру/client-common-server-int.txt
        echo "<ca>"
        cat /путь/к/удостоверяющему/центру/pki/ca.crt
        echo "</ca>"
        echo "<cert>"
        sed -ne '/BEGIN CERTIFICATE/,$ p' /путь/к/удостоверяющему/центру/pki/issued/"$client".crt
        echo "</cert>"
        echo "<key>"
        cat /путь/к/удостоверяющему/центру/pki/private/"$client".key
        echo "</key>"
        } > ~/"$client".ovpn
}


	clear
	echo
	echo "Выберите действие:"
	echo "   1) Создать CSR клиента"
	echo "   2) Отозвать клиента"
        echo "   3) Подписать CSR и выдать клиентский файл конфигурации на 1 день"
        echo "   4) Подписать CSR и выдать клиентский файл конфигурации на 5 дней"
        echo "   5) Подписать CSR и выдать клиентский файл конфигурации на 10 дней"
        echo "   6) Подписать CSR и выдать клиентский файл конфигурации на 30 дней"
        echo "   7) Подписать CSR и выдать клиентский файл конфигурации на 50 дней"
        echo "   8) Подписать CSR и выдать клиентский файл конфигурации на 60 дней"
	echo "   9) Подписать CSR и выдать клиентский файл конфигурации на 90 дней"
        echo "   10) Подписать CSR и выдать клиентский файл конфигурации на 180 дней"
        echo "   11) Подписать CSR и выдать клиентский файл конфигурации на 365 дней"
        echo "   12) Подписать CSR и выдать клиентский файл конфигурации на 3650 дней"
        echo "   13) Перегенерация crl.pem"
        echo "   14) Отправить конфигурацию на сервер"
        echo "   15) Информация о системе"
        echo "   16) Управление *имя вашего сервера*"
        echo "   17) Выход"

	read -p "Option: " option
	case "$option" in
		1)
                        clear
                        echo
                        echo "Введите имя клиента:"
                        read -p "Name: " unsanitized_client
                        client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        while [[ -z "$client" || -e /путь/к/удостоверяющему/центру/pki/issued/"$client".crt ]]; do
                                echo "$client: invalid name."
                                read -p "Name: " unsanitized_client
                                client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        done
                        if [ -e /путь/к/удостоверяющему/центру/pki/private/ca.key ]; then
                                cd /путь/к/удостоверяющему/центру/
                                ./easyrsa gen-req "$client" nopass
                                echo
                                echo "$client CSR создан."
                                exit
                        else
                                echo
                                echo "Не найден УЦ!"
                                fi

                ;;
		2)

                         clear
                        number_of_clients=$(tail -n +2 /путь/к/удостоверяющему/центру/pki/index.txt | grep -c "^V")
                        if [[ "$number_of_clients" = 0 ]]; then
                                echo "Не выдано."
                                exit
                        fi
                        echo
                         ls /путь/к/удостоверяющему/центру/pki/issued
                        read -p "Client: " client
                         if [ -e /путь/к/удостоверяющему/центру/pki/private/ca.key ]; then
                                cd /путь/к/удостоверяющему/центру/
                                ./easyrsa --batch revoke "$client"
                                EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
                                echo
                                echo "$client отозван. Отправьте crl.pem на сервера."
                        else
                                echo "Не найден УЦ!"
                        fi
                        exit
                ;;

                   
                3)
                        clear   
                        echo
                        echo "Введите имя клиента:"
                        read -p "Name: " unsanitized_client
                        client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        while [[ -z "$client" || -e /путь/к/удостоверяющему/центру/pki/issued/"$client".crt ]]; do
                                echo "$client: invalid name."
                                read -p "Name: " unsanitized_client
                                client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        done
                        if [ -e /путь/к/удостоверяющему/центру/pki/private/ca.key ]; then
                                echo "Сертификат будет выдан НА 90 ДНЕЙ! Введите пароль УЦ для подтверждения."
                                cd /путь/к/удостоверяющему/центру
                                EASYRSA_CERT_EXPIRE=1 ./easyrsa sign-req client "$client" 
                                new_client
                                echo
                                echo "$client сгенерирован."
                                exit
                        else
                                
                                echo "Не найден УЦ!"
                                fi
                ;; 
                4)
                        clear   
                        echo
                        echo "Введите имя клиента:"
                        read -p "Name: " unsanitized_client
                        client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        while [[ -z "$client" || -e /путь/к/удостоверяющему/центру/pki/issued/"$client".crt ]]; do
                                echo "$client: invalid name."
                                read -p "Name: " unsanitized_client
                                client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        done
                        if [ -e /путь/к/удостоверяющему/центру/pki/private/ca.key ]; then
                                echo "Сертификат будет выдан НА 90 ДНЕЙ! Введите пароль УЦ для подтверждения."
                                cd /путь/к/удостоверяющему/центру
                                EASYRSA_CERT_EXPIRE=5 ./easyrsa sign-req client "$client" 
                                new_client
                                echo
                                echo "$client сгенерирован."
                                exit
                        else
                                
                                echo "Не найден УЦ!"
                                fi
                ;; 
                5)
                        clear   
                        echo
                        echo "Введите имя клиента:"
                        read -p "Name: " unsanitized_client
                        client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        while [[ -z "$client" || -e /путь/к/удостоверяющему/центру/pki/issued/"$client".crt ]]; do
                                echo "$client: invalid name."
                                read -p "Name: " unsanitized_client
                                client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        done
                        if [ -e /путь/к/удостоверяющему/центру/pki/private/ca.key ]; then
                                echo "Сертификат будет выдан НА 90 ДНЕЙ! Введите пароль УЦ для подтверждения."
                                cd /путь/к/удостоверяющему/центру
                                EASYRSA_CERT_EXPIRE=10 ./easyrsa sign-req client "$client" 
                                new_client
                                echo
                                echo "$client сгенерирован."
                                exit
                        else
                                echo "Не найден УЦ!"
                                fi
                ;; 
                6)
                        clear   
                        echo
                        echo "Введите имя клиента:"
                        read -p "Name: " unsanitized_client
                        client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        while [[ -z "$client" || -e /путь/к/удостоверяющему/центру/pki/issued/"$client".crt ]]; do
                                echo "$client: invalid name."
                                read -p "Name: " unsanitized_client
                                client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        done
                        if [ -e /путь/к/удостоверяющему/центру/pki/private/ca.key ]; then
                                echo "Сертификат будет выдан НА 90 ДНЕЙ! Введите пароль УЦ для подтверждения."
                                cd /путь/к/удостоверяющему/центру
                                EASYRSA_CERT_EXPIRE=30 ./easyrsa sign-req client "$client" 
                                new_client
                                echo
                                echo "$client сгенерирован."

                                exit
                        else
                                echo
                                echo "Не найден УЦ!"
                                fi
                ;; 
                7)
                        clear   
                        echo
                        echo "Введите имя клиента:"
                        read -p "Name: " unsanitized_client
                        client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        while [[ -z "$client" || -e /путь/к/удостоверяющему/центру/pki/issued/"$client".crt ]]; do
                                echo "$client: invalid name."
                                read -p "Name: " unsanitized_client
                                client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        done
                        if [ -e /путь/к/удостоверяющему/центру/pki/private/ca.key ]; then
                                echo "Сертификат будет выдан НА 90 ДНЕЙ! Введите пароль УЦ для подтверждения."
                                cd /путь/к/удостоверяющему/центру
                                EASYRSA_CERT_EXPIRE=50 ./easyrsa sign-req client "$client" 
                                new_client
                                echo
                                echo "$client сгенерирован."

                                exit
                        else
                                echo
                                echo "Не найден УЦ!"
                                fi
                ;; 
 

	        8)
                        clear	
                        echo
                        echo "Введите имя клиента:"
                        read -p "Name: " unsanitized_client
                        client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        while [[ -z "$client" || -e /путь/к/удостоверяющему/центру/pki/issued/"$client".crt ]]; do
                                echo "$client: invalid name."
                                read -p "Name: " unsanitized_client
                                client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        done
                        if [ -e /путь/к/удостоверяющему/центру/pki/private/ca.key ]; then
                                echo "Сертификат будет выдан НА 90 ДНЕЙ! Введите пароль УЦ для подтверждения."
                                cd /путь/к/удостоверяющему/центру
                                EASYRSA_CERT_EXPIRE=60 ./easyrsa sign-req client "$client" 
                                new_client
                                echo
                                echo "$client сгенерирован."

                                exit
                        else
                                echo
                                echo "Не найден УЦ!"
                                fi
                ;;
                9)
                        clear   
                        echo
                        echo "Введите имя клиента:"
                        read -p "Name: " unsanitized_client
                        client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        while [[ -z "$client" || -e /путь/к/удостоверяющему/центру/pki/issued/"$client".crt ]]; do
                                echo "$client: invalid name."
                                read -p "Name: " unsanitized_client
                                client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        done
                        if [ -e /путь/к/удостоверяющему/центру/pki/private/ca.key ]; then
                                echo "Сертификат будет выдан НА 90 ДНЕЙ! Введите пароль УЦ для подтверждения."
                                cd /путь/к/удостоверяющему/центру
                                EASYRSA_CERT_EXPIRE=90 ./easyrsa sign-req client "$client" 
                                new_client
                                echo
                                echo "$client сгенерирован."

                                exit
                        else
                                echo
                                echo "Не найден УЦ!"
                                fi
                ;; 


                10)
                        clear   
                        echo
                        echo "Введите имя клиента:"
                        read -p "Name: " unsanitized_client
                        client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        while [[ -z "$client" || -e /путь/к/удостоверяющему/центру/pki/issued/"$client".crt ]]; do
                                echo "$client: invalid name."
                                read -p "Name: " unsanitized_client
                                client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        done
                        if [ -e /путь/к/удостоверяющему/центру/pki/private/ca.key ]; then
                                echo "Сертификат будет выдан НА 180 ДНЕЙ! Введите пароль УЦ для подтверждения."
                                cd /путь/к/удостоверяющему/центру
                                EASYRSA_CERT_EXPIRE=180 ./easyrsa sign-req client "$client" 
                                new_client
                                echo
                                echo "$client сгенерирован."

                                exit
                        else
                                echo
                                echo "Не найден УЦ!"
                                fi
                ;;

                11)
                        clear   
                        echo
                        echo "Введите имя клиента:"
                        read -p "Name: " unsanitized_client
                        client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        while [[ -z "$client" || -e /путь/к/удостоверяющему/центру/pki/issued/"$client".crt ]]; do
                                echo "$client: invalid name."
                                read -p "Name: " unsanitized_client
                                client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        done
                        if [ -e /путь/к/удостоверяющему/центру/pki/private/ca.key ]; then
                                echo "Сертификат будет выдан НА 365 ДНЕЙ! Введите пароль УЦ для подтверждения."
                                cd /путь/к/удостоверяющему/центру
                                EASYRSA_CERT_EXPIRE=365 ./easyrsa sign-req client "$client" 
                                new_client
                                echo
                                echo "$client сгенерирован."

                                exit
                        else
                                echo
                                echo "Не найден УЦ!"
                                fi
                ;;

                12)
                        clear   
                        echo
                        echo "Введите имя клиента:"
                        read -p "Name: " unsanitized_client
                        client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        while [[ -z "$client" || -e /путь/к/удостоверяющему/центру/pki/issued/"$client".crt ]]; do
                                echo "$client: invalid name."
                                read -p "Name: " unsanitized_client
                                client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
                        done
                        if [ -e /путь/к/удостоверяющему/центру/pki/private/ca.key ]; then
                                echo "Сертификат будет выдан НА 3650 ДНЕЙ! Введите пароль УЦ для подтверждения."
                                cd /путь/к/удостоверяющему/центру
                                EASYRSA_CERT_EXPIRE=3650 ./easyrsa sign-req client "$client" 
                                new_client
                                echo
                                echo "$client сгенерирован."

                                exit
                        else
                                echo
                                echo "Не найден УЦ!"
                                fi
                ;;


                13)
	              clear
                                if [ -e /путь/к/удостоверяющему/центру/pki/private/ca.key ]; then
                                cd /путь/к/удостоверяющему/центру/
                                 echo "Для выполнения операции, введите пароль УЦ." 
                                EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
                                echo
                                echo "Успешно"
                                exit
                        else
                                echo
                                echo "Не найден УЦ!"

                        fi
                        exit

               ;;

               14)      
                       clear
                       echo "Установка соединения с *имя вашего сервера*"
                       echo "Загрузка файла на сервер"
                       scp -P 22 /путь/к/удостоверяющему/центру/pki/crl.pem имя_пользователя@*имя вашего сервера*:crl-server-int.pem
                       echo "Добавление файла в систему"
                       ssh имя_пользователя@*имя вашего сервера* -p22 cp crl-server-int.pem /etc/openvpn/server-mikrotik/crl.pem
                       echo "Т.к. обходить sudo запрещено - перезапустите openvpn@server вручную."
                       ssh имя_пользователя@*имя вашего сервера* -p22 
                       echo "Успешно"
                       exit






              ;;
 
              15)      clear
                
                       echo "Любая информация указанная Вами."
                      exit
              ;;



              16)         clear
                         echo "Установка соединения с *имя вашего сервера*..."
                         ssh имя_пользователя@*имя вашего сервера* -p22
                         echo "Успешно"
                         exit
              ;;


              17)         clear
                         echo "Выход"

     esac
