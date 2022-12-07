# Marian Mocanu 1025277
# Declaring a function to check the system usage
function SystemUsage(){
    cpu=$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t", $(NF-2)}')
    ram=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }')
    disk=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')

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
if [ $1 = "system-update" ]; then
    echo -e "updating system"
    sudo apt-get update && sudo apt-get upgrade -y
    wait
    echo -e "system updated."
    exit 0
fi 

# Checking if something has been passed on, if "firewall" has been passed it will run the if statement
if [ $1 = "firewall" ]; then
    # Checking if 2nd var is passed to firewall, if not echo error
    if [ -z "$2" ]; then
        echo -e "You must include an add or remove"
        exit 1
    fi
    if [ -z "$3" ]; then
        echo -e "You must include an port"
        exit 1
    fi

    if [ $2 = "add" ]; then
        sudo ufw allow $3
        echo -e "Port $3 added to firewall"
        exit 0
    fi

    if [ $2 = "remove" ]; then
        sudo ufw delete allow $3
        echo -e "Port $3 removed from firewall"
        exit 0
    fi
fi

# Checking if something has been passed on, if "system-stats" has been passed it will run the if statement and call the function declared at the beggining
if [ $1 = "system-stats" ]; then
    SystemUsage
    wait 
    exit 0
fi
# Checking if something has been passed on, if "setup-wp" has been passed it will run the if statement
if [ $1 = "setup-nginx" ]; then
    # check if install-wp.sh is executable, if not make it executable
    if [ ! -x install-wp.sh ]; then
        echo -e "wordpress isnt an executable, lets make it one!"
        chmod +x install-wp.sh
        wait
    fi
    # run the install-wp.sh script
    ./install-wp.sh -x
    wait
    echo "All done!"
    exit 0
fi
# Checking if something has been passed on, if "create-user" has been passed it will run the if statement
if [ $1 = "create-user" ]; then
    echo -e "what do you want the user to be called?"
    read -p 'Username: ' username
    echo -e "What should the password for $username be?"
    read -sp 'Password: (this wont show anything but you are typing)' password

    # Creating a new user 
    sudo adduser -p password username

    echo -e "Please make sure to note these down!
    Username: $username
    Password $password
    "

    exit 0 
fi