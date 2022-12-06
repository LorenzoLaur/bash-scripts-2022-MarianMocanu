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