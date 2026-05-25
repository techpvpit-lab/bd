# bd
docker exec -i demo psql -U postgres -d postgres < create_tables.sql

## Какие NuGet-пакеты ставить

### 1) Если используешь EF Core (рекомендовано для приложений)

Пакеты в проект, где DbContext и модели (обычно \*.Data или основной проект):

```bash
dotnet add package Microsoft.EntityFrameworkCore
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 10.0.0
dotnet add package Microsoft.EntityFrameworkCore.Design
```

Опционально, но часто нужно:

```bash
dotnet add package Microsoft.Extensions.Configuration
dotnet add package Microsoft.Extensions.Configuration.Json
```

Если используешь миграции (создавать/обновлять схему из кода):

```bash
dotnet add package Microsoft.EntityFrameworkCore.Tools
```

> Примечание: Microsoft.EntityFrameworkCore.Tools нужен в проекте, где ты запускаешь migrations/scaffold через dotnet-ef; Design обязателен для dotnet ef.

### 2) Если без EF Core, прямые запросы (Dapper/ADO.NET)

Минимум:

```bash
dotnet add package Npgsql
```

Опционально (популярно):

```bash
dotnet add package Dapper
```

### 3) Avalonia (если проект уже создан шаблоном)

Обычно Avalonia-пакеты уже будут в проекте. Для БД они не требуются.

---

## Генерация моделей (Scaffold) из терминала VS Code

### Шаг 0. Поставь EF CLI (один раз)

```bash
dotnet tool install --global dotnet-ef
```

Проверка:

```bash
dotnet ef --version
```

---

## Сценарий A: Postgres опубликован на хост (например -p 5432:5432)

Это твой случай по выводу: 0.0.0.0:5432->5432/tcp.

### 1) Узнай данные подключения

- host: localhost
- port: 5432
- user: postgres
- password: (тот, что задавал в контейнере; если не задавал — посмотри в compose/env)
- db: demo

### 2) Scaffold командой

Перейди в папку проекта (где будет DbContext/Models) и выполни:

```bash
dotnet ef dbcontext scaffold "Host=localhost;Port=5432;Database=test;Username=postgres;Password=123" Npgsql.EntityFrameworkCore.PostgreSQL --context DemoDbContext --output-dir Models --context-dir Data --use-database-names --no-onconfiguring --force
```

Что делает:

- --use-database-names — оставляет имена как в БД (agent, producttype и т.д.)
- --no-onconfiguring — чтобы строка подключения не вшивалась в код
- --force — перезапишет модели при повторном scaffold

> Если хочешь только таблицы, например 2–3:

```bash
--table agent --table product --table material
```

dotnet ef dbcontext scaffold "Host=localhost;Port=5432;Database=trade;Username=postgres;Password=123" Npgsql.EntityFrameworkCore.PostgreSQL --context DemoDbContext
--output-dir Models --context-dir Data
--use-database-names --no-onconfiguring
--force
