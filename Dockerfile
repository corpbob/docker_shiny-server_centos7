FROM centos:centos7
MAINTAINER kris eberwein

RUN yum -y install epel-release
RUN yum update -y
RUN yum upgrade -y
RUN yum clean all -y
# RUN yum reinstall -y glibc-common
RUN yum install -y locales java-1.7.0-openjdk-devel tar wget

# R devtools pre-requisites:
RUN yum install -y git xml2 libxml2-devel curl curl-devel openssl-devel pandoc
# Plotly needs libcurl
RUN yum install libcurl-devel -y

WORKDIR /home/root
RUN yum install -y R

RUN R -e "install.packages(c('shiny', 'rmarkdown', 'devtools', 'RJDBC', 'dplyr', 'plotly', 'RPostgreSQL', 'lubridate', 'DT'), repos='http://cran.r-project.org', INSTALL_opts='--no-html')"

#-----------------------

# Add RStudio binaries to PATH
# export PATH="/usr/lib/rstudio-server/bin/:$PATH"
ENV LANG en_US.UTF-8

RUN yum install -y openssl098e supervisor passwd pandoc


RUN wget https://download3.rstudio.org/centos6.3/x86_64/shiny-server-1.5.9.923-x86_64.rpm
RUN yum -y install --nogpgcheck shiny-server-1.5.9.923-x86_64.rpm \
	&& rm -rf shiny-server-1.5.9.923-x86_64.rpm

RUN mkdir -p /var/log/shiny-server \
	&& chown shiny:shiny /var/log/shiny-server \
	&& chown shiny:shiny -R /srv/shiny-server \
	&& chmod 755 -R /srv/shiny-server \
	&& chown shiny:shiny -R /opt/shiny-server/samples/sample-apps \
	&& chmod 755 -R /opt/shiny-server/samples/sample-apps 

EXPOSE 3838


CMD ["/usr/bin/shiny-server"] 
