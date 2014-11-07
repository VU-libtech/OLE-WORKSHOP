OLE-WORKSHOP
============

#Prerequisites

Install Java 7

Install Tomcat 7

Install Mysql

#Edit mysql config to allow lower case table names. Add the following to [mysqld] in my.cnf

[mysqld]
lower_case_table_names=1

Restart mysql

#Building from Source

Install maven

Install ant

Install git

###create liquibase and user

```
mysql> create database LIQUIBASEBLANK;
mysql> create user 'LIQUIBASEBLANK'@'localhost' identified by 'LIQUIBASEBLANK';
mysql> grant all privileges on LIQUIBASEBLANK.* to 'LIQUIBASEBLANK'@'localhost' identified by 'LIQUIBASEBLANK';
```

###checkout the workshop file data
```
mkdir ~/OLE
cd ~/OLE
git clone https://github.com/VU-libtech/OLE-WORKSHOP.git
git clone https://github.com/VU-libtech/OLE-INST.git
```

###edit environment variables in OLE-WORKSHOP/env.sh

###implement environment variables
    source ~/OLE/OLE-WORKSHOP/env.sh
    
###edit ~/OLE/OLE-WORKSHOP/config/common-config.xml
```
<param name="mysql.dba.username">root</param>
<param name="mysql.dba.password">PW</param>
```

###Copy mysql JDBC driver to tomcat
    cp ~/OLE/OLE-WORKSHOP/lib/mysql-connector-java-5.1.13.jar $CATALINA_HOME/lib

###edit ~/OLE-WORKSHOP/build.sh at set your db user and password
    mvn initialize -Pdb -Djdbc.dba.username=root -Djdbc.dba.password=PW

###Set file to be executable
    chmod +x ~/OLE-WORKSHOP/build.sh

###build OLE
```
cd ~/OLE/OLE-WORKSHOP
./build.sh
```

#Deployment

###If you are skipping the build section, you'll need to grab the OLE apps from github
```
wget https://github.com/VU-libtech/OLE-WORKSHOP/releases/download/0.1.0/olefs.war -P ${CATALINA_HOME}/webapps
wget https://github.com/VU-libtech/OLE-WORKSHOP/releases/download/0.1.0/oledocstore.war -P ${CATALINA_HOME}/webapps
```

###start tomcat
    cd $CATALINA_HOME/bin
    ./startup.sh

###This will take some time, check the log for completion
    tail -f $CATALINA_HOME/logs/catalina.out

###View in browser
http://localhost:8080/olefs/portal.do

####Index Bibs, Holdings, Items in Solr (this will take a couple minutes, check the log for completion)
http://localhost:8080/oledocstore/admin.jsp

