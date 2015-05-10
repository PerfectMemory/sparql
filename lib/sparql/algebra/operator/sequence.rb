module SPARQL; module Algebra
  class Operator

    ##
    # The SPARQL UPDATE `sequence` operator.
    #
    # Sequences through each operand
    #
    # @example
    #   (sequence
    #     (bgp
    #       (triple ?s ?p ??0)
    #       (triple ??0 rdf:first ??1)
    #       (triple ??0 rdf:rest ??2)
    #       (triple ??2 rdf:first ??3)
    #       (triple ??2 rdf:rest rdf:nil))
    #     (path ??1 (seq (path* :p) :q) 123)
    #     (path ??3 (reverse :r) "hello"))
    #
    # @see XXX
    class Sequence < Operator
      include SPARQL::Algebra::Update

      NAME = :sequence

      ##
      # Executes this upate on the given `writable` graph or repository.
      #
      # XXX
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
        debug(options) {"Sequence #{operands.to_sse}"}

        last = queryable.query(operands.shift, options.merge(depth: options[:depth].to_i + 1))
        debug(options) {"(sequence)=>(last) #{last.map(&:to_hash).to_sse}"}

        operands.each do |op|
          this = queryable.query(op, options.merge(depth: options[:depth].to_i + 1))
          debug(options) {"(sequence)=>(this) #{this.map(&:to_hash).to_sse}"}

          last = last.map do |s1|
            this.map do |s2|
              s2.merge(s1) if s2.compatible?(s1)
            end
          end.flatten.compact
          debug(options) {"(sequence)=>(next) #{last.map(&:to_hash).to_sse}"}
        end

        @solutions = RDF::Query::Solutions.new(last)
        debug(options) {"(sequence)=> #{@solutions.map(&:to_hash).to_sse}"}
        @solutions.each(&block) if block_given?
        @solutions
      end
    end # Sequence
  end # Operator
end; end # SPARQL::Algebra
