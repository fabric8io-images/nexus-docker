FROM sonatype/nexus:oss
MAINTAINER fabric8.io (http://fabric8.io/)

USER root
COPY nexus.xml /sonatype-work/conf/nexus.xml
RUN chmod 777 /sonatype-work/conf /sonatype-work/conf/nexus.xml
RUN chown nexus /sonatype-work/conf /sonatype-work/conf/nexus.xml

# TODO we can't seem to run as anything but root right now due to permission issues
#USER nexus
