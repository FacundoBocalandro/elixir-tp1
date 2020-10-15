defmodule JsonGeneratorTest do
  use ExUnit.Case
  doctest JsonGenerator

  test "greets the world" do
    assert JsonGenerator.hello() == :world
  end
end
