FROM ubuntu:14.04
MAINTAINER someone

RUN apt-get update && apt-get upgrade -y && apt-get install -y python3-pip\
    git

RUN pip3 install uwsgi

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8


RUN useradd uid1000 -d /home/uid1000
RUN mkdir -p /home/uid1000 && chown uid1000: /home/uid1000
VOLUME /home/uid1000

ADD requirements.txt /opt/code/requirements.txt
WORKDIR /opt/code
RUN pip3 install -Ur requirements.txt
ADD . /opt/code

RUN chown -R uid1000: /opt
RUN chmod 500 /opt/code/flaskdump/start.sh
WORKDIR flaskdump

EXPOSE 5000
USER root
CMD ["./start.sh"]
