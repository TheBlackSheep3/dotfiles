export extern "release-helper" [
    --increase                      # Increase the snapshot version on the current branch
    --no-increase                   # Do not increase the snapshot version on the current branch (default)
    --release(-r): string           # Version of the newly created release
    --branch                        # Release to a new branch (default)
    --tag                           # Realese to a new tag
    --fail-on-snapshot-dependencies # Stop program execution upon detecting snapshot versions for dependencies
    --help(-h)                      # Print help
    --version(-V)                   # Print version
]
