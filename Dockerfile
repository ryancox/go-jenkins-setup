# Dockerizing Jenkins and Go related plugins along with a 
# sample job demonstrating CI techniques for Go

FROM       ubuntu:latest
MAINTAINER ryan.a.cox@gmail.com 

ENV JENKINS_HOME /var/lib/jenkins

# Install aptitude packages 
RUN apt-get update
RUN apt-get install -y git openjdk-7-jre python-pip software-properties-common wget bzr mercurial unzip

# Install go 1.3.3 
RUN wget -q https://storage.googleapis.com/golang/go1.3.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.3.3.linux-amd64.tar.gz 
ENV PATH /usr/local/go/bin:$PATH

# Install latest jenkins via aptitude
RUN wget -q -O - http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key | apt-key add -
RUN echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
RUN apt-get update
RUN apt-get install -y jenkins

RUN mkdir -p /var/lib/jenkins/plugins
RUN mkdir -p /var/lib/jenkins/jobs/Hugo

RUN wget -P /var/lib/jenkins/plugins http://updates.jenkins-ci.org/latest/scm-api.hpi
RUN wget -P /var/lib/jenkins/plugins http://updates.jenkins-ci.org/latest/git.hpi
RUN wget -P /var/lib/jenkins/plugins http://updates.jenkins-ci.org/latest/git-client.hpi
RUN wget -P /var/lib/jenkins/plugins http://updates.jenkins-ci.org/latest/git-server.hpi
RUN wget -P /var/lib/jenkins/plugins http://updates.jenkins-ci.org/latest/analysis-core.hpi
RUN wget -P /var/lib/jenkins/plugins http://updates.jenkins-ci.org/latest/envinject.hpi
RUN wget -P /var/lib/jenkins/plugins http://updates.jenkins-ci.org/latest/jobConfigHistory.hpi
RUN wget -P /var/lib/jenkins/plugins http://updates.jenkins-ci.org/latest/plot.hpi
RUN wget -P /var/lib/jenkins/plugins http://updates.jenkins-ci.org/latest/token-macro.hpi
RUN wget -P /var/lib/jenkins/plugins http://updates.jenkins-ci.org/latest/xunit.hpi
COPY warnings.hpi /var/lib/jenkins/plugins/warnings.hpi

COPY config.xml /var/lib/jenkins/jobs/Hugo/config.xml

EXPOSE 8080 

# ENTRYPOINT /bin/bash 

ENTRYPOINT /usr/bin/java -Djava.awt.headless=true -jar /usr/share/jenkins/jenkins.war --webroot=/var/cache/jenkins/war --httpPort=8080 --ajp13Port=-1
