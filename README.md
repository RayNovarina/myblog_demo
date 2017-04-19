# based on "Zero to Up and Running a Rails Project only using Docker" blog post
# at: https://blog.codeminer42.com/zero-to-up-and-running-a-rails-project-only-using-docker-20467e15f1be

#------------
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
Rays-MacBook-Pro:my-blog raynovarina$ docker images
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
myblog_web              latest              b09a50e1482e        5 minutes ago       759 MB
miadocker/myblog_demo   v1                  df5e0e477212        About an hour ago   752 MB
myblog_demo             latest              df5e0e477212        About an hour ago   752 MB
miadocker/rails5-demo   v1                  8687ae9a216d        4 days ago          693 MB
ruby                    latest              d2cee8adb148        3 weeks ago         678 MB
bartoffw/rails5         latest              2ccff8ff413a        8 months ago        566 MB
Rays-MacBook-Pro:my-blog raynovarina$ docker-compose run --rm -u root web bash -c "mkdir -p /bundle/vendor && chown -R railsuser /bundle/vendor"

Creating volume "myblog_db" with default driver
Pulling db (postgres:latest)...
latest: Pulling from library/postgres
6d827a3ef358: Already exists
9d7f5459c169: Pulling fs layer
ecb14191664d: Pull complete
ecd885727396: Pull complete
e1fc7408190a: Pull complete
a3cf57a1b661: Pull complete
91cef76ed67e: Pull complete
9236ca589ab4: Pull complete
69b3e91b94c5: Pull complete
cdc577dbd56f: Pull complete
db908b0ac3de: Pull complete
d80323bca9d7: Pull complete
88f943a70bad: Pull complete
Digest: sha256:3b51a72ca2642f24fa782c2fb99ddb0d29cbcd38f32639c98a80966a25ae2a64
Status: Downloaded newer image for postgres:latest
Creating myblog_db_1

#------------
$ docker-compose run --rm web bundle install
Using rake 12.0.0
Using concurrent-ruby 1.0.5

Using i18n 0.8.1
Using minitest 5.10.1
Using thread_safe 0.3.6
  .......
  Using rails 5.0.2
  Using sass-rails 5.0.6
  Bundle complete! 15 Gemfile dependencies, 62 gems now installed.
  Bundled gems are installed into /bundle/vendor.
  Rays-MacBook-Pro:my-blog raynovarina$ docker-compose run --rm web bundle exec rake db:create
  Created database 'myblog_development'
  Created database 'myblog_test'
  Rays-MacBook-Pro:my-blog raynovarina$ docker-compose run --rm web bundle exec rake db:migrate
  Rays-MacBook-Pro:my-blog raynovarina$ docker-compose run --rm web bundle exec rake db:seed


#------------
# Start web service and goto localhost:3000

$ docker-compose up
Creating network "myblog_default" with the default driver
Creating myblog_db_1
Creating myblog_web_1

Attaching to myblog_db_1, myblog_web_1
db_1   | LOG:  database system was shut down at 2017-04-19 22:38:41 UTC
db_1   | LOG:  MultiXact member wraparound protections are now enabled
db_1   | LOG:  database system is ready to accept connections
db_1   | LOG:  autovacuum launcher started
web_1  | => Booting Puma
web_1  | => Rails 5.0.2 application starting in development on http://0.0.0.0:3000
web_1  | => Run `rails server -h` for more startup options
web_1  | Puma starting in single mode...
web_1  | * Version 3.8.2 (ruby 2.4.1-p111), codename: Sassy Salamander
web_1  | * Min threads: 5, max threads: 5
web_1  | * Environment: development
web_1  | * Listening on tcp://0.0.0.0:3000
web_1  | Use Ctrl-C to stop
web_1  | Started GET "/tasks" for 172.20.0.1 at 2017-04-19 22:39:09 +0000
web_1  | Cannot render console from 172.20.0.1! Allowed networks: 127.0.0.1, ::1, 127.0.0.0/127.255.255.255
web_1  |   ActiveRecord::SchemaMigration Load (0.7ms)  SELECT "schema_migrations".* FROM "schema_migrations"
web_1  | Processing by TasksController#index as HTML
web_1  |   Rendering tasks/index.html.erb within layouts/application
web_1  |   Task Load (1.1ms)  SELECT "tasks".* FROM "tasks"
web_1  |   Rendered tasks/index.html.erb within layouts/application (34.3ms)
web_1  | Completed 200 OK in 516ms (Views: 461.9ms | ActiveRecord: 6.1ms)

