Capistrano::Configuration.instance(:must_exist).load do

  namespace :db do
    desc "setup database configuration for application server"
    task "setup", roles: :app do
      mkdir("#{shared_path}/config")
      database_setting_path = "#{shared_path}/config/database.yml"
      if remote_file_exists?(database_setting_path)
        warn '[SKIP] Database configuration exists already ...'
      else
        info "[Shared] Setup database configuration files ... "
        put File.read("config/database.example.yml"), database_setting_path
      end
    end
    after 'deploy:setup', 'db:setup'

    desc "setup database symlink for every time deploy"
    task :symlink_config, roles: :app do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end

    desc "web compile assets needs database configuration file"
    task :copy_example_database_config_for_assets_compiler, roles: :web do
      run "cp #{release_path}/config/database.example.yml #{release_path}/config/database.yml"
    end
    after "deploy:finalize_update", "db:copy_example_database_config_for_assets_compiler", "db:symlink_config"
  end
end
