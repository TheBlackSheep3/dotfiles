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
    start $"https://bitbucket.bdalswrd.de/projects/bdet/repos/material-skin/pull-requests?create&targetBranch=($target | str replace --all "/" "%2F")&sourceBranch=($source | str replace --all "/" "%2F")"
}

