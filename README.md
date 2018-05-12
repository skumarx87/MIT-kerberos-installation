# MIT-kerberos-installation
This is very simple shell script to install and configure the MIT kerberos on Linux Operating system.

This script has been written in shell script and tested on Centos 7 with minimal/less security configurations.

To setup the MIT kerberos server modify below lines and run the follwoing command.

KRB_DOMAIN_NAME="TANU.COM"

KDC_PASSWD=kdc123
ADMIN_PASSWD=admin123
KDC_SERVER=krbserver.tanu.com

On KDC server host, run below command

./install_mit_kerberos.sh server

On KDC client host, run below command

./install_mit_kerberos.sh client

On kdc host run below command to create test user principle using root account

kadmin.local -q " addprinc -pw user123 user1"

verify user1 account in kdc client server by running below command

[root@krbcln1 kerberos-setup]# kinit user1
Password for user1@TANU.COM:

[root@krbcln1 kerberos-setup]# klist
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: user1@TANU.COM

Valid starting       Expires              Service principal
05/12/2018 18:29:00  05/13/2018 04:29:00  krbtgt/TANU.COM@TANU.COM
        renew until 05/13/2018 18:28:56








