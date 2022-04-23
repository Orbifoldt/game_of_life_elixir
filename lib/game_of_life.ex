defmodule GameOfLife do
  import Board
  @moduledoc """
  Documentation for `GameOfLife`.
  """

  @neighbor_coord_offsets [
    {-1, -1}, {0, -1}, {1, -1},
    {-1, 0},           {1, 0},
    {-1, 1},  {0, 1},  {1, 1},
  ]

  @spec tick(Board) :: Board
  def tick(board) do
    new_cells = 0 .. board.width*board.height - 1
      |> Enum.map(fn idx -> coords(idx, board.width, board.height) end)
      |> Enum.map(fn {x,y} -> tick_cell(board, x, y) end)
    new_state = %Board{width: board.width, height: board.height, cells: new_cells}
  end

  defp coords(idx, width, height) when 0 <= idx and idx < width*height do
    {rem(idx, width), div(idx, width)}
  end

  defp tick_cell(board, x, y) do
    live_neighbors = get_neighbor_coords(x, y)
      |> Enum.reduce(0, fn ({nx, ny}, acc) -> acc + Board.get_cell(board, nx, ny) end)
      |> next_state(Board.get_cell(board, x, y))
  end

  defp next_state(live_neighbors, 1) when (live_neighbors == 2 or live_neighbors == 3), do: 1
  defp next_state(3, 0), do: 1
  defp next_state(live_neighbors, current_value), do: 0

  defp get_neighbor_coords(x, y) do
    @neighbor_coord_offsets |> Enum.map(fn {a, b} -> {x+a, y+b} end)
  end
end

defmodule GameOfLifePatterns do
  # {0,0}, {1,0}, {2,0}, {3,0},
  # {0,1}, {1,1}, {2,1}, {3,1},
  # {0,2}, {1,2}, {2,2}, {3,2},
  # {0,3}, {1,3}, {2,3}, {3,3}

  @block_offsets [
    {0,0}, {1,0},
    {0,1}, {1,1}
  ]

  @beehive_offsets [
           {1,0}, {2,0},
    {0,1},               {3,1},
           {1,2}, {2,2}
  ]

  @blinker_offsets [
    {0,0}, {1,0}, {2,0}
  ]

  defp abs_coords(pattern_offsets, x, y, rotation) do
    pattern_offsets
      |> rotate(rotation)
      |> Enum.map(fn {a,b} -> {x+a, y+b} end)
  end

  # # rotation anti-clockwise
  # defp rotate({x, y}, 0), do: {x, y}
  # defp rotate({x, y}, 90), do: {-y, x}
  # defp rotate({x, y}, 180), do: {-x, -y}
  # defp rotate({x, y}, 270), do: {y, -x}

  defp rotate(coords, rotation) do
    coords |> Enum.map(fn {a,b} ->
      case rotation do
        90 -> {-b, a}
        180 -> {-a, -b}
        270 -> {b, -a}
        _ -> {a, b}
      end
    end)
  end

  def block(x \\ 0, y \\ 0, rotation \\ 0), do: abs_coords(@block_offsets, x, y, rotation)
  def beehive(x \\ 0, y \\ 0, rotation \\ 0), do: abs_coords(@beehive_offsets, x, y, rotation)
  def blinker(x \\ 0, y \\ 0, rotation \\ 0), do: abs_coords(@blinker_offsets, x, y, rotation)

end
