#!/bin/bash
#
# mkcert.sh
#
# Créer ou renouveler un certificat SSL/TLS Let's Encrypt

# Créer le groupe certs avec le GID 240
if ! grep -q "^certs:" /etc/group ; then
  groupadd -g 240 certs
  echo ":: Ajout du groupe certs."
  sleep 3
fi

# Installer certbot-auto s'il n'est pas présent sur le serveur
if ! -x /usr/local/sbin/certbot-auto ; then
  echo ":: Installation de certbot-auto."
  pushd /usr/local/sbin
  wget -c https://dl.eff.org/certbot-auto
  chmod 0700 certbot-auto
  popd
fi

# Arrêter le serveur Apache
if ps ax | grep -v grep | grep httpd > /dev/null ; then
  echo ":: Arrêt du serveur Apache."
  systemctl stop httpd 1 > /dev/null 2>&1
  sleep 5
fi

# Générer ou renouveler un certificat SSL/TLS
/usr/local/sbin/certbot-auto certonly \
  --non-interactive \
  --email info@microlinux.fr \
  --preferred-challenges http \
  --standalone \
  --agree-tos \
  --renew-by-default \
  --webroot-path /var/www/slackbox-secure/html \
  -d slackbox.fr -d www.slackbox.fr \
  --webroot-path /var/www/slackbox-webmail/html \
  -d mail.slackbox.fr \
  --webroot-path /var/www/unixbox-secure/html \
  -d www.unixbox.fr -d unixbox.fr \
  --webroot-path /var/www/unixbox-webmail \
  -d mail.unixbox.fr 

# Définir les permissions
echo ":: Définition des permissions."
chgrp -R certs /etc/letsencrypt
chmod -R g=rx /etc/letsencrypt

# Démarrer Apache
echo ":: Démarrage du serveur Apache."
systemctl start httpd

