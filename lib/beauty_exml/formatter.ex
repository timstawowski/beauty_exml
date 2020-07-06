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
    |> Enum.reduce([{:start, nil, [tabs: 0]}], fn xml_chunk, acc ->
      {previous_type_is?, previous_content, opts} = List.first(acc)
      current_type_is? = get_xml_tag_type(xml_chunk)

      cond do
        previous_type_is? == :start ->
          [{current_type_is?, xml_chunk, opts}]

        previous_type_is? == :opening and current_type_is? == :opening ->
          opts = Keyword.update!(opts, :tabs, &if(&1 > 0, do: &1 - 1, else: 0))

          [{current_type_is?, xml_chunk, opts} | acc]

        (previous_type_is? == :closing and current_type_is? == :value) or
            previous_type_is? == :value ->
          opts =
            Keyword.update!(opts, :tabs, &if(current_type_is? == :value, do: &1, else: &1 + 1))

          xml_content = {current_type_is?, xml_chunk <> previous_content, opts}
          List.replace_at(acc, 0, xml_content)

        true ->
          [{current_type_is?, xml_chunk, opts} | acc]
      end
    end)
  end

  defp add_tab({_status, content, [tabs: 0]}), do: content

  defp add_tab({_status, content, [tabs: tab_count]}) do
    tabs = String.duplicate("\t", tab_count)
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
