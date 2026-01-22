FROM debian:trixie-slim
ARG SRSMILTER_VERSION=0.3.3


RUN apt-get update && \
    apt-get install -fy --no-install-recommends curl ca-certificates && \
    apt-get -fy dist-upgrade && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}

RUN curl -o srs-milter.deb -L \
    https://github.com/d--j/srs-milter/releases/download/v${SRSMILTER_VERSION}/srs-milter_${SRSMILTER_VERSION}_linux_`dpkg --print-architecture`.deb && \
    dpkg -i srs-milter.deb

ADD entrypoint /entrypoint

EXPOSE 10382
EXPOSE 10383

ENTRYPOINT ["/entrypoint"]
CMD ["/usr/bin/srs-milter", "-milterAddr", "0.0.0.0:10382", "-socketmapAddr", "0.0.0.0:10383"]
