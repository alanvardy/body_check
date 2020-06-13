defmodule BodyCheck.NoMultiLineFunctionHeadsTest do
  @moduledoc false
  use Credo.Test.Case

  alias BodyCheck.NoMultiLineFunctionHeads

  test "Accepts multiple single line arguments" do
    """
    defmodule CredoSampleModule do
      def good_function(single, line, arguments) do
        1 + 1
      end
    end
    """
    |> to_source_file()
    |> NoMultiLineFunctionHeads.run([])
    |> refute_issues()
  end

  test "Accepts a tuple" do
    """
    defmodule CredoSampleModule do
      def translate_error({msg, opts}) do
        msg ++ opts
      end
    end
    """
    |> to_source_file()
    |> NoMultiLineFunctionHeads.run([])
    |> refute_issues()
  end

  test "Accepts a guard on the next line" do
    """
    defmodule CredoSampleModule do
      def authorize(action, %Event{} = _event, _)
        when action in [:index, :show],
        do: true
    end
    """
    |> to_source_file()
    |> NoMultiLineFunctionHeads.run([])
    |> refute_issues()
  end

  test "Rejects multi-line arguments" do
    """
    defmodule CredoSampleModule do
      def bad_function(multi,
                        line,
                        arguments,
                        suck) do
        1 + 1
      end
    end
    """
    |> to_source_file()
    |> NoMultiLineFunctionHeads.run([])
    |> assert_issue()
  end
end
