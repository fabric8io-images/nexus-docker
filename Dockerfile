# Using the docker-nexus3 Dockerfile, removing VOLUME to run on OpenShift
# Until we have initContainers in Kubernetes 1.4 we have to use a custom script to configure nexus after starting
FROM fabric8/java-centos-openjdk8-jre

ENV NEXUS_DATA /nexus-data

ENV NEXUS_VERSION 3.0.2-02

RUN yum install -y \
  curl tar \
  && yum clean all

# install nexus
RUN mkdir -p /opt/sonatype/nexus \
  && curl --fail --silent --location --retry 3 \
    https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz \
  | gunzip \
  | tar x -C /opt/sonatype/nexus --strip-components=1 nexus-${NEXUS_VERSION} \
  && chown -R root:root /opt/sonatype/nexus

## configure nexus runtime env
RUN sed \
    -e "s|karaf.home=.|karaf.home=/opt/sonatype/nexus|g" \
    -e "s|karaf.base=.|karaf.base=/opt/sonatype/nexus|g" \
    -e "s|karaf.etc=etc|karaf.etc=/opt/sonatype/nexus/etc|g" \
    -e "s|java.util.logging.config.file=etc|java.util.logging.config.file=/opt/sonatype/nexus/etc|g" \
    -e "s|karaf.data=data|karaf.data=${NEXUS_DATA}|g" \
    -e "s|java.io.tmpdir=data/tmp|java.io.tmpdir=${NEXUS_DATA}/tmp|g" \
    -i /opt/sonatype/nexus/bin/nexus.vmoptions

RUN useradd -r -u 200 -m -c "nexus role account" -d ${NEXUS_DATA} -s /bin/false nexus

ENV EXTRA_JAVA_OPTS ""

EXPOSE 8081

ADD *.json /opt/sonatype/nexus/
ADD postStart.sh /opt/sonatype/nexus/

RUN chown nexus:nexus /opt/sonatype/nexus/

USER nexus
WORKDIR /opt/sonatype/nexus

CMD bin/nexus run
