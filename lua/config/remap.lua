vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv:")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv:")
vim.keymap.set("n", "<leader>s", function()
    vim.lsp.buf.format()
end)

vim.keymap.set("n", "<Tab>", function()
    require("bufferline").cycle(1)
end, { silent = true })
vim.keymap.set("n", "<S-Tab>", function()
    require('bufferline').cycle(-1)
end, { silent = true })

vim.keymap.set("n", "<leader>q", ":bdelete<CR>", { silent = true })

vim.keymap.set("n", "<S-h>", "<cmd>BufferLineMovePrev<CR>")
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineMoveNext<CR>")

vim.keymap.set("n", "<leader>bl", ":ls<CR>", { silent = true })

vim.api.nvim_create_autocmd("SwapExists", {
    callback = function()
        vim.v.swapchoice = "e" -- automatically choose "Edit anyway"
    end
})

vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, function()
        vim.cmd("buffer " .. i)
    end, { silent = true })
end


-- rust specific
local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
    "n",
    "<leader>a",
    function()
        vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
        -- or vim.lsp.buf.codeAction() if you don't want grouping.
    end,
    { silent = true, buffer = bufnr }
)

vim.keymap.set(
    "n",
    "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
    function()
        vim.cmd.RustLsp({ 'hover', 'actions' })
    end,
    { silent = true, buffer = bufnr }
)
