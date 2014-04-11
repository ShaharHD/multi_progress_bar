#!/usr/bin/env ruby

require 'rubygems'

$LOAD_PATH.unshift File.dirname(__FILE__)+"/../lib"
require 'ruby-progressbar'


begin
	MultiProgressBar.start

	# Demo.
	make_machine_bar = lambda { MultiProgressBar::Bar.new("(Waiting...)", 0) }
	machine_bars = [make_machine_bar[], make_machine_bar[]]
	total = MultiProgressBar::TotalBar.new("-Total-")

	machine_names = ["bleeker", "montrose"]

	until machine_bars.all? { |bar| bar.title != "(Waiting...)" && bar.current == bar.total }
		sleep(0.1)

		# Simulate machines becoming available.
		machine_bars.each do |bar|
			if bar.title == "(Waiting...)"
				bar.title = machine_names.pop if rand(10) == 0
				bar.total = 100
			else
				bar.inc(rand(10))
			end
		end

		MultiProgressBar.log(rand(2000))
	end
ensure
	MultiProgressBar.end
end
