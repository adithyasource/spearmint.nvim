local marks = {}
local globals = {}

local path = vim.fn.stdpath("data") .. "/simplemarks.json"

local function save()
  local f = io.open(path, "w")
  if f then
    f:write(vim.fn.json_encode(globals))
    f:close()
  end
end

local function load()
  local f = io.open(path, "r")
  if f then
    local c = f:read("*a")
    f:close()
    if c and c ~= "" then
      globals = vim.fn.json_decode(c)
    end
  end
end

load()

local function set()
  local c = vim.fn.getcharstr()
  if c:match("%l") then
    local b = vim.api.nvim_get_current_buf()
    if not marks[b] then marks[b] = {} end
    marks[b][c] = vim.api.nvim_win_get_cursor(0)
  elseif c:match("%u") then
    globals[c] = {
      f = vim.api.nvim_buf_get_name(0),
      p = vim.api.nvim_win_get_cursor(0)
    }
    save()
  end
end

local function jump()
  local c = vim.fn.getcharstr()
  if c:match("%l") then
    local b = vim.api.nvim_get_current_buf()
    local p = marks[b] and marks[b][c]
    if p then vim.api.nvim_win_set_cursor(0, p) end
  elseif c:match("%u") then
    local g = globals[c]
    if g then
      vim.cmd("edit " .. g.f)
      vim.api.nvim_win_set_cursor(0, g.p)
    end
  end
end

vim.api.nvim_create_autocmd({"CursorMoved", "BufLeave"}, {
  callback = function()
    local f = vim.api.nvim_buf_get_name(0)
    local p = vim.api.nvim_win_get_cursor(0)
    for k, g in pairs(globals) do
      if g.f == f then
        globals[k].p = p
      end
    end
  end
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = save
})

vim.keymap.set("n", "m", set)
vim.keymap.set("n", "'", jump)

print("plugin loaded")
