# Install_Kamailio

How to Install Kamailio SIP server on Ubuntu 18.04 | 16.04

   # Step 1: Install Apache2 HTTP

To install Apache2 HTTP on Ubuntu server, run the commands below...

    sudo apt update
    sudo apt install apache2

After installing Apache2, the commands below can be used to stop, start and enable Apache2 service to always start up with the server boots.

    sudo systemctl stop apache2.service 
    sudo systemctl start apache2.service 
    sudo systemctl enable apache2.service

# Step 2: Install MariaDB Database Server

    sudo apt install mariadb-server mariadb-client

After installing MariaDB, the commands below can be used to stop, start and enable MariaDB service to always start up when the server boots..

  Run these on Ubuntu
  
     sudo systemctl stop mariadb.service 
    sudo systemctl start mariadb.service 
    sudo systemctl enable mariadb.service
    
    

After that, run the commands below to secure MariaDB server by creating a root password and disallowing remote root access.
    
    sudo mysql_secure_installation
    
   When prompted, answer the questions below by following the guide.
Enter current password for root (enter for none): Just press the Enter Set root password? [Y/n]: Y
New password: Enter password
Re-enter new password: Repeat password
Remove anonymous users? [Y/n]: Y
Disallow root login remotely? [Y/n]: Y
Remove test database and access to it? [Y/n]: Y Reload privilege tables now? [Y/n]: Y


Restart MariaDB server
To test if MariaDB is installed, type the commands below to logon to MariaDB server

       sudo mysql -u root -p
    Then type the password you created above to sign on... if successful, you should see MariaDB welcome message
    
    
   # Step 3: Install PHP 7.2 and Related Modules
PHP 7.2 may not be available in Ubuntu default repositories... in order to install it, you will have to get it from third-party repositories.
Run the commands below to add the below third party repository to upgrade to PHP 7.2

        sudo apt-get install software-properties-common 
        sudo add-apt-repository ppa:ondrej/php
        
 Then update and upgrade to PHP 7.2
 
                sudo apt update
                
Next, run the commands below to install PHP 7.2 and related modules.

    sudo apt install php7.2 libapache2-mod-php7.2 php7.2-common php7.2- gmp php7.2-curl php7.2-intl php7.2-mbstring php7.2-xmlrpc php7.2- mysql php7.2-gd php7.2-imagick php-pear php7.2-xml php7.2-cli php7.2- zip php7.2-sqlite

After installing PHP 7.2, run the commands below to open PHP default config file for Apache2...

    sudo nano /etc/php/7.2/apache2/php.ini
   
Then make the changes on the following lines below in the file and save. The value below are great settings to apply in your environments.
   
    file_uploads = On 
    allow_url_fopen = On 
    short_open_tag = On 
    memory_limit = 256M 
    upload_max_filesize = 100M 
    max_execution_time = 360 
    max_input_vars = 1500 
    date.timezone = America/Chicago
   
 After making the change above, save the file and close out. After installing PHP and related modules, all you have to do is restart Apache2 to reload PHP configurations...
   
   To restart Apache2, run the commands below
   
        sudo systemctl restart apache2.service
  
To test PHP 7.2 settings with Apache2, create a phpinfo.php file in Apache2 root directory by running the commands below

      sudo nano /var/www/html/phpinfo.php

Then type the content below and save the file.

      <?php phpinfo( ); ?>
      
Save the file.. then browse to your server hostname followed by /phpinfo.php

    http://localhost/phpinfo.php
    
You should see PHP default test page...

# Step 4: Download Kamailio Latest Release

Kamailio packages are not available in the Ubuntu default repositories. In order to install it you’ll have to add its official repository to Ubuntu. To do that, follow the steps below:
First, download and add the GPG key for its repository by running the commands below:

       wget -O- http://deb.kamailio.org/kamailiodebkey.gpg | sudo apt-key add -
       
Next, run the commands below to create its repository file.

    sudo nano /etc/apt/sources.list.d/kamailio.list
  
