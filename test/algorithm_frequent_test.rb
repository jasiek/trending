require 'helper'

class AlgorithmFrequentTest < Test::Unit::TestCase
  def test_capacity_required
    [0, nil].each do |arg|
      assert_raises(ArgumentError) do
        Frequent.new(arg)
      end
    end
  end

  def test_top_1
    @m = Frequent.new(1)
    assert_equal([], @m.top)
    @m.bump(:a)
    assert_equal([:a], @m.top)
    @m.bump(:b)
    assert_equal([], @m.top)
    @m.bump(:a)
    assert_equal([:a], @m.top)
    @m.bump(:a)
    assert_equal([:a], @m.top)
    @m.bump(:b)
    assert_equal([:a], @m.top)
    @m.bump(:b)
    assert_equal([], @m.top)
    @m.bump(:c)
    assert_equal([:c], @m.top)
  end

  def test_top_lte_10
    @m = Frequent.new(10)
    sequence_0123456789.each do |e|
      @m.bump(e)
    end
    expected_top = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    10.downto(1).each do |size|
      assert_equal(expected_top.take(size), @m.top(size))
    end
  end

  def test_element_order_doesnt_matter
    sequence = sequence_0123456789
    100.times do |i|
      @m = Frequent.new(10)
      sequence.shuffle.each do |e|
        @m.bump(e)
      end
      assert_equal([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], @m.top, i)
    end
  end

  def test_huge_sequence
    @m = Frequent.new(5)
    huge_sequence.each do |e|
      @m.bump(e)
    end
    assert_equal([0, 1], @m.top(2))
  end

  private
  def sequence_0123456789
    (0..9).inject([]) do |acc, e|
      acc + [e] * (10 - e)
    end
  end

  def huge_sequence
    Enumerator.new do |y|
      1_000_000.times do
        r = rand(1_000)
        if r < 180
          y.yield(0)
        elsif r < 350
          y.yield(1)
        else
          y.yield(r)
        end
      end
    end
  end
end
