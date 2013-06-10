module SPARQL; module Algebra
  class Operator
    ##
    # The SPARQL Table operator.
    #
    # This is used to provide inline values. Each row becomes
    # a solution.
    #
    # @example
    #    (table (vars ?book ?title)
    #      (row (?title "SPARQL Tutorial"))
    #      (row (?book :book2)))
    #
    # @see http://www.w3.org/TR/2013/REC-sparql11-query-20130321/#inline-data
    class Table < Operator
      include Query
      
      NAME = [:table]

      ##
      # Returns solutions for each row
      #
      # @param  [RDF::Queryable] queryable
      #   the graph or repository to query
      # @param  [Hash{Symbol => Object}] options
      #   any additional keyword options
      # @return [RDF::Query::Solutions]
      #   the resulting solution sequence
      # @see    http://www.w3.org/TR/rdf-sparql-query/#sparqlAlgebra
      def execute(queryable, options = {})
        @solutions = RDF::Query::Solutions.new
        operands[1..-1].each do |row|
          bindings = row[1..-1].inject({}) do |memo, (var, value)|
            memo[var.to_sym] = value
          end
          @solutions << RDF::Query::Solution.new(bindings)
        end
        @solutions
      end
    end # Table
  end # Operator
end; end # SPARQL::Algebra
