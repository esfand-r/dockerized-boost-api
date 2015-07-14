# Docker Container for Boost Emulator’s Soap API

FROM centos:centos7

MAINTAINER Esfandiar Amirrahimi (esfandiar.rahimi@gmail.com)

# Environment variables
ENV JAVA_VERSION 8u45
ENV BUILD_VERSION b13
ENV JAVA_HOME /usr/java/latest
ENV CATALINA_HOME /usr/local/tomcat
ENV MAVEN_HOME /usr/local/maven
ENV APP_HOME /usr/local/boost-emulator
ENV GITHUB_CRED username:password
ENV ACTIVE_PROFILE test

ADD ./etc/nginx.repo /etc/yum/repos.d/nginx.repo

# Install YUM
RUN yum -y --noplugins --verbose update

# Some bare neccesities
RUN yum -y --noplugins --verbose install nginx git wget tar

# Java installation.
# Manually download Java once, host it somewhere, and wget it.
RUN wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm
RUN yum -y install /tmp/jdk-8-linux-x64.rpm

# nginx
ADD ./nginx-conf /etc/nginx/conf.d
RUN rm -f /etc/nginx/conf.d/default.conf

# Manually Download & install Tomcat 7
RUN wget -O /tmp/apache-tomcat-7.0.63.tar.gz http://apache.mirror.vexxhost.com/tomcat/tomcat-7/v7.0.63/bin/apache-tomcat-7.0.63.tar.gz
RUN cd /usr/local && tar xzf /tmp/apache-tomcat-7.0.63.tar.gz
RUN ln -s /usr/local/apache-tomcat-7.0.63 /usr/local/tomcat
RUN rm /tmp/apache-tomcat-7.0.63.tar.gz

# Manually Download & install Maven 3
RUN wget -O /tmp/apache-maven-3.3.3-bin.tar.gz http://apachemirror.ovidiudan.com/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
RUN cd /usr/local && tar xzf /tmp/apache-maven-3.3.3-bin.tar.gz
RUN ln -s /usr/local/apache-maven-3.3.3 /usr/local/maven
RUN rm /tmp/apache-maven-3.3.3-bin.tar.gz

# Copy start script
ADD ./start-script /usr/local
RUN chmod a+x /usr/local/start-everything.sh

# Clone the application itself
RUN cd /usr/local && git clone https://$GITHUB_CRED@github.com/AppDirect/boost-emulator.git

# Build the app once, so we can include all the dependencies in the image
RUN cd /usr/local/boost-emulator && /usr/local/maven/bin/mvn -Dmaven.test.skip=true package

# Set the start script as the default command (this will be overriden if a command is passed to Docker on the commandline).
# Note that we tail Tomcat's log in order to keep the process running
# so that Docker will not shutdown the container. This is a bit of a hack.
CMD /usr/local/start-everything.sh && tail -F /usr/local/tomcat/logs/catalina.out

# Forward HTTP ports
EXPOSE 80 8080

