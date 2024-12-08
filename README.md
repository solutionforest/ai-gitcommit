# Git-AI Commit Message Generator

This project provides a script to automatically generate meaningful and concise Git commit messages based on staged changes (`git diff`). It uses **Ollama**, a locally hosted AI model, to analyze changes and produce human-readable commit messages.

---

## Features

- **AI-Generated Commit Messages**: Automatically generates clear and accurate Git commit messages using Ollama's AI models.
- **Multi-Line Commit Messages**: Creates well-structured, descriptive commit messages, capped at 100 words.
- **Seamless Git Integration**: Automatically stages, generates, and commits changes for you.
- **Local AI Backend**: Runs entirely on your local machine for privacy and reliability.

---

## How It Works

1. The script extracts staged changes using `git diff --cached`.
2. The changes (diff) are sent to Ollama's API (`http://localhost:11434/api/generate`).
3. Ollama's AI model analyzes the diff and generates a commit message.
4. The commit message is saved into `.git/COMMIT_EDITMSG`.
5. Git creates the commit using the AI-generated message.

---

## Requirements

### Dependencies

- **`jq`**: A lightweight and flexible JSON processor.
- **`curl`**: A command-line tool for making HTTP requests.

You can install these dependencies using your system's package manager:

# For Debian/Ubuntu
```bash
sudo apt install jq curl
```

# For macOS
```bash
brew install jq curl
```

## Setting Up Ollama

This project uses **Ollama** as the AI backend to generate Git commit messages. Ollama is a privacy-focused AI platform that runs models locally on your machine. Follow the steps below to set up Ollama and ensure the project works correctly.

### Install Ollama

Visit the [Ollama website](https://ollama.ai/) and follow the instructions for installing Ollama on your operating system.

### Download the Required Model

This project uses the `llama3.2:3b` model. Once Ollama is installed, pull the model by running:

```bash
ollama create gitdiff -f Modelfile
```

### Commit Message
```bash
./git-ai-commit.sh
