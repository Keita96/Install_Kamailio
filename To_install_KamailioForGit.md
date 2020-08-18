# Conditions préalables

Pour pouvoir suivre les directives de ce document, vous devez y root accéder.

Les packages suivants sont requis avant de passer aux étapes suivantes.

git client:  apt-get install git-core- il est recommandé d'avoir une version récente, si votre distribution Linux a une ancienne version,
vous pouvez en télécharger une plus récente sur git-scm.com
Compilateurs gcc et g ++ : apt-get install gcc g++
flex -apt-get install flex
bison -apt-get install bison
libmysqlclient-dev - apt-get install libmysqlclient-dev(ou: apt install default-libmysqlclient-dev)
make et autoconf -apt-get install make autoconf
si vous souhaitez activer plus de modules, certains nécessitent des bibliothèques supplémentaires:

        libssl -apt-get install libssl-dev
         libcurl -apt-get install libcurl4-openssl-dev
         libxml2 -apt-get install libxml2-dev
         libpcre3 -apt-get install libpcre3-dev


Remarque importante : à partir de la version 4.3.0, Kamailio utilise le répertoire / var / run / kamailio / 
pour créer des fichiers de contrôle FIFO et UnixSocket RPC. 
Vous devrez peut-être compléter la section relative à l'installation du init.dscript pour la création /var/run/kamailiomême si 
vous prévoyez de démarrer Kamailio manuellement à partir de la ligne de commande. 
L'alternative consiste à définir des chemins différents par l' intermédiaire de paramètres de jsonrpcs et CTL modules.

# Serveur MySQL ou MariaDB

        apt-get install mysql-serverou apt-get install default-mysql-server
        
# Obtenir des sources de GIT
Tout d'abord, vous devez créer un répertoire sur le système de fichiers où les sources seront stockées.

        mkdir -p /usr/local/src/kamailio-5.2
        cd /usr/local/src/kamailio-5.2
        
# Téléchargez les sources depuis GIT à l'aide des commandes suivantes.

      git clone --depth 1 --no-single-branch https://github.com/kamailio/kamailio kamailio
      cd kamailio
      git checkout -b 5.2 origin/5.2 
      
 # Réglage des Makefiles
La première étape consiste à générer des fichiers de configuration de compilation.
      make cfg
L'étape suivante consiste à activer le module MySQL. Editez le fichier modules.lst :

    
        nano -w src/modules.lst
   or
         vim src/modules.lst
  
Ajoutez db_mysql à la variable include_modules .

        include_modules= db_mysql 
  
  Enregistrez le module.lst et quittez.
REMARQUE : il s'agit d'un mécanisme pour activer les modules qui ne sont pas compilés par défaut, 
tels que lcr, dialplan, presence - ajoutez les modules à la variable include_modules dans le fichier modules.lst ,
comme:
        include_modules= db_mysql dialplan

# Compiler Kamailio
Une fois que vous avez ajouté le module mysql à la liste des modules activés, vous pouvez compiler Kamailio:
      
      make all
      
# Installez Kamailio
Lorsque la compilation est prête, installez Kamailio avec la commande suivante:
      make install
      
      
# Quoi et où a été installé
Les binaires et les scripts exécutables ont été installés dans:

        /usr/local/sbin

Ceux-ci sont:
kamailio - serveur SIP Kamailio
kamdbctl - script pour créer et gérer les bases de données
kamctl - script pour gérer et contrôler le serveur SIP Kamailio
kamcmd - CLI - outil de ligne de commande pour s'interfacer avec le serveur Kamailio SIP
Pour pouvoir utiliser les binaires à partir de la ligne de commande, assurez-vous qu'il /usr/local/sbin 
est défini dans PATHla variable d'environnement. Vous pouvez vérifier cela avec echo $PATH. Sinon et que vous utilisez bash, 
ouvrez /root/.bash_profile et à la fin ajoutez

         PATH=$PATH:/usr/local/sbin
        export PATH
  
Les modules Kamailio sont installés dans:

    /usr/local/lib/kamailio/modules/ 
  
Remarque: sur les systèmes 64 bits, /usr/local/lib64peut être utilisé.

La documentation et les fichiers readme sont installés dans:

    /usr/local/share/doc/kamailio/
    
Les pages de manuel sont installées dans:

        /usr/local/share/man/man5/
        /usr/local/share/man/man8/
  
Le fichier de configuration a été installé dans:

        /usr/local/etc/kamailio/kamailio.cfg
  
# Créer une base de données MySQL

Pour créer la MySQLbase de données, vous devez utiliser le script de configuration de la base de données. 
Tout d' abord modifier kamctlrc fichier pour définir le type de serveur de base de données: 

    nano -w /usr/local/etc/kamailio/kamctlrc
    
 Localisez la DBENGINEvariable et définissez-la sur MYSQL:

      DBENGINE=MYSQL
Vous pouvez changer d'autres valeurs dans le fichier kamctlrc , au moins il est recommandé de changer les mots de passe par défaut pour 
les utilisateurs à créer pour se connecter à la base de données.

Notez que la ligne existante avec DBENGINEvou d'autres attributs peuvent être commentés, décommentés 
en supprimant le #caractère au début de la ligne.

Une fois que vous avez terminé la mise à jour du fichier kamctlrc , exécutez le script 
pour créer la base de données utilisée par Kamailio:

