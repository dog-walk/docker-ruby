# Set initial image
FROM debian:latest

# Set maintainer and image indo
MAINTAINER Konstantin Kozhin <konstantin@profitco.ru>
LABEL Description="This image contains Ruby language" Vendor="ProfitCo" Version="1.0"

# Set environment variables
ENV RUBY_VERSION 2.3.2

# Update package repository
RUN apt-get update -y

# Install required packages
RUN apt-get install build-essential git wget curl vim openssl libssl-dev libedit-dev zlib1g-dev libffi-dev libpq-dev libmysqlclient-dev libsqlite3-dev imagemagick sudo -y

# Install rbenv
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv \
 && git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build \
 && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile \
 && echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

# Install selected Ruby version
RUN bash -c "source ~/.bash_profile \
 && rbenv install $RUBY_VERSION \
 && rbenv local $RUBY_VERSION \
 && rbenv global $RUBY_VERSION \
 && rbenv rehash"

# Install Bundler
RUN bash -c "source ~/.bash_profile \
 && gem install bundler"

# Clean up tmp folder
RUN rm -Rf /tmp/*

# Clean up package repositories
RUN apt-get clean all

# Update Bash console
RUN echo 'source ~/.bash_profile' >> ~/.bashrc

# Set entrypoint
ENTRYPOINT ["bash"]
