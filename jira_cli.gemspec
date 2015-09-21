# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','jira_cli','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'jira_cli'
  s.version = JiraCli::VERSION
  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','jira_cli.rdoc']
  s.rdoc_options << '--title' << 'jira_cli' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'jira_cli'
  s.add_runtime_dependency('gli','2.13.2')
  s.add_runtime_dependency('rainbow', '2.0.0')
  s.add_runtime_dependency('launchy', '2.4.2')
  s.add_runtime_dependency('highline','1.6.21')
  s.add_runtime_dependency('jira-ruby', '0.1.14')
  s.add_runtime_dependency('git', '1.2.9.1')
end
