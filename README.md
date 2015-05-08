Fabric8 Sonatype Nexus
----------------------

Our distro of the OSS [Sonatype Nexus](http://www.sonatype.org/nexus/) based on the [sonatype/nexus:oss image](https://registry.hub.docker.com/u/sonatype/nexus/) which has additional configuration:

* adds the [JBoss Repository](https://repository.jboss.org/) to its proxy list
* adds a staging repository


Running this container
----------------------

```
docker run -d -p 8081:8081 --name nexus fabric8/nexus
```

If `dockerhost` is the host running docker then you can view the running Nexus at http://dockerhost:8081/

The default credentials are: `admin` / `admin123`.

For more detail on configuration options see the [sonatype nexus image documentation](https://registry.hub.docker.com/u/sonatype/nexus/).
