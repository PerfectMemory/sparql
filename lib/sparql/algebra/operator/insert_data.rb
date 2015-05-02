module SPARQL; module Algebra
  class Operator

    ##
    # The SPARQL UPDATE `insertData` operator.
    #
    # The INSERT DATA operation adds some triples, given inline in the request, into the Graph Store
    #
    # @example
    #   (insertData ((graph <http://example.org/g1> ((triple :s :p :o)))))
    #
    # @see http://www.w3.org/TR/sparql11-update/#insertData
    class InsertData < Operator::Unary
      include SPARQL::Algebra::Update

      NAME = [:insertData]

      ##
      # Executes this upate on the given `writable` graph or repository.
      #
      # @param  [RDF::Queryable] queryable
      #   the graph or repository to write
      # @param  [Hash{Symbol => Object}] options
      #   any additional keyword options
      # @option options [Boolean] debug
      #   Query execution debugging
      # @return [RDF::Queryable]
      #   Returns queryable.
      # @raise [IOError]
      #   If `from` does not exist, unless the `silent` operator is present
      # @see    http://www.w3.org/TR/sparql11-update/
      def execute(queryable, options = {})
        debug(options) {"InsertData"}

        operand.each do |op|
          case op
          when RDF::Enumerable, RDF::Statement
            queryable << op
          when Operator
            statements = op.execute(queryable, options.merge(:depth => options[:depth].to_i + 1))
            queryable.insert(*statements)
          end
        end
        queryable
      end
    end # InsertData
  end # Operator
end; end # SPARQL::Algebra
