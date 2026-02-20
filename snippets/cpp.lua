local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep

return {
    s("guards", {
        t("#ifndef "), i(1, "MODULE_NAME"),
        t({ "", "#define " }), rep(1),
        t({ "", "" }),
        t("#endif // !"), rep(1),
    }),
}
