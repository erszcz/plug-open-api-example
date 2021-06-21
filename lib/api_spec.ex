defmodule Example.ApiSpec do
  alias OpenApiSpex.{Info, OpenApi}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      info: %Info{
        title: "Plug App",
        version: "1.0"
      },
      paths: %{
        "/test" =>
          OpenApiSpex.PathItem.from_routes([
            %{verb: :post, plug: Example.ClientTransactionHandler, opts: []}
          ])
      }
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end

