#!/usr/bin/env bash


prev=$(ls snapshots | sort -r | head -n1 | xargs)

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     
		today=$(TZ='America/Los_Angeles' date -Idate);;
    Darwin*)
		realpath() {
		  OURPWD=$PWD
		  cd "$(dirname "$1")"
		  LINK=$(readlink "$(basename "$1")")
		  while [ "$LINK" ]; do
		    cd "$(dirname "$LINK")"
		    LINK=$(readlink "$(basename "$1")")
		  done
		  REALPATH="$PWD/$(basename "$1")"
		  cd "$OURPWD"
		  echo "$REALPATH"
		}
		# realpath "$@"
		today=$(TZ='America/Los_Angeles' date +%F);;
    CYGWIN*)    exit 1;;
    MINGW*)     exit 1;;
    *)          exit 1;;
esac

root=$(realpath $(dirname "$0")/..)
cd $root

echo ${today}

# today=$(TZ='America/Los_Angeles' date -Idate)

download_dir="$root"/snapshots/"$today"
mkdir -p "$download_dir"

cd $download_dir

UA = "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0"

curl -A "$UA" -L 'https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_INNOVATION_ETF_ARKK_HOLDINGS.csv' -o arkk.csv
curl -A "$UA" -L 'https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_AUTONOMOUS_TECHNOLOGY_&_ROBOTICS_ETF_ARKQ_HOLDINGS.csv' -o arkq.csv
curl -A "$UA" -L 'https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_NEXT_GENERATION_INTERNET_ETF_ARKW_HOLDINGS.csv' -o arkw.csv
curl -A "$UA" -L 'https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_GENOMIC_REVOLUTION_MULTISECTOR_ETF_ARKG_HOLDINGS.csv' -o arkg.csv
curl -A "$UA" -L 'https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_FINTECH_INNOVATION_ETF_ARKF_HOLDINGS.csv' -o arkf.csv

curl -A "$UA" -L 'https://ark-funds.com/wp-content/fundsiteliterature/csv/THE_3D_PRINTING_ETF_PRNT_HOLDINGS.csv' -o prnt.csv
curl -A "$UA" -L 'https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_ISRAEL_INNOVATIVE_TECHNOLOGY_ETF_IZRL_HOLDINGS.csv' -o izrl.csv
