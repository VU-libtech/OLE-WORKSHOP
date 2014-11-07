#!/bin/bash
clear

printf "delete old build info from ~/.m2/repository/org/kuali/ole\n"

rm -rf ~/.m2/repository/org/kuali/ole/*

printf "delete old build info from ~/kuali/main/dev\n"
rm -rf ~/kuali/main/dev/*

printf "delete old build info from ~/kuali/main/local\n"
rm -rf ~/kuali/main/local/*

# These runonce.properties files are required if you want to "reset" the database when loading tomcat
mkdir -p ~/kuali/main/local/olefs-webapp
cp ~/OLE/OLE-WORKSHOP/config/runonce.properties ~/kuali/main/local/olefs-webapp

mkdir -p ~/kuali/main/local/ole-docstore-webapp
cp ~/OLE/OLE-WORKSHOP/config/runonce.properties ~/kuali/main/local/ole-docstore-webapp

printf "common-config\n"
cp ~/OLE/OLE-WORKSHOP/config/common-config.xml ~/kuali/main/local

printf "delete old build info from ~/.kuali\n"
rm -rf ~/.kuali/*

printf "remove old webapps\n"
cd ${CATALINA_HOME}/webapps
rm -rf olefs
rm -rf olefs.war
rm -rf oledocstore
rm -rf oledocstore.war

printf ${OLE_DEVELOPMENT_WORKSPACE_ROOT}
cd ${OLE_DEVELOPMENT_WORKSPACE_ROOT}

printf "Building OLE\n"
mvn clean install -DskipTests=true

# inst
printf " OLE-INST data\n"
cd ${OLE_DEVELOPMENT_WORKSPACE_ROOT}/ole-app/ole-db/ole-liquibase/ole-liquibase-changeset
mvn clean install -Pinst-mysql,mysql -Dimpex.scm.phase=none

# demo data
#mvn clean install -Psql,mysql -Dscm.phase=none

# blank bootstrap only
#mvn clean install -Pbootstrap-sql-only,mysql -Dimpex.scm.phase=none

# go back to trunk after mysql-inst
printf "__________________\n"
cd ${OLE_DEVELOPMENT_WORKSPACE_ROOT}
mvn clean install -DskipTests=true

printf "__________________\n"
cd ${OLE_DEVELOPMENT_WORKSPACE_ROOT}/ole-app/olefs
mvn clean install -DskipTests=true

printf "_____________________\n"
cd ${OLE_DEVELOPMENT_WORKSPACE_ROOT}/ole-app/olefs
mvn initialize -Pdb -Djdbc.dba.username=root -Djdbc.dba.password=PW

cd ${OLE_DEVELOPMENT_WORKSPACE_ROOT}

printf "copy webapps\n"
cp ./ole-app/olefs/target/olefs.war ${CATALINA_HOME}/webapps/
cp ./ole-docstore/ole-docstore-webapp/target/oledocstore.war ${CATALINA_HOME}/webapps/
