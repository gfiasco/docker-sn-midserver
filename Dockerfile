FROM debian:9

# To get rid of error messages like "debconf: unable to initialize frontend: Dialog":
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

ARG SNOW_VERSION
ADD asset/* /opt/

RUN apt-get -q update && apt-get install -qy unzip \
    supervisor \
    xmlstarlet \
    vim \
    wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN wget --no-check-certificate \
      https://install.service-now.com/glide/distribution/builds/package/mid/2018/04/25/$SNOW_VERSION \
      -O /tmp/mid.zip && \
    unzip -d /opt /tmp/mid.zip && \
    mv /opt/agent/config.xml /opt/ && \
    chmod 755 /opt/init && \
    chmod 755 /opt/fill-config-parameter && \
    rm -rf /tmp/*

#EXPOSE 80 443

ENTRYPOINT ["/opt/init"]

CMD ["mid:start"]
