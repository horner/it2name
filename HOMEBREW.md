# Homebrew Distribution

## Quick Install

```bash
brew install horner/tap/it2name
```

This will automatically install `it2name` along with its dependencies:
- **imagemagick** - for text rendering
- **chafa** - for terminal graphics

## Tap Repository

The Homebrew tap is hosted at: https://github.com/horner/homebrew-tap

## Manual Tap Setup

If you want to add the tap first:

```bash
brew tap horner/tap
brew install it2name
```

## Testing

After installation, verify everything works:

```bash
# Check version
it2name --version

# Run help
it2name --help

# Test rendering
it2name "Hello World"
```

## For Maintainers

### Updating the Formula

When releasing a new version:

1. Update version in `it2name` script
2. Commit and tag: `git tag -a v0.X.Y -m "Release v0.X.Y"`
3. Push: `git push origin main && git push origin v0.X.Y`
4. Calculate new SHA256:
   ```bash
   curl -sL https://github.com/horner/it2name/archive/refs/tags/v0.X.Y.tar.gz | shasum -a 256
   ```
5. Update `homebrew-tap/Formula/it2name.rb`:
   - Change `version`
   - Change `url` (tag version)
   - Change `sha256` (from step 4)
6. Commit and push the tap
7. Test: `brew upgrade it2name && brew test it2name`

### Testing Locally

Before pushing updates to the tap:

```bash
cd ~/homebrew-tap
brew install --build-from-source ./Formula/it2name.rb
brew test it2name
brew audit --strict --online it2name
```

## Architecture

- **Main repo**: `horner/it2name` - Contains the script, tests, documentation
- **Tap repo**: `horner/homebrew-tap` - Contains the Homebrew formula
- Formula declares dependencies that Homebrew automatically installs
- Tests are included in the formula to validate installation

## See Also

- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [How to Create and Maintain a Tap](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)
