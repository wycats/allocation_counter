RSpec::Matchers.define :allocate do |expected|
  match do |actual|
    @actual = {}

    counts = AllocationCounter.measure(&actual)
    expected_total = 0

    expected.each do |name, expected_count|
      @actual[name] = counts[name]
      expected_total += expected_count
    end

    expected[:total] = expected_total
    @actual[:total] = counts[:allocated]
    @expected = @expected[0]

    expected == @actual
  end

  failure_message_for_should do
    "Expected block to allocate: #{@expected.inspect}"
  end

  diffable
end

