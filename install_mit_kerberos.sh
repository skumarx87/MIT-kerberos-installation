#!/bin/bash

KRB_DOMAIN_NAME="TANU.COM"
DOMAIN_UPPER=$(echo $KRB_DOMAIN_NAME|  tr '[:lower:]' '[:upper:]')
DOMAIN_LOWER=$(echo $KRB_DOMAIN_NAME|  tr '[:upper:]' '[:lower:]')
KDC_PASSWD=kdc123
ADMIN_PASSWD=admin123
KDC_SERVER=krbserver.tanu.com

server_setup()

{

echo "Starting server installation"
yum -y install krb5-server krb5-libs krb5-server-ldap
CUR_DIR=$(pwd)

cp -nv /etc/krb5.conf $CUR_DIR/krb5.conf_ORG
cp $CUR_DIR/sample-client-krb5.conf /etc/krb5.conf
sed -i "s/EXAMPLE.COM/$DOMAIN_UPPER/g" /etc/krb5.conf
sed -i "s/example.com/$DOMAIN_LOWER/g" /etc/krb5.conf
sed -i "s/kdchost/$KDC_SERVER/g" /etc/krb5.conf

cp -nv /var/kerberos/krb5kdc/kdc.conf $CUR_DIR/kdc.conf_ORG
cp $CUR_DIR/sample-server-kdc.conf /var/kerberos/krb5kdc/kdc.conf

sed -i "s/EXAMPLE.COM/$DOMAIN_UPPER/g" /var/kerberos/krb5kdc/kdc.conf
sed -i "s/example.com/$DOMAIN_LOWER/g" /var/kerberos/krb5kdc/kdc.conf

cp -nv /var/kerberos/krb5kdc/kadm5.acl $CUR_DIR/kadm5.acl_ORG
cp $CUR_DIR/sample-server-kadm5.acl /var/kerberos/krb5kdc/kadm5.acl

sed -i "s/EXAMPLE.COM/$DOMAIN_UPPER/g" /var/kerberos/krb5kdc/kadm5.acl 
kdb5_util create -r $DOMAIN_UPPER -s -P $KDC_PASSWD

echo -e "\n Starting KDC services"
service krb5kdc start
service kadmin start
chkconfig krb5kdc on
chkconfig kadmin on
echo -e "\n Creating admin principal"
kadmin.local -q "addprinc -pw root123 root/admin"


}

client_setup()

{
echo "starting client installation"

yum -y install krb5-workstation
CUR_DIR=$(pwd)

cp -nv /etc/krb5.conf $CUR_DIR/krb5.conf_ORG
cp $CUR_DIR/sample-client-krb5.conf /etc/krb5.conf
sed -i "s/EXAMPLE.COM/$DOMAIN_UPPER/g" /etc/krb5.conf
sed -i "s/example.com/$DOMAIN_LOWER/g" /etc/krb5.conf
sed -i "s/kdchost/$KDC_SERVER/g" /etc/krb5.conf



}
case "$1" in

server)
	echo "Server installation"
	server_setup
;;
client) 
	echo "Client installation"
	client_setup
;;

*)
	echo "Usage $0 server or client"
esac
