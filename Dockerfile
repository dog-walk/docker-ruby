# Set initial image
FROM debian:latest

# Set maintainer and image indo
LABEL Description="This image contains Ruby language" \
      Vendor="CodedRed" \
      Version="1.0" \
      Maintainer="Konstantin Kozhin <konstantin@codedred.com>"

# Set environment variables
ENV RUBY_VERSION 2.5.1

# Install packages
RUN apt-get update \
 && apt-get install git vim curl wget autoconf automake libffi-dev build-essential libssl-dev libreadline-dev zlib1g-dev -y \
 && apt-get clean all

# Set working directory
WORKDIR /root

# Install Vim colors
RUN mkdir -p ./.vim/colors
COPY vim/.vimrc ./
COPY vim/monokai.vim ./.vim/colors

# Install rbenv
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv \
 && git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build \
 && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile \
 && echo 'eval "$(rbenv init -)"' >> ~/.bash_profile \
 && rm -Rf /tmp/* \
 && echo 'source ~/.bash_profile' >> ~/.bashrc

# Install selected Ruby version
RUN bash -c "source ~/.bash_profile \
 && rbenv install $RUBY_VERSION \
 && rbenv local $RUBY_VERSION \
 && rbenv global $RUBY_VERSION \
 && rbenv rehash \
 && gem install bundler"

# Set command
CMD ["bash"]
