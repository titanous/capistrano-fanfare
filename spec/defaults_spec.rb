require 'minitest/autorun'
require 'capistrano/fanfare'
require 'capistrano/fanfare/defaults'

describe Capistrano::Fanfare::Defaults do
  before do
    @config = Capistrano::Configuration.new
    Capistrano::Fanfare::Defaults.load_into(@config)
    ENV['BRANCH'] = nil
  end

  it "sets :scm to :git" do
    @config.fetch(:scm).must_equal :git
  end

  it "sets :use_sudo to false" do
    @config.fetch(:use_sudo).must_equal false
  end

  it "sets :user to 'deploy'" do
    @config.fetch(:user).must_equal "deploy"
  end

  describe ":branch" do
    it "sets to master by default" do
      @config.fetch(:branch).must_equal "master"
    end

    it "sets to ENV['BRANCH'] if set" do
      ENV['BRANCH'] = "tree-branch"

      @config.fetch(:branch).must_equal "tree-branch"
    end
  end

  describe ":deploy_env" do
    before do
      @config.set :stage,     "stage_env"
      @config.set :rails_env, "railsy_baby"
      @config.set :rack_env,  "rackish_dude"

      ENV['RAILS_ENV']  = "rails_env_hash"
      ENV['RACK_ENV']   = "rack_env_hash"
    end

    after do
      ENV.delete 'RAILS_ENV'
      ENV.delete 'RACK_ENV'
    end

    it "sets to :stage if it exists" do
      @config.fetch(:deploy_env).must_equal "stage_env"
    end

    it "set to :rails_env if :stage isn't present" do
      @config.unset :stage

      @config.fetch(:deploy_env).must_equal "railsy_baby"
    end

    it "set to ENV['RAILS_ENV'] if :stage and :rails_env arent't present" do
      @config.unset :stage
      @config.unset :rails_env

      @config.fetch(:deploy_env).must_equal "rails_env_hash"
    end

    it "set to :rack_env if :stage, :rails_env, and ENV['RAILS_ENV'] arent't present" do
      @config.unset :stage
      @config.unset :rails_env
      ENV.delete 'RAILS_ENV'

      @config.fetch(:deploy_env).must_equal "rackish_dude"
    end

    it "set to ENV['RACK_ENV'] if :stage, :rails_env, ENV['RAILS_ENV'], and :rack_env arent't present" do
      @config.unset :stage
      @config.unset :rails_env
      @config.unset :rack_env
      ENV.delete 'RAILS_ENV'

      @config.fetch(:deploy_env).must_equal "rack_env_hash"
    end

    it "set to 'production' as a fallback" do
      @config.unset :stage
      @config.unset :rails_env
      @config.unset :rack_env
      ENV.delete 'RAILS_ENV'
      ENV.delete 'RACK_ENV'

      @config.fetch(:deploy_env).must_equal "production"
    end
  end
end