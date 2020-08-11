require_relative "test_helper"

class IsoTreeTest < Minitest::Test
  def test_works
    x = test_data
    model = IsoTree::IsolationForest.new(ntrees: 10, ndim: 2, nthreads: 1)
    model.fit(x)
    predictions = model.predict(x)
    assert_elements_in_delta [0.510724008530721, 0.4338067195010562, 0.5569583231648105], predictions.first(3)
    max_index = predictions.each_with_index.max[1]
    assert_equal [3, 3], x[max_index]
  end

  def test_numo
    x = Numo::DFloat.cast(test_data)
    model = IsoTree::IsolationForest.new(ntrees: 10, ndim: 2, nthreads: 1)
    model.fit(x)
    predictions = model.predict(x)
    assert_elements_in_delta [0.510724008530721, 0.4338067195010562, 0.5569583231648105], predictions.first(3)
    max_index = predictions.each_with_index.max[1]
    assert_equal [3, 3], x[max_index, true].to_a
  end

  def test_not_fit
    model = IsoTree::IsolationForest.new
    error = assert_raises do
      model.predict([])
    end
    assert_equal "Not fit", error.message
  end

  def test_different_columns
    x = Numo::DFloat.new(101, 2).rand_norm
    model = IsoTree::IsolationForest.new
    model.fit(x)
    error = assert_raises(ArgumentError) do
      model.predict(x.reshape(2, 101))
    end
    assert_equal "Input must have 2 columns for this model", error.message
  end

  def test_no_data
    model = IsoTree::IsolationForest.new
    error = assert_raises(ArgumentError) do
      model.fit([])
    end
    assert_equal "No data", error.message
  end

  def test_bad_size
    model = IsoTree::IsolationForest.new
    error = assert_raises(ArgumentError) do
      model.fit([[1, 2], [3]])
    end
    assert_equal "All rows must have the same number of columns", error.message
  end

  def test_bad_dimensions
    model = IsoTree::IsolationForest.new
    error = assert_raises(ArgumentError) do
      model.fit(Numo::DFloat.cast([[[1]]]))
    end
    assert_equal "Input must have 2 dimensions", error.message
  end

  def test_data
    CSV.table("test/support/data.csv", headers: false).to_a
  end
end
