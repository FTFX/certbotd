echo "======================================="
echo "Running certbot for domain $DOMAINS"
date -u
echo "---------------------------------------"

get_certificate() {
  echo $args $server
  echo "Getting certificate for $CERT_DOMAIN"
  certbot certonly --agree-tos --keep-until-expiring -n \
  --server $server \
  --email $EMAIL -d $CERT_DOMAIN $args
  ec=$?
  echo "Certbot exit code $ec"
  if [ $ec -eq 0 ]
  then
    echo "Success! Certificate obtained for $CERT_DOMAIN!"
  else
    echo "Cerbot failed to get cert for $CERT_DOMAIN. Check the logs for details."
  fi
}

set_arguments() {
  if [ $WEBROOT ]
  then
    args=" --webroot -w $WEBROOT/$CERT_DOMAIN"
  else
    args=" --standalone --preferred-challenges http-01"
  fi

  if [ $DEBUG ]
  then
    args=$args" --debug"
  fi

  if [ $STAGING ]
  then
    server="https://acme-staging-v02.api.letsencrypt.org/directory"
  else
    server="https://acme-v02.api.letsencrypt.org/directory"
  fi
}

certbot renew
echo "---------------------------------------"
for d in $DOMAINS
do
    if [ ! -f "/etc/letsencrypt/live/$d/fullchain.pem" ]
    then
      CERT_DOMAIN=$d
      set_arguments
      get_certificate
      echo "---------------------------------------"
    fi
done
