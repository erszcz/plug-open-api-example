defmodule Example.ClientTransactionHandler do
  @moduledoc false
  use Plug.Builder

  require Logger

  import OpenApiSpex.Operation,
    only: [request_body: 4, response: 3]

  alias OpenApiSpex.Operation
  alias Example.Schemas.BadRequestError
  alias Example.Schemas.ClientTransactionRequest
  alias Example.Schemas.InternalServerError
  alias Example.Schemas.OkResponse

  # plug(Plug.Parsers,
  #  parsers: [:urlencoded, {:json, json_decoder: Jason}]
  # )

  plug(OpenApiSpex.Plug.CastAndValidate,
    json_render_error_v2: true,
    operation_id: __MODULE__
  )

  # plug(OpenApiSpex.Plug.Cast, operation_id: __MODULE__)
  # plug(OpenApiSpex.Plug.Validate, spec: ClientTransactionRequest)

  plug(:run)

  def open_api_operation(_) do
    #:dbg.tracer()
    #:dbg.p(:all, :call)
    # :dbg.tpl(OpenApiSpex, :cast_and_validate, :x)
    # :dbg.tpl(OpenApiSpex, :cast_value, [])
    #:dbg.tpl(OpenApiSpex.Cast, :cast, [])

    %Operation{
      tags: ["client-transaction"],
      summary: "desc",
      description: "desc",
      parameters: [],
      requestBody:
        request_body(
          "desc",
          "application/json",
          ClientTransactionRequest,
          required: true
        ),
      operationId: __MODULE__,
      responses: %{
        200 => response("description", "application/json", OkResponse),
        400 => response("description", "application/json", BadRequestError)
      }
    }
  end

  def run(conn = %Plug.Conn{}, _opts) do

    ## debug start
    import OpenApiSpex.TestAssertions,
      only: [assert_schema: 3]

    body_params = conn.body_params
    Logger.debug(%{desc: "entry", body: body_params, module: __MODULE__})
    ## If I uncomment the following assertion, `mix test` fails on it.
    ## Why doesn't the `OpenApiSpex.Plug.CastAndValidate` catch that on validation?
    assert_schema(body_params, ClientTransactionRequest, Example.ApiSpec.spec())
    ## debug end

    ## other request processing
    code = 200
    response = Jason.encode!(%{
      "fake-response": "123qwe",
      "description": "which should not reach the test case, since validation should fail"
    })

    conn
    |> Plug.Conn.put_resp_header("content-type", "application/json")
    |> Plug.Conn.send_resp(code, response)
  end
end

