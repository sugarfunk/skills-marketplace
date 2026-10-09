# bart-skills

Personal Claude plugin marketplace. Each entry points at an upstream repo, so
nothing is copied here and updates come from the source.

## Add it

Claude desktop app: Plugins, Add marketplace, enter `sugarfunk/skills-marketplace`.
Claude Code: `/plugin marketplace add sugarfunk/skills-marketplace`

## Updating

Click Update on the marketplace in the desktop app (or enable auto-update).
In Claude Code: `/plugin marketplace update bart-skills`.

## Adding another upstream

Add an entry to `.claude-plugin/marketplace.json`. Use a `github` source for a
repo that is a plugin, `git-subdir` for a folder inside a bigger repo. To freeze
an entry, add a full 40 char `sha` to its source.

If an upstream repo has no `plugin.json`, list its skill folders in the entry's
`skills` array (as the wordpress-skills entry does).

## Fallback if direct skill paths do not load

Vendor the upstream skills into `plugins/<name>/skills/` with a scheduled
GitHub Action and point the entry at `./plugins/<name>`.
