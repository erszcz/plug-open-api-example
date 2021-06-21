defmodule Example.Schemas do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  defmodule ClientTransactionRequest do
    OpenApiSpex.schema(%{
      title: __MODULE__,
      type: :object,
      properties: %{
        client_id: %Schema{
          type: :integer,
          title: "a gambler's ID",
          format: :int32
        },
        test_enum: %Schema{
          type: :string,
          title: "test enum",
          enum: ["variant_a", "variant_b"]
        }
      },
      required: [:client_id],
      example: %{
        "client_id" => "5",
        "test_enum" => "variant_z"
      }
    })
  end

  defmodule OkResponse do
    OpenApiSpex.schema(%{
      title: __MODULE__,
      type: :object,
      properties: %{},
      example: %{}
    })
  end

  defmodule BadRequestError do
    OpenApiSpex.schema(%{
      title: __MODULE__,
      description: "The request is not semantically valid",
      type: :object,
      properties: %{
        error: %Schema{type: :string, description: "a human-readable error description"},
        reason: %Schema{type: :string, description: "error details"}
      },
      example: %{
        "error" => "a human-readable error description",
        "reason" => ""
      }
    })
  end
end
