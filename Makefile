include .env
export
project_name := GRAFANA-MONITORING-STACK

manager_compose_file := compose_files/role-manager.yml
worker_compose_file := compose_files/role-worker.yml

ifeq ($(DEPLOY_ROLE),worker)
	compose_file := $(worker_compose_file)
else
	compose_file := $(manager_compose_file)
endif

compose := docker-compose -f $(compose_file) -p $(project_name)

configure_telegraf:
	test ${TELEGRAF_HOSTNAME}
	test ${TELEGRAF_INFLUXDB_URL}
	rm -rf telegraf/etc/telegraf.conf
	cat telegraf/etc/telegraf.conf.template | envsubst > telegraf/etc/telegraf.conf

install: configure_telegraf
	$(compose) up -d

start:
	$(compose) start $(service)

stop:
	$(compose) stop $(service)
ps:
	$(compose) ps -a $(service)

top:
	$(compose) top $(service)

logs:
	$(compose) logs -f $(service)

uninstall:
	$(compose) down