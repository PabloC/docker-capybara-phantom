FROM freshbooks/ruby23

ENV DEBIAN_FRONTEND noninteractive

ENV buildDependencies curl

ENV phantomJSDependencies\
 libfontconfig1 libjpeg8 libfreetype6

RUN apt-get update -yqq \
    && apt-get install -fyqq ${buildDependencies} ${phantomJSDependencies}\
    && curl -LO https://s3.amazonaws.com/shortstack-assets/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && bzcat phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar xf - \
    && mv phantomjs-2.1.1-linux-x86_64 /opt/phantomjs-2.1.1 \
    && ln -s /opt/phantomjs-2.1.1 /opt/phantomjs \
    && ln -s /opt/phantomjs/bin/phantomjs /usr/local/bin/phantomjs \
    && rm phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && apt-get purge -yqq ${buildDependencies} \
    && apt-get autoremove -yqq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    # Checking if phantom works
    && phantomjs -v
