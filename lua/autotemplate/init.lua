local M = {}

M.config = {
	startinsert = false,
}

local templates_path = "autotemplate.templates"
M.templates = {
	java = require(templates_path .. ".java"),
	tsx = require(templates_path .. ".tsx"),
	html = require(templates_path .. ".html"),
	c = require(templates_path .. ".c"),
}

-- java package declaration
local function get_package_declaration(filepath)
	local dir = vim.fn.fnamemodify(filepath, ":p:h")
	local java_pos = dir:find("src/main/java/")
	local package_declaration = ""

	if java_pos then
		local package_path = dir:sub(java_pos + 14)
		package_declaration = "package " .. package_path:gsub("/", ".") .. ";"
	end
	return package_declaration
end

-- populate the template
local function generate_template(filetype, filepath, filename)
	local template = M.templates[filetype]
	if filetype == "java" then
		template = M.templates.java(filepath, filename)
	end

	if template then
		local populated_template = template:gsub("${FILENAME}", filename)
		return populated_template
	end
	return nil
end

-- set starting cursor position
local function set_cursor_position(filetype, package_declaration)
	local line_offset = 0
	if package_declaration ~= "" then
		line_offset = 2
	end

	if filetype == "java" then
		vim.api.nvim_win_set_cursor(0, { 2 + line_offset, 4 })
	elseif filetype == "tsx" then
		vim.api.nvim_win_set_cursor(0, { 8, 6 })
	elseif filetype == "html" then
		vim.api.nvim_win_set_cursor(0, { 9, 4 })
	elseif filetype == "c" then
		vim.api.nvim_win_set_cursor(0, { 4, 4 })
	end
end

-- main function
local function populate_file(filetype, filename, filepath)
	local package_declaration = get_package_declaration(filepath)
	local populated_template = generate_template(filetype, filepath, filename)

	if populated_template then
		vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(populated_template, "\n"))
		set_cursor_position(filetype, package_declaration)
	end
end

-- setup
function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		pattern = { "*.java", "*.tsx", "*.html", "*.c" },
		callback = function(args)
			if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
				local filepath = args.file
				local filetype = vim.fn.fnamemodify(filepath, ":e")
				local filename = vim.fn.fnamemodify(filepath, ":t:r")

				populate_file(filetype, filename, filepath)

				if M.config.startinsert then
					vim.cmd("startinsert")
				end
			end
		end,
	})
end

return M
