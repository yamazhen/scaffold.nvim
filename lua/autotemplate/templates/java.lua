return function(filepath, filename)
	local dir = vim.fn.fnamemodify(filepath, ":p:h")
	local java_pos = dir:find("src/main/java/")
	local package_declaration = ""

	if java_pos then
		local package_path = dir:sub(java_pos + 14)
		package_declaration = "package " .. package_path:gsub("/", ".") .. ";"
	end

	return (package_declaration ~= "" and package_declaration .. "\n\n" or "")
		.. "public class "
		.. filename
		.. " {\n"
		.. "    \n"
		.. "}"
end
