GITREF=$(cat .git/HEAD | cut -d' ' -f2)
GITSHA1=$(cat .git/$GITREF)
echo '{"git": {"sha1": "'$GITSHA1'", "ref": "'$GITREF'"}}' > dist/app-version.json
