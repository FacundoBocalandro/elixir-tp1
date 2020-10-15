defmodule Translator do
  defmodule State do
    defstruct frequencies: %{}, translations: %{}
  end

  use GenServer

  def start_link(translations) when is_map(translations) do
    GenServer.start_link(__MODULE__, %State{frequencies: %{}, translations: translations}, name: __MODULE__)
  end

  @impl true
  def init(translations) do
    {:ok, translations}
  end


  @impl true
  def handle_call({:translate, word}, _from, state) do
    new_freqs = add_freq(state.frequencies, word)
    {:reply, Map.get(state.translations, word, :not_found), %State{frequencies: new_freqs, translations: state.translations}}
  end

  @impl true
  def handle_call(:frequencies, _from, state) do
      {:reply, state.frequencies, state}
  end

  @impl true
  def handle_cast({:add, word, translation}, state) do
      {:noreply, %State{frequencies: state.frequencies, translations: Map.put(state.translations, word, translation)}}
  end

  defp add_freq(frequencies, word) do
    try do
      {_, new_map} = Map.get_and_update!(frequencies, word, fn x -> {x, x+1} end)
      new_map
    rescue
      _e in KeyError -> Map.put(frequencies, word, 1)
    end
  end

  def translate(word) do
    splittedText = String.split(word, " ", trim: true)
    translatedWords = Enum.map(splittedText, fn word -> GenServer.call(__MODULE__, {:translate, word}) end)
    Enum.join(translatedWords, " ")
  end

  def add_translation(word, translation) do
    GenServer.cast(__MODULE__, {:add, word, translation})
  end

  def get_frequencies() do
    GenServer.call(__MODULE__, :frequencies)
  end

end

defmodule TranslatorSupervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      {Translator, %{"hello" => "hola", "world" => "mundo"}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
