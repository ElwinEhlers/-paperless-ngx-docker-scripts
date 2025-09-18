#!/bin/bash
# export_with_original_names_host.sh
# Läuft direkt auf dem Host, nutzt gemountete Verzeichnisse
# ./media/documents/archive -> ./export

DB_CSV="./original_filenames.csv"
ARCHIVE_DIR="./media/documents/archive"
EXPORT_DIR="./export"
OVERVIEW="./documents_overview.txt"

mkdir -p "$EXPORT_DIR"
> "$OVERVIEW"

echo "Starte Export..."

while IFS=',' read -r id filename
do
    # Archiv-Datei mit führenden Nullen
    SRC_FILE="$ARCHIVE_DIR/$(printf '%07d.pdf' "$id")"

    if [ -f "$SRC_FILE" ]; then
        DEST_FILE="$EXPORT_DIR/$filename"

        # Konflikt vermeiden
        if [ -f "$DEST_FILE" ]; then
            BASENAME="${filename%.*}"
            EXT="${filename##*.}"
            COUNTER=1
            while [ -f "$EXPORT_DIR/${BASENAME}_$COUNTER.$EXT" ]; do
                COUNTER=$((COUNTER+1))
            done
            DEST_FILE="$EXPORT_DIR/${BASENAME}_$COUNTER.$EXT"
        fi

        cp "$SRC_FILE" "$DEST_FILE"
        echo "$SRC_FILE -> $DEST_FILE" >> "$OVERVIEW"
    else
        echo "$SRC_FILE fehlt!" >> "$OVERVIEW"
    fi
done < "$DB_CSV"

echo "Export abgeschlossen. Übersicht in: $OVERVIEW"
