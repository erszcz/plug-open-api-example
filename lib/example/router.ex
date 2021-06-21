defmodule Example.Router.Html do
  @openapi_path "/api/openapi"
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get("/swaggerui", to: OpenApiSpex.Plug.SwaggerUI, init_opts: [path: @openapi_path])
end

defmodule Example.Router do
  use Plug.Router

  plug(Plug.RequestId)
  plug(Plug.Logger)
  plug(Plug.Parsers, parsers: [:json], pass: ["*/*"], json_decoder: Jason)
  plug(OpenApiSpex.Plug.PutApiSpec, module: Example.ApiSpec)
  plug(:match)
  plug(:dispatch)
  

  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  post("/test", to: Example.ClientTransactionHandler)

  match("/*_", to: Example.Router.Html)

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
