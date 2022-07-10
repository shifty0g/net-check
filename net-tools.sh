#!/bin/bash
LAST_UPDATED="15/02/2022"
VERSION="1.1"
: '
 all network realted functions i make live in here 

 Version Updates
=================
 1.1
	added better hosts-add function and a few other little bits



 TO DO
==============
add more eth functions 
fix speedtest module or find an alternative
add in ipcalc
list all interfaces 
check DNS. resolve local and outside
im prove - check if file - maybe use checkinput?
add a heads up prints out everything nicely - int, route, gw est
gateway show - have variables for collecting route nameserver gw  puclic private .. est  so they can be used as vaiables
variable for each int NWINTERFACE NWINTERFACE2 ... GW ROUTE. LOCALIP. PUBLICIP
net-info . shows a little dashboard heads up of nw info
get a list of interfaces 
reset dns 
reset resolv file 

'

# change this to your correct interface 
export NWINTERFACE="eth0"

export LOCALIP=$(ip addr show $NWINTERFACE | grep 'inet' | cut -d: -f2 | awk '{ print $2}' |grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
export LOCALNW=$(ip addr show $NWINTERFACE | grep 'inet' | cut -d: -f2 | awk '{ print $2}' 2>/dev/null | head -1)
export DNS=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}' | tr "\n " " " 2>/dev/null)
export GW=$(ip route | awk '/default/ { print $3 }' 2>/dev/null | head -1)
export EXT_IP=$(wget http://ipinfo.io/ip -qO - | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")

export EDITOR="subl" # sublime text 

alias hosts='sudo $EDITOR /etc/hosts'
alias resolv='sudo $EDITOR /etc/resolv.conf'
alias i='ifconfig -a'
alias nameserver-list="cat /etc/resolv.conf | grep nameserver"
alias dns-set="$EDITOR /etc/resolv.conf"

# lazy / quick access 
alias helpnet="net-help"
alias nethelp="net-help"
alias help-net="net-hel"
alias ns="netstat -antp"
alias i='ip a'
alias ipu="ifu"
alias ipd="ifd" 


function ipp {
echo $LOACALIP
ip add show $NWINTERFACE | grep -v inet6 | grep inet | cut -c 1-28 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
}
alias ipa=ipp

function flushall {
for line in $(ifconfig | grep eth\[0-9\] | cut -d: -f1); do
	ifconfig $line down 
	sleep 0.5
	ip a flush $line 2> /dev/null;
	sleep 0.5
	ifconfig $line up 
done
}
function static {
ip a flush $NWINTERFACE  
sleep 0.5
ifconfig $NWINTERFACE $1
sleep 0.5
ifconfig $NWINTERFACE up
ifconfig $NWINTERFACE 
echo "" 
cat /etc/resolv.conf 
echo "" 
ip route
}
function dhcp {
# $1  - eth1.. so dhcp eth1
if [ -z "$1" ]; then
	ip a flush $NWINTERFACE  
	ifconfig $NWINTERFACE  down 
	ifconfig $NWINTERFACE  up 
	dhclient -v $NWINTERFACE  
	ifconfig $NWINTERFACE  
	echo "" 
	cat /etc/resolv.conf 
	echo "" 
	ip route
else
	#else run on range given
	ip a flush $1
	ifconfig $1 down 
	ifconfig $1 up 
	dhclient -v $1
	ifconfig $1 
	echo "" 
	cat /etc/resolv.conf 
	echo "" 
	ip route
fi
}
function nameserver-add {
echo "nameserver" $1 >> /etc/resolv.conf
if [ -n "$2" ]; then
    echo "nameserver" $1 >> /etc/resolv.conf
fi
cat /etc/resolv.conf
}
function nameserver-edit {
$EDITOR /etc/resolv.conf
}
alias dns-edit=nameserver-edit

function gateway { 
route add default gw $1
sleep 0.2 
ip route 
export GW=$1
echo "" 
ip route; }
function speedtest {
echo ""
echo -e "\e[92m[*] Speedtest-cli "
echo ""
# sudo apt-get install speedtest-cli
speedtest-cli
}
function net-check {
echo ""
echo "==============================[ Network Check ]=============================="


echo ""
echo -e "\e[96m[+] Ping Checks - Local Interface (127.0.0.1)"
echo "-------------------------------------------"
ping -c2 127.0.0.1 2>/dev/null | grep "bytes from"
echo "-------------------------------------------"

echo ""
echo -e "\e[96m[+] Ping Checks - $INT ($(ifconfig $INT | grep inet | head -1 | grep-ip | head -1))"
echo "-------------------------------------------"
ping -c2 $(ifconfig $NWINTERFACE | grep inet | head -1 | grep-ip | head -1) 2>/dev/null
echo "-------------------------------------------"

echo ""
echo -e "\e[95m[+] arp-scan - local"
echo "-------------------------------------------"
arp-scan -l 2>/dev/null | awk '{print $1}'|tail -n +3|head -n -2 | strings | grep -v "WARNING"  
echo "-------------------------------------------"


echo ""
echo -e "\e[94m[+] Ping Checks - Default Gateway ("$GW")"
echo "-------------------------------------------"
ping -c2 $(ip route | grep $NWINTERFACE | awk '/default/ { print $3 }') 2>/dev/null | grep "bytes from"  
echo "-------------------------------------------"


#echo ""
#echo -e "\e[93m[+] Ping Checks - Random IP from ARP ("$randomip")"
#echo ""
#randomip=$(shuf -n 1 tempxxxx)
#ping -c2 $randomip 2>/dev/null | grep "bytes from" 

echo ""
echo -e "\e[92m[+] Ping Checks - DNS Servers"
echo "-------------------------------------------"
ping -c2 $(cat /etc/resolv.conf | grep nameserver | awk '{print $2}' | cut -d' ' -f1)  2>/dev/null 
echo "-------------------------------------------"


echo ""
echo -e "\e[91m[+] Ping Checks - External Out by IP (8.8.8.8) *"
echo "-------------------------------------------"
ping -c2 8.8.8.8 2>/dev/null | grep "bytes from" 
echo "-------------------------------------------"


echo ""
echo -e "\e[96m[+] Ping (nmap) - External Out by DNS NAME (bbc.co.uk) *"
echo "-------------------------------------------"
nmap -sP bbc.co.uk 2>/dev/null
echo "-------------------------------------------"


echo ""
echo -e "\e[95m[+] Host - host lookup microsoft.com *"
echo "-------------------------------------------"
host -4 microsoft.com 2>/dev/null
echo "-------------------------------------------"


echo ""
echo -e "\e[94m[+] nmap - nmap.org *"
echo "-------------------------------------------"
nmap -T4 -PN -p53,80,443,22,3389 scanme.nmap.org
echo "-------------------------------------------"


echo ""
echo -e "\e[93m[+] Curl Checks - (https://google.co.uk) *"
echo "-------------------------------------------"
echo -e "\e[93m $(curl -i -k https://google.co.uk  2>/dev/null)"
echo "-------------------------------------------"


echo ""
echo -e "\e[92m[+] Speedtest-cli "
echo "-------------------------------------------"
# sudo apt-get install speedtest-cli
speedtest-cli
echo "-------------------------------------------"


# cleanup
rm tempxxxx 2>/dev/null
echo -e "\e[49m\e[39m \n =============================[ COMPLETE ]=============================="

#end

}
function tables-flush {
sudo iptables -Z && sudo iptables -F
echo "[+] iptables - flushed"
sudo arptables -Z && sudo arptables -F
echo "[+] arptables - flushed"
sudo ip6tables -Z && sudo ip6tables -F 
echo "[+] ip6tables - flushed"
tables-show
}
function block-ip {
if [ -z "$1" ]; then
	echo "[*] Usage: $0 <IPv4 ADDRESS - ie 10.2.202.124/30 or FILE - ie excludes.txt>"
	return
elif [ "$1" ]; then
	if [ -f "$1" ]; then 
		for line in $(cat $1); do
			#block an ipv4 address
			# arptables (apt-get install arptables) - https://linoxide.com/security/use-arptables-linux/
			sudo arptables -A INPUT -s $line -j DROP
			sudo arptables -A OUTPUT -s $line -j DROP
			sudo arptables -A INPUT -d $line -j DROP
			sudo arptables -A OUTPUT -d $line -j DROP
			#iptables
			sudo iptables -A INPUT -s $line -j DROP
			sudo iptables -A OUTPUT -s $line -j DROP
			sudo iptables -A INPUT -d $line -j DROP
			sudo iptables -A OUTPUT -d $line -j DROP
		done
	else
	#block an ipv4 address
	# arptables (apt-get install arptables) - https://linoxide.com/security/use-arptables-linux/
	sudo arptables -A INPUT -s $1 -j DROP
	sudo arptables -A OUTPUT -s $1 -j DROP
	sudo arptables -A INPUT -d $1 -j DROP
	sudo arptables -A OUTPUT -d $1 -j DROP
	#iptables
	sudo iptables -A INPUT -s $1 -j DROP
	sudo iptables -A OUTPUT -s $1 -j DROP
	sudo iptables -A INPUT -d $1 -j DROP
	sudo iptables -A OUTPUT -d $1 -j DROP
	fi
	tables-show
fi
}
function tables-show {
echo "[+] IPv4"
echo -e "\e[95m- iptables:"
echo -e "----------------------------------------------------------------------"
sudo iptables -L
echo -e "----------------------------------------------------------------------"
echo ""
echo "- arptables:"
echo "----------------------------------------------------------------------"
sudo arptables -L
echo -e "----------------------------------------------------------------------\e[96m "
echo "[+] IPv6"
echo ""
echo "- ip6tables:"
echo "----------------------------------------------------------------------"
sudo ip6tables -L
echo -e "----------------------------------------------------------------------\e[0m"
}
function hosts-add {
if [ -z "$1" ]||[ -z "$2" ]; then
	echo "[*] Usage: $0 <IP> <NAME>"
	return
fi
case `grep -i "$1 $2" "/etc/hosts" >/dev/null; echo $?` in
  0)
    # code if found
    echo "[*] $1 $2 is already in /etc/hosts"
    ;;
  1)
    # code if not found
    echo "$1 $2" >> /etc/hosts
    ;;
  *)
    # code if an error occurred
    echo "[!] ERROR"
    ;;
