defmodule BeautyExml.MixProject do
  use Mix.Project

  def project do
    [
      app: :beauty_exml,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "BeautyExml",
      source_url: "https://github.com/timstawowski/beauty_exml"
    ]
  end

  def application do
    []
  end

  defp description do
    "Simple xml formatter."
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev, runtime: false}]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/timstawowski/beauty_exml"}
    ]
  end
end
