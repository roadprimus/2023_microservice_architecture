# Задеплоить сервис в k8s
## Что нужно сделать?
1. Взять образ, полученный в домашнем задании №1 (взять с Dockerhub), написать манифесты для деплоя в k8s для этого сервиса;
2. Создать манифесты:
   1. deployment;
   2. service;
   3. ingress;
3. Создать не менее 2 реплик;
4. Релазиовать хост в ingress по адресу arch.homework;
5. Настроить редирект с /otusapp/{student name}/* на /*;
6. Поместить манифесты в одну директорию.

## Содержание репозитория
**README.md** - Описание домашней работы №2</br>
**manifests/** - Директория с манифестами</br>
|-- **deployment.yaml** - Манифест Deployment</br>
|-- **ingress.yaml** - Манифест Ingress</br>
|-- **namespace.yaml** - Манифест Namespace</br>
|-- **service.yaml** - Манифест Service</br>
**run_cluster_with_service.sh** - (Не входит в домашнее задание) Сводный скрипт от развёртывания кластера до вывода результратов запросов к сервису</br>
**kind-config.yaml** - (Не входит в домашнее задание) Конфигурация кластера для kind</br>

## Как сделан сервис?
Домашнее задание сделал с помощью инструмента [kind](https://kind.sigs.k8s.io). Настройки кластера лежат в файле kind-config.yaml. Создание кластера осуществил командой (документация [тут](https://kind.sigs.k8s.io/docs/user/quick-start/#configuring-your-kind-cluster)):
```
kind create cluster --config kind-config.yaml
```
Ingress контроллер устанавливал командой (документация [тут](https://kind.sigs.k8s.io/docs/user/ingress/#ingress-nginx)):
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```
Далее исполнил манифесты (в директории manifests):
```
kubectl apply -f .
```
При исполении команды возникла следующая ошибка:
```
namespace/my-ns created
service/my-service created
Error from server (NotFound): error when creating "deployment.yaml": namespaces "my-ns" not found
Error from server (NotFound): error when creating "ingress.yaml": namespaces "my-ns" not found
```
Она происходит из-за того, что не успевает вовремя создаться namespace, который используется в манифестах. Ещё раз перезапустил команду, всё выполнилось:
```
deployment.apps/my-app created
Warning: path /otusapp/.*?/(.*) cannot be used with pathType Prefix
Warning: path /(.*) cannot be used with pathType Prefix
ingress.networking.k8s.io/my-ingress created
namespace/my-ns unchanged
service/my-service unchanged
```
Сервис стал доступен на localhost. Для того, чтобы к нему можно было обращаться по имени arch.homework, необходимо добавить в /etc/hosts следующую строку:
```
127.0.0.1   arch.homework
```
После добавления строки перезапустил DNS:
```
sudo killall -HUP mDNSResponder
```
Далее для проверки работы сервиса выполнил команды:
```
% curl http://arch.homework/health/
{"status": "OK"}
% curl http://arch.homework/otusapp/surname/health/
{"status": "OK"}
```