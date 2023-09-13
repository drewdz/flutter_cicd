#!/bin/bash

PROJECT_ROOT_PATH=$1
LCOV_INPUT_FILES=""

while read FILENAME; do
  echo "- adding file - $FILENAME"
  LCOV_INPUT_FILES="$LCOV_INPUT_FILES -a \"$PROJECT_ROOT_PATH/coverage/$FILENAME\""
done < <( ls "$1/coverage/" )

echo "- current files list"
echo "'$LCOV_INPUT_FILES'"

echo "- trim leading and trailing white space"
LCOV_INPUT_FILES = "$LCOV_INPUT_FILES | xargs"

echo "- ready to combine files"
if [ -n $LCOV_INPUT_FILES ] 
then
  echo "- files"
  echo $LCOV_INPUT_FILES

  echo "- creating output file"
  touch $PROJECT_ROOT_PATH/coverage_report/combined_lcov.info

  echo "- combining files"
  eval lcov "${LCOV_INPUT_FILES}" -o $PROJECT_ROOT_PATH/coverage_report/combined_lcov.info

  lcov --remove $PROJECT_ROOT_PATH/coverage_report/combined_lcov.info \
    "lib/main_*.dart" \
    "*.gr.dart" \
    "*.g.dart" \
    "*.freezed.dart" \
    "*di.config.dart" \
    "*.i69n.dart" \
    "*/generated/*" \
    "*.theme_extension.dart" \
    -o $PROJECT_ROOT_PATH/coverage_report/cleaned_combined_lcov.info
fi