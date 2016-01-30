FROM rails:4
MAINTAINER gordon.burgett@gmail.com

RUN apt-get update

# we need nginx
COPY install_nginx.sh install_nginx.sh
RUN /bin/bash install_nginx.sh && rm install_nginx.sh

# and supervisor
RUN apt-get install -y supervisor

# create the rails app, add locomotivecms as a dependency, install all the gems
RUN rails new engine --skip-bundle --skip-active-record
WORKDIR engine/

RUN bundle inject 'locomotivecms' '~> 3.0.0'

RUN bundle install --path vendor/bundle && \
	 bundle exec rails generate locomotive:install && \
	 bundle install --path vendor/bundle

# precompile all the assets so nginx can serve them
RUN RAILS_ENV=production SECRET_KEY_BASE='foo' bin/rake assets:precompile

# expose the nginx port
EXPOSE 8080

# create a volume for the sites
VOLUME /engine/public/sites

# copy all the config files into the image
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY config config

# start by running supervisord
ENTRYPOINT ["/usr/bin/supervisord"]