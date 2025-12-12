defmodule Identicon do
  @moduledoc """
  Custom identicon generator made in Elixir.
  """

  alias Identicon.Image

  @rect_count 5
  @pixel_per_rect 50

  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> filter_odd_squares()
    |> build_pixel_map()
    |> draw_image()
    |> save_image(input)
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
      |> List.flatten()
      |> Enum.with_index()

    %Image{image | grid: grid}
  end

  def filter_odd_squares(image = %Image{grid: grid}) do
    odd_squares = Enum.filter(grid, &is_odd?(&1))

    %Image{image | grid: odd_squares}
  end

  def build_pixel_map(image = %Image{grid: grid}) do
    pixel_map =
      Enum.map(grid, fn {_number, index} ->
        horizontal = rem(index, @rect_count) * @pixel_per_rect
        vertical = div(index, @rect_count) * @pixel_per_rect
        top_left = {horizontal, vertical}
        bottom_right = {horizontal + @pixel_per_rect, vertical + @pixel_per_rect}
        {top_left, bottom_right}
      end)

    %Image{image | pixel_map: pixel_map}
  end

  def draw_image(%Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    border = :egd.color(darken_color(color))
    border_width = 1

    Enum.each(pixel_map, fn {start = {x1, y1}, stop = {x2, y2}} ->
      :egd.filledRectangle(image, start, stop, fill)

      Enum.each(0..(border_width - 1), fn off ->
        s = {x1 + off, y1 + off}
        e = {x2 - off, y2 - off}
        :egd.rectangle(image, s, e, border)
      end)
    end)

    :egd.render(image)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  # Private functions

  defp mirror_list(list = [a, b | _tail]), do: list ++ [b, a]

  defp is_odd?({number, _index}), do: rem(number, 2) == 0

  defp darken_color({r, g, b}) do
    factor = 0.7

    {
      trunc(r * factor),
      trunc(g * factor),
      trunc(b * factor)
    }
  end
end
