def "nu-complete create-pr available remote branches" [] {
    ^git branch -r 
    | lines 
    | parse -r '^\*?(\s*|\s*\S* -> )(\w+\/)(?P<branch>\S*$)' 
    | get branch 
    | uniq
}

def create-pr [
    source: string@"nu-complete create-pr available remote branches" ,              # source branch
    --target(-t): string@"nu-complete create-pr available remote branches" = main   # target branch
] {
    let project = (git remote -v | lines | parse -r '^(?P<remote>\S+)\s+(?P<url>\S+)\s+\((?P<direction>\S+)\)' | where direction == "push" and remote == "origin" | get url | parse -r '(/\S+)+/(?P<name>\S+)\.git' | get Name | first)
    start $"https://bitbucket.bdalswrd.de/projects/bdet/repos/($project)/pull-requests?create&targetBranch=($target | str replace --all "/" "%2F")&sourceBranch=($source | str replace --all "/" "%2F")"
}