esac
}
function block-ip6 {
if [ -z "$1" ]; then
	echo "[*] Usage: $0 <IPv6 ADDRESS>"
	return
elif [ "$1" ]; then
	#block an ipv6 address
	#ip6tables
	ip6tables -A INPUT -s $ip -j DROP
	ip6tables -A OUTPUT -s $ip -j DROP
	ip6tables -A INPUT -d $ip -j DROP
	ip6tables -A OUTPUT -d $ip -j DROP
	tables-show
fi
}		
function tables-show {
echo "[+] IPv4"
echo -e "\e[95m- iptables:"
echo -e "----------------------------------------------------------------------"
sudo iptables -L
echo -e "----------------------------------------------------------------------"
echo ""
echo "- arptables:"
echo "----------------------------------------------------------------------"
sudo arptables -L
echo -e "----------------------------------------------------------------------\e[96m "
echo "[+] IPv6"
echo ""
echo "- ip6tables:"
echo "----------------------------------------------------------------------"
sudo ip6tables -L
echo -e "----------------------------------------------------------------------\e[0m"
}
function hosts-add {
if [ -z "$1" ]||[ -z "$2" ]; then
	echo "[*] Usage: $0 <IP> <NAME>"
	return
fi
echo "$1 $2" >> /etc/hosts
}
function publicip {
echo "Public IP: $(wget http://ipinfo.io/ip -qO - | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")"
}
function proxy-off(){
   variables=( \
      "HTTP_PROXY" "HTTPS_PROXY" "FTP_PROXY" "SOCKS_PROXY" \
      "NO_PROXY" "GIT_CURL_VERBOSE" "GIT_SSL_NO_VERIFY" \
   )
   for i in "${variables[@]}"
   do
      unset $i
   done

   env | grep -e _PROXY -e GIT_ | sort
   echo -e "Proxy Settings Cleared"
}
function proxy-on() {
if [ -z "$PROXYADDRESS" ]
then
	PROXYADDRESS="127.0.0.1:8080"
fi
export HTTP_PROXY=$PROXYADDRESS
export HTTPS_PROXY=$PROXYADDRESS
export NO_PROXY=localhost,127.0.0.1
}
function ifu() {
if [ -z "$1" ]
then
	ifconfig $NWINTERFACE up
else
	ifconfig $1 up
fi
}
function ifd() {
if [ -z "$1" ]
then
	ifconfig $NWINTERFACE down
else
	ifconfig $1 down
fi
}
function flush() {
if [ -z "$1" ]
then
	ifconfig flush $NWINTERFACE
else
	ifconfig flush $1 
fi
}
function td {
#if nothing given then run default on $NWINTERFACE
if [ -z "$1" ]
then
	tcpdump -i $NWINTERFACE &
else
	#else run on interface given
	tcpdump -i $1 &
fi
}
function ws {
#if nothing given then run default on $NWINTERFACE
if [ -z "$1" ]
then
	wireshark -i $NWINTERFACE -k &
else
	#else run on interface given
	wireshark -i $1 -k &
fi
}
function allup() {
ifconfig eth0 up 2>/dev/null
ifconfig eth1 up 2>/dev/null
ifconfig eht2 up 2>/dev/null
ifconfig eth3 up 2>/dev/null
ifconfig eth4 up 2>/dev/null
ifconfig eth5 up 2>/dev/null
ifconfig eth6 up 2>/dev/null
ifconfig $NWINTERFACE up 2>/dev/null
# fix this too 
echo "[!] All interfaces UP"
}
function alldown() {
ifconfig eth0 down 2>/dev/null
ifconfig eth1 down 2>/dev/null
ifconfig eht2 down 2>/dev/null
ifconfig eth3 down 2>/dev/null
ifconfig eth4 down 2>/dev/null
ifconfig eth5 down 2>/dev/null
ifconfig eth6 down 2>/dev/null
ifconfig $NWINTERFACE down 2>/dev/null
echo "[!] All interfaces DOWN"
# i will make these better some time . currently lazy way 
}
function fixinternet() {
flushall
alldown 
route -n
ifu $NWINTERFACE
dhcp $NWINTERFACE
curl ipinfo.io
net-check 
}
function nw-config () {
$EDITOR /etc/network/interfaces
}
function docker-route {
# manually adds back docker route.. u may need to adjust this if urs is differnt
route add -net 172.17.0.0/16 dev docker0
}

