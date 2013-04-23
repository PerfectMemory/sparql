module SPARQL; module Algebra
  class Operator
    ##
    # The SPARQL `Extend` operator.
    #
    # Extends a solution
    #
    # @example
    #   (select (?z)
    #     (project (?z)
    #       (extend ((?z (+ ?o 10)))
    #         (bgp (triple ?s <http://example/p> ?o)))))
    #
    # @see http://www.w3.org/TR/rdf-sparql-query/#evaluation
    class Extend < Operator::Binary
      include Query
      
      NAME = [:extend]

      ##
      # Let μ be a solution mapping, Ω a multiset of solution mappings, var a variable and expr be an expression, then we define:
      # 
      # Extend(μ, var, expr) = μ ∪ { (var,value) | var not in dom(μ) and value = expr(μ) }
      # 
      # Extend(μ, var, expr) = μ if var not in dom(μ) and expr(μ) is an error
      # 
      # Extend is undefined when var in dom(μ).
      # 
      # Extend(Ω, var, expr) = { Extend(μ, var, expr) | μ in Ω }
      # @return [RDF::Query::Solutions]
      #   the resulting solution sequence
      # @see http://www.w3.org/TR/rdf-sparql-query/#evaluation
      def execute(queryable, options = {})
        debug(options) {"Extend"}
        @solutions = operands.last.execute(queryable, options.merge(:depth => options[:depth].to_i + 1))
        @solutions.each do |solution|
          debug(options) {"===> soln #{solution.to_hash.inspect}"}
          operands.first.each do |(var, expr)|
            begin
              val = expr.evaluate(solution)
              debug(options) {"===> + #{var} => #{val.inspect}"}
              solution.bindings[var.to_sym] = val
            rescue TypeError => e
              # Evaluates to error, ignore
              debug(options) {"===> #{var} error: #{e.message}"}
            end
          end
        end
        @solutions
      end
      
      ##
      # Returns an optimized version of this query.
      #
      # Return optimized query
      #
      # @return FIXME
      def optimize
        operands = operands.map(&:optimize)
      end
    end # Filter
  end # Operator
end; end # SPARQL::Algebra
