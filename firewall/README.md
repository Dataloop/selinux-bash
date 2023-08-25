# HABILITAR PUERTOS DE SAS VIYA EN FIREWALLD

La lista de puertos a abrir está disponible en:

Viya
[https://go.documentation.sas.com/doc/en/calcdc/3.5/dplyml0phy0lax/n1avwv04n69r3fn1jly7cqno71bm.htm]()

SVI
[https://documentation.sas.com/doc/en/dplyvi0phy0lax/10.3.1/n1avwv04n69r3fn1jly7cqno71bm.htm]()

Requerimientos:

- firewald
- firewall-cmd

**TODO EL PROCESO DEBE SER EJECUTADO EN CADA SERVIDOR**

## Reiniciar firewalld


Se debe reiniciar para tener únicamente las configuraciones que ya han sido guardadas. Ejecutar:

```
sudo systemctl restart firewalld
```

Posteriormente, revisar los puertos que están habilitados:

```
firewall-cmd --list-ports
```

## Abrir los puertos determinados por la documentación

Copiar firewall.sh. Posterior mente, asignarle permisos de ejecución y ejecutar firewall.sh con la opción f, dicha opción abre todos los puertos necesarios para SAS viya 

```
chmod +x firewall.sh
. firewall.sh -f
```

revisar los puertos habilitados con:

```
firewall-cmd --list-ports
```

## Puertos efímeros

Estos puertos temporales que Linux utiliza para comunicaciones IP cortas, y se alojan automáticamente en este rango. Esto es particularmente util para todos los puertos que utiliza CAS.

En caso de que estos puertos quieran ser utilizados pero estén bloqueados por el firewall los servicios van a fallar. Debido a esto, debemos permitir el rango de los puertos efímeros en el firewal. 


Revisar el rango de puertos efímeros y agregarlo como se muestra en el dejemplo

```
sudo sysctl net.ipv4.ip_local_port_range

# OUTPUT
> net.ipv4.ip_local_port_range = 32768    60999

sudo firewall-cmd --add-port=32768-60999/tcp
```

Revisar que SAS viya esté funcionando correctamente, y en caso de estarlo hacer persistente la configuración aplicada:

```
. firewall.sh -p
```

```
sudo systemctl status firewalld
sudo systemctl enable firewalld
```


