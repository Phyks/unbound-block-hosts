#/bin/sh
set -e

cd "$(dirname "$0")"

echo "Fetch Malware domains list and append to unbound"
./unbound-block-hosts --url="http://www.malwaredomainlist.com/hostslist/hosts.txt" --file=/etc/unbound/includes/malwaredomainlist-blocking.conf
echo "Fetch Yoyo ad servers list and append to unbound"
curl "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=unbound;showintro=0&mimetype=plaintext" > /etc/unbound/includes/yoyoadservers-blocking.conf

systemctl reload unbound
