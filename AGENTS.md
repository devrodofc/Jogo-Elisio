# Repository Guidelines

## Project Structure & Module Organization

This repository currently contains a minimal Godot project named `Jogo-Elisio`. `project.godot` declares the Godot 4.7 feature level, and `icon.svg` supplies the project icon. No gameplay scripts, scenes, or tests are present yet.

As the game grows, organize scenes under `scenes/`, GDScript under `scripts/`, reusable art and audio under `assets/`, and automated checks under `tests/`. Reference project resources through `res://` paths. Treat `.godot/` as generated editor and import data; do not edit or commit its contents. Keep Godot-generated resource identifiers and import metadata alongside their corresponding resources.

## Build, Test, and Development Commands

Run commands from the repository root with a compatible Godot installation:

- `godot --editor --path .` opens the project for development.
- `godot --headless --editor --path . --quit` imports resources and checks that the editor can initialize; inspect output for errors.
- `godot --path .` runs the game after a main scene has been created and configured.

No export presets or build scripts exist yet. Configure export presets in the editor before documenting platform-specific builds. Prefer editor UI changes for `project.godot` settings.

## Coding Style & Naming Conventions

For new GDScript, use tabs for indentation, `snake_case` for files, functions, and variables, `PascalCase` for class names, and `UPPER_SNAKE_CASE` for constants. Prefer explicit types where practical. Use descriptive scene filenames such as `main_menu.tscn` and descriptive node names. No formatter or linter is configured.

## Testing Guidelines

No test framework or coverage requirement is configured. For each change, run the headless import check and exercise affected scenes in the editor. Describe the checks performed and any limitations. If adding automated tests, document the framework, execution command, and naming convention with that addition.

## Commit & Pull Request Guidelines

Git history is unavailable in this workspace, so existing commit conventions cannot be verified. Use concise, imperative subjects such as `Add player movement scene`. Keep commits focused. Pull requests should describe behavior changes, link relevant issues, list validation performed, and include screenshots or short recordings for visual changes.
