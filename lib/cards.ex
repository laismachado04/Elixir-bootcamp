defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """

  @spec create_deck :: list
  @doc """
    Returns a list of strings representing a deck of playing cards
  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end

  @spec shuffle(any) :: list
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @spec contains?(any, any) :: boolean
  @doc """
    Determines whether a deck contains a given card

  ## Examples
      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "Ace of Spades")
      true

  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @spec deal(any, integer) :: {list, list}
  @doc """
    Divides a deck into a hand and the remainder of the deck.
    the `hand_size` argument indicates how many cards should be in the hand.

  ## Examples
      iex> deck = Cards.create_deck
      iex> {hand, deck} = Cards.deal(deck,1)
      iex> hand
      ["Ace of Spades"]

  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  @spec save(
          any,
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | char,
              binary | []
            )
        ) :: :ok | {:error, atom}
  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  @spec load(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | char,
              binary | []
            )
        ) :: any
  def load(filename) do
    case File.read(filename) do
      {:ok, binary} ->
        :erlang.binary_to_term(binary)

      {:error, _reason} ->
        "That file does not exist"

        # variaveis com _ serao ignoradas pelo elixir.
        # eh preciso assinalar ela no metodo, por causa do pattern matching
        # (File.read(filename) retorna sempre uma tupla de dois elementos)
        # mas nao utilizaremos, no caso de erro a segunda variavel, portanto _reason
    end
  end

  @spec create_hand(integer) :: {list, list}
  def create_hand(hand_size) do
    # deck = Cards.create_deck()
    # deck = Cards.shuffle(deck)
    # deck = Cards.deal(deck, hand_size)

    Cards.create_deck()
    |> Cards.shuffle()
    |> Cards.deal(hand_size)
    # Para Cards.deal(deck, hand_size) o pipe |> ira automaticamente assumir que o primeiro elemento do metodo eh o resultado do anterior
  end
end
