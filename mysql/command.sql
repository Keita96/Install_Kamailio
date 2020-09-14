#    Ajout d'un utilisateur MySQL pour l'accès à distance

my.cnf ou /etc/mysql/mariadb.conf.d/50-server.cnf sur *_DEDIAN 10_* (my.ini sous Windows)


Replace xxx with your IP Address 
          bind-address        = xxx.xxx.xxx.xxx
          
          
 puis,
        CREATE USER 'myuser'@'localhost' IDENTIFIED BY 'mypass';
        CREATE USER 'myuser'@'%' IDENTIFIED BY 'mypass';          
        
        
ensuite

          GRANT ALL ON *.* TO 'myuser'@'localhost';
          GRANT ALL ON *.* TO 'myuser'@'%';
          FLUSH PRIVILEGE
          
          
   En fonction de votre système d'exploitation, vous devrez peut-être ouvrir le port 3306 pour autoriser les connexions à distance.        
