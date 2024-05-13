vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = false
vim.o.smartindent = true

vim.opt.autochdir = false
vim.keymap.set({ "n" }, "<leader>c", [[:w<CR>:term go test ./lexer<CR>]], { desc = "" })
vim.keymap.set({ "n" }, "<leader>p", [[:w<CR>:!python %<CR>]], { desc = "" })
-- vim.keymap.set({ "n" }, "<leader>t", [[:w<CR>:term python %<CR>]], { desc = "" })

vim.keymap.set({ "n" }, "<leader>fs", [[:w<CR>]], { desc = "" })
vim.keymap.set({ "n" }, "<leader>bp", [[:bp<CR>]], { desc = "" })
vim.keymap.set({ "n" }, "<leader>bn", [[:bn<CR>]], { desc = "" })
vim.keymap.set({ "n" }, "<leader>bd", [[:bd<CR>]], { desc = "" })
vim.keymap.set({ "n" }, "<leader>q", [[:bd<CR>]], { desc = "" })

local function run_file()
	local filetype = vim.bo.filetype
	vim.cmd("w")
	if filetype == "python" then
		vim.cmd("term python %")
	elseif filetype == "go" then
		vim.cmd("term go run .")
	elseif filetype == "rust" then
		vim.cmd("term cargo run")
	end
end

vim.keymap.set({ "n" }, "<leader>t", function() run_file() end, { desc = "" })

local harpoon = require("harpoon")
-- REQUIRED
harpoon:setup({})

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

-- Update list of files to use with harpoon
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- Harpoon keymaps for J K L ;
vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(4) end)

-- -- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

-- Terminal mode binds
vim.keymap.set("t", "<C-j>", function() harpoon:list():select(1) end)
vim.keymap.set("t", "<C-k>", function() harpoon:list():select(2) end)

-- vim.keymap.set("t", "<C-l>", function() harpoon:list():select(3) end)
vim.keymap.set("t", "<C-;>", function() harpoon:list():select(4) end)
vim.keymap.set({ "t" }, "<ESC>", [[<C-\><C-n>]], { desc = "" })

-- Harpoon-like mark jumping
vim.keymap.set("n", "<C-a>", [['a zz]])
vim.keymap.set("n", "<C-s>", [['s zz]])
vim.keymap.set("i", "<C-a>", [[<ESC>'a zzi]])
vim.keymap.set("i", "<C-s>", [[<ESC>'s zzi]])

-- Quick project file tree
vim.keymap.set("n", "<C-t>", [[:term exa -T<CR>]])
