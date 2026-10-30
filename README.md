![ART Logo](./logo-small.png)

# GITIGNORE-GEN version by CROFT

CLI-генератор `.gitignore` по стеку проекта.

[![Live Demo](https://img.shields.io/badge/demo-live-blue)](https://obladaet-ru.github.io/gitignore-gen/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Node.js Version](https://img.shields.io/badge/node-%3E%3D18-brightgreen)](https://nodejs.org/)

`gitignore-gen` — CLI-утилита на TypeScript, которая сканирует директорию, определяет стек проекта по сигнальным файлам и собирает читаемый `.gitignore` из готовых шаблонов.

---

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
```

### Или запуск без установки через npx

```bash
npx gitignore-gen
```

### Требования

- Node.js >= 18
- npm >= 9 (или любой совместимый пакетный менеджер)

---

## Использование

Базовый запуск — сканирует текущую директорию и создаёт `.gitignore`:

```bash
gitignore-gen
```

Запуск в конкретной директории:

```bash
gitignore-gen ./my-project
```

Предпросмотр без записи файла:

```bash
gitignore-gen --dry-run
```

Перезапись существующего `.gitignore`:

```bash
gitignore-gen --force
```

Явное указание стеков (без автоопределения):

```bash
gitignore-gen --stacks node,docker --no-os
```

Показать доступные шаблоны:

```bash
gitignore-gen --list
```

---

## Флаги CLI

| Флаг | Описание |
| :--- | :--- |
| `--dry-run` | Показать результат, не писать файл |
| `--force` | Перезаписать существующий `.gitignore` |
| `--no-ide` | Не добавлять секции IDE |
| `--no-os` | Не добавлять секции ОС |
| `--stacks a,b` | Явно указать стеки (например, `--stacks node,docker`) |
| `--list` | Показать доступные шаблоны |
| `--help` | Справка |
| `--version` | Версия |

Все флаги опциональны и комбинируются. Без аргументов утилита работает в текущей директории.

---

## Поддерживаемые стеки

Детектор смотрит на маркерные файлы в корне. Достаточно одного совпадения, чтобы подключить соответствующий шаблон.

| Стек | Сигнальные файлы | Что попадает в `.gitignore` |
| :--- | :--- | :--- |
| Node.js / TS | `package.json`, `tsconfig.json`, `.nvmrc` | `node_modules/`, `dist/`, `*.log`, `.env*` |
| Python | `pyproject.toml`, `requirements.txt`, `setup.py` | `__pycache__/`, `.venv/`, `*.pyc`, `.pytest_cache/` |
| Go | `go.mod`, `go.sum` | `/bin/`, `*.exe`, `*.test`, `vendor/` |
| Rust | `Cargo.toml`, `Cargo.lock` | `/target/`, `**/*.rs.bk`, `*.pdb` |
| Java | `pom.xml`, `build.gradle`, `settings.gradle` | `target/`, `build/`, `*.class`, `.gradle/` |
| Docker | `Dockerfile`, `docker-compose.yml` | `.docker/`, `*.pid`, `docker-compose.override.yml` |
| IDE | Всегда доступно | `.vscode/`, `.idea/`, `*.iml`, `.history/` |
| ОС | Всегда доступно | `.DS_Store`, `Thumbs.db`, `.Spotlight-V100/` |

---

## Как это работает

Конвейер разбит на чистые функции: детекция, сборка шаблонов, сериализация. Каждый этап тестируется отдельно.

1. **Сканирование** (`src/detector.ts`) — читает содержимое корня проекта, сопоставляет имена с таблицей правил и возвращает список обнаруженных стеков.
2. **Сборка шаблонов** (`src/templates/`) — для каждого стека берётся объект шаблона, секции объединяются, дубликаты удаляются, IDE и ОС добавляются по флагам.
3. **Запись** (`src/writer.ts`) — сериализует дерево в текст с заголовками-комментариями, проверяет существующий файл и пишет результат с учётом `--force` / `--dry-run`.

### Пример детектора

```ts
const RULES: Rule[] = [
  { stack: "node",    files: ["package.json", "tsconfig.json"] },
  { stack: "python",  files: ["pyproject.toml", "requirements.txt"] },
  { stack: "go",      files: ["go.mod"] },
  { stack: "rust",    files: ["Cargo.toml"] },
  { stack: "java",    files: ["pom.xml", "build.gradle"] },
  { stack: "docker",  files: ["Dockerfile", "docker-compose.yml"] },
];

export function detectStacks(root: string): Stack[] {
  const entries = new Set(readdirSync(root));
  return RULES
    .filter(r => r.files.some(f => entries.has(f)))
    .map(r => r.stack);
}
```

### Пример сериализатора

```ts
export function serialize(
  tree: TemplateTree,
  opts: { comments: boolean; sort: boolean }
): string {
  const out: string[] = [];
  for (const [section, patterns] of Object.entries(tree)) {
    if (opts.comments) out.push(`# ${section}`, "");
    const list = opts.sort ? [...patterns].sort() : patterns;
    out.push(...list, "");
  }
  return out.join("\n").trimEnd() + "\n";
}
```

---

## Структура проекта

```text
gitignore-gen/
├── src/
│   ├── cli.ts            # парсинг argv, оркестрация
│   ├── detector.ts       # правила детекта стеков
│   ├── writer.ts         # сериализация и запись
│   ├── types.ts          # общие типы
│   └── templates/
│       ├── node.ts
│       ├── python.ts
│       ├── go.ts
│       ├── rust.ts
│       ├── java.ts
│       ├── docker.ts
│       ├── ide.ts
│       └── os.ts
├── test/
│   ├── detector.test.ts
│   └── writer.test.ts
├── package.json
├── tsconfig.json
├── README.md
└── LICENSE
```

---

## Разработка

Проект собирается через `tsc`, тесты — на встроенном `node:test`. Никаких тяжёлых тулчейнов.

### Сборка и запуск

```bash
# установка зависимостей
npm install

# сборка TypeScript
npm run build

# локальный запуск
node dist/cli.js ./example

# тесты
npm test

# линт и форматирование
npm run lint
npm run format
```

### Фрагмент `package.json`

```json
{
  "name": "gitignore-gen",
  "version": "0.1.0",
  "type": "module",
  "bin": { "gitignore-gen": "./dist/cli.js" },
  "engines": { "node": ">=18" },
  "scripts": {
    "build": "tsc",
    "test": "node --test",
    "lint": "eslint src"
  },
  "license": "MIT"
}
```

### Требования к коммитам

- Используйте осмысленные сообщения коммитов (например, `feat: add docker template`, `fix: handle missing package.json`).
- Перед пушем убедитесь, что `npm run build` и `npm test` проходят без ошибок.
- Не коммитьте `node_modules/`, `dist/` и файлы `.env`.

---

## Лицензия

[MIT](LICENSE) © 2024
```
