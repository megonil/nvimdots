return
{
    {
        "nvim-telescope/telescope.nvim",
        config = function()
            require("config.telescope").setup()
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = function()
            return require("config.treesitter")
        end,
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "saghen/blink.cmp", "L3MON4D3/LuaSnip" },
        opts = {
            servers = {
                lua_ls = {},
                bashls = {},
                prismals = {},
                rust_analyzer = {},
                clangd = {
                    cmd = {
                        "clangd",
                        "--compile-commands-dir=build",
                        "--clang-tidy",
                        "--clang-tidy-checks=*",
                    },
                },
                ts_ls = {},
                eslint = {},
                pyright = {},
                cmake = {},
                asm_lsp = {},
                marksman = {},
                yamlls = {},
                hls = {},
                jdtls = {},
            },
        },
        config = function(_, opts)
            local blink = require("blink.cmp")
            for server, server_opts in pairs(opts.servers) do
                server_opts.capabilities = blink.get_lsp_capabilities(server_opts.capabilities)
                vim.lsp.config[server] = server_opts
                vim.lsp.enable(server)
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end

                    local map_opts = { buffer = bufnr, silent = true }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts)
                    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, map_opts)
                    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, map_opts)
                    vim.keymap.set("n", "<M-j>", vim.diagnostic.goto_next, { silent = true })
                    vim.keymap.set("n", "<M-k>", vim.diagnostic.goto_prev, { silent = true })
                    vim.keymap.set("n", "<C-.>", vim.lsp.buf.code_action, map_opts)
                    vim.keymap.set("n", "<C-R>", vim.lsp.buf.references, map_opts)
                    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, map_opts)
                    vim.keymap.set("n", "<leader>U", vim.lsp.buf.signature_help, map_opts)

                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr })
                            end,
                        })
                    end
                end,
            })
        end,
    },
    {
        "saghen/blink.cmp",
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '1.*',
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = { preset = 'default' },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                nerd_font_variant = 'mono',
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = { documentation = { auto_show = false, auto_show_delay_ms = 200 }, ghost_text = { enabled = true } },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer', 'omni' },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "rust" }
        },
        opts_extend = { "sources.default" }

    },

    {
        "akinsho/toggleterm.nvim",
        --    config = function()
        --        require('toggleterm').setup(require('config.toggleterm').setup())
        --    end
        version = "*",
        opts = {
            open_mapping = [[<C-j>]],
            autochdir = true,
        },
        config = true
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local bufferline = require("bufferline")
            bufferline.setup({
                options = {
                    mode = "buffers", -- set to "tabs" to only show tabpages instead
                    style_preset = bufferline.style_preset.minimal, -- or bufferline.style_preset.minimal,
                    themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
                    numbers = "ordinal",
                    close_command = "bdelete! %d", -- can be a string | function, | false see "Mouse actions"
                    right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
                    left_mouse_command = "buffer %d", -- can be a string | function, | false see "Mouse actions"
                    middle_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
                    indicator = {
                        icon = '▎', -- this should be omitted if indicator style is not 'icon'
                        style = 'icon', -- | 'underline' | 'none',
                    },
                    buffer_close_icon = '󰅖',
                    modified_icon = '● ',
                    close_icon = ' ',
                    left_trunc_marker = ' ',
                    right_trunc_marker = ' ',
                    --- name_formatter can be used to change the buffer's label in the bufferline.
                    --- Please note some names can/will break the
                    --- bufferline so use this at your discretion knowing that it has
                    --- some limitations that will *NOT* be fixed.
                    name_formatter = function(buf) -- buf contains:
                        -- name                | str        | the basename of the active file
                        -- path                | str        | the full path of the active file
                        -- bufnr               | int        | the number of the active buffer
                        -- buffers (tabs only) | table(int) | the numbers of the buffers in the tab
                        -- tabnr (tabs only)   | int        | the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`
                    end,
                    max_name_length = 18,
                    max_prefix_length = 15,               -- prefix used when a buffer is de-duplicated
                    truncate_names = true,                -- whether or not tab names should be truncated
                    tab_size = 18,
                    diagnostics = "nvim_lsp",             -- | "nvim_lsp" | "coc",
                    diagnostics_update_in_insert = false, -- only applies to coc
                    diagnostics_update_on_event = true,   -- use nvim's diagnostic handler
                    -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        return "(" .. count .. ")"
                    end,
                    -- NOTE: this will be called a lot so don't do any heavy processing here
                    custom_filter = function(buf_number, buf_numbers)
                        -- filter out filetypes you don't want to see
                        if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
                            return true
                        end
                        -- filter out by buffer name
                        if vim.fn.bufname(buf_number) ~= "[No Name]" then
                            return true
                        end
                        -- filter out based on arbitrary rules
                        -- e.g. filter out vim wiki buffer from tabline in your work repo
                        if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
                            return true
                        end
                        -- filter out by it's index number in list (don't show first buffer)
                        if buf_numbers[1] ~= buf_number then
                            return true
                        end
                    end,
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "File Explorer",
                            text_align = "left",
                            separator = true
                        }
                    },
                    color_icons = true, -- | false, -- whether or not to add the filetype icon highlights
                    get_element_icon = function(element)
                        -- element consists of {filetype: string, path: string, extension: string, directory: string}
                        -- This can be used to change how bufferline fetches the icon
                        -- for an element e.g. a buffer or a tab.
                        -- e.g.
                        local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype,
                            { default = false })
                        return icon, hl
                        -- or
                        -- local custom_map = {my_thing_ft: {icon = "my_thing_icon", hl}}
                        -- return custom_map[element.filetype]
                    end,
                    show_buffer_icons = true, -- disable filetype icons for buffers
                    show_buffer_close_icons = false,
                    show_close_icon = true,
                    show_tab_indicators = true,
                    duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
                    persist_buffer_sort = true,      -- whether or not custom sorted buffers should persist
                    move_wraps_at_ends = false,      -- whether or not the move command "wraps" at the first or last position
                    -- can also be a table containing 2 custom separators
                    -- [focused and unfocused]. eg: { '|', '|' }
                    separator_style = "slope", -- | "slope" | "thick" | "thin" | { 'any', 'any' },
                    enforce_regular_tabs = false,
                    always_show_bufferline = false,
                    auto_toggle_bufferline = true,
                    hover = {
                        enabled = true,
                        delay = 200,
                        reveal = { 'close' }
                    },
                    sort_by = '', -- |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
                    -- add custom logic
                    -- local modified_a = vim.fn.getftime(buffer_a.path)
                    -- local modified_b = vim.fn.getftime(buffer_b.path)
                    -- return modified_a > modified_b
                    -- end,
                    pick = {
                        alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
                    },
                }
            })
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                    refresh_time = 16,
                    events = {
                        'WinEnter',
                        'BufEnter',
                        'BufWritePost',
                        'SessionLoadPost',
                        'FileChangedShellPost',
                        'VimResized',
                        'Filetype',
                        'CursorMoved',
                        'CursorMovedI',
                        'ModeChanged',
                    },
                }
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { 'filename' },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'lsp_status' },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        }
    },
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },

        config = function()
            local api = require("nvim-tree.api")

            local function open_nvim_tree(data)
                if vim.fn.isdirectory(data.file) ~= 1 then return end
                vim.cmd.enew()
                vim.cmd.bw(data.buf)
                vim.cmd.cd(data.file)
                api.tree.open()
            end

            vim.api.nvim_create_autocmd("VimEnter", {
                callback = open_nvim_tree,
            })

            require("nvim-tree").setup({
                disable_netrw = true,
                hijack_directories = { enable = true, auto_open = true },
                update_focused_file = { enable = true, update_cwd = true },
                sort = { sorter = "case_sensitive" },
            })
        end,

        keys = {
            { "<C-n>", function() vim.cmd("NvimTreeToggle") end,  mode = "n" },
            { "<C-f>", function() vim.cmd("NvimTreeFindFile") end },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter.configs").setup {
                select = {
                    enable = true,

                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,

                    keymaps = {
                        -- Functions
                        ["mF"] = "@function.outer", -- select around function (mnemonic: "Motion Function")
                        ["mf"] = "@function.inner", -- select inside function

                        -- Classes / structs
                        ["mC"] = "@class.outer", -- around class
                        ["mc"] = "@class.inner", -- inside class

                        -- Parameters
                        ["mp"] = "@parameter.outer", -- around parameter
                        ["mP"] = "@parameter.inner", -- inside parameter

                        -- Scopes / blocks
                        ["ms"] = { query = "@local.scope", query_group = "locals", desc = "Select local scope" },
                    },

                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V',  -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },                              -- If you set this to `true` (default is `false`) then any textobject is
                    -- extended to include preceding or succeeding whitespace. Succeeding
                    -- whitespace has priority in order to act similarly to eg the built-in
                    -- `ap`.
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * selection_mode: eg 'v'
                    -- and should return true or false
                    include_surrounding_whitespace = true,
                },
            }
        end,
    },
    {
        "numToStr/Comment.nvim",
        opts = {
            padding = true,
            sticky = true,
            toggler = {
                line = 'gcc',
                block = 'gbc'
            },
            opleader = {
                line = 'gc',
                block = 'gb'
            },
            extra = {
                above = 'gc0',
                below = 'gco',
                eol = 'gcA'
            },
            mappings = {
                basic = true,
                extra = true,
            },
            pre_hook = nil,
            post_hook = nil
        }
    },
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        opts = function(_, opts)
            local ls = require("luasnip")

            vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

            require("luasnip.loaders.from_vscode").lazy_load() -- friendly-snippets
            require("luasnip.loaders.from_lua").lazy_load({
                paths = vim.fn.stdpath("config") .. "/snippets"
            })
        end
    },
    {
        "mfussenegger/nvim-jdtls"
    }

}
