wget -O- http://deb.kamailio.org/kamailiodebkey.gpg | sudo apt-key add -
echo "deb http://deb.kamailio.org/kamailio51 $(lsb_release -sc) main" >/etc/apt/sources.list.d/kamailio.list
apt update && apt install kamailio kamailio-mysql-modules kamailio-presence-modules kamailio-xml-modules



###to gerate key 

https://lmtools.com/node/236
  
  
  ###to install rtpproxy
  
https://computingforgeeks.com/how-to-install-rtpproxy-from-source-on-ubuntu-linux/
  
  ### pour installer les prerequis pour la compilation
  
  sudo apt-get install build-essential git cmake

