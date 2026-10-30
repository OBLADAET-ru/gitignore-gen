# Gitignore-Generator
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **gitignore-gen** — CLI-утилита для автоматической генерации `.gitignore` на основе определения стека проекта.

## Возможности

- 🎯 Автоматическое определение языка/фреймворка по файлам в проекте
- 📦 Поддержка стеков: Node.js, Python, Go, Rust, Java, Docker
- 🎨 Шаблоны IDE (VS Code, JetBrains) и ОС (macOS, Windows, Linux)
- 🚀 Простой CLI с поддержкой флагов
- 📝 Чистый TypeScript с тестами

## Быстрый старт

```bash
# Установка
npm install -g gitignore-gen

# Генерация .gitignore в текущей директории
gitignore-gen

# Указание директории
gitignore-gen ./my-project

# Без шаблонов IDE и ОС
gitignore-gen --no-ide --no-os
```

## Разработка

```bash
# Установка зависимостей
npm install

# Линтинг и проверка типов
npm run lint
npm run typecheck

# Тесты
npm test

# Сборка
npm run build

# Полный чек
npm run check
```

## Структура проекта

```
gitignore-gen/
├── src/
│   ├── cli/           # Точка входа, CLI через commander
│   ├── detector/      # Определение стека по файлам
│   ├── templates/     # Шаблоны для разных стеков
│   ├── writer/        # Генерация .gitignore
│   ├── types/         # Общие типы
│   └── utils/         # Утилиты (logger, fs)
├── tests/             # Unit-тесты
└── package.json
```

## License

MIT
