defmodule Guess do
  use Application
  def start(_,_) do
    run()
    {:ok, self()}
  end

  # Fluxo do programa
  def run() do
    IO.puts("Lets play this game!")

    IO.gets("Choose your level (1,2 or 3):")
    |> parse_input()
    |> pickup_number()
    |> play()
  end


  # Função resposta
  def play(picked_num) do
    IO.gets("I have my number. What is your guess?")
    |> parse_input()
    |> guess(picked_num, 1)
  end

  # Validando as respostas
  def guess(user_guess, picked_num, count) when user_guess > picked_num do
    IO.gets("Too high. try again:")
    |> parse_input()
    |> guess(picked_num, count + 1)
  end

  def guess(user_guess, picked_num, count) when user_guess < picked_num do
    IO.gets("Too low. try again:")
    |> parse_input()
    |> guess(picked_num, count + 1)
  end

  def guess(user_guess, picked_num, count) when user_guess == picked_num do
    IO.puts("You got it! #{count} guess.")
    show_score(count)
  end

  def show_score(guesses) when guesses > 6 do
    IO.puts("Better luck next time!")
  end

  def show_score(guesses) do
    map = %{
      1..1 => "You're a mind rider!",
      2..4 => "Most impressive",
      3..6 => "You can do better than that"
    }
    |> Enum.find(fn {range,_} ->
      Enum.member?(range, guesses)
    end)
    {_, msg} = map # Desconstruindo o map
    IO.puts(msg)
  end

  # Número selecionado
  def pickup_number(level) do
    level
    |> get_range()
    |> Enum.random()
  end

  def parse_input(:error) do
    IO.puts("Invalid option!")
    run()
  end

  def parse_input({num,_}), do: num # Short syntax

  def parse_input(data) do
    data
    |> Integer.parse()
    |> parse_input()
  end

  # Lida com o range
  def get_range(level) do
    case level do # Equivalente ao switch case do JS
      1 -> 1..10
      2 -> 1..100
      3 -> 1..1000
      _ -> IO.puts("Invalid option!")
      run()
    end
  end
end
