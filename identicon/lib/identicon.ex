defmodule Identicon do
  @moduledoc """
  Custom identicon generator made in Elixir.
  """

  alias Identicon.Image

  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
  end

  def hash_input(string) do
    seed = :binary.bin_to_list(:crypto.hash(:md5, string))
    %Image{seed: seed}
  end

  def pick_color(image = %Image{seed: [r, g, b | _tail]}) do
    %Image{image | color: {r, g, b}}
  end

  def build_grid(image = %Image{seed: seed}) do
    grid =
      seed
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_list(&1))

    %Image{image | grid: grid}
  end

  # Private functions

  defp mirror_list(list = [a, b | _tail]) do
    list ++ [b, a]
  end
end
