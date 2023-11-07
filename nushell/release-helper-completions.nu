def "nu-complete release-helper next versions" [] {
    git tag
        | lines
        | parse '{major}.{minor}.{patch}.{revision}'
        | each {|e|{major: ($e.major | into int), minor: ($e.minor|into int), patch: ($e.patch | into int), revision: ($e.revision | into int)}}
        | sort --reverse
        | first
        |
            [
                { major: $in.major, minor: $in.minor, patch: $in.patch, revision: ($in.revision + 1) }
                { major: $in.major, minor: $in.minor, patch: ($in.patch + 1), revision: 0 }
                { major: $in.major, minor: ($in.minor + 1), patch: 0, revision: 0 }
                { major: ($in.major + 1), minor: 0, patch: 0, revision: 0 }
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
