FROM ruby:3.0.2

WORKDIR /app
#ADD ./app/Gemfile /app/Gemfile
#ADD ./app/Gemfile.lock /app/Gemfile.lock
#RUN bundle install --system
#
ADD ./app /app
RUN bundle install --system

EXPOSE 4567

CMD ["ruby", "app.rb"]
