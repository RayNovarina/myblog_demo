from ruby

env DEBIAN_FRONTEND=noninteractive \
  NODE_VERSION=6.9.1

run sed -i '/deb-src/d' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y build-essential libpq-dev postgresql-client

run curl -sSL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" | tar xfJ - -C /usr/local --strip-components=1 && \
  npm install npm -g

run useradd -m -s /bin/bash -u 1000 railsuser
user railsuser

workdir /app

# Works:
# docker-compose run -p 3000:3000 web bash -c "bin/rails server -b 0.0.0.0"

# problem with run from DockerHub:
# $ docker run --rm --name myblog_demo -it -p 3000:3000 miadocker/myblog_demo:v2 /bin/bash -c "bundle install; bin/rails server -b 0.0.0.0"
#   There was an error while trying to write to `/app/.bundle/config`. It is likely
#   that you need to grant write permissions for that path.
#
#      /bin/bash: bin/rails: No such file or directory
