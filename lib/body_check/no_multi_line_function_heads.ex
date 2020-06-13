defmodule BodyCheck.NoMultiLineFunctionHeads do
  use Credo.Check,
    base_priority: :high,
    category: :readability

  @moduledoc """
  Function heads should not be multi-line
  """
  @explanation [check: @moduledoc]

  @doc false
  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)

    source_file
    |> Credo.Code.prewalk(&traverse/2)
    |> Enum.map(&issue_for(&1, issue_meta))
  end

  defp traverse(
         {definition, meta, [{function, _, arguments}, _]} = ast,
         issues
       )
       when definition in [:def, :defp] do
    line = meta[:line]

    if one_line?(line, arguments) do
      {ast, issues}
    else
      {ast, [{function, line} | issues]}
    end
  end

  defp traverse(ast, issues) do
    {ast, issues}
  end

  defp one_line?(_line, nil) do
    true
  end

  defp one_line?(line, {_, meta, _}) do
    line == meta[:line]
  end

  defp one_line?(line, tuple) when is_tuple(tuple) do
    list = Tuple.to_list(tuple)

    one_line?(line, list)
  end

  defp one_line?(line, arguments) when is_list(arguments) do
    arguments
    |> Enum.map(&get_line_number(&1, line))
    |> List.flatten()
    |> Enum.all?(&(&1 == line))
  end

  defp get_line_number({_, meta, _}, line) do
    meta[:line] || line
  end

  defp get_line_number(_ast, line) do
    [line]
  end

  defp issue_for({function, line_no}, issue_meta) do
    format_issue(issue_meta,
      message: "Function #{function} spans multiple lines",
      trigger: function,
      line_no: line_no
    )
  end
end
