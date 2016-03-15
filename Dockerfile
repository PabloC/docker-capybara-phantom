FROM freshbooks/ruby

ENV DEBIAN_FRONTEND noninteractive

ENV buildDependencies curl

ENV phantomJSDependencies\
 libfontconfig1 libjpeg8 libfreetype6

RUN apt-get update -yqq \
    && apt-get install -fyqq ${buildDependencies} ${phantomJSDependencies}\
    && curl -LO https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
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

COPY Gemfile /usr/src/Gemfile
ENV BUNDLE_GEMFILE /usr/src/Gemfile
ENV BUNDLE_PATH /vendor/bundle
ENV rubyDependencies\
  ruby2.0-dev make gcc zlib1g-dev libxml2-dev patch
RUN apt-get update -yqq \
    && apt-get install -fyqq ${rubyDependencies} \
    && bundle install \
    && apt-get purge -yqq ${rubyDependencies} \
    && apt-get autoremove -yqq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
