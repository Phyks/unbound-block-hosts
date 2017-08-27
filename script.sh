#/bin/sh
set -e

cd "$(dirname "$0")"
mkdir /tmp/dnsblock || true

echo "Fetch Malware domains list and append to unbound"
curl "http://www.malwaredomainlist.com/hostslist/hosts.txt" > /tmp/dnsblock/0.txt

echo "Fetch Yoyo ad servers list and append to unbound"
curl "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts;showintro=0&mimetype=plaintext" > /tmp/dnsblock/1.txt

echo "Fetch Adaway list and append to unbound"
curl "https://adaway.org/hosts.txt" > /tmp/dnsblock/2.txt

echo "Fetch Dan Pollock's list and append to unbound"
curl "http://someonewhocares.org/hosts/hosts" > /tmp/dnsblock/2.txt

echo "Fetch hpHosts’s Ad and tracking list and append to unbound"
curl "https://hosts-file.net/ad_servers.txt" > /tmp/dnsblock/3.txt

echo "Fetch MVPS list and append to unbound"
curl "http://winhelp2002.mvps.org/hosts.txt" > /tmp/dnsblock/6.txt

cat /tmp/dnsblock/*.txt | sed -e '/^[[:blank:]]*#/d;s/#.*//' | sed -e '/^\s*$/d' | grep -v localhost | grep -v broadcasthost | sort | uniq | sed -e 's/0\.0\.0\.0/127\.0\.0\.1/g' | sed -e 's/\t/  /g' > /tmp/dnsblock/dnsblock.txt

python -c "for line in open('/tmp/dnsblock/dnsblock.txt', 'r'): print('local-data: \"%s IN A %s\"' % tuple(reversed(line.split())))" > /etc/unbound/includes/dnsblock.conf

rm -rf /tmp/dnsblock

systemctl reload unbound
systemctl status unbound | grep "active (running)" > /dev/null
