defmodule Ping do
  use GenServer

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:play, n}, state) do
    Enum.each(1..n, fn _ -> Pong.send() end)
    {:noreply, state}
  end

  @impl true
  def handle_cast(:ball, state) do
    Pong.send()
    {:noreply, state + 1}
  end

  @impl true
  def handle_call(:stats, _from, state) do
    {:reply, state, state}
  end

  def play(n) do
    GenServer.cast(__MODULE__, {:play, n})
  end

  def send do
    GenServer.cast(__MODULE__, :ball)
  end

  def stats do
    GenServer.call(__MODULE__, :stats)
  end

  def start_link(_state) do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

end

defmodule Pong do
  use GenServer

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast(:ball, state) do
    Ping.send()
    {:noreply, state}
  end

  def send do
    GenServer.cast(__MODULE__, :ball)
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

end
