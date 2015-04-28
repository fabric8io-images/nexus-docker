FROM sonatype/nexus:oss
MAINTAINER fabric8.io (http://fabric8.io/)

ADD nexus.xml /sonatype-work/conf/nexus.xml
USER root
RUN chown -R nexus:nexus /sonatype-work/conf
USER nexus
