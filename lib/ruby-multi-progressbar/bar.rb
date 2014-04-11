module MultiProgressBar
	# Represents a progress bar at the bottom of the screen.
	#
	# +Bar+ exposes the same interface as +ProgressBar+ from the +progressbar+
	# gem which backs its display.
	#
	#   file_progress = MultiProgressBar::Bar.new("file_1", 2596)
	#   file_progress.inc     # Increment value by 1.
	#   file_progress.inc(10) # Increment value by 10.
	#   file_progress.set(30) # Set value to 30.
	#
	#   # Change bar format.
	#   file_progress.format = "%-14s (%s) %3d%% %s"
	#   file_progress.format_arguments = [:title, :stat, :percentage, :bar].
	#
	# See the +ruby-progressbar+ gem (http://0xcc.net/ruby-progressbar/index.html.en)
	# for more details.
	#
	# MultiProgressBar::Bar makes two additional format arguments available: :current
	# and :total.  These display the current and total values respectively.
	class Bar < DelegateClass(BarRenderer)
		attr_reader :color

		# Create a new Bar with a +title+ and a +total+ value.
		def initialize(title, total)
			MultiProgressBar.add_bar(self)

			@observers = []

			@renderer = BarRenderer.new(title, total, MultiProgressBar.width) do |rendered_bar|
				MultiProgressBar.update_bar(self, rendered_bar)
			end

			super @renderer
		end

		# Increment the current value of the bar.
		def inc(step = 1)
			super
			notify_observers
		end

		# Set the current value of the bar absolutely.
		def set(count)
			super
			notify_observers
		end

		# Set the progress to 100% and display elapsed time instead of ETA.
		def finish
			super
			notify_observers
		end

		def color=(color)
			@color = color
			show
		end

		def observe(&b)  #:nodoc:
			@observers << b
		end

		private
		def notify_observers
			@observers.each { |b| b.call(self) }
		end
	end
end
