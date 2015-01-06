from ubuntu:precise

run echo "deb http://us.archive.ubuntu.com/ubuntu/ precise-updates main restricted" | tee -a /etc/apt/sources.list.d/precise-updates.list

# update packages
run apt-get update

# install required packages
run apt-get install -y python python-dev python-setuptools python-software-properties supervisor

# add nginx stable ppa
run add-apt-repository -y ppa:nginx/stable
# update packages after adding nginx repository
run apt-get update
# install latest stable nginx
run apt-get install -y nginx

# install pip
run easy_install pip

run pip install uwsgi

add . /webapp/

# setup config files
run echo "daemon off;" >> /etc/nginx/nginx.conf
run rm /etc/nginx/sites-enabled/default
run ln -s /webapp/nginx.conf /etc/nginx/sites-enabled/
run ln -s /webapp/supervisor.conf /etc/supervisor/conf.d/

# install project requirements
run pip install -r /webapp/app/requirements.txt

expose 80
cmd ["supervisord", "-n"]