#---------------------
$ docker run --rm --name myblog_demo -it -p 3000:3000 miadocker/myblog_demo:v2 /bin/bash -c "bundle install;
 bin/rails server -b 0.0.0.0"
There was an error while trying to write to `/app/.bundle/config`. It is likely that you need to grant write permissions for that path.
/bin/bash: bin/rails: No such file or directory
Rays-MacBook-Pro:my-blog raynovarina$ docker run --rm --name myblog_demo -it -u railsuser -p 3000:3000 miadocker/myblog_demo:v2 /bin/bash -c "bu
ndle install; bin/rails server -b 0.0.0.0"

There was an error while trying to write to `/app/.bundle/config`. It is likely that you need to grant write permissions for that path.
/bin/bash: bin/rails: No such file or directory
Rays-MacBook-Pro:my-blog raynovarina$ docker run --rm --name myblog_demo -it -u railsuser -p 3000:3000 miadocker/myblog_demo:v2 /bin/bash
railsuser@b5c1898fae52:/app$ ls
railsuser@b5c1898fae52:/app$ pwd
/app

#------------------
# Add scaffolding for minimal rails app else Heroku deploy will not open app "no route matches \"
$ docker-compose run --rm web bundle exec rails g scaffold task title:string notes:string due:datetime completion:integer
      invoke  active_record
      create    db/migrate/20170419201552_create_tasks.rb
      ..........
      invoke  scss
            create    /assets/stylesheets/scaffolds.scss

      Rays-MacBook-Pro:my-blog raynovarina$
      Rays-MacBook-Pro:my-blog raynovarina$
      Rays-MacBook-Pro:my-blog raynovarina$ docker-compose run --rm web bundle exec rails db:migrate
      == 20170419201552 CreateTasks: migrating ======================================
      -- create_table(:tasks)
         -> 0.0674s
      == 20170419201552 CreateTasks: migrated (0.0677s) =============================

#------------
remote:        An error occurred while installing sqlite3 (1.3.13), and Bundler cannot
remote:        continue.
remote:        Make sure that `gem install sqlite3 -v '1.3.13'` succeeds before bundling.
remote:  !
remote:  !     Failed to install gems via Bundler.
remote:  !     Detected sqlite3 gem which is not supported on Heroku:
remote:  !     https://devcenter.heroku.com/articles/sqlite3
remote:  !

remote:  !     Push rejected, failed to compile Ruby app.
remote:
remote:  !     Push failed
remote: Verifying deploy...
remote:
remote: !       Push rejected to myblog-demo-94037.
remote:
To https://git.heroku.com/myblog-demo-94037.git
 ! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'https://git.heroku.com/myblog-demo-94037.git'
Rays-MacBook-Pro:my-blog raynovarina$

$ git commit -m "change db from sqlite to postgresql so we can deploy to Heroku."
[master dace497] change db from sqlite to postgresql so we can deploy to Heroku.
 6 files changed, 36 insertions(+), 29 deletions(-)

 rewrite config/database.yml (86%)
Rays-MacBook-Pro:my-blog raynovarina$ git push origin master
Counting objects: 10, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (10/10), done.
Writing objects: 100% (10/10), 1.16 KiB | 0 bytes/s, done.
Total 10 (delta 7), reused 0 (delta 0)
remote: Resolving deltas: 100% (7/7), completed with 7 local objects.
To https://github.com/RayNovarina/myblog_demo.git
   d1a1ffb..dace497  master -> master