function nw-eth0-dhcp () {
ifconfig eth0 down 
ip route flush table main
sleep 2
echo "" > /etc/resolv.conf 
ifconfig eth0 up
sleep 2 
dhclient eth0 -v
sleep 2
docker-route
sleep 1
nmap --iflist
curl ipinfo.io
ping google.co.uk -c 5
}
function nw-eth1-dhcp () {
ifconfig eth1 down 
sleep 2
ip route flush table main
echo "" > /etc/resolv.conf 
ifconfig eth1 up
sleep 2 
dhclient eth1 -v
sleep 2
docker-route
docker 1
nmap --iflist
curl ipinfo.io
ping google.co.uk -c 5
}


function net-tools-install {
if [[ $EUID -ne 0 ]]; then
	echo ""
	echo -e "\e[01;31m[!]\e[00m This must be run as root. Run again with 'sudo'"
	echo ""
	break 2> /dev/null
fi
sudo apt-get update
sudo apt-get install -y prips 
sudo apt-get install -y ipcalc 
sudo apt-get install -y arptables 
sudo apt-get install -y speedtest-cli 
sudo apt-get install -y host
sudo apt-get install -y iptables-persistent
curl -Ls https://github.com/ipinfo/cli/releases/download/ipinfo-2.8.0/deb.sh | sh
echo "source $(realpath $0)" >> ~/.bashrc
}


