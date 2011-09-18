desc "Invokes the test suite in multiple RVM environments"
task :'test!' do
  # Override this by adding RVM_TEST_ENVS=".." in .rvmrc
  envs = ENV['RVM_TEST_ENVS'] || '1.9.2@reacco,,1.8.7@reacco'
  puts "* Testing in the following RVM environments: #{envs.gsub(',', ', ')}"
  system "rvm #{envs} rake test" or abort
end

desc "Runs tests"
task :test do
  Dir['test/*_test.rb'].each { |f| load f }
end

task :default => :test

gh = "rstacruz/reacco"
namespace :doc do
  # http://github.com/rstacruz/reacco
  desc "Builds the documentation into doc/"
  task :build do
    analytics = "--analytics #{ENV['ANALYTICS_ID']}"  if ENV['ANALYTICS_ID']
    system "reacco -a --github #{gh} #{analytics} --api lib"
  end

  # http://github.com/rstacruz/git-update-ghpages
  desc "Posts documentation to GitHub pages"
  task :deploy => :build do
    system "git update-ghpages #{gh} -i doc/"
  end
end

task :doc => :'doc:build'
