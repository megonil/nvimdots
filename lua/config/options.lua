-- lua/config/options.lua
local M = {}

function M.setup()
    vim.g.mapleader = " " -- <leader>
    vim.g.maplocalleader = "\\"

    -- Line numbers
    vim.opt.relativenumber = true
    vim.opt.number = true
    vim.opt.signcolumn = "yes"

    -- Tabulation
    vim.opt.tabstop = 4      -- tab width
    vim.opt.shiftwidth = 4   -- indent width
    vim.opt.expandtab = true -- spaces instead of tabs

    vim.opt.hlsearch = false
    vim.opt.incsearch = true
    vim.opt.termguicolors = true
    vim.opt.scrolloff = 8
    vim.opt.isfname:append("@-@")

    vim.opt.updatetime = 50

    -- Other useful options
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    vim.opt.clipboard = "unnamedplus"
    vim.opt.fillchars = "eob: "

    vim.opt.winborder = 'rounded'
    vim.opt.showmode = false
    vim.opt.termguicolors = true

    vim.opt.autochdir = false

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
end

return M
