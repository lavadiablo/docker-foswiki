#based on https://github.com/lavadiablo/docker-xwiki
FROM debian:latest

MAINTAINER Frederico Martins frederico.imm@gmail.com

#update debian and set xterm for nano
ENV TERM xterm
RUN apt-get update
RUN apt-get -y upgrade

#tools
RUN apt-get -y --force-yes install wget unzip tomcat7 curl python nano libreoffice

#Tomcat
RUN cd /usr/share/tomcat7 && ln -s /etc/tomcat7 conf
RUN ln -s /var/lib/tomcat7/webapps/ /usr/share/tomcat7/webapps
VOLUME /usr/share/tomcat7/logs

#Mysql JDBC
RUN wget http://jdbc.postgresql.org/download/postgresql-9.3-1102.jdbc4.jar -P /var/lib/tomcat7/webapps/xwiki/WEB-INF/lib/

#Download WAR from xwiki
RUN \curl -o xwikiDownloadPage.html http://download.forge.ow2.org/xwiki/
ADD versionPicker.py .
RUN python versionPicker.py >> downloader.sh
RUN chmod +x downloader.sh
RUN sh downloader.sh

RUN perl -i -p0e "s/# environment.permanentDirectory/  environment.permanentDirectory/smg" /var/lib/tomcat7/webapps/xwiki/WEB-INF/xwiki.properties
RUN perl -i -p0e "s/# openoffice.taskExecutionTimeout=30000/  openoffice.taskExecutionTimeout=300000/smg" /var/lib/tomcat7/webapps/xwiki/WEB-INF/xwiki.properties
RUN perl -i -p0e "s/# openoffice.autoStart=false/  openoffice.autoStart=true/smg" /var/lib/tomcat7/webapps/xwiki/WEB-INF/xwiki.properties
COPY ./conf/hibernate.cfg.xml /var/lib/tomcat7/webapps/xwiki/WEB-INF/hibernate.cfg.xml
ENV JAVA_OPTS="-server -Xms400m -Xmx800m -XX:MaxPermSize=222m -Dfile.encoding=utf-8 -Djava.awt.headless=true -XX:+UseParallelGC -XX:MaxGCPauseMillis=100"

#Start
CMD /usr/share/tomcat7/bin/catalina.sh run

#Port
EXPOSE 8080
EXPOSE 8009