FROM freshbooks/ruby

# Dependencies we just need for building phantomjs
ENV buildDependencies\
  wget unzip python build-essential g++ flex bison gperf\
  perl libsqlite3-dev libssl-dev libpng-dev ruby-dev \
  libicu-dev libfontconfig1-dev libjpeg-dev

# Dependencies we need for running phantomjs
ENV phantomJSDependencies\
  libicu52 libfontconfig1 libjpeg8 libfreetype6

COPY Gemfile /usr/src/Gemfile
ENV BUNDLE_GEMFILE /usr/src/Gemfile
ENV BUNDLE_PATH /vendor/bundle

# Installing phantomjs
RUN \
    # Installing dependencies
    apt-get update -yqq \
&&  apt-get install -fyqq ${buildDependencies} ${phantomJSDependencies}\
    # Downloading src, unzipping & removing zip
&&  mkdir phantomjs \
&&  cd phantomjs \
&&  wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.0.0-source.zip \
&&  unzip phantomjs-2.0.0-source.zip \
&&  rm -rf /phantomjs/phantomjs-2.0.0-source.zip \
    # Building phantom
&&  cd phantomjs-2.0.0/ \
&&  ./build.sh --confirm --silent \
    # Removing everything but the binary
&&  ls -A | grep -v bin | xargs rm -rf \
    # Symlink phantom so that we are able to run `phantomjs`
&&  ln -s /phantomjs/phantomjs-2.0.0/bin/phantomjs /usr/local/share/phantomjs \
&&  ln -s /phantomjs/phantomjs-2.0.0/bin/phantomjs /usr/local/bin/phantomjs \
&&  ln -s /phantomjs/phantomjs-2.0.0/bin/phantomjs /usr/bin/phantomjs \
    # Removing build dependencies, clean temporary files
&&  bundle install
&&  apt-get purge -yqq ${buildDependencies} \
&&  apt-get autoremove -yqq \
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    # Checking if phantom works
&&  phantomjs -v
