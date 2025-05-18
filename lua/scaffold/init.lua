local M = {}
M.config = {
	startinsert = false,
	template_dir = nil,
}

-- auto-detect plugin directory and set template directory
local function get_template_dir()
	if M.config.template_dir then
		return M.config.template_dir
	end

	local info = debug.getinfo(1, "S")
	local script_path = info.source:match("@(.+)")
	if script_path then
		local plugin_dir = vim.fn.fnamemodify(script_path, ":p:h")
		return plugin_dir .. "/templates"
	end

	return vim.fn.stdpath("config") .. "/scaffold/templates"
end

-- load template from file
local function load_template(filetype)
	local template_dir = get_template_dir()
	local template_path = template_dir .. "/" .. filetype .. ".template"

	local file = io.open(template_path, "r")
	if file then
		local content = file:read("*all")
		file:close()
		return content
	end

	return nil
end

-- generate java package declaration
local function get_java_package_declaration(filepath)
	local dir = vim.fn.fnamemodify(filepath, ":p:h")
	local java_pos = dir:find("src/main/java/")
	if java_pos then
		local package_path = dir:sub(java_pos + 14)
		return "package " .. package_path:gsub("/", ".") .. ";\n\n"
	end
	return ""
end

-- process template with placeholders
local function process_template(template, filetype, filepath, filename)
	if not template then
		return nil, 1, 0
	end

	local processed = template:gsub("${FILENAME}", filename)

	if filetype == "java" then
		local package_decl = get_java_package_declaration(filepath)
		if package_decl ~= "" then
			package_decl = package_decl:gsub("\n\n$", "")
			processed = processed:gsub("${PACKAGE}", package_decl)
		else
			processed = processed:gsub("${PACKAGE}\n*", "")
		end
	end

	local cursor_line, cursor_col = 1, 0
	local lines = vim.split(processed, "\n")

	for i, line in ipairs(lines) do
		local start_pos = line:find("${CURSOR}")
		if start_pos then
			cursor_line = i
			cursor_col = start_pos - 1
			lines[i] = line:gsub("${CURSOR}", "")
			break
		end
	end

	return table.concat(lines, "\n"), cursor_line, cursor_col
end

-- main function to populate file
local function populate_file(filetype, filename, filepath)
	local template = load_template(filetype)
	local content, cursor_line, cursor_col = process_template(template, filetype, filepath, filename)

	if content then
		vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(content, "\n"))
		vim.api.nvim_win_set_cursor(0, { cursor_line, cursor_col })
	end
end

-- setup function
function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter" }, {
		pattern = { "*.java", "*.tsx", "*.html", "*.c" },
		callback = function(args)
			local line_count = vim.api.nvim_buf_line_count(0)
			local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""

			if line_count == 1 and first_line == "" then
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
