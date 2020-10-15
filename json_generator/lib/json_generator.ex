defprotocol JsonEncoder do
  @fallback_to_any true
  def to_json(value)
end

defimpl JsonEncoder, for: List do
  @spec to_json(any) :: <<_::16, _::_*8>>
  def to_json(list) do
    "[" <> Enum.join(Enum.map(list, fn value -> JsonEncoder.to_json(value) end), ", ") <> "]"
  end
end

defimpl JsonEncoder, for: Map do
  def to_json(map) do
    "{" <> Enum.join(Enum.map(Map.keys(map), fn key -> key <> ": " <> JsonEncoder.to_json(Map.get(map, key)) end), ", ") <> "}"
  end
end

defimpl JsonEncoder, for: Any do
  def to_json(value) do
    value
  end
end
