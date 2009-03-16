# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-recaptcha}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Johannes Barre"]
  s.date = %q{2009-03-16}
  s.description = %q{My almost unchanged fork of ruby-recaptcha}
  s.email = %q{igel@igels.net}
  s.extra_rdoc_files = ["lib/recaptcha.rb", "lib/ruby-recaptcha.rb", "README.textile"]
  s.files = ["Manifest", "Rakefile", "test/test_recaptcha.rb", "test/test_helper.rb", "script/console", "script/generate", "script/destroy", "lib/recaptcha.rb", "lib/ruby-recaptcha.rb", "README.textile", "ruby-recaptcha.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://bitbucket.org/mml/ruby-recaptcha/wiki/Home}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Ruby-recaptcha", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ruby-recaptcha}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{My almost unchanged fork of ruby-recaptcha}
  s.test_files = ["test/test_recaptcha.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
