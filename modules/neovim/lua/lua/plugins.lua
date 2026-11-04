--
-- render-markdown
--
-- only mandatory if you want to set custom options
-- require('render-markdown').setup({})

--
-- copilot
--
vim.keymap.set("i", "<C-l>", "<Plug>(copilot-accept-line)", { silent = true })

--
-- filetypes
--
vim.filetype.add({
	extension = {
		hbs = "handlebars",
	},
})
-- vim.treesitter.language.register("html", "handlebars")
vim.api.nvim_create_autocmd("FileType", {
	pattern = "handlebars",
	callback = function()
		vim.treesitter.language.register("html", "handlebars")
		-- Optional: force-restart treesitter for the current buffer
		pcall(vim.treesitter.start)
	end,
})

--
-- lsp
--
-- add handlebars to the list of filetypes for html
vim.lsp.enable({ "lua_ls", "clangd", "pyright", "nixd", "rust_analyzer", "protols", "ts_ls", "html", "cssls", "jsonls" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "code action" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration(vim.lsp (test))" })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "[f]ormat buffer using lsp" })
vim.keymap.set({ "n", "v" }, "<leader>cF", function()
	require("conform").format({
		async = true,
		lsp_format = "fallback",
	})
end, { desc = "[F]ormat buffer using conform" })

--
-- conform
--
require("conform").setup({
	formatters_by_ft = {
		nix = { "alejandra" },
		lua = { "stylua" },
		sh = { "shfmt" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		json = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
	},
	-- format_on_save = {
	-- 	timeout_ms = 500,
	-- 	lsp_format = "fallback",
	-- },
})

--
-- mini
--
require("mini.pairs").setup()
require("mini.bufremove").setup()
vim.keymap.set("n", "<leader>bd", require("mini.bufremove").delete, { desc = "buffer delete" })

--
-- git signs
--
require("gitsigns").setup()

--
-- which-key
--
require("which-key").add({
	{ "<leader>s", group = "search" },
	{ "<leader>b", group = "buffer" },
	{ "<leader>c", group = "code" },
	{ "<leader>d", group = "debug" },
	{ "<leader>q", group = "session" },
})

--
-- telescope
--
require("telescope").setup({
	-- ui extension for code actions
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({
				-- even more opts
			}),
		},
	},
})
require("telescope").load_extension("ui-select")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "find buffer" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "find files" })
vim.keymap.set("n", "<leader>sF", function()
	builtin.find_files({ hidden = true })
end, { desc = "find hidden files" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "live grep" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = 'find recent files ("." for repeat)' })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "search help" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "search keymaps" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "search telescope" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "search current word" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "search diagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "search resume" })

-- load lsp keymaps on LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
	callback = function(event)
		vim.keymap.set("n", "gs", builtin.lsp_document_symbols, { desc = "goto document symbols" })
		-- TODO: whats the deference between workspace and dynamic workspace
		vim.keymap.set("n", "gS", builtin.lsp_workspace_symbols, { desc = "goto workspace symbols" })
		vim.keymap.set("n", "gw", builtin.lsp_dynamic_workspace_symbols, { desc = "goto dynamic workspace symbols" })

		vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "goto reference" })
		vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "goto definition" })
		vim.keymap.set("n", "gt", builtin.lsp_type_definitions, { desc = "goto type definition" })
		vim.keymap.set("n", "gI", builtin.lsp_implementations, { desc = "goto implementation" })
	end,
})

--
-- lualine
--
require("lualine").setup({
	options = {
		globalstatus = true,
		showtabline = 2,
	},
	-- tabline = {
	--   lualine_a = {},
	--   lualine_b = {{'buffers', max_length = vim.o.columns}}, -- You can add other components here if needed
	--   lualine_c = {},
	--   lualine_x = {},
	--   lualine_y = {},
	--   lualine_z = {},
	-- },
})

--
-- neo-tree
--
require("neo-tree")
vim.keymap.set("n", "\\", ":Neotree toggle<CR>", {})
vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})

--
-- theme setup
--
--
require("catppuccin").setup({
	integrations = {
		blink_cmp = { enabled = true, style = "bordered" }, -- Enable the blink.cmp integration
	},
})
vim.cmd.colorscheme("catppuccin")
--
-- require('matugen').setup()
--
-- require("pixel").setup({
--   disable_italics = false,
-- })
-- vim.cmd.colorscheme("pixel")

--
-- bufferline
--
require("bufferline").setup({
	highlights = require("catppuccin.special.bufferline").get_theme(),
})

--
-- blink.cmp
--
require("blink.cmp").setup({
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
	keymap = {
		preset = "super-tab",
	},

	-- signature = { enabled = true },

	cmdline = {
		keymap = { preset = "inherit" },
		completion = {
			menu = { auto_show = true },
			-- list = { selection = { preselect = false, auto_insert = true }},
		},
	},

	appearance = {
		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
		-- use_nvim_cmp_as_default = true,
	},

	-- (Default) Only show the documentation popup when manually triggered
	completion = {
		documentation = { auto_show = false },
		menu = {
			-- auto_show = false,
			-- border = 'rounded',
			scrollbar = false,
		},
		-- ghost_text = { enable = true, show_with_menu = true },
		-- list = { selection = { preselect = false, auto_insert = true }},
	},

	-- Default list of enabled providers defined so that you can extend it
	-- elsewhere in your config, without redefining it, due to `opts_extend`
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},

	-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
	-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
	-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
	--
	-- See the fuzzy documentation for more information
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

---
--- dap
---
local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "toggle breakpoint" })
vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "continue" })
vim.keymap.set("n", "<Leader>do", dap.step_over, { desc = "step over" })
vim.keymap.set("n", "<Leader>dO", dap.step_out, { desc = "step out" })
vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "step into" })
vim.keymap.set("n", "<Leader>dq", dap.terminate, { desc = "terminate" })
vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "toggle ui" })

vim.fn.sign_define("DapBreakpoint", {
	text = "",
	texthl = "DiagnosticSignError",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DapBreakpointRejected", {
	text = "", -- or "❌"
	texthl = "DiagnosticSignError",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DapStopped", {
	text = "", -- or "→"
	texthl = "DiagnosticSignWarn",
	linehl = "Visual",
	numhl = "DiagnosticSignWarn",
})

--
-- dap c/rust
--
dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}
dap.configurations.c = {
	{
		name = "Launch",
		type = "gdb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		args = {}, -- provide arguments if needed
		cwd = "${workspaceFolder}",
		stopAtBeginningOfMainSubprogram = false,
	},
	{
		name = "Select and attach to process",
		type = "gdb",
		request = "attach",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		pid = function()
			local name = vim.fn.input("Executable name (filter): ")
			return require("dap.utils").pick_process({ filter = name })
		end,
		cwd = "${workspaceFolder}",
	},
	{
		name = "Attach to gdbserver :1234",
		type = "gdb",
		request = "attach",
		target = "localhost:1234",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
	},
}

--
-- dap python
--
require("dap-python").setup("python3")

-- -- NOT WORKING probably because of telescope
-- --
-- -- Move the last added configuration to the first position.
-- -- allow custom configurations in .vscode/launch.json to be first in list
-- --
-- local configs = dap.configurations.python
-- if #configs > 1 then
--     local last = table.remove(configs)
--     table.insert(configs, 1, last)
-- end
--
