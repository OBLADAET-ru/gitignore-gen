![Логотип](./logo-small.png)

# gitignore-gen

CLI-генератор `.gitignore` по стеку проекта.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Node.js Version](https://img.shields.io/badge/node-%3E%3D18-brightgreen)](https://nodejs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue)](https://www.typescriptlang.org/)
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-success)](https://www.npmjs.com/package/gitignore-gen)

`gitignore-gen` — CLI-утилита на TypeScript, которая сканирует директорию, определяет стек проекта по сигнальным файлам и собирает читаемый `.gitignore` из готовых шаблонов.

---

## Сайт(DEMO)
https://obladaet-ru.github.io/gitignore-gen/

## Содержание

- [Возможности](#возможности)
- [Установка](#установка)
- [Использование](#использование)
- [Флаги CLI](#флаги-cli)
- [Поддерживаемые стеки](#поддерживаемые-стеки)
- [Как это работает](#как-это-работает)
- [Структура проекта](#структура-проекта)
- [Разработка](#разработка)
- [Лицензия](#лицензия)

---

## Возможности

- **Автоопределение стека** — 27 правил сопоставляют имена файлов в корне проекта: `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `pom.xml`, `Dockerfile` и другие.
- **6 языковых шаблонов** — Node.js/TypeScript, Python, Go, Rust, Java (Maven/Gradle) и Docker — с артефактами сборки, кэшами и lock-файлами.
- **IDE и ОС по умолчанию** — секции VS Code, JetBrains, Emacs/Vim и macOS/Windows/Linux добавляются автоматически и отключаются флагами `--no-ide` / `--no-os`.
- **Детерминированный вывод** — `sortKeys()` приводит шаблоны к фиксированному порядку, поэтому повторная генерация даёт идентичный файл. Удобно для code review.
- **Защита от перезаписи** — если `.gitignore` уже существует, утилита не тронет его без флага `--force`. Флаг `--dry-run` покажет результат, ничего не записывая.
- **Ноль зависимостей** — только стандартная библиотека Node.js: `fs`, `path`, `process`. Быстрый старт, маленький bundle, никаких supply-chain сюрпризов.

---

## Установка

### Глобально через npm

```bash
npm install -g gitignore-gen
