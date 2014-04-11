require 'ncurses'
require 'ruby-progressbar'
require 'delegate'

module MultiProgressBar
  class << self
    attr_reader :bars

    # Set up the screen.  Always call +MultiProgressBar.start+ before using progress bars.
    def start
      @bars = [].freeze

      Ncurses.initscr
      Ncurses.curs_set(0)
      Ncurses.start_color

      (0..7).each { |color_number| Ncurses.init_pair(color_number, color_number, Ncurses::COLOR_BLACK); }

      @bars_window = Ncurses::WINDOW.new(1, 0, Ncurses.LINES-1, 0)
      @log_window  = Ncurses::WINDOW.new(Ncurses.LINES-1, 0, 0, 0)
      @log_window.scrollok(true)

      trap("SIGWINCH") do
        Ncurses.endwin
        Ncurses.refresh

        refresh_window_positions

        @bars.each do |bar|
          bar.width = @bars_window.getmaxx
          bar.show
        end
      end
    end

    # Restore the terminal to normal function.  Always call this before exiting.
    def end
      # Give an extra line below the output for the shell to prompt on.
      add_bar(nil)

      Ncurses.endwin
    end

    # Write +text+ to the space above the progress bars.
    def log(text)
      text = text.to_s

      # Parse ANSI escape codes.
      text.scan(/([^\e]*)(?:\e\[(\d+.))?/) do |normal_text, code|
        @log_window.addstr(normal_text)
        case code
          when /3(\d)m/
            @log_window.attron(Ncurses.COLOR_PAIR($1.to_i))
          when /0m/
            @log_window.attron(Ncurses.COLOR_PAIR(7))
        end
      end
      @log_window.addstr("\n")
      @log_window.refresh
    end

    def width  #:nodoc:
      @bars_window.getmaxx
    end

    def refresh_window_positions
      @bars_window.mvwin(Ncurses.LINES-bars.size, @bars_window.getbegx)
      @bars_window.resize(bars.size, @bars_window.getmaxx)
      @bars_window.refresh

      @log_window.resize(Ncurses.LINES-bars.size, @log_window.getmaxx)
      @log_window.refresh
    end

    def add_bar(bar)  #:nodoc:
      @bars += [bar]
      refresh_window_positions
    end

    def update_bar(bar, rendered_bar)  #:nodoc:
      @bars_window.move(bars.index(bar), 0)
      @bars_window.attron(Ncurses.COLOR_PAIR(bar.color)) if bar.color
      @bars_window.addstr(rendered_bar)
      @bars_window.attroff(Ncurses.COLOR_PAIR(bar.color)) if bar.color
      @bars_window.refresh
    end
  end
end

require 'ruby-multi-progressbar/version'
require 'ruby-multi-progressbar/bar_renderer'
require 'ruby-multi-progressbar/bar'
require 'ruby-multi-progressbar/total_bar'
