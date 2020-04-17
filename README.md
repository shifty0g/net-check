lazy net-tools
=========================
a simple bash script to check network connectivity and set various things 
nothing special just to make things a little eaiser 

Features
--------------
* Set Static IP
* Set DHCP IP
* Set Default
* Set nameserver 
* Add entries to hosts file 
* net-check - checks connectivity - arp,ping,dns,portscan,curl
* Speedtest - using speedtest-cli
* Find public IP
* Block IPv4 and IPv6 addresss using iptables,arptables and ip6tables
* Display iptables
* flush iptables


Install
-----------
cd /usr/share
git clone https://github.com/shifty0g/lazy-net-tools
cd lazy-net-check
chmod +x net-check.sh
./net-tools.sh net-tools-install
* runs the function to instal the additional tools required and adds source entry to ~/.bashrc

Usege
---------
net-check

Example Output
-------------
```console
net-help 
               __              __                .__           
  ____   _____/  |_          _/  |_  ____   ____ |  |   ______                                                                                                                                                                             
 /    \_/ __ \   __\  ______ \   __\/  _ \ /  _ \|  |  /  ___/                                                                                                                                                                             
|   |  \  ___/|  |   /_____/  |  | (  <_> |  <_> )  |__\___ \                                                                                                                                                                              
|___|  /\___  >__|            |__|  \____/ \____/|____/____  >                                                                                                                                                                             
     \/     \/                                             \/                                                                                                                                                                              
                                                                                                                                                                                                                                           
[*] Usage: [FUNCTION] [PARAMS]                                                                                                                                                                                                             
========================================================================================
dhcp                                   DHCP on eth (default interface)
dhcp  eth1                             set DHCP address on specified interface eth1
static  192.168.2.99/24                set static IPv4 Address
gateway  192.168.1.1                   set default gateway
nameserver  192.168.1.1                add nameserver to /etc/resolve.conf
net-check                              does a set of tests to check connectivity (arp,ping,portscan,host)
tables-show                            shows the tables (iptables,ip6tables,arptables)
tables-flush                           flush all the tables (iptables,ip6tables,arptables)
block-ip  192.168.2.2                  BLOCK IPv4 addresses(iptables + arptables)
block-ip-file  excludes.txt            BLOCK IPv4 addresses from file(iptables + arptables)
block-ip6                              use ip6tables to block a ipv6 adddress 
hosts-add  10.10.10.171 htb.openadmin  adds hosts entry to /etc/hosts
hosts                                  opens up /etc/hosts
flush                                  flushes eth0 
flushall                               flushes ALL eth adapters
i                                      shows ifconfig - just lazy
public                                 shows public ip address
ws                                     starts wirshark on eth0 (specify the interface if you want another one)
speedtest                              runs speedtest-cli
net-tools-install                      run as root to install tools and include file in .bashr
```
