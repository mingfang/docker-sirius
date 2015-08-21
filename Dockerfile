FROM ubuntu:14.04
 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8
RUN echo "export PS1='\e[1;31m\]\u@\h:\w\\$\[\e[0m\] '" >> /root/.bashrc

#Runit
RUN apt-get install -y runit 
CMD export > /etc/envvars && /usr/sbin/runsvdir-start
RUN echo 'export > /etc/envvars' >> /root/.bashrc

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common jq psmisc

RUN wget -O - http://web.eecs.umich.edu/~jahausw/download/sirius-1.0.1.tar.gz | tar xz
RUN mv sirius* sirius

RUN cd /sirius/sirius-application && \
    tar xzf question-answer.tar.gz

RUN cd /sirius/sirius-application && \
    ./get-dependencies.sh

RUN cd /sirius/sirius-application && \
    ./get-opencv.sh

RUN cd /sirius/sirius-application && \
    ./get-kaldi.sh

RUN cd /sirius/sirius-application && \
    ./compile-sirius-servers.sh

#Needed by sirius-web
RUN apt-get install -y python-openssl

#Need by image server
RUN apt-get install -y python-simplejson

ENV LD_LIBRARY_PATH /usr/local/lib

RUN cd /sirius/sirius-application/question-answer && \
    wget -O - http://web.eecs.umich.edu/~jahausw/download/wiki_indri_index.tar.gz | tar xz

#Add runit services
#ADD sv /etc/service 

