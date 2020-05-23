module Talty
  class Exp
    def evaluate
        raise 'Exp.evaluate should not be called!'
    end
  end

  class BinaryExp < Exp
    attr_reader :left, :op, :right
    def initialize(left, op, right)
        @left = left
        @op = op
        @right = right
    end

    def evaluate
        lval = @left.evaluate
        rval = @right.evaluate
        
        if @op.symbol == :+
            return lval + rval
        elsif @op.symbol == :-
            return lval - rval
        elsif @op.symbol == :*
            return lval * rval
        elsif @op.symbol == :/
            return lval / rval
        else
            raise 'Wrong operation'
        end
    end
  end

  class UnaryExp < Exp
    attr_reader :op, :right
    def initialize(op, right)
        @op = op
        @right = right
    end

    def evaluate
        val = @right.evaluate
        op.nil? ? val : -val
    end
  end

  class LiteralExp < Exp
    attr_reader :value
    def initialize(value)
        @value = value
    end

    def evaluate
        @value
    end
  end

  class GroupingExp
    attr_reader :child
    def initialize(child)
        @child = child
    end

    def evaluate
        child.evaluate
    end
  end

  class Parser
    def parse(tokens)
        @tokens = tokens
        @current = 0
        expression
    end

    def peek
        @tokens[@current]
    end
    
    def previous
        @tokens[@current - 1]
    end

    def advance
        @current += 1 if @tokens.any?
        previous
    end

    def check(token)
        return false if @tokens.empty?
        !(peek.nil?) && peek.symbol == token
    end

    def match(tokens)
        for token in tokens
            if (check(token))
                advance
                return true
            end
        end

        return false
    end

    def expression
        addition
    end

    def addition
        exp = multiplication
        
        while match([:+, :-])
            operator = previous
            right = multiplication
            exp = BinaryExp.new(exp, operator, right)
        end

        exp
    end

    def multiplication
        exp = unary

        while match([:*, :/])
            operator = previous
            right = unary
            exp = BinaryExp.new(exp, operator, right)
        end

        exp
    end

    def unary
        if match([:-])
            right = unary
            return UnaryExp.new(:-, right)
        end

        primary
    end

    def primary
        if (match([:NUMBER]))
            return LiteralExp.new(previous.data)
        end

        if (match([:OPEN_PAR]))
            exp = expression
            consume(:CLOSE_PAR, "Expected ')' after expression")
            GroupingExp.new(exp)
        end
    end

    def consume(token, message)
        return advance if (check(token))
        raise "#{token}: #{message}"
    end
  end
end