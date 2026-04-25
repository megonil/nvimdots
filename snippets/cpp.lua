local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("guards", {
    t("#ifndef "), i(1, "MODULE_NAME"),
    t({ "", "#define " }), rep(1),
    t({ "", "" }),
    t("#endif // !"), rep(1),
  }),
  s("pon", {
    t({ "#pragma once", "" })
  }),
  s("str", {
    t("std::string")
  }),
  s("vec", {
    t("std::vector")
  }),
  s("cond", {
    c(1, {
      fmt("#if defined({})", { i(1, "MACRO") }),
      fmt("#ifndef {}", { i(1, "MACRO") }),
    }),
    t({ "", "" }),
    i(2),
    t({ "", "#else", "" }),
    i(3),
    t({ "", "#endif" }),
  })
}
