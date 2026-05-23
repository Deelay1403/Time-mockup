#!/bin/bash

# === KONFIGURACJA ===
REPO_PATH="/home/patryk/TimeMockup/timemockup"  # ZMIEŃ NA SWOJĄ ŚCIEŻKĘ
FILE_NAME="log.txt"

# === SPRAWDZENIE GODZINY (nie działa między 00:00 a 09:00) ===
HOUR=$(date +"%H")
if [ "$HOUR" -ge 2 ] && [ "$HOUR" -lt 9 ]; then
  echo "Cisza nocna. Skrypt nie działa między 00:00 a 09:00."
  exit 0
fi

# === PRZEJŚCIE DO REPO ===
cd "$REPO_PATH" || { echo "Nie można wejść do katalogu repo"; exit 1; }

# === LOSOWA ILOŚĆ COMMITÓW (1-3) ===
NUM_COMMITS=$((RANDOM % 3 + 1))

MESSAGES=(
  "Update log"
  "Minor adjustment"
  "Routine check"
  "Small fix"
  "Log sync"
  "Refactor entry"
  "Cleanup"
  "Daily update"
  "Tweak values"
  "Maintenance"
)

echo "Wykonuję $NUM_COMMITS commit(ów)..."

for ((i = 1; i <= NUM_COMMITS; i++)); do
  # Losowe opóźnienie między commitami (30-180 sekund) — imituje człowieka
  if [ "$i" -gt 1 ]; then
    SLEEP_TIME=$((RANDOM % 151 + 30))
    echo "Czekam ${SLEEP_TIME}s przed kolejnym commitem..."
    sleep "$SLEEP_TIME"
  fi

  # Nowa linia w pliku
  TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  EXTRA=$((RANDOM % 1000))
  echo "[$TIMESTAMP] entry-$EXTRA" >> "$FILE_NAME"

  git add "$FILE_NAME"

  # Losowa wiadomość commita
  MSG_INDEX=$((RANDOM % ${#MESSAGES[@]}))
  COMMIT_MSG="${MESSAGES[$MSG_INDEX]} [$TIMESTAMP]"

  git commit -m "$COMMIT_MSG"
  echo "Commit $i: $COMMIT_MSG" 
  git push 
  echo "Pushed $i: $COMMIT_MSG"
done

# Push na koniec
git push origin main
echo "Gotowe. Wysłano $NUM_COMMITS commit(ów)."
