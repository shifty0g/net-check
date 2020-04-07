net-check
=========================
a simple bash script to check network connectivity

Features
--------------
* Ping local interface, DNS server + Gateway
* Arp Scan
* 

Install
-----------
cd /usr/share

sudo apt-get install speedtest-cli

git clone https://github.com/shifty0g/net-check

cd net-check

chmod +x net-check.sh


create an alias to the file (add in alias file)


echo "alias net-check='/usr/share/net-check/net-check.sh'" >> ~/.bash_aliases


Usege
---------
net-check

Example Output
-------------
```console
└[14:37]─╼# net-check

==============================[ Network Check ]==============================

[*] Ping Checks - Local Interface (127.0.0.1)
                                                                                                                   
64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.026 ms                                                           
64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.038 ms                                                           
                                                                                                                   
[*] arp-scan - local                                                                                               
                                                                                                                   
192.168.0.1                                                                                                        
192.168.0.18                                                                                                       
192.168.0.28                                                                                                       
192.168.0.25                                                                                                       
192.168.0.25                                                                                                       
192.168.0.16                                                                                                       
192.168.0.36                                                                                                       
192.168.0.86                                                                                                       
192.168.0.106                                                                                                      
192.168.0.76                                                                                                       
192.168.0.77                                                                                                       
192.168.0.101                                                                                                      
192.168.0.132                                                                                                      
192.168.0.133                                                                                                      
192.168.0.117                                                                                                      
192.168.0.20                                                                                                       
192.168.0.10                                                                                                       
                                                                                                                   
[*] Ping Checks - Default Gateway (192.168.0.1)                                                                    
                                                                                                                   
64 bytes from 192.168.0.1: icmp_seq=1 ttl=64 time=128 ms                                                           
64 bytes from 192.168.0.1: icmp_seq=2 ttl=64 time=3.31 ms                                                          
                                                                                                                   
[*] Ping Checks - DNS Servers                                                                                      
                                                                                                                   
64 bytes from 194.168.4.100: icmp_seq=1 ttl=61 time=20.7 ms                                                        
64 bytes from 194.168.4.100: icmp_seq=2 ttl=61 time=106 ms                                                         
64 bytes from 194.168.8.100: icmp_seq=1 ttl=61 time=17.0 ms                                                        
64 bytes from 194.168.8.100: icmp_seq=2 ttl=61 time=19.6 ms                                                        
                                                                                                                   
[*] Ping Checks - External Out by IP (8.8.8.8) *                                                                   
                                                                                                                   
64 bytes from 8.8.8.8: icmp_seq=1 ttl=55 time=171 ms                                                               
64 bytes from 8.8.8.8: icmp_seq=2 ttl=55 time=61.7 ms                                                              
                                                                                                                   
[*] Ping - External Out by DNS NAME (bbc.co.uk) *                                                                  
                                                                                                                   
64 bytes from 151.101.192.81 (151.101.192.81): icmp_seq=1 ttl=58 time=24.4 ms                                      
64 bytes from 151.101.192.81 (151.101.192.81): icmp_seq=2 ttl=58 time=26.1 ms                                      
                                                                                                                   
[*] Host - host lookup yahoo.com *                                                                                 
                                                                                                                   
yahoo.com has address 98.138.219.231                                                                               
yahoo.com has address 98.137.246.8                                                                                 
yahoo.com has address 72.30.35.10                                                                                  
yahoo.com has address 98.137.246.7                                                                                 
yahoo.com has address 98.138.219.232                                                                               
yahoo.com has address 72.30.35.9                                                                                   
yahoo.com has IPv6 address 2001:4998:c:1023::4                                                                     
yahoo.com has IPv6 address 2001:4998:44:41d::4                                                                     
yahoo.com has IPv6 address 2001:4998:c:1023::5                                                                     
yahoo.com has IPv6 address 2001:4998:44:41d::3                                                                     
yahoo.com has IPv6 address 2001:4998:58:1836::11                                                                   
yahoo.com has IPv6 address 2001:4998:58:1836::10                                                                   
yahoo.com mail is handled by 1 mta7.am0.yahoodns.net.                                                              
yahoo.com mail is handled by 1 mta5.am0.yahoodns.net.                                                              
yahoo.com mail is handled by 1 mta6.am0.yahoodns.net.                                                              
                                                                                                                   
[*] nmap - nmap.org 8.8.8.8 *                                                                                      
                                                                                                                   
Starting Nmap 7.80 ( https://nmap.org ) at 2020-04-07 14:39 BST                                                    
Nmap scan report for nmap.org (45.33.49.119)                                                                       
Host is up (0.19s latency).                                                                                        
Other addresses for nmap.org (not scanned): 2600:3c01::f03c:91ff:fe98:ff4e                                         
rDNS record for 45.33.49.119: ack.nmap.org                                                                         
                                                                                                                   
PORT     STATE    SERVICE                                                                                          
22/tcp   open     ssh                                                                                              
53/tcp   filtered domain                                                                                           
80/tcp   open     http                                                                                             
443/tcp  open     https                                                                                            
3389/tcp filtered ms-wbt-server                                                                                    
                                                                                                                   
Nmap scan report for dns.google (8.8.8.8)                                                                          
Host is up (0.026s latency).                                                                                       
                                                                                                                   
PORT     STATE    SERVICE                                                                                          
22/tcp   filtered ssh                                                                                              
53/tcp   open     domain                                                                                           
80/tcp   filtered http                                                                                             
443/tcp  open     https                                                                                            
3389/tcp filtered ms-wbt-server                                                                                    
                                                                                                                   
Nmap done: 2 IP addresses (2 hosts up) scanned in 1.98 seconds                                                     
                                                                                                                   
[*] Curl Checks - External Out by DNS NAME #2 (https://google.co.uk) *                                             
                                                                                                                   
 HTTP/2 301                                                                                                        
location: https://www.google.co.uk/                                                                                
content-type: text/html; charset=UTF-8                                                                             
date: Tue, 07 Apr 2020 13:39:21 GMT                                                                                
expires: Thu, 07 May 2020 13:39:21 GMT                                                                             
cache-control: public, max-age=2592000                                                                             
server: gws                                                                                                        
content-length: 222                                                                                                
x-xss-protection: 0                                                                                                
x-frame-options: SAMEORIGIN                                                                                        
alt-svc: quic=":443"; ma=2592000; v="46,43",h3-Q050=":443"; ma=2592000,h3-Q049=":443"; ma=2592000,h3-Q048=":443"; ma=2592000,h3-Q046=":443"; ma=2592000,h3-Q043=":443"; ma=2592000,h3-T050=":443"; ma=2592000                         
                                                                                                                   
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">                                     
<TITLE>301 Moved</TITLE></HEAD><BODY>                                                                              
<H1>301 Moved</H1>                                                                                                 
The document has moved                                                                                             
<A HREF="https://www.google.co.uk/">here</A>.                                                                      
</BODY></HTML>                                                                                                     
                                                                                                                   
[+] Speedtest-cli                                                                                                  
                                                                                                                   
Retrieving speedtest.net configuration...                                                                          
Testing from XXXXX YYYYYY (X.X.X.X)...                                                                         
Retrieving speedtest.net server list...                                                                            
Selecting best server based on ping...                                                                             
Hosted by YYYYYY UK (XXXXX) [32.23 km]: 38.733 ms                                                              
Testing download speed................................................................................             
Download: 6.85 Mbit/s                                                                                              
Testing upload speed......................................................................................................                                                                                                            
Upload: 12.48 Mbit/s                                                                                               
                                                                                                                   
 =============================[ COMPLETE ]==============================
```
