local M = {}

local globals = {}

local path = vim.fn.stdpath("data") .. "/spearmint.json"

local function save()
  local file = io.open(path, "w")
  if file then
    file:write(vim.fn.json_encode(globals))
    file:close()
  end
end

local function load()
  local file = io.open(path, "r")
  if file then
    local store = file:read("*a")
    file:close()
    if store and store ~= "" then
      globals = vim.fn.json_decode(store)
    end
  end
end

local function set_mark()
  local filePath = vim.api.nvim_buf_get_name(0)
  -- file path as key so that autocmd stays o(1)
  globals[filePath] = {
    char = vim.fn.getcharstr(),
    pos = vim.api.nvim_win_get_cursor(0)
  }
  save()
end

local function jump()
  for filePath, data in pairs(globals) do
    if data.char == vim.fn.getcharstr() then
      vim.cmd("edit " .. filePath)
      vim.api.nvim_win_set_cursor(0, data.pos)
    end
  end
end

function M.setup(opts)
  opts = opts or {}

  load()

  vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave" }, {
    callback = function()
      local filePath = vim.api.nvim_buf_get_name(0)
      if globals[filePath] then
        globals[filePath].pos = vim.api.nvim_win_get_cursor(0)
      end
    end
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = save
  })

  vim.keymap.set("n", opts.set_key or "m", set_mark)
  vim.keymap.set("n", opts.jump_key or "'", jump)
end

return M
