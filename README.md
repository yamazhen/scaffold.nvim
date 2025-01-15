> [!WARNING]
> This is a WIP plugin

# AutoTemplate.nvim

**autotemplate.nvim** is a neovim plugin that automatically populates new files with predefined templates based on their filetypes. This helps streamline development by automatically generating boilerplate code when creating new files.

## Currently working filetypes
* **Java:** automatically inserts a class template with package declaration.
* **Typescript React:** automatically inserts a typescript react component template.
* **Html:** generic html boilerplate.

## Features
* Automatically generates a template when a new file is created.
* Supports Java, Typescript React and HTML file types (so far).
* Optionally adds a package declartion for Java files based on their directory structure.
* Configurable to start in insert mode after populating the template.

## Installation
To install `autotemplate.nvim`, you can use any Neovim plugin manager.

### Using [Packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use 'yamazhen/autotemplate.nvim'
```
### Using [Lazy.nvim](https://github.com/folke/lazy.nvim)
``` lua
return {
    "yamazhen/autotemplate.nvim",
    config = function()
        require("autotemplate").setup({})
    end
}
```

## Configuration
You can configure the plugin with the `setup` function. Here's the default configration:

```lua
require("autotemplate").setup({
    startinsert = false, -- Set this to true if you want to start in insert mode after template population
})
```

## Usage
Once installed, the plugin will automatically populate when you create a new file based on their filetype

## Contribution
If you would like to contribute to this plugin, feel free to open an issue or submit a pull request.
Contributions are always welcome!
