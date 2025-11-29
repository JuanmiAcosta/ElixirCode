defmodule Cards do
  @moduledoc """
  This modules implements card decks utilities
  """

  @cards_number 52
  @suits [:hearts, :diamonds, :clubs, :spades]

  @doc """
  Get number suits
  """
  def suits_number do
    Enum.count(@suits)
  end

  @doc """
  Get how many cards per suit
  """
  def cards_per_suit do
    div(@cards_number, suits_number())
  end

  defp format_card_number(card_number) do
    cond do
      card_number == 1 -> "A"
      card_number == 11 -> "J"
      card_number == 12 -> "Q"
      card_number == 13 -> "K"
      card_number in 2..10 -> Integer.to_string(card_number)
      true -> raise ArgumentError, "número de carta inválido: #{inspect(card_number)}"
    end
  end

  # --------------------------------------------

  @doc """
  Get a whole ordered deck
  """
  def create_deck do
    for suit <- @suits,
        card_number <- 1..cards_per_suit(),
        do: {format_card_number(card_number), suit}
  end
end
