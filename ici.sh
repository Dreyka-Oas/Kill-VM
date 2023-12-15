if ! dpkg -l | grep -q "nmap"
then
    sudo apt update && sudo apt install nmap -y
fi
if ! dpkg -l | grep -q "sshpass"
then
    sudo apt update && sudo apt install sshpass -y
fi
nom_fichier="output.txt"
nmap -sn 192.168.103.0/24 | grep -B2 "Oracle VirtualBox virtual NIC" | grep -oP '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'  > $nom_fichier


user="permabook"
password="permabook"


accepter_cle_ssh() {
    ssh-keyscan -H "$1" >> ~/.ssh/known_hosts
}

if [ -e "$nom_fichier" ]; then
    while IFS= read -r ligne; do
        accepter_cle_ssh "$ligne"
        
        sshpass -p "$password" ssh "$user@$ligne" 'sudo -S -i init 0' << EOF
$password
EOF
    done < "$nom_fichier"
fi
