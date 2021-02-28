PROJECT_NAME = base
MAIN_CONTAINER = backend_base

# ======================
# Docker
# ======================

up:
	@docker-compose up -d

down:
	@docker-compose down

build:
	@docker-compose up -d --build

bash:
	docker exec -it $(MAIN_CONTAINER) bash

install: up
	@docker exec -it $(MAIN_CONTAINER) pipenv install


# ======================
# Django Commands
# ======================

run:
	@docker exec -it $(MAIN_CONTAINER) python manage.py runserver 0:8000

collect:
	@docker exec -it $(MAIN_CONTAINER) python manage.py collectstatic --no-input

makemigrations:
	@docker exec -it $(MAIN_CONTAINER) python manage.py makemigrations

migrate:
	@docker exec -it $(MAIN_CONTAINER) python manage.py migrate

startapp:
	@docker exec -it $(MAIN_CONTAINER) python manage.py startapp $(name)




# ======================
# MISC
# ======================

# Init project

init:
	cp .env-template .env
	docker-compose up -d
	@read -p "Enter project name: " new_project_name; \
	mv ./$(PROJECT_NAME) ./$$new_project_name; \
	docker exec $(MAIN_CONTAINER) sed -i "s/$(PROJECT_NAME).settings/$$new_project_name.settings/g" /app/$$new_project_name/asgi.py ; \
	docker exec $(MAIN_CONTAINER) sed -i "s/$(PROJECT_NAME).settings/$$new_project_name.settings/g" /app/$$new_project_name/wsgi.py ; \
	docker exec $(MAIN_CONTAINER) sed -i "s/$(PROJECT_NAME).urls/$$new_project_name.urls/g" /app/$$new_project_name/settings.py ; \
	docker exec $(MAIN_CONTAINER) sed -i "s/$(PROJECT_NAME).wsgi/$$new_project_name.wsgi/g" /app/$$new_project_name/settings.py ; \
	docker exec $(MAIN_CONTAINER) sed -i "s/$(PROJECT_NAME).settings/$$new_project_name.settings/g" /app/manage.py ; \
	docker exec $(MAIN_CONTAINER) sed -i "s/PROJECT_NAME = $(PROJECT_NAME)/PROJECT_NAME = $$new_project_name/g" /app/Makefile ; \
	docker exec $(MAIN_CONTAINER) sed -i "s/MAIN_CONTAINER = backend_$(PROJECT_NAME)/MAIN_CONTAINER = backend_$$new_project_name/g" /app/Makefile ; \
	docker exec $(MAIN_CONTAINER) sed -i "s/backend_$(PROJECT_NAME)/backend_$$new_project_name/g" /app/docker-compose.yml ; \
	docker exec $(MAIN_CONTAINER) sed -i "s/database_$(PROJECT_NAME)/database_$$new_project_name/g" /app/docker-compose.yml ; \
	docker exec $(MAIN_CONTAINER) sed -i "s/database_$(PROJECT_NAME)/database_$$new_project_name/g" /app/.env ; \
	docker exec $(MAIN_CONTAINER) sed -i "s/your_db_name/$$new_project_name/g" /app/.env
	docker container stop backend_$(PROJECT_NAME)
	docker container stop database_$(PROJECT_NAME)
	docker-compose up --build -d
	@echo "done!"

# Run isort for auto sort python imports

isort:
	@docker exec $(MAIN_CONTAINER) isort **/*.py
	@echo "iSort applied!"


#  Run black auto formatter

black:
	@docker exec $(MAIN_CONTAINER) black .
	@echo "black applied!"

# Run all lints

lints:
	@docker exec $(MAIN_CONTAINER) isort **/*.py
	@echo "iSort applied!"
	@docker exec $(MAIN_CONTAINER) flakehell lint .
	@echo "flake8 applied!"
	@docker exec $(MAIN_CONTAINER) black .
	@echo "black applied!"

# Run test

test:
	@docker exec $(MAIN_CONTAINER) coverage run manage.py test
	@docker exec $(MAIN_CONTAINER) coverage report
	@docker exec $(MAIN_CONTAINER) coverage erase
