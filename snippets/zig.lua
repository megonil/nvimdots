local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local function import_path(args)
  local name = args[1][1]

  if not name or name == "" then
    return ""
  end

  name = name:gsub("%.zig$", "")

  local found = vim.fs.find(
    function(fname)
      return fname == (name .. ".zig")
    end,
    {
      path = ".",
      upward = false,
      limit = 1,
      type = "file",
    }
  )

  if #found == 0 then
    return name
  end

  local path = found[1]

  path = path:gsub("^./", "")

  return path
end

return {
  s("imp",
    fmt('const {} = @import("{}");', {
      i(1, "module"),
      f(import_path, { 1 }),
    })
  ),
}
