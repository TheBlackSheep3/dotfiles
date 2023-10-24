def "nu-complete bruker-publisher available versions" [] {
    git tag | lines | parse -r '(?P<version>\d+\.\d+\.\d+\.\d+)' | get version
}

export extern "bruker-publisher" [
    --artifact-base-url                                                             # Base url to fetch artifacts
    --api-key: string                                                               # Artifactory API-Key, form `AKXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`
    --target-directory: string                                                      # Directory where the artifact shall be published
    --publish-version(-p): string@"nu-complete bruker-publisher available versions" # Version of the artifact to be published, must be in form <MAJOR>.<MINOR>.<PATCH>.<REVISION>
    --artifact-path: string                                                         # Path to the artifact
    --classifier: string                                                            # Classifier for the artifact, for example `win32-vc141`
    --verbose(-v)                                                                   # More verbose output
    --copy-release-path: string                                                     # Copy path to published release binary to clipboard
    --config-path: string                                                           # Provide different config file than the default in ~/.config/publisher/config.ini
    --help(-h)                                                                      # Print help
    --version(-V)                                                                   # Print version
]
