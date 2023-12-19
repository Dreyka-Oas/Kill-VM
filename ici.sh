if ! dpkg -l | grep -q "nmap"
then
    sudo apt update && sudo apt install nmap -y
fi
if ! dpkg -l | grep -q "sshpass"
then
    sudo apt update && sudo apt install sshpass -y
fi

nom_fichier="output.txt"
user="permabook"
password="permabook"


nmap -sn 192.168.103.0/24 | grep -B2 "Oracle VirtualBox virtual NIC" | grep -oP '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'  > $nom_fichier

accepter_cle_ssh() {
    ssh-keyscan -H "$1" >> ~/.ssh/known_hosts
}

if [ -e "$nom_fichier" ]; then
    while IFS= read -r ligne; do
        accepter_cle_ssh "$ligne"

        if sshpass -p "$password" ssh "$user@$ligne" 'sudo -S -i init 0' <<EOF
$password
EOF
        then
            # Afficher en vert si la VM est éteinte
            echo -e "\e[32mLa VM $ligne est éteinte\e[0m"
        else
            # Afficher en rouge si la VM n'est pas éteinte
            echo -e "\e[31mLa VM $ligne n'est pas éteinte\e[0m"
        fi
    done < "$nom_fichier"
fi

#
#
#