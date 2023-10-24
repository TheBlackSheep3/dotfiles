def "nu-complete release-helper next versions" [] {
    git tag
        | lines
        | parse '{major}.{minor}.{patch}.{revision}'
        | sort --reverse
        | first 
        | 
            [
                { major: ($in.major | into int), minor: ($in.minor | into int), patch: ($in.patch | into int), revision: (($in.revision | into int) + 1) }
                { major: ($in.major | into int), minor: ($in.minor | into int), patch: (($in.patch | into int) + 1), revision: 0 }
                { major: ($in.major | into int), minor: (($in.minor | into int) + 1), patch: 0, revision: 0 }
                { major: (($in.major | into int) + 1), minor: 0, patch: 0, revision: 0 }
            ]
        | each { |v| $"($v.major).($v.minor).($v.patch).($v.revision)" }
}

export extern "release-helper" [
    --increase                                                          # Increase the snapshot version on the current branch
    --no-increase                                                       # Do not increase the snapshot version on the current branch (default)
    --release(-r): string@"nu-complete release-helper next versions"    # Version of the newly created release
    --branch                                                            # Release to a new branch (default)
    --tag                                                               # Realese to a new tag
    --fail-on-snapshot-dependencies                                     # Stop program execution upon detecting snapshot versions for dependencies
    --help(-h)                                                          # Print help
    --version(-V)                                                       # Print version
]
