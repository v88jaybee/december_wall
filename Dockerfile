# Start from a small, trusted base image with the version pinned down
FROM ruby:2.3.3-alpine AS base

# Install system dependencies required both at runtime and build time
# The image uses Postgres but you can swap it with mariadb-dev (for MySQL) or sqlite-dev
RUN apk update && apk upgrade && \
  apk --no-cache add mysql-dev tzdata && \
  rm -rf /var/cache/apk/*

# Install system dependencies required to build some Ruby gems (pg)
RUN apk add --update build-base

# We'll install the app in this directory
RUN mkdir -p /var/www/your-wall
WORKDIR /var/www/your-wall

COPY Gemfile /var/www/your-wall

# Update gems (excluding development/test dependencies)
RUN bundle update

EXPOSE 3000


# rails: https://lipanski.com/posts/dockerfile-ruby-best-practices
#   - config.file_watcher = ActiveSupport::FileUpdateChecker
#   - docker-compose run wall rake db:migrate
#   - docker-compose run wall rake db:migrate