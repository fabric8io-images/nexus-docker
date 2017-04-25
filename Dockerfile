FROM jboss/base-jdk:8

ENV SONATYPE_WORK /sonatype-work
ENV NEXUS_VERSION 2.14.4-03

ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 74
ENV JAVA_VERSION_BUILD 02

USER root

RUN yum install -y \
  curl tar createrepo \
  && yum clean all

RUN mkdir -p /opt/sonatype/nexus \
  && curl --fail --silent --location --retry 3 \
    https://download.sonatype.com/nexus/oss/nexus-${NEXUS_VERSION}-bundle.tar.gz \
  | gunzip \
  | tar x -C /tmp nexus-${NEXUS_VERSION} \
  && mv /tmp/nexus-${NEXUS_VERSION}/* /opt/sonatype/nexus/ \
  && rm -rf /tmp/nexus-${NEXUS_VERSION}

RUN useradd -r -u 200 -m -c "nexus role account" -d ${SONATYPE_WORK} -s /bin/false nexus

WORKDIR /opt/sonatype/nexus

USER nexus
COPY startnexus /opt/sonatype/nexus/bin/startnexus
COPY nexus.xml /sonatype-work/conf/nexus.xml
COPY passwd.template /usr/local/share/passwd.template


USER root
RUN chgrp -R 0 /sonatype-work
RUN chmod -R g+rw /sonatype-work
RUN find /sonatype-work -type d -exec chmod g+x {} +

#USER 200

CMD /opt/sonatype/nexus/bin/startnexus
