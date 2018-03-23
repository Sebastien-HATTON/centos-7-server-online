#!/bin/bash
#
# postinstall.sh
#
# Script post-installation pour serveur dédié CentOS 7
#
# (c) Nicolas Kovacs, 2018

# Exécuter en tant que root
if [ $EUID -ne 0 ] ; then
  echo "::"
  echo ":: Vous devez être root pour exécuter ce script."
  echo "::"
  exit 1
fi

# Répertoire courant
CWD=$(pwd)

# Interrompre en cas d'erreur
set -e

# Couleurs
VERT="\033[01;32m"
GRIS="\033[00m"

# Journal
LOG=/tmp/postinstall.log

# Pause entre les opérations
DELAY=1

# Nettoyer le fichier journal
echo > $LOG

# Bannière
sleep $DELAY
echo
echo "     ################################################" | tee -a $LOG
echo "     ### Serveur dédié CentOS 7 Post-installation ###" | tee -a $LOG
echo "     ################################################" | tee -a $LOG
echo | tee -a $LOG
sleep $DELAY
echo "     Pour suivre l'avancement des opérations, ouvrez une"
echo "     deuxième console et invoquez la commande suivante :"
echo
echo "       # tail -f /tmp/postinstall.log"
echo
sleep $DELAY

# Activer la gestion des Delta RPM
if ! rpm -q deltarpm 2>&1 > /dev/null ; then
  echo -e ":: Activer la gestion des Delta RPM... \c"
  yum -y install deltarpm >> $LOG 2>&1
  echo -e "[${VERT}OK${GRIS}] \c"
  sleep $DELAY
  echo
  echo "::"
fi

echo

exit 0
