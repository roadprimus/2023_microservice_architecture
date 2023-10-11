**! Файл в разработке**
# Реализовать CRUD-сервис пользователей
## Что нужно сделать?
1. Сделать CRUD-сервис для работы с пользователями;
2. Добавить БД в приложение;
3. Конфигурация хранится в Configmap;
4. Доступы к БД хранятся в Secrets;
5. Первоначальные миграции находятся в отдельной Job-е;
6. Приложение доступно по адресу arch.homework;
7. Сделать инструкцию по запуску приложения;
8. Предоставить postman-коллекцию CRUD запросов;
9. Проверить корректность работы приложения с помощью newman run;
10. Шаблонизировать приложение в helm чартах.

## Содержание репозитория
**README.md** - Описание домашней работы №3</br>
**run_homework_03.sh** - Скрипт запуска домашней работы №3</br>
**helm/** - Директория с helm-файлами</br>
|-- **templates/** - Шаблоны для манифестов</br>
|-- **values.yaml** - Переменные для шаблонов манифестов</br>
**my_crud/** - Директория с CRUD-сервисом</br>
|-- **my_crud/** - Сервис</br>
|     |-- **fixtures/** - Начальные данные для таблицы пользователей</br>
|     |-- **runserver.sh** - скрип запуска сервиса</br>
|-- **.vscode/** - Настройки для запуска приложения в [Visual Studio Code](https://code.visualstudio.com) (подразумевается использование [pipenv](https://pypi.org/project/pipenv/))</br>
|-- **.env** - Переменные окружения для запуска сервиса</br>
|-- **docker-compose.yml** - docker-compose для запуска сервиса с БД</br>
|-- **Dockerfile** - Dockerfile сервиса</br>
|-- **requirements.txt** - Зависимости сервиса</br>
|-- **Pipfile** - Зависимости сервиса (для [pipenv](https://pypi.org/project/pipenv/))</br>
|-- **Pipfile.lock** - Хеши зависимостей сервиса (для [pipenv](https://pypi.org/project/pipenv/))</br>
**postgres/** - Описание настроек БД postgresql</br>
|-- **.env** - Переменные окружения для запуска БД</br>
|-- **run.sh** - Команда запуска docker-контейнера с БД</br>
**tests/** - Описание тестов</br>
|-- **crud.postman_collection.json** - Коллекция postman тестов</br>
|-- **crud.postman_environment.json** - Переменные окружения для запуска коллекции postman тестов</br>
|-- **run.sh** - Команда запуска newman</br>

## Запуск CRUD-сервиса
Для запуска сервиса требуются следующие компоненты: [kind](https://kind.sigs.k8s.io), [Helm](https://helm.sh), [postman](https://www.postman.com) и [newman](https://www.npmjs.com/package/newman). Запуск осуществялется с помощью [Helm](https://helm.sh).
```
...homework_03 % helm install helm --generate-name
```
Необходимо подождать, чтобы поднялись pod-ы, несколько минут будет достаточно.
```
# Состояние pod-ов сразу после начала
% kubectl get pods -n my-ns
NAME                              READY   STATUS              RESTARTS   AGE
db-74d95b5b79-zrzbt               0/1     ContainerCreating   0          6s
helm-1697057553-bb656b49d-l7kvq   0/1     ContainerCreating   0          6s
helm-1697057553-bb656b49d-nh9t2   0/1     ContainerCreating   0          6s
helm-1697057553-job-wch84         0/1     ContainerCreating   0          6s

# Состояние pod-ов через несколько минут
% kubectl get pods -n my-ns
NAME                              READY   STATUS      RESTARTS   AGE
db-74d95b5b79-zrzbt               1/1     Running     0          2m21s
helm-1697057553-bb656b49d-l7kvq   1/1     Running     0          2m21s
helm-1697057553-bb656b49d-nh9t2   1/1     Running     0          2m21s
helm-1697057553-job-rdmgb         0/1     Completed   0          90s
helm-1697057553-job-wch84         0/1     Error       0          2m21s
```
Дальше можно переходить к тестированию. Для демонстрации домашней работы можно воспользоваться скриптом run_homework_03.sh. Этот скрипт делает следующие шаги:
1. создаёт кластер;
2. выполняет helm-чарты;
3. запускает тесты;
4. удаляет кластер.


У этого скрипта есть недостаток. В нём используется команда sleep, чтобы дождаться завершения выполнения процесса, запущенного предыдущей командой. К сожалению, этого времени не всегда хватает для завершения процесса, запущенного предыдущей командой. Поэтому этот файл можно рассматривать, как последовательность команд, которые нужно выполнить.

## Тестирование CRUD-сервиса
Для тестирования используется [postman](https://www.postman.com) и [newman](https://www.npmjs.com/package/newman). В postman можно создавать коллекции запросов и тесты к ним. newman позволяет запускать коллекции в командной строке.
### Перед запуском тестов
Подразумевается, что сервис доступен на хосте arch.homework, при этом сам сервис поднимается локально. Для настройки этого функционала смотри [README.md](https://github.com/roadprimus/2023_microservice_architecture/blob/main/homework_02/README.md) для Домашнего задания №2.
### Установка postman на Mac
Инструкция [тут](https://www.postman.com/downloads/).
### Установка newman на Mac
Можно через менеджер пакетов [brew](https://formulae.brew.sh/formula/newman).
### Запуск тестов
```
% newman --version
5.3.2
% cd tests
% ls
crud.postman_collection.json	crud.postman_environment.json
% newman run crud.postman_collection.json -e crud.postman_environment.json
```

## Запуск сервиса через docker-compose.yml
Этот функционал не нужно было реализовывать по ДЗ. Но так как k8s для новая система, то решил сначала сделать что-то похожее в более знакомой среде (Docker Compose). Как оказалось, это было очень полезно, так как столкнулся множеством мелких трудностей. В знакомой среде их проще решить. Не настраивал volume-ы, так как не нужно долго хранить данные в БД.
Поднять контейнеры:
```
% docker-compose up -d
[+] Running 2/2
✔ Container my_crud-db-1   Started  0.2s
✔ Container my_crud-web-1  Started  0.3s
```
Сервис доступен на порту 8003:
```
% curl http://127.0.0.1:8003/health/
{"status":"OK"}%
```

## .env - файлы
Для CRUD-сервиса и базы данных созданы два файла с переменными окружения. Значения можно изменять любым образом, главное, чтобы файлы были между собой согласованы.
### my_crud/.env
Рекомендую не убирать значения DEBUG=1 т.к. в этом режиме через браузер приятнее смотреть результат запросов, а также работает swagger.</br></br>
SECRET_KEY - Секретный ключ CRUD-сервиса;</br>
DEBUG - Запускать приложение в debug-режиме (1) или нет (0);</br>
ALLOWED_HOSTS - Домены, которые могут работать с этим приложением;</br>
DB_DEFAULT_ENGINE - Движок для базы данных;</br>
DB_DEFAULT_NAME - Имя базы данных;</br>
DB_DEFAULT_USER - Пользователь, от имени котрого подключаемся к базе данных;</br>
DB_DEFAULT_PASSWORD - Пароль пользователя, который указан в DB_DEFAULT_USER;</br>
DB_DEFAULT_HOST - Хост, где находится база данных (имя сервиса, если запуск через docker-compose)
DB_DEFAULT_PORT - Порт, где находится база данных;</br>
PYTHONDONTWRITEBYTECODE - python не будет создавать файлы .pyc.</br>
### postgres/.env
POSTGRES_DB - Имя базы данных;</br>
POSTGRES_USER - Пользователь базы данных;</br>
POSTGRES_PASSWORD - Пароль пользователя базы данных, который указан в POSTGRES_USER.</br>

## Размещение образа на Docker Hub
Сборка образа (по условию необходимо собрать под amd64):
```
docker build --platform=linux/amd64 -t my_crud .
```
Появился новый образ:
```
% docker images
REPOSITORY            TAG               IMAGE ID       CREATED         SIZE
my_crud               latest            40c63fcfbe49   8 minutes ago   144MB
```
Создаю тег для отправлки в Docker Hub:
```
docker tag my_crud roadprimus/my_crud:v0.0.1
```
Появилась новая строка:
```
% docker images
REPOSITORY            TAG               IMAGE ID       CREATED          SIZE
my_crud               latest            40c63fcfbe49   12 minutes ago   144MB
roadprimus/my_crud    v0.0.1            40c63fcfbe49   12 minutes ago   144MB
```
Отправляю образ в Docker Hub (предварительно залогинился):
```
docker push roadprimus/my_crud:v0.0.1
```