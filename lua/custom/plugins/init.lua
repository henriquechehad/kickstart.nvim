-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- auto session (per folder)
local function session_file()
  return vim.fn.stdpath 'state' .. '/session-' .. vim.fn.getcwd():gsub('/', '_') .. '.vim'
end

vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    vim.cmd('mksession! ' .. session_file())
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.schedule(function()
      local s = session_file()
      if vim.fn.filereadable(s) == 1 then
        vim.cmd('source ' .. s)
      end
    end)
  end,
})

return {}
