python /var/www/my_crud/manage.py makemigrations
python /var/www/my_crud/manage.py migrate
python /var/www/my_crud/manage.py loaddata /var/www/my_crud/fixtures/user.json
python /var/www/my_crud/manage.py runserver 0.0.0.0:8000