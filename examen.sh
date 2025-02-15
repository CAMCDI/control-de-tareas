#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo -e "\e[31m[!] Este script debe ejecutarse con permisos de root.\e[0m"
  exit 1
fi

DB_FILE="/var/lib/todolist/todolist.tlf"

mkdir -p /var/lib/todolist
touch $DB_FILE

mostrar_menu() {
  clear
  echo -e "\e[35m╔═══════════════════════════════════════════════════════════════════╗\e[0m"
  echo -e "\e[35m║                  \e[33m Sistema de Gestión de Tareas \e[35m                   ║\e[0m"
  echo -e "\e[35m╠═══════════════════════════════════════════════════════════════════╣\e[0m"
  echo -e "\e[35m║   \e[34m[1] \e[0m\e[36mAgregar tarea                                               \e[35m║\e[0m"
  echo -e "\e[35m║   \e[34m[2] \e[0m\e[36mEliminar tarea                                              \e[35m║\e[0m"
  echo -e "\e[35m║   \e[34m[3] \e[0m\e[36mModificar estado de tarea                                   \e[35m║\e[0m"
  echo -e "\e[35m║   \e[34m[4] \e[0m\e[36mMostrar todas las tareas                                    \e[35m║\e[0m"
  echo -e "\e[35m║   \e[34m[5] \e[0m\e[36mSalir                                                       \e[35m║\e[0m"
  echo -e "\e[35m╚═══════════════════════════════════════════════════════════════════╝\e[0m"
  echo -n -e "\e[33mSeleccione una opción:\e[0m "
}
agregar_tarea() {
  echo -n -e "\e[36m[+] Ingrese la descripción de la tarea:\e[0m "
  read tarea
  echo -e "\e[36mSeleccione el estado de la tarea:\e[0m"
  echo -e "  \e[32m[1] Pendiente\e[0m"
  echo -e "  \e[32m[2] En proceso\e[0m"
  echo -e "  \e[32m[3] Finalizada\e[0m"
  echo -n "Estado: "
  read estado

  case $estado in
    1) estado="pendiente" ;;
    2) estado="en proceso" ;;
    3) estado="finalizada" ;;
    *) echo -e "\e[31m[!] Estado no válido\e[0m"; return ;;
  esac

  id=$(($(tail -1 $DB_FILE 2>/dev/null | cut -d ':' -f 1) + 1))
  [ -z "$id" ] && id=1

  echo "$id:$tarea:$estado" >> $DB_FILE
  echo -e "\e[32m[+] Tarea agregada con éxito.\e[0m"
}

eliminar_tarea() {
  echo -n -e "\e[36m[-] Ingrese el ID de la tarea a eliminar:\e[0m "
  read id

  if grep -q "^$id:" $DB_FILE; then
    sed -i "/^$id:/d" $DB_FILE
    echo -e "\e[32m[+] Tarea con ID $id eliminada.\e[0m"
  else
    echo -e "\e[31m[!] No se encontró una tarea con ID $id.\e[0m"
  fi
}

modificar_estado() {
  echo -n -e "\e[36m[*] Ingrese el ID de la tarea a modificar:\e[0m "
  read id

  if grep -q "^$id:" $DB_FILE; then
    echo -e "\e[36mSeleccione el nuevo estado:\e[0m"
    echo -e "  \e[32m[1] Pendiente\e[0m"
    echo -e "  \e[32m[2] En proceso\e[0m"
    echo -e "  \e[32m[3] Finalizada\e[0m"
    echo -n "Nuevo estado: "
    read nuevo_estado

    case $nuevo_estado in
      1) nuevo_estado="pendiente" ;;
      2) nuevo_estado="en proceso" ;;
      3) nuevo_estado="finalizada" ;;
      *) echo -e "\e[31m[!] Estado no válido\e[0m"; return ;;
    esac

    sed -i "/^$id:/s/:[^:]*$/:$nuevo_estado/" $DB_FILE
    echo -e "\e[32m[+] Estado de la tarea actualizado.\e[0m"
  else
    echo -e "\e[31m[!] No se encontró una tarea con ID $id.\e[0m"
  fi
}

mostrar_tareas() {
  if [ ! -s $DB_FILE ]; then
    echo -e "\e[31m[!] No hay tareas registradas.\e[0m"
    return
  fi

  echo -e "\n\e[33m┌──────────────────────────── Lista de Tareas ───────────────────────────────────────────┐\e[0m"
  printf "\e[33m│ %-5s │ %-40s │ %-15s │\e[0m\n" "ID" "Tarea" "Estado"
  echo -e "\e[33m├───────┼────────────────────────────────────────────────────────────┼─────────────────────┤\e[0m"
  
  while IFS=: read -r id task status; do
    printf "\e[33m│ %-5s │ %-40s │ %-15s │\e[0m\n" "$id" "$task" "$status"
  done < $DB_FILE

  echo -e "\e[33m└───────┴────────────────────────────────────────────────────────────┴─────────────────────┘\e[0m"
}
while true; do
  mostrar_menu
  read opcion
  case $opcion in
    1) agregar_tarea ;;
    2) eliminar_tarea ;;
    3) modificar_estado ;;
    4) mostrar_tareas ;;
    5) echo -e "\e[31m[!] Saliendo...\e[0m"; exit 0 ;;
    *) echo -e "\e[31m[!] Opción no válida. Intente de nuevo.\e[0m" ;;
  esac
  echo -e "\e[33mPresione Enter para continuar...\e[0m"
  read
done
