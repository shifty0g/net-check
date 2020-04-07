#!/bin/bash
VERSION="1.0"
DATE="07-04-2020"
# net-check - just checks network connectivity
# needs speedtest-cli to be install -- sudo apt-get install speedtest-cli

# maybe add nmap scan too 

if [[ $EUID -ne 0 ]]; then
	echo ""
	echo -e "\e[01;31m[!]\e[00m This must be run as root. Run again with 'sudo'"
	echo ""
	exit 0 2> /dev/null
fi

echo ""
echo "==============================[ Network Check ]=============================="

echo ""
echo -e "\e[96m[*] Ping Checks - Local Interface (127.0.0.1)"
echo ""
ping -c2 127.0.0.1 2>/dev/null | grep "bytes from" 

echo ""
echo -e "\e[95m[*] arp-scan - local"
echo ""
rm tempxxxx 2>/dev/null; arp-scan -l 2>/dev/null | awk '{print $1}'|tail -n +3|head -n -2 | strings | grep -v "WARNING"  | tee tempxxxx

echo ""
echo -e "\e[94m[*] Ping Checks - Default Gateway ("$GW")"
echo ""
ping -c2 $GW 2>/dev/null | grep "bytes from" 

#echo ""
#echo -e "\e[93m[*] Ping Checks - Random IP from ARP ("$randomip")"
#echo ""
#randomip=$(shuf -n 1 tempxxxx)
#ping -c2 $randomip 2>/dev/null | grep "bytes from" 

echo ""
DNS=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}' 2>/dev/null) 
dnsip1=$(echo $DNS | cut -d' ' -f1)
dnsip2=$(echo $DNS | cut -d' ' -f2)
echo -e "\e[92m[*] Ping Checks - DNS Servers"
echo ""
ping -c2 $dnsip1 2>/dev/null | grep "bytes from" 
ping -c2 $dnsip2 2>/dev/null | grep "bytes from" 

echo ""
echo -e "\e[91m[*] Ping Checks - External Out by IP (8.8.8.8) *"
echo ""
ping -c2 8.8.8.8 2>/dev/null | grep "bytes from"

echo ""
echo -e "\e[96m[*] Ping - External Out by DNS NAME (bbc.co.uk) *"
echo ""
ping -c2 bbc.co.uk 2>/dev/null | grep "bytes from"


echo ""
echo -e "\e[95m[*] Host - host lookup yahoo.com *"
echo ""
host -4 yahoo.com 2>/dev/null


echo ""
echo -e "\e[94m[*] nmap - nmap.org 8.8.8.8 *"
echo ""
nmap -T4 -PN -p53,80,443,22,3389 nmap.org 8.8.8.8 

echo ""
echo -e "\e[93m[*] Curl Checks - External Out by DNS NAME #2 (https://google.co.uk) *"
echo ""
echo -e "\e[93m $(curl -i -k https://google.co.uk  2>/dev/null)"

echo ""
echo -e "\e[92m[+] Speedtest-cli "
echo ""
# sudo apt-get install speedtest-cli
speedtest-cli

# cleanup
rm tempxxxx 2>/dev/null
echo -e "\e[49m\e[39m \n =============================[ COMPLETE ]=============================="

#end
