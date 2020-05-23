require_relative 'lexer'
require_relative 'parser'
require 'readline'

parser = Talty::Parser.new

loop do
  line = Readline.readline("talty> ", true)
  exit if line =~ /^(exit|quit|elo|nara)$/i

  begin
    tokens = Talty::Lexer.new(line).read_exp
    ast = parser.parse(tokens)
    p ast.evaluate
  rescue Exception => error
    # ANSI escaped red
    puts "\e[31m"
    puts "on #{error.backtrace.pop}: #{error.message}"
    puts error.backtrace.map { |line| "\tfrom:#{line} " }
    # Clear ANSI escapes
    print "\e[0m"
  end
end