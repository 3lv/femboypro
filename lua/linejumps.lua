local M = { }

local data = {
	init = false,
}

M.data = data

local lines = {
	empty     = "                                        ",
	full      = "########################################",
}


M.Create_Scratchbuf = function()
	--unlisted and 'scratch'
	local bufid = vim.api.nvim_create_buf(false, true)
	return bufid
end


M.Random_Line = function()
	local topline = 0
	local botline = vim.fn.line('$') - 1
	local randomline = math.random(topline,botline)
	if data.currentline ~= nil then
		vim.api.nvim_buf_set_lines(0, data.currentline, data.currentline + 1, false, { lines.empty })
	end
	data.currentline = randomline
	vim.api.nvim_buf_set_lines(0, randomline, randomline + 1, false, { lines.full })
end

M.Check_Line = function()
	if vim.fn.line('.') - 1 == data.currentline then
		M.Random_Line()
	end
end

local async_check_request = vim.loop.new_async(vim.schedule_wrap(M.Check_Line))
M.async_check_call = function() async_check_request:send() end

M.Init = function()
	if data.init == false then
		math.randomseed(os.time())
	end
	vim.cmd[[
	augroup femboypro
	autocmd!
	autocmd CursorMoved * lua require'linejumps'.async_check_call()
	autocmd CursorMoved * echo 'super'
	augroup END
	]]
	M.Random_Line()
end

return M
