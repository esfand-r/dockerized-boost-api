#!/bin/sh

# Pull latest version
cd /usr/local/boost-emulator
git pull origin master

# Build app
/usr/local/maven/bin/mvn -Dmaven.test.skip=true package

# Copy war to Tomcat
rm -rf $CATALINA_HOME/webapps/*
cp emulator-boost-api/target/emulator-boost-api-3.0.0-SNAPSHOT.war $CATALINA_HOME/webapps/ROOT.war

# Start Tomcat
JAVA_OPTS="$JAVA_OPTS -Dspring.profiles.active=$ACTIVE_PROFILE" $CATALINA_HOME/bin/startup.sh

nginx