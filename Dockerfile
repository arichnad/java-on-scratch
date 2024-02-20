


# *** SEE README.md for how to use ***

FROM scratch

ARG JAVA_PATH=/usr/lib/jvm/java-17-openjdk-amd64

COPY packages/busybox /bin/busybox

RUN ["busybox", "--install", "-s", "/bin"]

COPY packages /packages

RUN mkdir --parents /usr /var/lib/dpkg /var/lib/dpkg/info /etc/alternatives && \
	ln -s /bin /usr/bin && \
	touch /var/lib/dpkg/status && \
	dpkg --force-depends -i /packages/*.deb && \
	rm -rf /packages


RUN ln -s $JAVA_PATH/bin/java* /usr/bin

CMD "sh"

