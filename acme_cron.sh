#!/bin/sh

check_var() {
    eval val='$'"$1"
    if [ -z $val ]; then echo "$1 is empty, exiting"; exit 1; fi
}

CONFIG_FILE=$1

check_var CONFIG_FILE

. $CONFIG_FILE # Source configuration.

# Check vars from sourced config file.
check_var ACME_DOMAIN
check_var ACME_DNSAPI
check_var ACME_WORKINGDIR

cd $ACME_WORKINGDIR                                                                                                                                                                                                                                                                                                                                                   
rm -rf master.tar.gz 2> /dev/null                                                                                                                                                                                                                                                                                                                                     
rm -rf acme.sh-master 2> /dev/null                                                                                                                                                                                                                                                                                                                                    
rm -rf acme.sh 2> /dev/null                                                                                                                                                                                                                                                                                                                                           
wget https://github.com/Neilpang/acme.sh/archive/master.tar.gz                                                                                                                                                                                                                                                                                                        
tar xvf master.tar.gz                                                                                                                                                                                                                                                                                                                                                 
cd acme.sh-master                                                                                                                                                                                                                                                                                                                                                     
./acme.sh --install --nocron --home "$ACME_WORKINGDIR/acme.sh"                                                                                                                                                                                                                                                                                                        
cd ..                                                                                                                                                                                                                                                                                                                                                                 
cd acme.sh                                                                                                                                                                                                                                                                                                                                                            
./acme.sh --issue --post-hook "/usr/syno/sbin/synoservicecfg --restart httpd-sys" --dns $ACME_DNSAPI --certpath /usr/syno/etc/ssl/ssl.crt/server.crt --keypath /usr/syno/etc/ssl/ssl.key/server.key --ca-file /usr/syno/etc/ssl/ssl.intercrt/server-ca.crt --config-home "$ACME_WORKINGDIR/acme.sh/" --dnssleep 300 -d $ACME_DOMAIN --debug                          
cd ..                                                                                                                                                                                                                                                                                                                                                                 
rm -rf master.tar.gz 2> /dev/null                                                                                                                                                                                                                                                                                                                                     
rm -rf acme.sh-master 2> /dev/null                                                                                                                                                                                                                                                                                                                                    
rm -rf acme.sh 2> /dev/null
