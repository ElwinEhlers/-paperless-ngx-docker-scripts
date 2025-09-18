# -paperless-ngx-docker-scripts
paperless-ngx Docker

docker exec -i paperless-db-1 psql -U paperless -d paperless -t -A -F"," \
-c "SELECT id, original_filename FROM documents_document ORDER BY id;" > ./original_filenames.csv

chmod +x export_with_original_names_host.sh

./export_with_original_names_host.sh

