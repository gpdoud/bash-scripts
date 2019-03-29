# if [ -d ./angular ]; then
#     echo "Yes Angular Directory"
# fi
# if [ -d ./angular/test-cors/.git ]; then
#     echo "Yes Angular/test-cores/.git Directory"
# fi
dirtyfiles=/c/repos/git.dirty.files
noremote=/c/repos/github.remote.exists
for gitpath in $(find . -iname ".git"); do
    [ -d "$gitpath" ] || continue
    if [ -d "$gitpath" ]; then
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
    fi
    # git --git-dir=x/.git --work-tree=x status
done