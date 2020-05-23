require 'strscan'

module Talty
    class Token
        attr_reader :data, :symbol
        
        def initialize(symbol, data = nil)
          @symbol = symbol
          @data = data
        end
    end

    class Lexer
        def initialize(expression)
          @tokens = expression.scan /\(|\)|\+|\-|\*|\/|\d+/
        end

        def peek
          @tokens.first
        end
    
        def next_token
          @tokens.shift
        end
        
        def read
          return Token.new(:EOS) if @tokens.empty?
          
          if (token = next_token) =~ /\d+/
            Token.new(:NUMBER, token.to_i)
          elsif token == '('
            Token.new(:OPEN_PAR)
          elsif token == ')'
            Token.new(:CLOSE_PAR)
          else
            Token.new(token.to_sym)
          end
        end

        def read_exp
          tokens = []
          until (token = read).symbol == :EOS
            tokens << token
          end
          tokens
        end
    end
end