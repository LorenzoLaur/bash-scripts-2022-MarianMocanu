if [ $# -eq 0  ]; then
    echo -e "Usage $0 [command]";
    echo -e "Commands:";
    echo -e "  help - gives list of commands you can run";
fi

if [ $1 = "help" ]; then
    echo -e "  add-user - create a user";
    echo -e "  firewall - add or remove a firewall port"; 
    echo -e "  update-system - update system";
    echo -e "   setup-wp - installs apts neeeded for wp";
fi


if [ $1 = "system-update"]; then
    echo -e "updating system";
    sudo apt-get update && sudo-apt get upgrade -y
    wait
    echo -e "system updated.";
fi

if [ $1 = "firewall" ]; then
    # checking if 2nd var is passed to firewall, if not echo error
    if [ -z "$2" ]; then
        echo -e "Must specify if you want to [add] or [remove] a port";
    fi

    # checking if 3rd var is passed to firewall, if not echo error
    if [ -z "$3" ]; then
        echo -e "Must include a port";
    fi

    if [ $2 = "add"]; then
        sudo ufw allow $3
        wait
        echo -e "Port $3 added to firewall";
    fi

    if [ $2 = "remove" ]; then
        sudo ufw delete allow $3
        wait
        echo -e "Port $3 removed from firwall";
    fi
fi

if [ $1 = "system-stats"]; then
    cpu=$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t", $(NF-2)');
    ram=$(free -m | awk '{printf "%.2f%%\t\t", $3*100/$2}' );
    disk=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}');

    echo -e "VM Useage
    CPU: $cpu
    RAM: $ram
    DISK: $disk";
fi

if [ $1 = "setup-wp" ]; then
    # add the sudo-get get's for needed apps for wp
    sudo-apt install nginx -y
    wait
    sudo-apt install mariadb -y
    wait
    systemctl enable mariadb.service -y
    wait
    echo -e "** MAKE NOT OF YOUR ROOT PASSWORD ON THIS NEXT PART! **"
    mysql_secure_installation
    wait
    mysql -u root -p

    # finish this off for installing wp and setup
fi