Then copy and paste the lines below in the file and save it.

    deb http://deb.kamailio.org/kamailio52 bionic main 
    deb-src http://deb.kamailio.org/kamailio52 bionic main
  
Finally, update Ubuntu packages and install Kamailio.
    sudo apt update
    sudo apt install kamailio kamailio-mysql-modules kamailio-websocket- modules

 After installing Kamailio, you can check whether it’s installed and ready by running the commands below.
 
            kamailio -V
            
You should see similar lines as shown below output:

    version: kamailio 5.2.6 (x86_64/linux)
    flags: STATS: Off, USE_TCP, USE_TLS, USE_SCTP, TLS_HOOKS, USE_RAW_SOCKS, DISABLE_NAGLE, USE_MCAST, DNS_IP_HACK,             SHM_MEM,    SHM_MMAP, PKG_MALLOC, Q_MALLOC, F_MALLOC, TLSF_MALLOC, DBG_SR_MEMORY, USE_FUTEX, FAST_LOCK-ADAPTIVE_WAIT,       USE_DNS_CACHE, USE_DNS_FAILOVER, USE_NAPTR, USE_DST_BLACKLIST, HAVE_RESOLV_RES, TLS_PTHREAD_MUTEX_SHARED
    ADAPTIVE_WAIT_LOOPS=1024, MAX_RECV_BUFFER_SIZE 262144 MAX_URI_SIZE 1024, BUF_SIZE 65535, DEFAULT PKG_SIZE 8MB
    poll method support: poll, epoll_lt, epoll_et, sigio_rt, select.
    id: unknown
    compiled with gcc 7.4.0


Kamailio default configuration file is located at /etc/kamailio/kamctlrc .
For configurations, simply open the file and add your changes, then save it. To specify a
domain name for your server, run the commands below to open its configuration file

    sudo nano /etc/kamailio/kamctlrc
    
Then edit the highlighted lines in the file and save.

       #The Kamailio configuration file for the control tools. 
      ##your SIP domain
      SIP_DOMAIN=kamailio.example.com
      ##chrooted directory
      #If you want to setup a database with kamdbctl, you must at least specify
       #this parameter.
      DBENGINE=MYSQL
      ##database host
      ##database read only user
    
After making the changes above, run the script below to create a database, user and tables needed by Kamailio.
  
      kamdbctl create
  
If you get access denied for root@localhost, follow the steps below to resolve. Logon to MariaDB server by running the commands below

    sudo mysql -u root

That should get you into the database server. After that, run the commands below to disable plugin authentication for the root user
Restart and run the commands below to set a new password.
sudo systemctl restart mariadb.service
Now run the Kamailio script to create a database and user. 
When prompted, answer with the settings below:

    Enter character set name:
    latin1
    INFO: creating database kamailio ...
    INFO: granting privileges to database kamailio ...
    INFO: creating standard tables into kamailio ...
    INFO: Core Kamailio tables succesfully created.
    Install presence related tables? (y/n): y
    INFO: creating presence tables into kamailio ...
    INFO: Presence tables succesfully created.
    Install tables for imc cpl siptrace domainpolicy carrierroute
    drouting userblacklist htable purple uac pipelimit mtree sca mohqueue
    rtpproxy rtpengine? (y/n): y INFO: creating extra tables into kamailio ...
    INFO: Extra tables succesfully created.
    Install tables for uid_auth_db uid_avp_db uid_domain uid_gflags
    uid_uri_db? (y/n): y
    INFO: creating uid tables into kamailio ...
    INFO: UID tables succesfully created.

    sudo nano /etc/kamailio/kamailio.cfg

Then add the following lines below #!KAMAILIO .

         #!define WITH_MYSQL 
         #!define WITH_AUTH
         #!define WITH_USRLOCDB 
         #!define WITH_ACCDB 
  
Save and exit.

    sudo systemctl restart kamailio
   
