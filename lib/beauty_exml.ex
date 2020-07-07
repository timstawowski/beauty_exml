defmodule BeautyExml do
  @moduledoc """
  Simple xml formatter for adding tabs and new lines.
  """

  import BeautyExml.Formatter, only: [__beautify__: 1]

  @doc """
  Add xml-binary to recieve it formatted.

  ## Examples

      format("<test><is>a</is><closed/></test>")
      {:ok, "<test>\\n\\t<is>a</is>\\n<closed/>\\n</test>"}
  """
  @spec format(binary()) :: {:ok, binary()} | :error
  def format(xml_content) when is_binary(xml_content), do: __beautify__(xml_content)

  def format(_), do: :error
end
