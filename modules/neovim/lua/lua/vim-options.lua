vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

vim.opt.swapfile = false

-- Navigate vim panes
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Switch buffers
vim.keymap.set('n', '<C-n>', vim.cmd.bn, { desc = 'Move focus to next buffer' })
vim.keymap.set('n', '<C-p>', vim.cmd.bp, { desc = 'Move focus to previous buffer' })

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- vim.wo.number = true
vim.opt.relativenumber = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = false
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show which line your cursor is on
-- vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
-- vim.opt.timeoutlen = 300


-- indention options should be overriden by tree-sitter, TODO double check
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.tabstop = 4        -- Number of spaces a <Tab> in the file counts for
vim.opt.shiftwidth = 4     -- Number of spaces to use for each step of indent
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.opt.cindent = true

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("options_highlight_yank", { clear = true }),
	callback = function()
		(vim.hl or vim.highlight).on_yank()
	end,
})

vim.opt.winborder = "rounded"

vim.diagnostic.config({
	virtual_text = true,
  -- vitual_lines = { current_line = true },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "󰋼",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
	-- float = {
		-- border = "rounded",
		-- format = function(d)
		-- 	return ("%s (%s) [%s]"):format(d.message, d.source, d.code or d.user_data.lsp.code)
		-- end,
	-- },
	-- underline = true,
	-- jump = {
	-- 	float = true,
	-- },
})

-- bytecode cache for faster startup
vim.loader.enable()
