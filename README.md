# Django + Docker start project

This is a django + docker scratch for new project

## Prerequisites

- Docker >= 19.0.0
- Make >= 3.0

## Usage

```sh

# Clone the repository
git clone https://github.com/gustavo-fonseca/django-docker-start-project YOUR_PROJECT_NAME

# Change the project name
cd ./YOUR_PROJECT_NAME
make init

# Open the .env file and change the default data
vim .env

# Clean the git's origin
git remote remove origin

```


## Make commands from docker host machine
These commands shouldn't been run inside the main container

```sh

# =============================
# Misc
# =============================

# Run all lints
make lints

# Run isort
make isort

# Run black
make black

# =============================
# Docker
# =============================

# Shortcut: docker-compose up -d
make up

# Shortcut: docker-compose down 
make down

# Shortcut: docker-compose up -d --build 
make build

# Compile and install requirements && docker build
make install


# =============================
# Django
# =============================

# Shortcut: python manage.py runserver 0:8000
make run

# Shortcut: python manage.py collectstatic --no-input
make collect

# Shortcut: python manage.py makemigrations
make makemigrations

# Shortcut: python manage.py migrate
make migrate

# Shortcut: python manage.py startapp YOUR_APP_NAME
make startapp name=YOUR_APP_NAME

```