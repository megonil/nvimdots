-- local lsp_servers = {
  -- { name = "lua_ls", cmd = { "lua-language-server" } },
  -- { name = "rust_analyzer", cmd = { "rust-analyzer" } },
  -- { name = "cmake", cmd = { "cmake-language-server" } },
  -- { name = "clangd", cmd = { "clangd" } },
  -- { name = "bashls", cmd = { "bash-language-server" } },
  -- { name = "prismals", cmd = { "prisma-language-server" } },
  -- { name = "ts_ls", cmd = { "typescript-language-server", "--stdio" } },
  -- { name = "eslint", cmd = { "vscode-eslint-language-server", "--stdio" } },
  -- { name = "pyright", cmd = {"pyright"}}
-- }

local M = {}

local lsp_servers = {"lua_ls", "rust_analyzer", "cmake", "clangd", "prismals", "bashls", "eslint", "pyright", "ts_ls"}


function M.setup(capabilities)
  -- if lsp_enable then
  --   for _, server in ipairs(lsp_servers) do
  --     vim.lsp.enable({
  --       server,
  --       capabilities
  --     })
  --   end
  -- end
  vim.lsp.enable(lsp_servers)

end

return M