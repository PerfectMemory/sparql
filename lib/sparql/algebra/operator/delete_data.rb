module SPARQL; module Algebra
  class Operator

    ##
    # The SPARQL UPDATE `deleteData` operator.
    #
    # The DELETE DATA operation removes some triples, given inline in the request, if the respective graphs in the Graph Store contain those
    #
    # @example
    #   (deleteData ((triple :a foaf:knows :c)))
    #
    # @see http://www.w3.org/TR/sparql11-update/#deleteData
    class DeleteData < Operator::Unary
      include SPARQL::Algebra::Update

      NAME = [:deleteData]

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
        debug(options) {"DeleteData"}

        operand.each do |op|
          case op
          when RDF::Enumerable, RDF::Statement
            queryable.delete(op)
          when Operator
            statements = op.execute(queryable, options.merge(:depth => options[:depth].to_i + 1))
            queryable.delete(*statements)
          end
        end
        queryable
      end
    end # DeleteData
  end # Operator
end; end # SPARQL::Algebra
