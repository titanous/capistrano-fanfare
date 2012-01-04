module Capistrano::Fanfare::Defaults
  def self.load_into(configuration)
    configuration.load do
      set :scm,         :git
      set :use_sudo,    false
      set :user,        "deploy"
      set(:branch)      { ENV['BRANCH'] ? ENV['BRANCH'] : "master" }

      ##
      # Determines deployment environment or run mode to help database naming,
      # deploy directories, etc.
      #
      # Thanks to capistrano-recipies for the great idea:
      # https://github.com/webficient/capistrano-recipes
      set(:deploy_env)  {
        if exists?(:stage)
          stage
        elsif exists?(:rails_env)
          rails_env
        elsif ENV['RAILS_ENV']
          ENV['RAILS_ENV']
        elsif exists?(:rack_env)
          rack_env
        elsif ENV['RACK_ENV']
          ENV['RACK_ENV']
        else
          "production"
        end
      }
    end
  end
end

if Capistrano::Configuration.instance
  Capistrano::Fanfare::Defaults.load_into(Capistrano::Configuration.instance)
end