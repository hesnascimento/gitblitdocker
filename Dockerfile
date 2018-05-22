# Basics
#
FROM ubuntu:latest
LABEL Henrique Souza Nascimento <hesnascimento@gmail.com>
RUN apt-get update
RUN apt-get install -q -y git-core redis-server

# Install Java 7

RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y software-properties-common
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y python-software-properties
RUN DEBIAN_FRONTEND=noninteractive apt-add-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get install oracle-java8-installer -y

# Install Gitblit

RUN apt-get install -q -y curl
RUN curl -Lks http://dl.bintray.com/gitblit/releases/gitblit-1.8.0.tar.gz -o /root/gitblit.tar.gz
RUN mkdir -p /opt/gitblit-tmp
RUN tar zxf /root/gitblit.tar.gz -C /opt/gitblit-tmp
RUN mv /opt/gitblit-tmp/gitblit-1.8.0 /opt/gitblit
RUN rm -rf /opt/gitblit-tmp
RUN rm -f /root/gitblit.tar.gz

# Move the data files to a separate directory
RUN mkdir -p /opt/gitblit-data

RUN mv /opt/gitblit/data/* /opt/gitblit-data

# Adjust the default Gitblit settings to bind to 80, 443, 9418, 29418, and allow RPC administration.
#
# Note: we are writing to a different file here because sed doesn't like to the same file it
# is streaming.  This is why the original properties file was renamed earlier.

RUN echo "server.httpPort=80" >> /opt/gitblit-data/gitblit.properties
RUN echo "server.httpsPort=443" >> /opt/gitblit-data/gitblit.properties
RUN echo "server.redirectToHttpsPort=false" >> /opt/gitblit-data/gitblit.properties
RUN echo "web.enableRpcManagement=true" >> /opt/gitblit-data/gitblit.properties
RUN echo "web.enableRpcAdministration=true" >> /opt/gitblit-data/gitblit.properties
RUN echo "git.repositoriesFolder=/opt/gitblit-repository" >> /opt/gitblit-data/gitblit.properties

# Setup the Docker container environment and run Gitblit
WORKDIR /opt/gitblit
EXPOSE 80
EXPOSE 443
EXPOSE 9418
EXPOSE 29418
CMD ["java", "-server", "-Xmx1024M", "-Djava.awt.headless=true", "-jar", "/opt/gitblit/gitblit.jar", "--baseFolder", "/opt/gitblit-data"]
