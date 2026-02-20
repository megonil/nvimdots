local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep

return {
  s("guards", {
    t("#ifndef "), i(1, "MODULE_NAME"),
    t({ "", "#define " }), rep(1),
    t({ "", "", "" }),
    i(0),
    t({ "", "#endif // !" }), rep(1),
  }),
  s("basis", {
    t({
      "#include <stdio.h>",
      "",
      "int",
      "main (int argc, char* argv[])",
      "{",
      "    "
    }),
    i(1),
    t({
      "",
      "    return 0;",
      "}"
    }),
    i(0)
  })
}
