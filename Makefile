include .env
export
project_name := GRAFANA-MONITORING-STACK
compose_file := docker-compose.yml
compose := docker-compose -f $(compose_file) -p $(project_name)

configure_telegraf:
	test ${TELEGRAF_HOSTNAME}
	test ${TELEGRAF_INFLUXDB_URL}
	rm -rf telegraf/etc/telegraf.conf
	cat telegraf/etc/telegraf.conf.template | envsubst > telegraf/etc/telegraf.conf

install_manager: configure_telegraf
	$(compose) up -d

install_worker: configure_telegraf
	$(compose) up telegraf -d

start_manager:
	$(compose) start

start_worker:
	$(compose) start telegraf

stop_manager:
	$(compose) stop 

stop_worker:
	$(compose) stop telegraf

ps:
	$(compose) ps -a $(service)

top:
	$(compose) top $(service)

logs:
	$(compose) logs -f $(service)