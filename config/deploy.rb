require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

set :domain, '139.162.213.166'
set :deploy_to, '/var/www/samstarling.co.uk'
set :repository, 'git@github.com:samstarling/samstarling.co.uk.git'
set :branch, 'master'

set :user, 'samstarling'

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'bundle:install'
    queue "#{bundle_prefix} nanoc"
  end
end
