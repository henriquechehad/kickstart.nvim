-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- auto session (per folder)
-- Pin the project dir at startup: saving uses this dir, never whatever cwd
-- a restored session left behind (mksession embeds a `cd`, which previously
-- made project A's session overwrite/leak into project B).
local startup_cwd = vim.fn.getcwd()

local function session_file()
  return vim.fn.stdpath 'state' .. '/session-' .. startup_cwd:gsub('/', '_') .. '.vim'
end

local function wipe_tree_buffers()
  -- close + wipe neo-tree buffers: they are UI chrome, not document state.
  -- mksession would otherwise store the tree window as a dead blank buffer
  -- ("neo-tree filesystem [1]") that restores as a fake, non-navigable tree.
  pcall(vim.cmd, 'Neotree close')
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[b].filetype == 'neo-tree' then
      pcall(vim.api.nvim_buf_delete, b, { force = true })
    end
  end
end

vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    wipe_tree_buffers()
    vim.cmd('mksession! ' .. vim.fn.fnameescape(session_file()))
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.schedule(function()
      local s = session_file()
      if vim.fn.filereadable(s) == 1 then
        vim.cmd('source ' .. vim.fn.fnameescape(s))
        -- undo the `cd` embedded in the session so we stay in this project
        vim.cmd('cd ' .. vim.fn.fnameescape(startup_cwd))
        -- wipe fake tree buffers restored from sessions saved before this
        -- fix: they are named like "neo-tree filesystem [1]" but are plain
        -- empty buffers (real ones have filetype == 'neo-tree')
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_get_name(b):match '^neo%-tree' and vim.bo[b].filetype ~= 'neo-tree' then
            pcall(vim.cmd, 'bwipe! ' .. b)
          end
        end
      end
    end)
  end,
})

return {}
