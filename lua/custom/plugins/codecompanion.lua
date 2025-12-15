vim.api.nvim_create_user_command('CC', function(opts)
  vim.cmd('CodeCompanion ' .. table.concat(opts.fargs, ' '))
end, { nargs = '*' })

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    ignore_warnings = true,
    opts = {
      log_level = 'DEBUG', -- or "TRACE"
    },
  },
}
