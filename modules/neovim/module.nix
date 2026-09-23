{ self, inputs, ... }: {
    flake.modules.neovim.main = {
        config,
        pkgs,
        options,
        ...
    }: {
        config.specMods = {
            options.runtimePkgs = options.runtimePkgs // {
                description = ''
                A runtimePkgs spec field to put packages on the PATH
                If the spec is disabled, this value will not be included in the resulting neovim derivation
                '';
            };
        };

        config.runtimePkgs = config.specCollect (acc: v: acc ++ (v.runtimePkgs or [ ])) [ ];

        config.settings.config_directory = ./lua;

        config.specs.general = {
            data = with pkgs.vimPlugins; [
                nvim-lspconfig
                gitsigns-nvim
                which-key-nvim
                catppuccin-nvim
                bufferline-nvim
                telescope-nvim
                telescope-ui-select-nvim
                lualine-nvim
                neo-tree-nvim
                friendly-snippets
                mini-pairs
                mini-bufremove
                blink-cmp
                nvim-dap
                nvim-dap-ui
                nvim-dap-python
                conform-nvim
                nvim-web-devicons
                copilot-vim
                render-markdown-nvim
            ];

            runtimePkgs = with pkgs; [
                nixd
                lua-language-server
                typescript-language-server
                fd
                ripgrep
                clang-tools
                prettier
                prettierd
                black
                isort
                rustfmt
                rust-analyzer
                pyright
                alejandra # Nix formatter
                stylua    # Lua formatter
                shfmt     # Shell script formatter

            ];
        };

        config.specs.nvim-treesitter = {
            data = with pkgs.vimPlugins; [
                nvim-treesitter.withAllGrammars
            ];
            runtimePkgs = with pkgs; [
                tree-sitter
            ];
        };
    };

    perSystem = { system, pkgs, lib, self', ... }: {

        # Override the default pkgs bundle to allow unfree packages
        _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };

        packages.myNeovim = inputs.wrapper-modules.wrappers.neovim.wrap {

            inherit pkgs; # now refers to the overridden pkgs with allowUnfree = true

            imports = [
                self.modules.neovim.main
            ];


            # settings.dont_link = true; 
            # binName = "mynvim";
            settings.aliases = [ ];


        };
    };

}
