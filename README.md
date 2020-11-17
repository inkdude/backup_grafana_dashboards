# backup_grafana_dashboards
bash script, which backup dashboards with folders

This script parse folders in which store dashboards, then create folders named as in grafana gui and dump dashboards in folders as in grafana (create topology). If dashboards stored in "General" folder, this dashboards will be saved in root directory ($DASH_DIR)
