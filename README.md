<div align="center">

# dotnet-uninstall.sh

</div>

This script is an unofficial tool for bulk removal of specific versions of the .NET SDK/runtime in a Linux environment installed using [dotnet-install.sh](https://github.com/dotnet/install-scripts)

As background, while dotnet-install.sh provides a means of installation into the user space e.g. `~/.dotnet` that does not use the Linux distribution's package manager, the uninstall tool [dotnet-core-uninstall-tool](https://github.com/dotnet/cli-lab), still This is because it only supports Windows and macOS and does not yet support Linux.


**NOTE**: *.NET* here is the cross-platform, modern implementation of .NET, formerly called *.NET Core*, as opposed to *Mono* or *.NET Framework.*

## Usage

Basically, it is executed by specifying the version prefix as the argument of the `--version <prefix>` option.
This searches the version directory with forward matching, so there is no need to be aware of what the subrevision is.
For example, if you have the version `7.0.410` of the SDK installed, you can specify `--version 7.0`.

To check the operation without executing the removal, add the `--dry-run` option.
In addition, you can omit answering the confirmation message and immediately execute the removal by adding `--yes`.

You can also run with the `--list` option to check for installed SDKs and runtimes. (You can also check with: `dotnet --list-sdks`, `dotnet --list-runtimes`, `dotnet --info`)

```

About:
  ./dotnet-uninstall.sh - Unofficial uninstall script for Linux installed with dotnet-install.sh

Usage:
  ./dotnet-uninstall.sh -v <version-prefix> [-r <runtime>]... [options]

Description:
  Uninstalls specified versions of .NET SDKs and runtimes from a given install directory.
  Supports dry-run, interactive confirmation, and listing installed versions.

Options:
  -v, --version <prefix>       Version prefix to match (e.g., 7.0)
  -r, --runtime <type>         Runtime type to target:
                                 - sdk
                                 - dotnet     (Microsoft.NETCore.App)
                                 - aspnetcore (Microsoft.AspNetCore.App)
                               can be specified multiple times like: ./dotnet-uninstall.sh -r sdk -r dotnet
      --install-dir <path>     Custom install directory (default: ~/.dotnet)
      --dry-run                Show matching versions without deleting
  -y, --yes                    Skip confirmation prompt and uninstall directly
  -l, --list                   List installed versions of sdk, dotnet, and aspnetcore
      --help                   Show this help message

Examples:
  ./dotnet-uninstall.sh -v 7.0
      Uninstall all 7.0.* versions of all runtimes (sdk, dotnet, aspnetcore)

  ./dotnet-uninstall.sh -v 6.0 -r sdk -r dotnet
      Uninstall only sdk and dotnet runtimes for 6.0.*

  ./dotnet-uninstall.sh -v 8.0 --dry-run
      Preview uninstall targets for 8.0.* without actually deleting

  ./dotnet-uninstall.sh --list
      Show all installed SDKs and runtimes

  ./dotnet-uninstall.sh -v 7.0 -y
      Uninstall all 7.0.* versions without confirmation

More Info:
  To check more informations about dotnet-install scripts, see Microsoft Docs:
      https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script

  Install scripts repository is available on GitHub: 
      https://github.com/dotnet/install-scripts
```

## Installation

Download the latest version script from the  release page and grant executable permissions like `chmod +x ./dotnet-uninstall.sh`.

> [Latest Release](https://github.com/sheepla/dotnet-uninstall/releases/tag/latest)

```sh
curl -sL -o dotnet-uninstall.tar.gz https://github.com/sheepla/dotnet-uninstall/archive/refs/tags/v0.0.1.tar.gz
tar xf dotnet-uninstall.tar.gz
cd dotnet-uninstall-0.0.1/
chmod +x ./dotnet-uninstall.sh
```

## See Also

- [dotnet-install scripts reference - Microsoft Docs](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script)
- [dotnet/install-scripts - GitHub](https://github.com/dotnet/install-scripts)
- [dotnet-uninstall tool overview - Microsoft Docs](https://learn.microsoft.com/en-us/dotnet/core/additional-tools/uninstall-tool-overview?pivots=os-windows)
- [dotnet/cli-lab (dotnet-core-uninstall-tool) - GitHub](https://github.com/dotnet/cli-lab)
