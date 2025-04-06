#!/usr/bin/env bash

set -e

INSTALL_DIR="$HOME/.dotnet"
VERSION_PREFIX=""
RUNTIMES=()
DRY_RUN=false
AUTO_YES=false
LIST_MODE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--version)
            VERSION_PREFIX="$2"
            shift 2
            ;;
        -r|--runtime)
            RUNTIMES+=("$2")
            shift 2
            ;;
        --install-dir)
            INSTALL_DIR="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -y|--yes)
            AUTO_YES=true
            shift
            ;;
        -l|--list)
            LIST_MODE=true
            shift
            ;;
        -h|--help)
            cat <<EOF
About:
  $0 - Unofficial uninstall script for Linux installed with dotnet-install.sh

Usage:
  $0 -v <version-prefix> [-r <runtime>]... [options]

Description:
  Uninstalls specified versions of .NET SDKs and runtimes from a given install directory.
  Supports dry-run, interactive confirmation, and listing installed versions.

Options:
  -v, --version <prefix>       Version prefix to match (e.g., 7.0)
  -r, --runtime <type>         Runtime type to target:
                                 - sdk
                                 - dotnet (Microsoft.NETCore.App)
                                 - aspnetcore (Microsoft.AspNetCore.App)
                               can be specified multiple times like: $0 -r sdk -r dotnet
      --install-dir <path>     Custom install directory (default: ~/.dotnet)
      --dry-run                Show matching versions without deleting
  -y, --yes                    Skip confirmation prompt and uninstall directly
  -l, --list                   List installed versions of SDK, dotnet, and aspnetcore
      --help                   Show this help message

Examples:
  $0 -v 7.0
      Uninstall all 7.0.* versions of all runtimes (sdk, dotnet, aspnetcore)

  $0 -v 6.0 -r sdk -r dotnet
      Uninstall only sdk and dotnet runtimes for 6.0.*

  $0 -v 8.0 --dry-run
      Preview uninstall targets for 8.0.* without actually deleting

  $0 --list
      Show all installed SDKs and runtimes

  $0 -v 7.0 -y
      Uninstall all 7.0.* versions without confirmation

More Info:
  To check more informations about dotnet-install scripts, see Microsoft Docs:
      https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script

  Install scripts repository is available on GitHub: 
      https://github.com/dotnet/install-scripts
EOF
            exit 0
            ;;
        *)
            echo "Unknown argument: $1"
            echo "To see command line usage of this script, run: $0 --help"
            exit 1
            ;;
    esac
done


if $LIST_MODE; then
    echo "[sdk]"
    SDK_DIR="$INSTALL_DIR/sdk"
    if [[ -d "$SDK_DIR" ]]; then
        find "$SDK_DIR" -maxdepth 1 -mindepth 1 -type d | sort | while read -r dir; do
            ver=$(basename "$dir")
            echo "  $ver    $dir"
        done
    else
        echo "  (none)"
    fi

    echo "[dotnet]"
    RUNTIME_DIR="$INSTALL_DIR/shared/Microsoft.NETCore.App"
    if [[ -d "$RUNTIME_DIR" ]]; then
        find "$RUNTIME_DIR" -maxdepth 1 -mindepth 1 -type d | sort | while read -r dir; do
            ver=$(basename "$dir")
            echo "  $ver    $dir"
        done
    else
        echo "  (none)"
    fi

    echo "[aspnetcore]"
    ASP_DIR="$INSTALL_DIR/shared/Microsoft.AspNetCore.App"
    if [[ -d "$ASP_DIR" ]]; then
        find "$ASP_DIR" -maxdepth 1 -mindepth 1 -type d | sort | while read -r dir; do
            ver=$(basename "$dir")
            echo "  $ver    $dir"
        done
    else
        echo "  (none)"
    fi

    exit 0
fi

if [[ -z "$VERSION_PREFIX" ]]; then
    echo "Error: --version <prefix> is required."
    echo "To see command line usage of this script, run: $0 --help"
    exit 1
fi

# The default is to target all of these runtimes: sdk, dotnet, aspnetcore
if [[ ${#RUNTIMES[@]} -eq 0 ]]; then
    RUNTIMES=(sdk dotnet aspnetcore)
fi

MATCHING_DIRS=()

for RUNTIME_TYPE in "${RUNTIMES[@]}"; do
    case "$RUNTIME_TYPE" in
        sdk)
            BASE_DIR="$INSTALL_DIR/sdk"
            ;;
        dotnet)
            BASE_DIR="$INSTALL_DIR/shared/Microsoft.NETCore.App"
            ;;
        aspnetcore)
            BASE_DIR="$INSTALL_DIR/shared/Microsoft.AspNetCore.App"
            ;;
        *)
            echo "Unknown runtime type: $RUNTIME_TYPE"
            exit 1
            ;;
    esac

    if [[ -d "$BASE_DIR" ]]; then
        while IFS= read -r -d $'\0' dir; do
            MATCHING_DIRS+=("$dir")
        done < <(find "$BASE_DIR" -maxdepth 1 -type d -name "$VERSION_PREFIX*" -print0)
    fi
done

if [[ ${#MATCHING_DIRS[@]} -eq 0 ]]; then
    echo "No versions matching '$VERSION_PREFIX' found."
    exit 0
fi

echo "The following directories will be removed:"
for dir in "${MATCHING_DIRS[@]}"; do
    echo "  $dir"
done

if $DRY_RUN; then
    echo "[Dry run] No files were deleted."
    exit 0
fi

if ! $AUTO_YES; then
    read -rp "Proceed with deletion? [Y/n] " response
    case "$response" in
        [Yy][Ee][Ss]|[Yy]|"")
            ;;
        *)
            echo "Aborted."
            exit 0
            ;;
    esac
fi

for dir in "${MATCHING_DIRS[@]}"; do
    echo "Removing: $dir"
    rm -rf "$dir"
done

echo "Uninstall complete."
