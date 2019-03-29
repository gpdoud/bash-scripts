#
# scans the current and all subfolders and reports
# whether git repositories are clean and whether
# they have a remote defined
#
TMP=/tmp
DIRTY_FILES="$TMP/git.dirty.files"
NO_REMOTE="$TMP/github.remote.exists"

for gitpath in $(find . -iname ".git"); do
    [ -d "$gitpath" ] || continue # if not a dir, continue
    (
        cd "$gitpath" && cd ..
        cdir=`pwd`
        git status -s > "$DIRTY_FILES"
        clean=""
        if [[ -s "$DIRTY_FILES" ]]; then
            clean="not clean"
        fi
        rm "$DIRTY_FILES"
        # check if GitHub connection exists
        remote=""
        git remote -v > "$NO_REMOTE"
        if [[ ! -s "$NO_REMOTE" ]]; then
            remote="No remote"
        fi
        rm "$NO_REMOTE"
        if [[ ! "$clean$remote" == "" ]]; then
            echo "$cdir - $clean $remote"
        fi
    )
    # git --git-dir=x/.git --work-tree=x status
done