Rays-MacBook-Pro:my-blog raynovarina$ git push heroku master
Counting objects: 97, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (83/83), done.
Writing objects: 100% (97/97), 21.61 KiB | 0 bytes/s, done.
Total 97 (delta 9), reused 0 (delta 0)
remote: Compressing source files... done.
remote: Building source:
remote:
remote: -----> Ruby app detected
  ;'''''''''''''
  remote: -----> Launching...
  remote:        Released v5
  remote:        https://myblog-demo-94037.herokuapp.com/ deployed to Heroku
  remote:
  remote: Verifying deploy... done.
  To https://git.heroku.com/myblog-demo-94037.git
   * [new branch]      master -> master
  Rays-MacBook-Pro:my-blog raynovarina$ heroku ps:scale web=1 --app myblog-demo-94037
  Scaling dynos... done, now running web at 1:Free
  Rays-MacBook-Pro:my-blog raynovarina$ heroku run bash --app myblog-demo-94037
  Running bash on ⬢ myblog-demo-94037... up, run.1398 (Free)
  ~ $ rails db:create
  FATAL:  permission denied for database "postgres"

  $ heroku run rails db:migrate
  Running rails db:migrate on ⬢ myblog-demo-94037... up, run.2258 (Free)
  D, [2017-04-19T20:22:43.044680 #4] DEBUG -- :    (46.3ms)  CREATE TABLE "schema_migrations" ("version" character varying PRIMARY KEY)
  D, [2017-04-19T20:22:43.060376 #4] DEBUG --    

#------------------
$ docker tag myblog_demo miadocker/myblog_demo:v2
Rays-MacBook-Pro:my-blog raynovarina$ docker push miadocker/myblog_demo:v2


#---------------------
$ heroku container:push web
Sending build context to Docker daemon 888.3 kB
Step 1/7 : FROM ruby
 ---> d2cee8adb148
Step 2/7 : ENV DEBIAN_FRONTEND noninteractive NODE_VERSION 6.9.1
 ---> Using cache
 ---> c0875fb5af1f
Step 3/7 : RUN sed -i '/deb-src/d' /etc/apt/sources.list &&   apt-get update &&   apt-get install -y build-essential libpq-dev postgresql-client
 ---> Using cache
 ---> 198b1fd629c9
Step 4/7 : RUN curl -sSL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" | tar xfJ - -C /usr/local --strip-compone

nts=1 &&   npm install npm -g
 ---> Using cache
 ---> 4b8eaafc445e
Step 5/7 : RUN useradd -m -s /bin/bash -u 1000 railsuser
 ---> Using cache
 ---> 9022a1bab414
Step 6/7 : USER railsuser
 ---> Using cache
 ---> 22f1022ce2c9
Step 7/7 : WORKDIR /app
 ---> Using cache
 ---> b09a50e1482e
Successfully built b09a50e1482e
The push refers to a repository [registry.heroku.com/myblog-demo-94037/web]
b556076cf254: Preparing
b556076cf254: Pushed
0ec410e6363c: Pushed
4a19f22a9e37: Pushed
8e6133f6d26b: Pushed
fd8cb2d9bb24: Pushed
7e0b138fec00: Pushed
ac45884e47e6: Mounted from railsbox4-docker-94037/web
f078de0e3e2b: Mounted from notetakeing-app-94037-v2/web
e6562eb04a92: Mounted from notetakeing-app-94037-v2/web
7e0b138fec00: Pushed
ac45884e47e6: Mounted from railsbox4-docker-94037/web
f078de0e3e2b: Mounted from notetakeing-app-94037-v2/web
e6562eb04a92: Mounted from notetakeing-app-94037-v2/web
596280599f68: Mounted from notetakeing-app-94037-v2/web
5d6cbe0dbcf9: Mounted from notetakeing-app-94037-v2/web
latest: digest: sha256:3fa4a610d4385a9238e1f820d600571750c7360b4825af49597a648525fd3b7d size: 2840

# Refreshed browser page to start app:
  "crashed" Heroku msg.
Logs:
2017-04-19T23:24:55.534997+00:00 heroku[web.1]: State changed from down to starting
2017-04-19T23:25:11.081521+00:00 heroku[web.1]: Starting process with command `irb`
2017-04-19T23:25:14.111547+00:00 app[web.1]: Switch to inspect mode.
2017-04-19T23:25:14.113447+00:00 app[web.1]:
2017-04-19T23:25:14.247831+00:00 heroku[web.1]: State changed from starting to crashed
2017-04-19T23:25:14.248881+00:00 heroku[web.1]: State changed from crashed to starting
2017-04-19T23:25:14.235780+00:00 heroku[web.1]: Process exited with status 0
2017-04-19T23:25:48.878895+00:00 heroku[web.1]: Starting process with command `irb`
2017-04-19T23:25:50.847274+00:00 app[web.1]: Switch to inspect mode.
2017-04-19T23:25:50.848765+00:00 app[web.1]:
2017-04-19T23:25:50.925798+00:00 heroku[web.1]: Process exited with status 0
2017-04-19T23:25:50.940998+00:00 heroku[web.1]: State changed from starting to crashed

#--------------
Add Heroku Profile, app.json per https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server

# web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
web: bundle exec puma -C config/puma.rb
