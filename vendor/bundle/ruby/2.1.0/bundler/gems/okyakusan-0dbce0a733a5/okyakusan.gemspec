# -*- encoding: utf-8 -*-
# stub: okyakusan 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "okyakusan"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Terence Lee"]
  s.date = "2014-12-07"
  s.description = "Wrapper Around net/http to be used with Heroku API V3"
  s.email = ["hone02@gmail.com"]
  s.files = [".gitignore", "Gemfile", "LICENSE.txt", "README.md", "Rakefile", "lib/okyakusan.rb", "lib/okyakusan/client.rb", "lib/okyakusan/version.rb", "okyakusan.gemspec", "spec/artifice/heroku_api.rb", "spec/okyakusan/client_spec.rb", "spec/okyakusan_spec.rb", "spec/rspec_helper.rb"]
  s.homepage = ""
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Wrapper Around net/http to be used with Heroku API V3"
  s.test_files = ["spec/artifice/heroku_api.rb", "spec/okyakusan/client_spec.rb", "spec/okyakusan_spec.rb", "spec/rspec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<netrc>, ["~> 0.7.7"])
      s.add_development_dependency(%q<bundler>, ["~> 1.6"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<netrc>, ["~> 0.7.7"])
      s.add_dependency(%q<bundler>, ["~> 1.6"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<netrc>, ["~> 0.7.7"])
    s.add_dependency(%q<bundler>, ["~> 1.6"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
