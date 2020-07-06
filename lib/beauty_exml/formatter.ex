defmodule BeautyExml.Formatter do
  @check_for_xml_content ~r/<[^>]+>/
  @instant_closing ~r/<[\w]+\/>|^<\?[\w\s=\\".-]+\?>/
  @opening ~r/<[\w]+>/
  @closing ~r/<\/[\w]+>/

  def __beautify__(raw_xml_content) do
    formatted_xml =
      raw_xml_content
      |> structure_xml()
      |> concat_result()

    {:ok, formatted_xml}
  end

  defp concat_result(structured_xml_list) do
    structured_xml_list
    |> Enum.map(&add_tab/1)
    |> Enum.join("\n")
  end

  defp structure_xml(xml_list) do
    @check_for_xml_content
    |> Regex.split(xml_list, include_captures: true, trim: true)
    |> Enum.reverse()
    |> Enum.reduce([{:start, nil, 0}], fn xml_chunk, acc ->
      {previous_type_is?, previous_content, tabs} = List.first(acc)
      current_type_is? = get_xml_tag_type(xml_chunk)

      cond do
        previous_type_is? == :start ->
          [{current_type_is?, xml_chunk, tabs}]

        previous_type_is? == :opening and current_type_is? == :opening ->
          [{current_type_is?, xml_chunk, tabs - 1} | acc]

        (previous_type_is? in [:closing, :instant_closing] and current_type_is? == :value) or
            previous_type_is? == :value ->
          xml_content = {current_type_is?, xml_chunk <> previous_content, tabs}
          List.replace_at(acc, 0, xml_content)

        previous_type_is? in [:closing, :instant_closing] and current_type_is? == :closing ->
          [{current_type_is?, xml_chunk, tabs + 1} | acc]

        true ->
          [{current_type_is?, xml_chunk, tabs} | acc]
      end
    end)
  end

  defp add_tab({_status, content, 0}), do: content

  defp add_tab({_status, content, tabs}) do
    tabs = String.duplicate("\t", tabs)
    tabs <> content
  end

  defp get_xml_tag_type(term) do
    cond do
      Regex.match?(@instant_closing, term) -> :instant_closing
      Regex.match?(@closing, term) -> :closing
      Regex.match?(@opening, term) -> :opening
      true -> :value
    end
  end
end
