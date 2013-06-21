Code.require_file "../test_helper.exs", __DIR__

defmodule Ecto.QueryTest do
  use ExUnit.Case

  import Ecto.TestHelpers
  import Ecto.Query, warn: false
  alias Ecto.Query.Query

  test "from check" do
    assert_raise ArgumentError, "from expressions must be in `var in Record` format", fn ->
      delay_compile from(x + 1)
    end

    assert_raise ArgumentError, "left hand side of `in` must be a variable", fn ->
      delay_compile from(:x in Record)
    end

    assert_raise ArgumentError, "right hand side of `in` must be a module name", fn ->
      delay_compile from(x in y)
    end

    delay_compile from (x in Record)
  end

  test "where check" do
    assert_raise ArgumentError, "binary expression `in` is not allowed in query expressions", fn ->
      delay_compile where(x in y)
    end

    assert_raise ArgumentError, "tuples are not allowed in query expressions", fn ->
      delay_compile where({1, 2})
    end

    assert_raise ArgumentError, "lists are not allowed in query expressions", fn ->
      delay_compile where([1, 2, 3])
    end

    delay_compile where(x - y && x + y)
  end

  test "select check" do
    assert_raise ArgumentError, "lists are not allowed in query expressions", fn ->
      delay_compile select(Query[], [y])
    end

    assert_raise ArgumentError, "tuples are not allowed in query expressions", fn ->
      delay_compile select(Query[], x == {1, 2})
    end

    assert_raise ArgumentError, "function calls are not allowed in query expressions", fn ->
      delay_compile select(Query[], f(x, y, z))
    end

    assert_raise ArgumentError, "binary expression `++` is not allowed in query expressions", fn ->
      delay_compile select(Query[], x ++ y)
    end
  end

  # TODO: test validate
end