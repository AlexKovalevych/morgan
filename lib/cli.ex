defmodule Morgan.CLI do
  def main(stdin) do
    lines = IO.read(:stdio, :all) |> String.split("\n")
    [cases | data] = lines
    cases = String.to_integer(cases)
    1..1 |> Enum.map(fn i ->
      res = process(Enum.at(lines, (i - 1) * 2 + 1), Enum.at(lines, i * 2), "")
      |> IO.inspect
      # IO.write(:stdio, res)
    end)
  end

  defp process("", b, result) do
    result <> b
  end

  defp process(a, "", result) do
    result <> a
  end

  defp process(a, b, result) do
    {a1, a_tail} = String.split_at(a, 1)
    {b1, b_tail} = String.split_at(b, 1)

    cond do
      a1 > b1 -> process(a, b_tail, result <> b1)
      a1 < b1 -> process(a_tail, b, result <> a1)
      true ->
        equal_length = process_equal(a_tail, b_tail, 0)
        {_, a_diff_tail} = String.split_at(a_tail, equal_length)
        {_, b_diff_tail} = String.split_at(b_tail, equal_length)
        {diff_a1, _} = String.split_at(a_diff_tail, 1)
        {diff_b1, _} = String.split_at(b_diff_tail, 1)
        if diff_a1 > diff_b1 do
          process(a, b_tail, result <> b1)
        else
          process(a_tail, b, result <> a1)
        end
    end
  end

  defp process_equal("", "", l), do: l

  defp process_equal(a, b, l) do
    {a1, a_tail} = String.split_at(a, 1)
    {b1, b_tail} = String.split_at(b, 1)
    if a1 == b1 do
      process_equal(a_tail, b_tail, l + 1)
    else
      l
    end
  end
end
