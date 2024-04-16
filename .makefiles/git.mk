.PHONY: set-credential-httppath
set-credential-httppath: ## Set the credential to use HTTP Path
	@echo "Setting credential useHttpPath..."
	git config --global credential.useHttpPath true


.PHONY: set-gituser
set-gituser: ## Set the git user credential's.  Usage: make set-gituser GIT_USER_NAME=changeme GIT_USER_EMAIL=changeme
	git config --global user.name $(GIT_USER_NAME)
	git config --global user.email $(GIT_USER_EMAIL)

.PHONY: clone-infrarepos
clone-infrarepos: ## Clone all infrastructure repositories
	@echo "Cloning repositories..."
	@$(foreach repo,$(shell cat ./.repos/infrastructure.list),git clone $(repo);)

.PHONY: clone-maintrepos
clone-maintrepos: ## Clone all maintenance repositories
	@echo "Cloning repositories..."
	@$(foreach repo,$(shell cat ./.repos/maintenance.list),git clone $(repo);)

.PHONY: clean-branches
clean-branches:
	@echo "Cleaning branches..."
	@$(foreach branch,$(shell git branch | grep -v "master"),git branch -D $(branch);)

.PHONY: push
push:
	@branch=$$(git symbolic-ref --short HEAD); \
	if [ "$$branch" = "master" ]; then \
		echo "Cannot Push to master..."; \
		exit 1; \
	else \
		echo "Pushing to origin..."; \
		git push --set-upstream origin $$branch; \
	fi

.PHONY: commits-and-changes-by-author
commits-and-changes-by-author:
	@echo "Commits and changes by author..."
	git log --all --no-merges --numstat --pretty="%aN" | awk 'BEGIN { FS = "\t"; OFS = ": " } {if (NF == 1) {author = $$0} else if (NF > 1) {adds[author] += $$1; dels[author] += $$3}} END {for (author in adds) {print author, adds[author] " additions, " dels[author] " deletions"}}'

.PHONY: commits-by-author
commits-by-author:
	@echo "Commits by author..."
	git shortlog -s -n --all --no-merges

