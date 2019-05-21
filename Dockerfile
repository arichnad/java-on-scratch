


# *** SEE README.md for how to use ***



FROM scratch

#the static busybox does not work because glibc is broken and getaddrinfo fails when used statically
#( https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=757941 )
COPY busybox /bin/busybox
#these are overwritten over further down
COPY ld-2.27.so /lib64/ld-linux-x86-64.so.2
COPY libc-2.27.so libc.so.6 ld-2.27.so  \
	libnss_dns-2.27.so libnss_dns.so.2 \
	libresolv-2.27.so libresolv.so.2 \
	/lib/x86_64-linux-gnu/

RUN ["busybox", "--install", "-s", "/bin"]

RUN mkdir --parents /usr && ln -s /bin /usr/bin

RUN mkdir --parents /var/lib/dpkg /var/lib/dpkg/info /etc/alternatives && touch /var/lib/dpkg/status && \
	wget \
		http://us.archive.ubuntu.com/ubuntu/pool/main/g/glibc/libc6_2.29-0ubuntu2_amd64.deb \
		http://us.archive.ubuntu.com/ubuntu/pool/main/g/gcc-9/libstdc++6_9.1.0-2ubuntu1_amd64.deb \
		http://us.archive.ubuntu.com/ubuntu/pool/main/g/gcc-9/libgcc1_9.1.0-2ubuntu1_amd64.deb \
		http://us.archive.ubuntu.com/ubuntu/pool/main/j/java-common/java-common_0.71_all.deb \
		http://us.archive.ubuntu.com/ubuntu/pool/main/z/zlib/zlib1g_1.2.11.dfsg-1ubuntu2_amd64.deb \
		
		http://us.archive.ubuntu.com/ubuntu/pool/main/o/openjdk-lts/openjdk-11-jre-headless_11.0.4+2-1ubuntu1_amd64.deb \
		
		http://us.archive.ubuntu.com/ubuntu/pool/main/o/openjdk-lts/openjdk-11-jdk-headless_11.0.4+2-1ubuntu1_amd64.deb \
		
		&& \
	dpkg --force-depends -i *.deb && \
	rm *.deb && \
	ln -s /usr/lib/jvm/java-11-openjdk-amd64/bin/java* /usr/bin

CMD "sh"