## Help Function 
function net-help {                                                         
echo -e "\e[96m               __              __                .__           "
echo "  ____   _____/  |_          _/  |_  ____   ____ |  |   ______ "
echo " /    \_/ __ \   __\  ______ \   __\/  _ \ /  _ \|  |  /  ___/ "
echo "|   |  \  ___/|  |   /_____/  |  | (  <_> |  <_> )  |__\___ \  "
echo "|___|  /\___  >__|            |__|  \____/ \____/|____/____  > "
echo "     \/     \/                                             \/  "
echo "                                                               "
echo -e "\e[39m[*] Usage: \e[91m[FUNCTION] \e[93m[PARAMS]\e[39m"
echo "========================================================================================"
echo -e "\e[91mdhcp\e[39m	DHCP on $NWINTERFACE  (specify the interface if you want another one)
\e[91mstatic  \e[93m192.168.2.99/24	\e[39mset static IPv4 Address
\e[91mgateway  \e[93m192.168.1.1	\e[39mset default gateway
\e[91mnameserver  \e[93m192.168.1.1	\e[39madd nameserver to /etc/resolve.conf
\e[91mnet-check	\e[39mdoes a set of tests to check connectivity (arp,ping,portscan,host)
\e[91mtables-show	\e[39mshows the tables (iptables,ip6tables,arptables)
\e[91mtables-flush	\e[39mflush all the tables (iptables,ip6tables,arptables)
\e[91mblock-ip  \e[93m192.168.2.2	\e[39mBLOCK IPv4 addresses(iptables + arptables)
\e[91mblock-ip-file  \e[93mexcludes.txt	\e[39mBLOCK IPv4 addresses from file(iptables + arptables)
\e[91mblock-ip6 \e[39m	use ip6tables to block a ipv6 adddress 
\e[91mhosts-add  \e[93m10.10.10.171 htb.openadmin	\e[39madds hosts entry to /etc/hosts
\e[91mhosts	\e[39mopens up /etc/hosts
\e[91mflush	\e[39mflushes $NWINTERFACE (specify the interface if you want another one)
\e[91mifu	\e[39mifconfig up on $NWINTERFACE  (specify the interface if you want another one)
\e[91mifd	\e[39mifconfig down on $NWINTERFACE  (specify the interface if you want another one)
\e[91mflushall	\e[39mflushes ALL eth adapters
\e[91mi	\e[39mshows ifconfig - just lazy
\e[91mpublicip	\e[39mshows public ip address
\e[91mws	\e[39mstarts wirshark on $NWINTERFACE (specify the interface if you want another one)
\e[91mspeedtest	\e[39mruns speedtest-cli
\e[91mproxy-off	\e[39mclear proxy settings
\e[91mproxy-on	\e[39madd proxy settings 
\e[91mnet-help	\e[39mashow the net-tools help menu (THIS)
\e[91mallup 	\e[39mifconfig up on all interfaces 
\e[91malldown 	\e[39mifconfig down on all interfaces 
\e[91fixinternet 	\e[39mturn it all off and on again and see if got tinternet
\e[91mnet-tools-install	\e[39mrun as root to install tools and include file in .bashrc
" | column -t -s'	'
echo -e "\e[39m========================================================================================"
echo ""
nmap -iflist
}



