#
# scans the current and all subfolders and reports
# whether git repositories are clean and whether
# they have a remote defined
#
TMP=/tmp
DIRTY_FILES="$TMP/git.dirty.files"
NO_REMOTE="$TMP/github.remote.exists"

if [[ "$1" == "--commit" ]]; then
    DO_GIT_COMMIT=Y
else
    DO_GIT_COMMIT=N
fi

echo "Finding all Git repositories ..."
for gitpath in $(find . -iname ".git"); do
    [ -d "$gitpath" ] || continue # if not a dir, continue
    (
        cd "$gitpath" && cd ..
        cdir=`pwd`
        git status -s > "$DIRTY_FILES"
        clean=""
        if [[ -s "$DIRTY_FILES" ]]; then
            clean="not clean"
            if [[ "$DO_GIT_COMMIT" == "Y" ]]; then
                git add . && git commit -m 'Check-Git auto commit'
                clean="$clean; committed"
            fi
        fi
        rm "$DIRTY_FILES"
        # check if GitHub connection exists
        remote=""
        git remote -v > "$NO_REMOTE"
        if [[ ! -s "$NO_REMOTE" ]]; then
            remote="No remote"
        elif [[ "$DO_GIT_COMMIT" == "Y" ]]; then
            # git add . && git commit -m 'Check-Git auto commit'
            clean="$clean; pushed"
        fi
        rm "$NO_REMOTE"
        if [[ ! "$clean$remote" == "" ]]; then
            echo "$cdir - $clean $remote"
        fi
    )
    # git --git-dir=x/.git --work-tree=x status
done
echo "Done."