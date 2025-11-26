#!/bin/bash

# Директория с файлами резервных копий
vcd_backup="/opt/vmware/vcloud-director/data/transfer/backups"

# Количество дней для хранения актуальных бэкапов
days=30

# Файл для Zabbix (флаг результата)
log_file="/var/log/create-backup-vcd-flag"

# Функция поиска и удаления файлов резервных копий
remove_old_backups() {
    # Проверка наличия директории
    if [ ! -d "$vcd_backup" ]; then
        echo "Backup directory $vcd_backup does not exist!" >&2
        return 1
    fi

    echo "Searching for backups older than $days days..."

    # Поиск файлов старше $days
    older_backups=$(find "$vcd_backup" -type f -mtime "+$days" 2>/dev/null)

    if [ -n "$older_backups" ]; then
      echo "Deleting older backups:"
      echo "$older_backups"
      while IFS= read -r file; do
        if [ -f "$file" ]; then
          rm -f "$file" && echo "Deleted: $file" || echo "Failed to delete: $file" 2>&1
        fi
      done <<< "$older_backups"
    else
      echo "No backups older than $days days found in $vcd_backup."
    fi
}

echo "Starting VCD Backup Procedure at $(date)"

echo "Running create-backup.sh..."

if /opt/vmware/appliance/bin/create-backup.sh; then
    echo "Backup created successfully"
    echo "1" > "$log_file"
else
    echo "Error running create-backup.sh" >&2
    echo "0" > "$log_file"
fi

# Установка разрешения на файл с маркером успешного выполнения бэкапа
chmod 644 "$log_file"

# Функция ротации бэкапов
remove_old_backups

echo "Backup procedure completed at $(date)"
