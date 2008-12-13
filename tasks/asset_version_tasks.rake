desc "Explaining what the task does"
namespace :asset_version do
  task :install do
    require 'ftools'

    source = File.join(File.dirname(__FILE__), '..', 'initializers', 'asset_version.rb')
    destination = File.join(RAILS_ROOT, 'config', 'initializers', 'asset_version.rb')
    File.copy(source, destination)
    puts "Installed #{destination}"
  end
end