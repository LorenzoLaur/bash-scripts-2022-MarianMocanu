echo -e "whats your domain name? ('localhost' if you dont have one and want to run it on inside your network)"
    read -p "Domain (example.com): " domain
    wait
    # adding php repository
    sudo apt-add-repository ppa:ondrej/php -y
    wait
    # updating so apt-get can find php packages needed
    sudo apt update -y
    wait
    # Installing Nginx
    sudo apt-get install nginx -y
    wait
    # Installing MariaDB
    sudo apt-get install mariadb -y
    wait
    # Enablingh MaridDB
    systemctl enable mariadb.service -y
    wait
    # Installing PHP 
    sudo apt-get install php7.2 php7.2-cli php7.2-fpm php7.2-mysql php7.2-json php7.2-opcache php7.2-mbstring php7.2-xml php7.2-gd php7.2-curl -y
    waitON
    echo -e "** MAKE NOT OF YOUR ROOT PASSWORD  THIS NEXT PART! **"
    wait
    # Installing MySQL
    mysql_secure_installation
    wait
    # Logging in MySQL with the username "-u" and password "-p"
    mysql -u root -p
    wait
    # Creating a directory "-p"
    mkdir -p /var/www/html/wordpress/public_html
    wait
    # The path where to create the directory
    cd /var/www/html/wordpress/public_html
    wait
    # The path where the system will write in
    cd /etc/nginx/sites-available
    wait
    rm -R deafault
    wait
    # Telling the system to write the following in the file with the path above
    echo "server {
            listen 80 default_server;
            listen [::]:80 default_server;

            root /var/www/html;
            index index.php index.html index.htm index.nginx-debian.html;

            server_name $domain www.$domain;

            location / {
                try_files \$uri \$uri/ =404;
            }

            location = /robots.txt {
                    allow all;
                    log_not_found off;
                    access_log off;
            }

            location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.2-fpm.sock;
            }

            location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                    expires max;
                    log_not_found off;
            }

            location ~ /\.ht {
                deny all;
            }
        }" > /etc/nginx/sites-available/wordpress.conf
    wait
    # Checking that the file created is created correctly
    nginx -t
    wait
    # Path for the next step
    cd /etc/nginx/sites-enabled
    # Using the path above activating the server block
    wait
    ln -s ../sites-available/wordpress.conf
    wait 
    # Restarting Nginx
    systemctl reload nginx