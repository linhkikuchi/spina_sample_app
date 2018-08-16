# lib/tasks/db.rake
# https://gist.github.com/hopsoft/56ba6f55fe48ad7f8b90

namespace :db do

  desc "Dumps the database to db/APP_NAME.dump"
  task :dump => :environment do
    cmd = nil
    with_config do |app, host, db, user, pass|
      cmd = "PGPASSWORD=\"#{pass}\" pg_dump --host #{host} --username #{user} --no-password --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/#{app}.dump"
    end
    exec cmd
  end

  desc "Restores the database dump at db/APP_NAME.dump."
  task :restore => :environment do
    cmd = nil
    with_config do |app, host, db, user, pass|
      cmd = "PGPASSWORD=\"#{pass}\" pg_restore --verbose --host #{host} --username #{user} --no-password --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/#{app}.dump"
    end
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    exec cmd
  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,
      ActiveRecord::Base.connection_config[:host] || 'localhost',
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username] || 'postgres',
      ActiveRecord::Base.connection_config[:password]
  end

end
