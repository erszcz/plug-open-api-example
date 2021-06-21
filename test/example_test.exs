defmodule Example.ClientTransactionHandlerTest do
  use ExUnit.Case
  use Plug.Test

  import OpenApiSpex.TestAssertions,
    only: [assert_schema: 3]

  import Example.Test.Helper

  require Logger

  @moduletag capture_log: true

  alias Example.Router

  @endpoints [
    test_: "/test"
  ]

  describe @endpoints[:test_] do
    alias Example.Schemas.BadRequestError
    alias Example.Schemas.ClientTransactionRequest
    alias Example.Schemas.OkResponse

    test "accepts only :variant_a enum variant" do
      ## given
      alias OpenApiSpex.Schema
      example = ClientTransactionRequest.schema() |> Schema.example()
      example = %{example | "test_enum" => "variant_x"}
      ## validation is intentionally skipped to check how the service behaves!
      body = Jason.encode!(example)

      Logger.info("POST body: #{inspect(body)}")
      opts = Router.init([])

      ## when
      conn =
        :post
        |> conn(@endpoints[:test_], body)
        |> put_req_header("content-type", "application/json")
        |> Router.call(opts)

      ## then
      Logger.info("Response body: #{inspect(conn.resp_body)}")
      assert conn.state == :sent
      assert conn.status == 200
      #assert_schema(conn.resp_body |> Jason.decode!(), BadRequestError, Example.ApiSpec.spec())
      assert false
    end
  end
end
