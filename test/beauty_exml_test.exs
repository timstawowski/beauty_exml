defmodule BeautyExmlTest do
  use ExUnit.Case

  describe "format" do
    test "with simple xml" do
      xml = "<test><a>link</a></test>"
      assert BeautyExml.format(xml) == {:ok, "<test>\n\t<a>link</a>\n</test>"}
    end

    test "with instant_closing" do
      xml = ~S(<test><is>a</is><closed/></test>)

      assert BeautyExml.format(xml) == {:ok, "<test>\n\t<is>a</is>\n<closed\/>\n</test>"}
    end

    test "with deeply nested" do
      xml =
        ~S(<test><this><b>list</b></closing><is>a</is><closed/></this><after>this</after><current><type>boolean</type></current></test>)

      assert BeautyExml.format(xml) ==
               {:ok,
                "\t<test>\n\t\t<this>\n\t\t\t<b>list</b>\n\t\t</closing>\n\t\t<is>a</is>\n\t<closed/>\n\t</this>\n\t<after>this</after>\n<current>\n\t<type>boolean</type>\n</current>\n</test>"}
    end

    test "with xml encoding header" do
      xml = ~S(<?xml version="1.0" encoding="ISO-8859-15"?><test><is>a</is><closed/></test>)

      assert BeautyExml.format(xml) ==
               {:ok,
                "<?xml version=\"1.0\" encoding=\"ISO-8859-15\"?>\n<test>\n\t<is>a</is>\n<closed\/>\n</test>"}
    end
  end

  describe "error handling" do
    test "with invalid data" do
      assert BeautyExml.format(1) == :error
      assert BeautyExml.format([]) == :error
      assert BeautyExml.format(2.0) == :error
      assert BeautyExml.format(:atom) == :error
      assert BeautyExml.format({}) == :error
    end
  end
end
