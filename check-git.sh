#
# scans the current and all subfolders and reports
# whether git repositories are clean and whether
# they have a remote defined
#
dirtyfiles=/c/repos/git.dirty.files
noremote=/c/repos/github.remote.exists
for gitpath in $(find . -iname ".git"); do
    [ -d "$gitpath" ] || continue # if not a dir, continue
    (
        cd "$gitpath" && cd ..
        cdir=`pwd`
        git status -s > "$dirtyfiles"
        clean=""
        if [[ -s "$dirtyfiles" ]]; then
            clean="not clean"
        fi
        rm "$dirtyfiles"
        # check if GitHub connection exists
        remote=""
        git remote -v > "$noremote"
        if [[ ! -s "$noremote" ]]; then
            remote="No remote"
        fi
        rm "$noremote"
        echo "$cdir - $clean $remote"
    )
    # git --git-dir=x/.git --work-tree=x status
done