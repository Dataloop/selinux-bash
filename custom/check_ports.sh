re='^[0-9]+$'
if [ $# -lt 1 ]
  then
    echo "Not enough arguments supplied. Use --help or -h for usage"
    return 126
fi
if [ -z "$2" ]
  then
    echo "No host supplied using localhost instead"
    HOST=localhost
else
    HOST=$2
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ]
then
    echo "This script opens ports and checks if you can reach ports
          
          check_ports.sh <option> <host>
          
          options:
            <Integer>: pings the port asigned
            all: use all the options below
            viya: only ports reachable by viya environment
            workstation: only ports reachable by workstation
            sas9: only ports reachable by sas9
            tcp: only ports reachable by tcp
          host:
            defaults to localhost if not provided
          "
elif [[ $1 =~ $re ]]||[ "$1" = "all" ] || [ "$1" = "viya" ] || [ "$1" = "workstation" ] ||  [ "$1" = "sas9" ] || [ "$1" = "tcp" ]
then
    echo "$HOST"
    declare -a VIYA_PORTS=(80 443 4369 5570 8777 5671 5672 15672 25672 7080 8200 8300 8301 8302 8500 8501 8591 9200 9300 10334 14443 17541 17551 {5430..5439} {5440..5449} {18201..18250} {18501..18600} {18601..19000});
    WORKSTATION_PORTS=(80 443 5570 17541 17551);
    SAS9_PORTS=(17541 17551);
    TCP_PROTOCOL=7;
    
    if [[ $1 =~ $re ]]
    then
        echo "PORT $1"
        firewall-cmd --add-port=$1/tcp
        nc -v -z $HOST  $1
    fi
    
    if [ "$1" = "all" ] || [ "$1" = "viya" ]
    then
        echo "VIYA_PORTS"
        for i in ${VIYA_PORTS[@]};
        do
            echo "PORT $i"
            firewall-cmd --add-port=${PORT}_t/tcp
            nc -v -z $HOST  $i
        done
    fi
    
    if [ "$1" = "all" ] || [ "$1" = "workstation" ]
    then
        echo "WORKSTATION_PORTS"
        for i in ${WORKSTATION_PORTS[@]};
        do
            echo "PORT $i"
            firewall-cmd --add-port=${PORT}_t/tcp
            nc -v -z $HOST  $i
        done
    fi
    
    if [ "$1" = "all" ] || [ "$1" = "sas9" ]
    then
        echo "SAS9_PORTS"
        for i in ${SAS9_PORTS[@]};
        do
            echo "PORT $i"
            firewall-cmd --add-port=${PORT}_t/tcp
            nc -v -z $HOST  $i
        done
    fi
    
    if [ "$1" = "all" ] || [ "$1" = "tcp" ]
    then
        echo "TCP_PROTOCOL"
        for i in ${TCP_PROTOCOL[@]};
        do
            echo "PORT $i"
            firewall-cmd --add-port=${PORT}_t/tcp
            nc -v -z $HOST  $i
        done
    fi
else
    echo "Option not valid. Use --help or -h for usage"
fi