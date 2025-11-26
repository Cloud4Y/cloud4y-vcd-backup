# VMware Cloud Director Backup Automation

Automated scripts for VMware Cloud Director backup with archive rotation and result logging for monitoring.

## Scripts

### 1. `backup-vcd.sh`
- Designed for a **single-cell VMware Cloud Director deployment**.
- Performs:
  - runs the built-in backup (`create-backup.sh`);
  - rotates old backup archives;
  - writes a flag file for monitoring (`/var/log/create-backup-vcd-flag`).

### 2. `backup-vcd-cluster.sh`
- Designed for a **clustered environment**.
- The script is deployed on every cluster node but executes **on the primary node** to prevent duplicate backups..  
- All other functionality is the same as `backup-vcd.sh`.

## Usage

1. Place the script on the VMware Cloud Director server where backups will be performed.
2. Make the file executable:

```bash
chmod +x backup-vcd.sh
```
3. Run the script:

```bash
./backup-vcd.sh
```

## Zabbix Integration

The scripts create a flag file: `/var/log/create-backup-vcd-flag`:

* `1` — backup completed successfully
* `0` — backup failed

To enable monitoring:

* Install the Zabbix-agent on the appliance.
* Create a text data item pointing to the flag file:
```
vfs.file.contents[/var/log/create-backup-vcd-flag]
```
* Configure a trigger that fires on value `0`. This allows receiving notifications for failed backups.

## This document in Russian / Перевод этого документа на русский язык

- [README.ru.md](README.ru.md)
