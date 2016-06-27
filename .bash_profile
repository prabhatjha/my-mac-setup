source ~/.git-prompt.sh
PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/shims:$PATH"
export CLICOLOR=1 export LSCOLORS=GxFxCxDxBxegedabagaced

function git_merge_master() {
if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1
then
  branch=$(git rev-parse --abbrev-ref HEAD)
  if [[ $branch == 'master' ]]
  then
    echo "This command cannot be run from the master branch"
    return 1
  else
    git checkout master && \
    git pull origin master --ff-only && \
    git checkout "$branch" && \
    git diff-index --quiet --cached HEAD && \
    git rebase master && \
    git diff-index --quiet --cached HEAD && \
    git push origin "$branch":"$branch" --force-with-lease && \
    git checkout master && \
    git merge - --ff-only && \
    git checkout master && \
    git push origin master:master && \
    git push origin ":$branch" && \
    git branch -d "$branch"
  fi
else
  echo "This command must be run within a git repository"
  return 1
fi
}
