FROM sonatype/nexus:oss
MAINTAINER fabric8.io (http://fabric8.io/)

USER root
ADD nexus.xml /sonatype-work/conf/nexus.xml
RUN chown nexus:nexus /sonatype-work/conf/nexus.xml
USER nexus
