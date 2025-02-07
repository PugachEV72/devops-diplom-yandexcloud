# Дипломный практикум в Yandex.Cloud - Пугач Евгений.


---

## `Цели:`

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.
---

## `Этапы выполнения:`

## Создание облачной инфраструктуры

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с  
   инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права  
   суперпользователя
2. Подготовьте backend для Terraform:  
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)  
   б. Альтернативный вариант: Terraform Cloud
3. Создайте VPC с подсетями в разных зонах доступности.  
4. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply`  
   без дополнительных ручных действий.
5. В случае использования Terraform Cloud в качестве backend убедитесь, что применение изменений  
   успешно проходит, используя web-интерфейс Terraform cloud.
---

### Решение: 

1. Создал сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы  
   с инфраструктурой с необходимыми и достаточными правами.

![Скриншот 1](https://github.com/PugachEV72/Images/blob/master/2024-07-14_13-46-40.png)

2. Подготовил backend для Terraform:  
   Выбрал рекомендуемый вариант: S3 bucket в созданном аккаунте. 

![Скриншот 2](https://github.com/PugachEV72/Images/blob/master/2024-07-14_13-46-40.png)

[bucket.tf](https://github.com/PugachEV72/devops-diplom-yandexcloud/blob/main/terraform_bucket/bucket.tf)

3. Создал VPC с подсетями в разных зонах доступности.

![Скриншот 3](https://github.com/PugachEV72/Images/blob/master/2024-07-14_13-45-26.png)

[network.tf](https://github.com/PugachEV72/devops-diplom-yandexcloud/blob/main/terraform/network.tf) 

4. Убедился, что теперь могу выполнить команды terraform destroy и terraform apply без дополнительных  
   ручных действий

![Скриншот 4](https://github.com/PugachEV72/Images/blob/master/2024-07-14_11-12-24.png)

![Скриншот 5](https://github.com/PugachEV72/Images/blob/master/2024-07-14_11-13-51.png)

![Скриншот 6](https://github.com/PugachEV72/Images/blob/master/2024-07-14_11-15-16.png)

![Скриншот 7](https://github.com/PugachEV72/Images/blob/master/2024-07-14_13-44-48.png)

## `Полученная конфигурация инфраструктуры`

![Скриншот 8](https://github.com/PugachEV72/Images/blob/master/2024-07-14_13-44-29.png)
---

### Дополнение:

В ходе проверки данного этапа задания были выявлены недочеты при создании инфраструктуры,  
а именно невозможность масштабирования кластера. При необходимости изменения количества  
виртуальных машин, предлагаю следующий вариант создания кластера: [TERRAFORM](https://github.com/PugachEV72/response/tree/main/terraform)

При изначальных настройках кластер состоит из 3 виртуальных машин

![Скриншот 8-1](https://github.com/PugachEV72/Images/blob/master/2024-08-01_12-43-04.png)

При этом они распределены по разнымм подсетям

![Скриншот 8-2](https://github.com/PugachEV72/Images/blob/master/2024-08-01_12-36-46.png)
---

При небходимости расширения меняем размер кластера

![Скриншот 8-3](https://github.com/PugachEV72/Images/blob/master/2024-08-01_13-13-14.png)

![Скриншот 8-4](https://github.com/PugachEV72/Images/blob/master/2024-08-01_12-45-00.png)

Убеждаемся, что ВМ также распределены по разным подсетям

![Скриншот 8-5](https://github.com/PugachEV72/Images/blob/master/2024-08-01_12-46-00.png)

---

## Создание Kubernetes кластера

На этом этапе необходимо создать Kubernetes кластер на базе предварительно созданной инфраструктуры.  
Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания  
   Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании  
   к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса,  
   используйте Terraform для внесения изменений.  
   б. Подготовить ansible конфигурации, можно воспользоваться, например Kubespray  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы  
2. Альтернативный вариант: воспользуйтесь сервисом Yandex Managed Service for Kubernetes  
   а. С помощью terraform resource для kubernetes создать региональный мастер kubernetes с размещением  
   нод в разных 3 подсетях  
   б. С помощью terraform resource для kubernetes node group 
---

### Решение:

Создал Kubernetes кластер на базе предварительно созданной инфраструктуры. Обеспечил доступ к ресурсам  
из Интернета. Для выполнения данного задания использовал **Kubespray**.

### Подготовка к установке:

Склонировал репозиторий

![Скриншот 8-6](https://github.com/PugachEV72/Images/blob/master/2024-07-14_13-07-12.png)

Установил зависимости, сконфигурировал кластер с запуском билдера

![Скриншот 9](https://github.com/PugachEV72/Images/blob/master/2024-07-14_13-18-29.png)

![Скриншот 10](https://github.com/PugachEV72/Images/blob/master/2024-07-14_13-20-18.png)

![Скриншот 11](https://github.com/PugachEV72/Images/blob/master/2024-07-14_13-21-47.png)

### Установка

Установил кластер при помощи **Ansible**

```
ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -b -v
```

![Скриншот 12](https://github.com/PugachEV72/Images/blob/master/2024-07-14_13-37-51.png)

### Организация внешнего доступа

Для доступа к кластеру извне добавил параметр `supplementary_addresses_in_ssl_keys: [внешний IP control plane]`  
в файл `inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml`

Получил желаемый результат:

1. Работоспособный Kubernetes кластер.

2. В файле `~/.kube/config` на локальной машине находятся данные для доступа к кластеру.

![Скриншот 12-1](https://github.com/PugachEV72/Images/blob/master/2024-07-28_13-04-46.png)

![Скриншот 12-2](https://github.com/PugachEV72/Images/blob/master/2024-07-28_13-07-15.png)

3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.

![Скриншот 13](https://github.com/PugachEV72/Images/blob/master/2024-07-14_13-43-45.png)

---

## Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.
---

### Решение:

Получил ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.

[Application](https://github.com/PugachEV72/app-nginx-static)

2. Регистри с собранным docker image. В качестве регистри использовал DockerHub.

![Скриншот 14](https://github.com/PugachEV72/Images/blob/master/2024-06-23_15-07-18.png)

[DockerHub](https://hub.docker.com/r/pugachev72/nginx_custom_01/tags)

---

## Подготовка cистемы мониторинга и деплой приложения

Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:

1. Задеплоить в кластер prometheus, grafana, alertmanager, экспортер основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, nginx сервер отдающий статическую страницу.

Способ выполнения:

1. Воспользоваться пакетом kube-prometheus, который уже включает в себя Kubernetes оператор для  
   grafana, prometheus, alertmanager и node_exporter. Альтернативный вариант - использовать набор helm  
   чартов от bitnami.
2. Если на первом этапе вы не воспользовались Terraform Cloud, то задеплойте и настройте в кластере atlantis  
   для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или  
   atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория  
   в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD  
   системы. 
---

### Решение:

1. Воспользовался пакетом `kube-prometheus`. Этот пакет содержит в себе полный набор инструментов, позволяющих  
   реализовать мониторинг кластера и приложений, работающих в нём.

Пакет Kube-Prometheus позволяет кастомизацию устанавливаемых пакетов. Потребуется установить пакет поддержки  
языка `Golang`. Далее следует установить инструмент `jsonnet-bundler`. Перед компиляцией необходимо дополнительно  
установить инструменты `gojsontoyaml` и `jsonnet`.

![Скриншот 15](https://github.com/PugachEV72/Images/blob/master/2024-07-14_14-35-44.png)

![Скриншот 16](https://github.com/PugachEV72/Images/blob/master/2024-07-14_14-44-56.png)

![Скриншот 17](https://github.com/PugachEV72/Images/blob/master/2024-07-14_17-54-06.png)

Доступ к развернутым в кластере приложениям мониторинга можно организовать несколькими способами, прще всего  
воспользоваться проброской портов и получить доступ к сервисам мониторинга из локального окружения. Когда все  
ресурсы запустились, можно выполнить проброску портов кластера в локальное окружение с помощью  
команды `kubectl port-forward`

![Скриншот 18](https://github.com/PugachEV72/Images/blob/master/2024-07-14_20-41-14.png)

После чего убедиться в доступности инструментов мониторинга:

![Скриншот 19](https://github.com/PugachEV72/Images/blob/master/2024-07-14_20-33-33.png)

![Скриншот 20](https://github.com/PugachEV72/Images/blob/master/2024-07-14_20-38-12.png)

![Скриншот 21](https://github.com/PugachEV72/Images/blob/master/2024-07-14_20-52-24.png)
---

### Дополнение:

В ходе проверки данного этапа был выявлен недочет в получении доступа из локального окружения.  
Доступ к развернутым в кластере приложениям мониторинга можно организовать при помощи создания  
сервисов вида `NodePort`, и получать доступ по внешним IP-адресам **любой** из нод кластера.  

Для этого внесем изменения в файл `monitoring.jsonnet`

![Скриншот 22](https://github.com/PugachEV72/Images/blob/master/2024-07-31_13-08-40.png)

Перезапустим сборку `Kube-Prometeus`

Получили желаемый результат

![Скриншот 23](https://github.com/PugachEV72/Images/blob/master/2024-07-31_13-37-58.png)

![Скриншот 24](https://github.com/PugachEV72/Images/blob/master/2024-07-31_14-58-07.png)

2. Http доступ к тестовому приложению организован подобным же образом.

![Скриншот 25](https://github.com/PugachEV72/Images/blob/master/2024-07-29_14-06-36.png)

![Скриншот 26](https://github.com/PugachEV72/Images/blob/master/2024-07-29_14-07-56.png)

---

## Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения  
при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать teamcity, jenkins, GitLab CI или GitHub Actions.

Ожидаемый результат:

Интерфейс ci/cd сервиса доступен по http.  
При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр  
Docker образа. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим  
label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.

### Решение:

Для автоматической сборки `docker image` и деплоя приложения при изменении кода буду использовать  
**Github actions**

Для работы в `github action` требуются некоторые учетные данные.  
Поэтому создаем в Dockerhub секретный токен.

![Скриншот 27](https://github.com/PugachEV72/Images/blob/master/2024-07-22_22-13-51.png)

Затем создадим в `Github` секреты для доступа к `DockerHub`

![Скриншот 28](https://github.com/PugachEV72/Images/blob/master/2024-07-22_22-34-53.png)

Рабочие процессы `GitHub Actions` определяем в файлах YAML в `.github/workflows` каталоге репозитория  
с тестовым приложением [Workflows](https://github.com/PugachEV72/app-nginx-static/tree/main/.github/workflows)

Создадим два workflow

1. Для сборки и отправки в регистр Docker образа при любом коммите в репозитории с тестовым приложением

[Build and push](https://github.com/PugachEV72/app-nginx-static/blob/main/.github/workflows/ci_deployment.yaml)

Отправка коммита

![Скриншот 29](https://github.com/PugachEV72/Images/blob/master/2024-07-30_03-03-30.png)

Сборка образа и отправка в DockerHub

![Скриншот 30](https://github.com/PugachEV72/Images/blob/master/2024-07-30_03-06-40.png)

![Скриншот 31](https://github.com/PugachEV72/Images/blob/master/2024-07-30_03-07-16.png)

![Скриншот 32](https://github.com/PugachEV72/Images/blob/master/2024-07-30_03-09-02.png)

2. Для сборки и отправки с соответствующим label в регистри, а также деплоя соответствующего Docker образа  
в кластер Kubernetes при создании тега (например, v1.0.0)

[Build, push and deploy](https://github.com/PugachEV72/app-nginx-static/blob/main/.github/workflows/ci_cd_deployment.yaml)

Отправка тега

![Скриншот 33](https://github.com/PugachEV72/Images/blob/master/2024-07-30_03-12-26.png)

Сборка образа соответствующей версии, отправка в DockerHub и деплой в кластер Kubernetes

![Скриншот 34](https://github.com/PugachEV72/Images/blob/master/2024-07-30_03-13-30.png)

![Скриншот 35](https://github.com/PugachEV72/Images/blob/master/2024-07-30_03-13-46.png)

![Скриншот 36](https://github.com/PugachEV72/Images/blob/master/2024-07-30_03-40-25.png)

Dockerhub

![Скриншот 37](https://github.com/PugachEV72/Images/blob/master/2024-07-30_03-22-10.png)

Приложение

![Скриншот 38](https://github.com/PugachEV72/Images/blob/master/2024-07-30_03-18-36.png)

---

## Результат выполнения дипломного проекта

При внесении изменений в тестовое приложение и создании тега **v1.0.3** система отрабатывает корректно

![Скриншот 39](https://github.com/PugachEV72/Images/blob/master/2024-07-31_15-02-36.png)

![Скриншот 40](https://github.com/PugachEV72/Images/blob/master/2024-07-31_15-03-06.png)

![Скриншот 41](https://github.com/PugachEV72/Images/blob/master/2024-07-31_15-04-25.png)

Состояние кластера

![Скриншот 42](https://github.com/PugachEV72/Images/blob/master/2024-08-01_00-01-00.png)

Приложение

![Скриншот 43](https://github.com/PugachEV72/Images/blob/master/2024-07-31_15-01-37.png)

![Скриншот 44](https://github.com/PugachEV72/Images/blob/master/2024-07-31_14-59-09.png)

---


