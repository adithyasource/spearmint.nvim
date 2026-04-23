# spearmint

no bs upgrade to default neovim marks but in ~100 LOC

## to install

with nvim 0.12.0+
  ```lua
  vim.pack.add({ "https://github.com/adithyasource/spearmint.nvim" })
  ```

or add `adithyasource/spearmint.nvim` to your favourite package manager of choice

or install it manually
  ```bash
  git clone https://github.com/adithyasource/spearmint.nvim ~/.config/nvim/pack/nvim/start/spearmint.nvim
  ```

add this to your config to enable its functionality
  ```lua
  require('spearmint').setup()
  ```
and configure the jump and set_mark keymaps
```lua
vim.keymap.set("n", "m", function() Spearmint.set_mark() end)
vim.keymap.set("n", "'", function() Spearmint.jump() end)
  ```
> i like to override the functionality of vim marks so i use the `m` and `'` key to use spearmint but you can set your own keymaps

## how to use

- hit the `set_mark` key followed by any character and your file will be assigned to that key.
- as you move around files and change locations, if you ever need to go back to that file, hit the `jump` key followed by the character you want
- you'll be taken back to your last position in that file

## why?
i wanted something not as heavy as harpoon; it has a ui which i end up not using often, so i ended up using default vim marks but they had no project context and required me to hit caps lock for setting "global" marks. thus, i ended up making this: has project wise marks, really lightweight and works with terminal buffers :]

## acknowledgments

<table>
    <tbody>
        <tr>
            <th>inspired by</th>
            <td><a href="https://github.com/ThePrimeagen/harpoon/tree/harpoon2" target="_blank">harpoon (theprimeagen)</a></td>
        </tr>
    </tbody>
</table>
