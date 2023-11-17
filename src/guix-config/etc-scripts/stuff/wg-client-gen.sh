#!/bin/bash

# =================Where the script was launched from.
script="${0}"

# =================Function to print help
printhelp () {
    echo "Usage: $script [OPTION...]"
    echo "  -q    generate qrcodes and put them in the current dir (REQUIRES QRENCODE)"
    echo "  -h    print help"
    exit 0
}

# =================Arguments to the script
args="${@:1}"

# check for the help argument and print help
case $args in
    *"-h"* )
	printhelp
	;;
esac

# don't return anything about the script running with arguments
# if there is no arguments passed to the script.
[ -z "$args" ] || echo "Running script with arguments: $args"

# First, remove previously generated config files created by this script.
generatedfiles=("./client.conf"
                "./wireguard-client-config.png")

for i in ${generatedfiles[@]}; do
    [ -f "$i" ] &&
        rm "./$i"
done

# =================Temporary files that will be created
#                  by this script.
files=("/tmp/pk"	# where the privatekey will be temporarily stored
       "/tmp/pbk"	# where the publickey will be temporarily stored
       "/tmp/psk")	# where the presharedkey will be temporarily stored

# ================Function to remove temporary files created by this script.
rtemp () {
    for i in ${files[@]}; do
        [ -f "$i" ] && shred -n 200 -u "$i"
    done
}

# ===============Set permissions for files that are to
#                be created by this script.
umask 077

# ===============Client config ([Interface] section in client config file)
read -p "Wireguard client IP (e.g 10.10.0.2/32): " address
privatekey=$(wg genkey > ${files[0]} && cat ${files[0]})
publickey=$(wg pubkey < ${files[0]} > ${files[1]} && cat ${files[1]})
read -p "DNS for client (DEFAULT 1.1.1.1): " dns

# determine if subnet mask was provided from user input
# and if not, use <ip_address>/32
[[ "$address" =~ /[0-9][0-9]$ ]] && address="$address" || address="$address/32" 

# if no DNS was supplied use 1.1.1.1 
[ -z "$dns" ] && dns="1.1.1.1"

# ===============Client config ([Peer] section in client config file for server)
read -p "Server public IP address and port (e.g 12.14.25.45:51820): " endpoint
allowedips="0.0.0.0/0"
presharedkey=$(wg genpsk > ${files[2]} && cat ${files[2]})
read -p "Are you behind NAT (e.g home connection) (y/n) (DEFAULT:y): " mtu
read -p "Public key of server: " srvpublickey

case $mtu in
    [yY]* )
        mtu="1380"
	keepalive="21"
	;;
    [nN]* )
	mtu="1500"
	keepalive="0"
	;;
    * )
	mtu="1380"
	keepalive="21"
	;;
esac

# if no port was specified for server address use default port 51820
[[ "$endpoint" =~ :[0-9]?*$ ]] && endpoint="$endpoint" || endpoint="$endpoint:51820"

# ===============Client config file "generation" using created variables
cat << __EOF >> client.conf
[Interface]
Address = $address
PrivateKey = $privatekey
MTU = $mtu
DNS = $dns

[Peer]
PublicKey = $srvpublickey
PresharedKey = $presharedkey
AllowedIPs = $allowedips
Endpoint = $endpoint
PersistentKeepAlive = $keepalive
__EOF


# ===============Function to copy generated keys to the current directory.
copy-keys-to-current-dir () {
    cp "${files[1]}" ./publickey
    cp "${files[2]}" ./presharedkey
}

# ===============Function to generate a qrcode from client config for use with
#                wireguard app on phones for example.
qrgen () {
    check=$(which qrencode 2>/dev/null)
    if [[ ${check} ]]; then
        qrencode -t png -o wireguard-client-config.png < client.conf
    else
        echo "qrencode is not installed, won't do anything."
    fi
}

# ===============Argument checking
[[ "$args" == *"q"* ]] && qrgen

# ===============Copy keys to current directory
copy-keys-to-current-dir

# ===============Finally, remove temporary files created by this script.
rtemp
