echo "Remove all .git folders"
if [[ "$1" == "--remove" ]]; then
    REMOVE="Y"
fi
for gitpath in $(find . -iname ".git"); do
    [ "$gitpath" == "./.git" ] && echo "ignore $gitpath" && continue
    [ -d "$gitpath" ] || continue # if not a dir, continue
    (
        cd "$gitpath" && cd ..
        if [[ "$REMOVE" == "Y" ]]; then
            rm -rf .git
            echo "$gitpath - removed"
        else
            echo "$gitpath"
        fi
    )
done
