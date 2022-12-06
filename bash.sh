# Marian Mocanu 1025277
# Declaring a function to check the system usage
function SystemUsage(){
    cpu=$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t", $(NF-2)');
    ram=$(free -m | awk '{printf "%.2f%%\t\t", $3*100/$2}' );
    disk=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}');

     echo -e "VM Useage
    CPU: $cpu
    RAM: $ram
    DISK: $disk"
}
# Checking if something has been passed on, if it's not then it will run the if statement 
if [ $# -eq 0 ]; then
    echo "Usage: $0 [command]"
    echo "Commands:"
    echo "  help - print this help message"
    exit 0
fi

# Checking if something has been passed on, if "help" has been passed it will run the if statement 
if [ $1 = "help" ]; then
    echo -e "   add-user - create a user"
    echo -e "   firewall - add or remove a firewall port"
    echo -e "   update-system - update system"
    echo -e "   setup-wp - installs apts neeeded for wp"
    echo -e "   create-user - creates a user"
    exit 0
fi

# Checking if something has been passed on, if "system-update" has been passed it will run the if statement
if [ $1 = "system-update"]; then
    echo -e "updating system"
    sudo apt-get update && sudo-apt get upgrade -y
    wait
    echo -e "system updated."
    exit 0
fi

# Checking if something has been passed on, if "firewall" has been passed it will run the if statement
if [ $1 = "firewall" ]; then
    # Checking if 2nd var is passed to firewall, if not echo error
    if [ -z "$2" ]; then
        echo -e "Must specify if you want to [add] or [remove] a port"
        exit 0
    fi

    # Checking if 3rd var is passed to firewall, if not echo error
    if [ -z "$3" ]; then
        echo -e "Must include a port"
        exit 0
    fi

    if [ $2 = "add"]; then
        sudo ufw allow $3
        wait
        echo -e "Port $3 added to firewall"
        exit 0
    fi

    if [ $2 = "remove" ]; then
        sudo ufw delete allow $3
        wait
        echo -e "Port $3 removed from firwall"
        exit 0
    fi
fi
# Checking if something has been passed on, if "system-stats" has been passed it will run the if statement and call the function declared at the beggining
if [ $1 = "system-stats"]; then
    SystemUsage
    wait 
    exit 0
fi
# Checking if something has been passed on, if "setup-wp" has been passed it will run the if statement
if [ $1 = "setup-wp" ]; then
    # Installing Nginx
    sudo-apt install nginx -y
    wait
    # Installing MariaDB
    sudo-apt install mariadb -y
    wait
    # Enablingh MaridDB
    systemctl enable mariadb.service -y
    wait
    # Installing PHP 
    sudo-apt install php7 php7-cli php7-fpm php7-mysql php7-json php7-opcache php7-mbstring php7-xml php7-gd php7-curl -y
    wait
    echo -e "** MAKE NOT OF YOUR ROOT PASSWORD ON THIS NEXT PART! **"
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
    # Telling the system to write the following in the file with the path above
    cat wordpress.conf
    server {
                listen 80;
                root /var/www/html/wordpress/public_html;
                index index.php index.html;
                server_name SUBDOMAIN.DOMAIN.TLD;

	        access_log /var/log/nginx/SUBDOMAIN.access.log;
    	        error_log /var/log/nginx/SUBDOMAIN.error.log;

                location / {
                            try_files $uri $uri/ =404;
                }

                location ~ \.php$ {
                            include snippets/fastcgi-php.conf;
                            fastcgi_pass unix:/run/php/php7.2-fpm.sock;
                }
            
                location ~ /\.ht {
                            deny all;
                }

                location = /favicon.ico {
                            log_not_found off;
                            access_log off;
                }

                location = /robots.txt {
                            allow all;
                            log_not_found off;
                            access_log off;
                }
       
                location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                            expires max;
                            log_not_found off;
                }
    }
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
    systemctl reaload nginx
    wait
    echo "All done"
    exit 0
fi
# Checking if something has been passed on, if "create-user" has been passed it will run the if statement
if [ $1 = "create-user" ]; then
    echo -e "** MAKE SURE TO KEEP A RECORD OF THE USERS CREDENTIALS**"
    # Creating a new user 
    sudo adduser newuser

    exit 0 
fi