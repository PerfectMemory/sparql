module SPARQL; module Algebra
  class Operator
    ##
    # The SPARQL GraphPattern `reduced` operator.
    #
    # @example
    #   (prefix ((xsd: <http://www.w3.org/2001/XMLSchema#>)
    #            (: <http://example/>))
    #     (reduced
    #       (project (?v)
    #         (bgp (triple ?x ?p ?v)))))
    #
    # @see http://www.w3.org/TR/sparql11-query/#sparqlAlgebra
    class Reduced < Operator::Unary
      include Query
      
      NAME = [:reduced]

      ##
      # Executes this query on the given `queryable` graph or repository.
      # Removes duplicate solutions from the solution set.
      #
      # @param  [RDF::Queryable] queryable
      #   the graph or repository to query
      # @param  [Hash{Symbol => Object}] options
      #   any additional keyword options
      # @yield  [solution]
      #   each matching solution
      # @yieldparam  [RDF::Query::Solution] solution
      # @yieldreturn [void] ignored
      # @return [RDF::Query::Solutions]
      #   the resulting solution sequence
      # @see    http://www.w3.org/TR/sparql11-query/#sparqlAlgebra
      def execute(queryable, options = {}, &block)
        @solutions = operands.last.
          execute(queryable, options.merge(depth: options[:depth].to_i + 1)).reduced
        @solutions.each(&block) if block_given?
        @solutions
      end
      
      ##
      # Returns an optimized version of this query.
      #
      # Return optimized query
      #
      # @return [Union, RDF::Query] `self`
      def optimize
        operands = operands.map(&:optimize)
      end
    end # Reduced
  end # Operator
end; end # SPARQL::Algebra
