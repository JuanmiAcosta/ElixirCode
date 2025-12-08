defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "Create deck returns 52 cards" do
    deck_length = Enum.count(Cards.create_deck())
    assert deck_length == 52
  end

  describe "shuffle/1" do
    test "returns a shuffled deck as {:ok, deck}" do
      deck = Cards.create_deck()
      {:ok, shuffled_deck} = Cards.shuffle(deck)

      assert is_list(shuffled_deck)
      assert Enum.count(shuffled_deck) == 52
    end

    test " Shuffling a deck randomizes it" do
      first_card =
        Cards.create_deck()
        |> Cards.shuffle()
        |> elem(1)
        |> Enum.at(0)

      assert first_card != {"A", :hearts}
    end

    test "returns an error if the input is not a list" do
      invalid_input = "not a deck"
      result = Cards.shuffle(invalid_input)

      assert result == {:error, "The deck must be a list"}
    end

    test "returns an error if the deck is not a list of tuples" do
      invalid_deck = ["A", "B", "C"]
      result = Cards.shuffle(invalid_deck)

      assert result == {:error, "This is not a keyword list"}
    end
  end
end
