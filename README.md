OLE-WORKSHOP
============
install java 7

install tomcat 7
cp app/mysql-connector-java-5.1.13.jar $CATALINA_HOME/lib

install maven

install ant

install git

#edit environment variables in env.sh

#set env variables
source ~/OLE/OLE-WORKSHOP/env.sh

install mysql

#Edit mysql config to allow lower case table names
my.cnf
[mysqld]
lower_case_table_names=1

restart mysql

create liquibase and user

mysql> create database LIQUIBASEBLANK;
mysql> create user 'LIQUIBASEBLANK'@'localhost' identified by 'LIQUIBASEBLANK';
mysql> grant all privileges on LIQUIBASEBLANK.* to 'LIQUIBASEBLANK'@'localhost' identified by 'LIQUIBASEBLANK';

#checkout the workshop file data
mkdir ~/OLE
cd ~/OLE
git clone https://github.com/VU-libtech/OLE-WORKSHOP.git
git clone https://github.com/VU-libtech/OLE-INST.git

#edit ~/OLE-WORKSHOP/config/common-config.xml
<param name="mysql.dba.username">root</param>
<param name="mysql.dba.password">PW</param>

#edit ~/OLE-WORKSHOP/build.sh
mvn initialize -Pdb -Djdbc.dba.username=root -Djdbc.dba.password=PW

#Set file to be executable
chmod +x ~/OLE-WORKSHOP/build.sh

#build OLE
cd ~/OLE/OLE-WORKSHOP
./build.sh

#start tomcat
cd $CATALINA_HOME/bin
./startup.sh

#This will take some time, check the log for completion
tail -f $CATALINA_HOME/logs/catalina.out

#view in browser
http://localhost:8080/olefs/portal.do

#Index Bibs, Holdings, Items in Solr (this will take a couple minutes, check the log for completion)
http://localhost:8080/oledocstore/admin.jsp

