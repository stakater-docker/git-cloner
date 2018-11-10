FROM debian:stretch

RUN apt-get update && apt-get install -y git

ARG USER=1001

ADD [--chown=$USER:root] init.sh /
RUN chmod +x /init.sh

USER root

RUN mkdir /root/.ssh/ && \
	mkdir /repository && \
	touch /root/.ssh/known_hosts && \
	echo "\nStrictHostKeyChecking no" >> /etc/ssh/ssh_config

RUN chgrp -R 0 /root && \
    chmod -R g=u /root

# Clean up
RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/init.sh"]
