# 📝 Markdown Article Publisher

A simple Bash automation script to publish Markdown articles into [my blog](https://github.com/claudiocaldeirao/my-blog-in-nextjs-outstatic) by by copying them between folders and committing them to a remote Git repository. It is designed to publish one article at a time and log each operation for traceability.

---

## 📂 Folder Structure

The project relies on the following directory layout under your `$HOME`:

```
$HOME/
├── [DRAFTS_PATH]       # Markdown drafts waiting to be published
├── [PUBLISHED_PATH]    # Target Git repo folder where articles are committed
├── [ARCHIVE_PATH]      # Storage for already published drafts
└── [LOGS_PATH]         # Contains `publish.log` with publication history
```

These paths are configured via environment variables in a `.env` file, like:

```env
DRAFTS_PATH=articles/drafts
PUBLISHED_PATH=path/to/other-repo/posts
ARCHIVE_PATH=articles/archive
LOGS_PATH=articles/logs
REMOTE=origin
BRANCH=main
```

---

## 🚀 Purpose

This script helps automate the workflow of publishing articles:

- ✅ Copies the **first available `.md` file** from the drafts folder into a separate repository.
- ✅ Commits and pushes the new article to a remote branch.
- ✅ Archives the original draft only **after** a successful publish.
- ✅ Logs all actions in a `publish.log` file.

This is particularly useful if you:

- Maintain articles in a local folder structure.
- Use GitHub (or any Git remote) for publishing content.
- Want to automate your publishing pipeline.

---

## 🕒 Setting Up as a Cron Job

To automate article publishing, schedule the script using `cron`.

### 1. Make the Script Executable

```bash
chmod +x $HOME/scripts/publish_one_article.sh
```

### 2. Ensure Your `.env` File Is in the Same Directory as the Script

Your script loads variables via `source .env`, so `.env` should be alongside the script or its path should be adjusted accordingly.

### 3. Edit Your Crontab

Run:

```bash
crontab -e
```

Add a line to schedule the job. For example, to run it every day at 9 AM:

```cron
0 9 * * * cd $HOME/scripts && ./publish_one_article.sh >> $HOME/articles/logs/cron.log 2>&1
```

This will:

- Change to the correct directory (so `.env` can be sourced properly)
- Run the script
- Log output and errors to `cron.log`

---

## 📌 Notes

- Make sure the published directory is a valid Git repository and the branch/remote in `.env` is correct.
- This script publishes **only one file per run**, so if you have multiple drafts, set up cron to run it repeatedly.

---

## 🛠 Example Run

```bash
./publish_one_article.sh
```

Sample log output:

```
2025-05-04 09:00:00 - Published and archived: my-article.md
```

---
