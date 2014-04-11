# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ruby-multi-progressbar"

Gem::Specification.new do |s|
	s.rubygems_version      = '1.3.5'

	s.name                  = 'ruby-multi-progressbar'
	s.rubyforge_project     = 'ruby-multi-progressbar'

	s.version               = MultiProgressBar::VERSION
	s.platform              = Gem::Platform::RUBY

	s.authors               = ["shaharhd"]
	s.email                 = 'shaharhd@gmail.com'
	s.date                  = Time.now
	s.homepage              = 'https://github.com/ShaharHD/ruby-multi-progressbar'

	s.summary               = 'Displays multiple progress bars using Ncurses.'
	s.description           = <<-THEDOCTOR
Displays multiple progress bars using Ncurses and ruby-progressbar
Useful for displaying the status of multiple test runs or multipile threads.
THEDOCTOR

	s.rdoc_options          = ['--charset', 'UTF-8']
	s.extra_rdoc_files      = %w[README.md]
	s.license               = 'LICENSE'

	#= Manifest =#
	s.files                 = Dir.glob("lib/**/*")
	s.test_files            = Dir.glob("{test,spec,features}/**/*")
	s.executables           = Dir.glob("bin/*").map{ |f| File.basename(f) }
	s.require_paths         = ["lib"]
end