Une fois que vous avez terminé la mise à jour du fichier kamctlrc , 
exécutez le script pour créer la base de données utilisée par Kamailio:
 
  /usr/local/sbin/kamdbctl create
  
  Vous pouvez appeler ce script sans aucun paramètre pour obtenir de l'aide pour l'utilisation. 
  Il vous sera demandé le nom de domaine que Kamailio va servir (par exemple mysipserver.com) 
  et le mot de passe de l' rootutilisateur MySQL. Le script créera une base de données nommée kamailio contenant 
  les tables requises par Kamailio. Vous pouvez modifier les paramètres par défaut dans le fichier 
  kamctlrc mentionné ci-dessus.
  
  Le script ajoutera deux utilisateurs dans MySQL:

kamailio - (avec mot de passe par défaut kamailiorw) - utilisateur disposant des droits d'accès complets à la kamailio 
base de données

kamailioro - (avec mot de passe par défaut kamailioro) - utilisateur qui a
des droits d'accès en lecture seule à la kamailiobase de données

IMPORTANT: changez les mots de passe de ces deux utilisateurs en quelque chose de différent 
des valeurs par défaut fournies avec les sources.

Modifier le fichier de configuration
Pour répondre à vos exigences pour la plate-forme VoIP, vous devez éditer le fichier de configuration.

        /usr/local/etc/kamailio/kamailio.cfg
  
Suivez les instructions dans les commentaires pour activer l'utilisation de MySQL.
En gros, vous devez ajouter plusieurs lignes en haut du fichier de configuration, comme:

        #!define WITH_MYSQL
        #!define WITH_AUTH
         #!define WITH_USRLOCDB
    
   
Si vous avez changé le mot de passe de l' kamailioutilisateur de MySQL, 
vous devez mettre à jour la valeur des db_urlparamètres.

Vous pouvez parcourir kamailio.cfg en ligne sur le référentiel GIT.https://github.com/kamailio/kamailio/blob/master/etc/kamailio.cfg

# Exécuter Kamailio

Il existe quelques variantes pour démarrer / arrêter / redémarrer Kamailio, 
celles recommandées étant via un init.dscript ou une systemdunité, 
selon ce que le système d'exploitation Debian est configuré pour utiliser.

        Script init.d
Pour installer le init.d script, exécutez-le dans le répertoire du code source de Kamailio:

        make install-initd-debian
Suivez toutes les instructions qui peuvent être imprimées par la commande ci-dessus.

Ensuite, vous pouvez démarrer / arrêter Kamailio à l'aide des commandes suivantes:

        /etc/init.d/kamailio start
         /etc/init.d/kamailio stop
  
  United Systemd
  
Pour installer l' systemdunité, exécutez dans le répertoire du code source Kamailio:

make install-systemd-debian
Suivez toutes les instructions qui peuvent être imprimées par la commande ci-dessus.

Ensuite, vous pouvez démarrer / arrêter Kamailio à l'aide des commandes suivantes:

        systemctl start kamailio
        systemctl stop kamailio
  
  Kamctl
Vous devrez peut-être modifier, modifier /usr/local/etc/kamailio/kamctlrc et définir les attributs PID_FILEet STARTOPTIONS.

Vous pouvez utiliser:

        kamctl start
        kamctl stop
Ligne de commande
Kamailio peut être démarré à partir de la ligne de commande en exécutant le binaire avec des paramètres spécifiques. 
Par exemple:

# démarrer Kamailio
        /usr/local/sbin/kamailio -P /var/run/kamailio/kamailio.pid -m 128 -M 12
 # arrêter Kamailio
 
            killall kamailio
or        
        kill -TERM $(cat /var/run/kamailio/kamailio.pid)  


# Prêt à basculer
Maintenant, tout est en place. Vous pouvez démarrer le service VoIP, créer de nouveaux comptes et configurer les téléphones.

Un nouveau compte peut être ajouté à l'aide de l' kamctl outil via:

    kamctl add username password

Si SIP_DOMAIN n'a pas été défini dans le kamctlrc fichier, utilisez l'une des options suivantes.

exécuter dans le terminal:

      export SIP_DOMAIN=mysipserver.com
     kamctl add username password
     
ou éditez /usr/local/etc/kamailio/kamctlrcet ajoutez:

        SIP_DOMAIN=mysipserver.com
        
puis exécutez à nouveau kamctl add ...comme ci-dessus.

ou donnez le nom d'utilisateur avec le domaine en kamctl add ...paramètre:

        kamctl add username@mysipserver.com password

Au lieu de cela, mysipserver.com il faut lui donner le vrai domaine du service SIP ou l'adresse IP de Kamailio.



# Entretien
Le processus de maintenance est très simple pour le moment. Vous devez être utilisateur root et exécuter les commandes suivantes:

  cd /usr/local/src/kamailio-5.2/kamailio
  
                git pull origin
                 make all
                make install
                /etc/init.d/kamailio restart
                
Vous avez maintenant le dernier développement de Kamailio en cours d'exécution sur votre système.

# Quand mettre à jour
Les notifications concernant les commits GIT sont envoyées à la liste de diffusion: sr-dev@lists.kamailio.org . 
Chaque notification de validation contient la référence à la branche où la validation a été effectuée. Si le message de validation contient les lignes:

Module: kamailio
Branch: 5.2
puis une mise à jour a été faite à la version de développement de Kamailio 
et elle sera disponible pour le GIT public en un rien de temps.
