# spearmint

a [harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2) style upgrade to default neo/vim marks but in ~69 LOC (nice)

## to install

with nvim 0.12.0+
  ```lua
  vim.pack.add({ "https://github.com/adithyasource/spearmint" })
  ```

or add `adithyasource/spearmint` to your favourite package manager of choice

or install it manually
  ```bash
  git clone https://github.com/adithyasource/spearmint.nvim ~/.config/nvim/pack/nvim/start/spearmint.nvim
  ```

run this to enable its functionality
  ```lua
  require('spearmint').setup()
  ```

## how to use

- with the default config, hit `m` followed by any character and your file will be assigned to that key.
- as you move around files and change locations, if you ever need to go back to that file, hit `'` followed by the character you want
- you'll be taken back to your last position in that file

## configure

default config
  ```lua
  {
    set_key = "m",
    jump_key = "'"
  }
  ```

pass an updated table to the setup function to change the keymaps; example:
  ```lua
  require('spearmint').config({
    set_key = "<C-h>"
  })
  ```
