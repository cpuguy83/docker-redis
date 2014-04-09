FROM cpuguy83/debian:jessie

ADD http://download.redis.io/redis-stable.tar.gz /tmp/
WORKDIR /tmp
RUN apt-get update -qq && apt-get install -y build-essential -qq
RUN tar -zxvf redis-stable.tar.gz && cd redis-stable && make && cp src/redis-server /usr/local/bin/redis-server && cp src/redis-cli /usr/local/bin/redis-cli
RUN apt-get remove -y build-essential -qq && apt-get clean && apt-get autoremove -y -qq
ADD redis.conf /etc/redis.conf
RUN useradd --system redis
RUN mkdir /var/redis && touch /var/redis/.foo && chown -R redis.redis /var/redis
USER redis

VOLUME /var/redis
EXPOSE 6379
ENTRYPOINT ["/usr/local/bin/redis-server"]
CMD ["/etc/redis.conf"]
