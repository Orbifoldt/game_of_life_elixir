# Game of life
Here I'm gonna implement the game of life using elixir.
We have the following rules:
   1. Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
   2. Any live cell with more than three live neighbours dies, as if by overcrowding.
   3. Any live cell with two or three live neighbours lives on to the next generation.
   4. Any dead cell with exactly three live neighbours becomes a live cell.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `game_of_life` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:game_of_life, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/game_of_life>.

