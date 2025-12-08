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

  @doc """
  Shufle a deck. Returns {:ok,deck} if it is a propper deck and {:error,reason} if there is an error
  """
  def shuffle(deck) when is_list(deck) do
    if Enum.any?(deck) && Enum.all?(deck, &is_tuple/1),
      do: {:ok, Enum.shuffle(deck)},
      else: {:error, "This is not a keyword list"}
  end

  def shuffle(_) do
    {:error, "The deck must be a list"}
  end

  @doc """
  Returns if the deck contains this specific card

  ## Examples

      iex> deck = Cards.create_deck()
      iex> Cards.contains?(deck, {"A", :hearts})
      true
  """
  def contains?(deck, card_to_check) do
    Enum.member?(deck, card_to_check)
  end

  @doc """
  Returns the deal and the remaining deck.

  ## Examples

      iex> deck = Cards.create_deck()
      iex> {hand, rest_of_deck} = Cards.deal(deck,1)
      iex> hand
      [{"A", :hearts}]
      iex> Enum.count(rest_of_deck)
      51
  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  @doc """
  Saves the deck into a file
  """
  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  @doc """
  Loads a deck from a file
  """
  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _reason} -> "That file doesn't exist"
    end
  end

  @doc """
  Creates a hand using three functions in a row (create_deck, shuffle and deal)
  """
  def create_hand(hand_size) do
    with {:ok, shuffled_deck} <- create_deck() |> shuffle() do
      deal(shuffled_deck, hand_size)
    end
  end
end
