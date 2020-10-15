defmodule GenServerTranslatorTest do
  use ExUnit.Case
  doctest GenServerTranslator

  test "greets the world" do
    assert GenServerTranslator.hello() == :world
  end
end
