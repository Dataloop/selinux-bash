#!/bin/bash
re='^[0-9]+$'
if [ $# -lt 1 ]
then
    echo "Not enough arguments supplied. Use --help or -h for usage"
    return 126
fi
if [ "$1" = "--help" ] || [[ "$1" =~ .*"h".* ]]
then
    echo "This script opens ports and checks if you can reach ports

          check_ports.sh -[options] <parameter>
        Examples:
            check_ports.sh -cf archive.tar viya  # adds viya ports and checks if they can be reached.
            check_ports.sh -c archive.tar viya  # checks if svi ports can be reached.

          options:
          -f: adds port rule to firewall
          -c: checks if port is in usage with nc
          -p: makes port adding persistent

          parameter:
            svi: opens svi ports
            viya: opens viya ports
    "
    return 0
fi
# * VIYA

backup=7 #TCP protocol
apache=(80 443) #SAS Viya servers, workstation
epmd_port=(4369) #SAS Viya servers only
cas_server=5570 #SAS Viya servers and workstations
cas_monitor=8777 #SAS Viya servers
sas_message_broker=(5671 5672 15672 25672) #SAS Viya servers only
sas_studio=7080 #SAS Viya servers only
sas_secrets=8200 #SAS Viya servers only
sas_config=(8300 8301 8302 8500 8501) #SAS Viya servers only
sas_spawner=8591 #SAS Viya servers only
elasticsearch=(9200 9300) #9200(Clientes), 9300(máquinas de Elasticsearch) #Solo servidores SAS Viya
sas_cache_locator=10334 #SAS Viya Servers only
sas_cache=4443 #SAS Viya Servers only
sas_conect_spawner_manager=17541 #SAS Viya servers, SAS 9.X servers, workstation
sas_conect_spawner=17551 #SAS Viya servers, SAS 9.X servers, workstation
sas_data_server="5430-5439" #SAS Viya servers only
sas_planning="5440-5449" #SAS Viya servers only
sas_model_iot_launcher="18201-18250" #SAS Viya servers only
sas_job_launcher="18501-18600" #SAS Viya servers only
sas_forecasting_iot_launcher="18601-19000" #SAS Viya servers only

# * SVI

cas_comunicator=0 #SAS Viya Servers only
sas_event_stream_manager=2552 #ESP servers only
sas_infraestructure_data="5430–5439"
default_sas_message_broker=5672
svi_sas_config=("8300–8309" 8500 8501) # SAS Viya Servers only
default_sas_message_broker=15672 # SAS Viya Servers only
sas_model_manager_launcher_context="18201–18250" # SAS Viya Servers only
sas_job_execution_launcher_context="18501–18600" # SAS Viya Servers only
sas_visual_forecasting_launcher_context="18601–19000" # SAS Viya Servers only
sas_cloud_analytics_services="19990-19999" # SAS Viya Servers only

declare -A ARR
if [ "$2" = "viya" ]
then
    ARR["backup"]=${backup[@]}
    ARR["apache"]=${apache[@]}
    ARR["epmd_port"]=${epmd_port[@]}
    ARR["sas_data_server"]=${sas_data_server[@]}
    ARR["sas_planning"]=${sas_planning[@]}
    ARR["cas_server"]=${cas_server[@]}
    ARR["cas_monitor"]=${cas_monitor[@]}
    ARR["sas_message_broker"]=${sas_message_broker[@]}
    ARR["sas_studio"]=${sas_studio[@]}
    ARR["sas_secrets"]=${sas_secrets[@]}
    ARR["sas_config"]=${sas_config[@]}
    ARR["sas_spawner"]=${sas_spawner[@]}
    ARR["elasticsearch"]=${elasticsearch[@]}
    ARR["sas_cache_locator"]=${sas_cache_locator[@]}
    ARR["sas_cache"]=${sas_cache[@]}
    ARR["sas_conect_spawner_manager"]=${sas_conect_spawner_manager[@]}
    ARR["sas_conect_spawner"]=${sas_conect_spawner[@]}
    ARR["sas_model_iot_launcher"]=${sas_model_iot_launcher[@]}
    ARR["sas_job_launcher"]=${sas_job_launcher[@]}
    ARR["sas_forecasting_iot_launcher"]=${sas_forecasting_iot_launcher[@]}
elif [ "$2" = "svi" ]
then
    ARR["apache"]=${apache[@]}
    ARR["epmd_port"]=${epmd_port[@]}
    ARR["cas_server"]=${cas_server[@]}
    ARR["sas_studio"]=${sas_studio[@]}
    ARR["sas_secrets"]=${sas_secrets[@]}
    ARR["sas_config"]=${sas_config[@]}
    ARR["sas_spawner"]=${sas_spawner[@]}
    ARR["cas_monitor"]=${cas_monitor[@]}
    ARR["sas_conect_spawner_manager"]=${sas_conect_spawner_manager[@]}
    ARR["cas_comunicator"]=${cas_comunicator[@]}
    ARR["sas_event_stream_manager"]=${sas_event_stream_manager[@]}
    ARR["sas_infraestructure_data"]=${sas_infraestructure_data[@]}
    ARR["default_sas_message_broker"]=${default_sas_message_broker[@]}
    ARR["default_sas_message_broker"]=${default_sas_message_broker[@]}
    ARR["sas_model_manager_launcher_context"]=${sas_model_manager_launcher_context[@]}
    ARR["sas_job_execution_launcher_context"]=${sas_job_execution_launcher_context[@]}
    ARR["sas_visual_forecasting_launcher_context"]=${sas_visual_forecasting_launcher_context[@]}
    ARR["sas_cloud_analytics_services"]=${sas_cloud_analytics_services[@]}
else
    echo "Option not valid. Use --help or -h for usage"
    return 1
fi

for key in ${!ARR[@]};
do
    echo "$key"
    echo "PORT ${ARR[${key}]}"
    for i in ${ARR[${key}]}
    do
        echo "${i}"
        if [[ "$1" =~ .*"f".* ]]
        then
            sudo firewall-cmd --add-port=$i/tcp
        fi
        if [[ "$1" =~ .*"n".* ]]
        then
            nc -v -z localhost  $i
        fi
    done
done

unset ARR
