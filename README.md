> [!WARNING]
> This is a WIP plugin
> Has been renamed from autotemplate.nvim to scaffold.nvim

# scaffold.nvim

this is a neovim plugin that automatically populates new files with predefined templates based on their filetypes. This helps streamline development by automatically generating boilerplate code when creating new files. I made this for myself to use when developing spring-boot web applications.

## Currently working filetypes
* **Java:** automatically inserts a class template with package declaration.
* **Typescript React:** automatically inserts a typescript react component template.
* **Html:** generic html boilerplate.
* **C:** generic c language boilerplate.

## Features
* Automatically generates a template when a new file is created.
* Supports Java, Typescript React and HTML file types (so far).
* Optionally adds a package declartion for Java files based on their directory structure.
* Configurable to start in insert mode after populating the template.

## Installation
To install `scaffold.nvim`, you can use any Neovim plugin manager.

### Using [Packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use 'yamazhen/scaffold.nvim'
```
### Using [Lazy.nvim](https://github.com/folke/lazy.nvim)
``` lua
return {
    "yamazhen/scaffold.nvim",
    config = function()
        require("scaffold").setup({})
    end
}
```

## Configuration
You can configure the plugin with the `setup` function. Here's the default configration:

```lua
require("scaffold").setup({
    startinsert = false, -- Set this to true if you want to start in insert mode after template population
    template_dir = nil, -- Specify the directory for templates
})
```

You can create your own templates by specifying the `template_dir` configuration above. Below is the format to create a template

```template
import React from 'react'

type Props = {}

const ${FILENAME}: React.FC<Props> = () => {
  return (
    <div>
      ${CURSOR}      
    </div>
  )
}

export default ${FILENAME}
```

the plugin places your cursor on the position specified by ${CURSOR} and changes ${FILENAME} to the file's name

## Usage
Once installed, the plugin will automatically populate when you create a new file based on their filetype

## Contribution
If you would like to contribute to this plugin, feel free to open an issue or submit a pull request.
Contributions are always welcome!
