defmodule Example.Test.Helper do
  alias OpenApiSpex.Schema

  import OpenApiSpex.TestAssertions,
    only: [assert_schema: 3]

  def example!(module) when is_atom(module) do
    module.schema()
    |> Schema.example()
    |> example!(module)
  end

  def example!(%{} = spec, module) when is_atom(module) do
    assert_schema(spec, module, Example.ApiSpec.spec())
    Jason.encode!(spec)
  end
end

ExUnit.start()
