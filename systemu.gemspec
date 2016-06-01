## systemu.gemspec
#

Gem::Specification::new do |spec|
  spec.name = "systemu"
  spec.version = "2.6.5"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "systemu"
  spec.description = "universal capture of stdout and stderr and handling of child process pid for windows, *nix, etc."
  spec.license = "Ruby"

  spec.files = `git ls-files`.split("\n").
    select { |f| f =~ /^(lib)/ ||
                 f =~ /^History|LICENSE|README|Rakefile|Mavenfile|pom.xml/i } +
    Dir.glob('lib/**/*.jar') # 'lib/jopenssl.jar' and potentially BC jars

  spec.executables = []

  spec.require_path = "lib"

  spec.test_files = nil



  spec.extensions.push(*[])

  spec.rubyforge_project = "codeforpeople"
  spec.author = "Ara T. Howard"
  spec.email = "ara.t.howard@gmail.com"
  spec.homepage = "https://github.com/ahoward/systemu"
end
