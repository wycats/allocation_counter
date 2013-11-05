module AllocationCounter
  def self.count
    yield Counter.new
  end

  def self.simple
    count { |c| c.count("it", 1) { yield } }
  end

  class Counter
    def hash
      { last: nil, total: 0 }
    end

    def count(description, count)
      changes = {
        allocated: hash,
        object: hash,
        class: hash,
        module: hash,
        float: hash,
        string: hash,
        regex: hash,
        array: hash,
        hash: hash,
        bignum: hash,
        file: hash,
        data: hash,
        match: hash,
        complex: hash,
        rational: hash,
        node: hash,
        iclass: hash
      }

      results = {}
      result = nil

      GC.disable
      ObjectSpace.garbage_collect

      # Intentionally run twice. For some reason, the first run generates
      # some String objects
      ObjectSpace.count_objects(results)
      ObjectSpace.count_objects(results)
      update_all(changes, results)

      count.times do |i|
        result = yield
        ObjectSpace.count_objects(results)

        update_all(changes, results)
      end

      puts
      description += " (#{count} times)"

      puts description
      puts "=" * description.size
      changes.each do |key, change|
        if key === :allocated && change[:total].zero?
          puts "%10s: %s" % [key, "\e[0;32mGOOD WORK! NO ALLOCATIONS\e[0m \e[0;42m:+1:\e[0m"]
        end

        next if change[:total].zero?
        puts "%10s: %d" % [key, change[:total]]
      end

      result
    rescue Exception => e
      puts e.class
      puts e.message
      puts e.backtrace
    ensure
      GC.enable
    end

    def update_all(changes, results)
      update(changes, :allocated, results[:TOTAL] - results[:FREE])
      update(changes, :object, results[:T_OBJECT])
      update(changes, :class, results[:T_CLASS])
      update(changes, :module, results[:T_MODULE])
      update(changes, :float, results[:T_FLOAT])
      update(changes, :string, results[:T_STRING])
      update(changes, :regex, results[:T_REGEXP])
      update(changes, :array, results[:T_ARRAY])
      update(changes, :hash, results[:T_HASH])
      update(changes, :bignum, results[:T_BIGNUM])
      update(changes, :file, results[:T_FILE])
      update(changes, :data, results[:T_DATA])
      update(changes, :match, results[:T_MATCH])
      update(changes, :complex, results[:T_COMPLEX])
      update(changes, :rational, results[:T_RATIONAL])
      update(changes, :node, results[:T_NODE])
      update(changes, :iclass, results[:T_ICLASS])
    end

    def update(changes, key, result)
      if changes[key][:last]
        incr = result - changes[key][:last]
        changes[key][:total] += incr
      end

      changes[key][:last] = result
    end
  end
end
