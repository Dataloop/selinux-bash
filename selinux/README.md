## Configure el entorno para adaptarse a SELinux

Para implementar SAS Viya con SELinux habilitado en todas las máquinas en su implementación, realice las siguientes tareas:

### Deshabilite la verificación previa a la instalación que determina si SELinux está activo.

Si SELinux está activo en su entorno y desea implementar SAS Viya con SELinux habilitado, agregue un par clave-valor.

Abra el archivo vars.yml si aún no está abierto.
Agregue la siguiente declaración al final del archivo:
```
VERIFY_SELINUX: false
```
Guarde y cierre el archivo `vars.yml`.

### Configure SELinux para habilitar el servidor HTTP Apache.

De forma predeterminada, SELinux no permite que el componente httpd de Apache acceda a la red.
Ejecute el siguiente comando en cualquier máquina que sea ImplementarTargets para el grupo de hosts [httpproxy] en el archivo inventario.ini:

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/configuring-selinux-for-applications-and-services-with-non-standard-configurations_using-selinux

```
sudo setsebool -P httpd_can_network_connect 1
```
### Asegúrese de que el estado deny_unknown de la política SELinux esté configurado en permitido.
Realice los siguientes pasos:
Ejecute el siguiente comando para determinar la configuración actual de SELinux:

```
sudo sestatus -v
```

- Verifique el valor de la Política deny_unknown status en el resultado. Si el valor no está permitido, debe cambiar la configuración de la política.
- Como root, edite el archivo `/etc/selinux/semanage.conf`.
- Añade la siguiente línea:
   `handle-unknown=allow`
- Como root, ejecute el siguiente comando para reconstruir y recargar la política:
   `semodule -B`