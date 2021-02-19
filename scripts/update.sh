#!/usr/bin/env bash

root=$(realpath $(dirname "$0")/..)
cd $root

prev=$(ls snapshots | sort -r | head -n1 | xargs)
today=$(date -Idate)

download_dir="$root"/snapshots/"$today"
mkdir -p "$download_dir"

cd $download_dir

curl -L 'https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_INNOVATION_ETF_ARKK_HOLDINGS.csv' -o arkk.csv
curl -L 'https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_AUTONOMOUS_TECHNOLOGY_&_ROBOTICS_ETF_ARKQ_HOLDINGS.csv' -o arkq.csv
curl -L 'https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_NEXT_GENERATION_INTERNET_ETF_ARKW_HOLDINGS.csv' -o arkw.csv
curl -L 'https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_GENOMIC_REVOLUTION_MULTISECTOR_ETF_ARKG_HOLDINGS.csv' -o arkg.csv
curl -L 'https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_FINTECH_INNOVATION_ETF_ARKF_HOLDINGS.csv' -o arkl.csv

curl -L 'https://ark-funds.com/wp-content/fundsiteliterature/csv/THE_3D_PRINTING_ETF_PRNT_HOLDINGS.csv' -o prnt.csv
curl -L 'https://ark-funds.com/wp-content/fundsiteliterature/csv/ARK_ISRAEL_INNOVATIVE_TECHNOLOGY_ETF_IZRL_HOLDINGS.csv' -o izrl.csv

cd "$root"

changes_dir="$root"/changes/"$today"
mkdir -p "$changes_dir"

for fund in ark{k,q,w,g,l}; do
 scripts/csv_diff.py -l snapshots/"$prev"/$fund.csv -r snapshots/"$today"/$fund.csv -o "$changes_dir"/$fund.csv
done

scripts/csv_diff.py -l snapshots/"$prev"/ark{k,q,w,g,l}.csv -r snapshots/"$today"/ark{k,q,w,g,l}.csv -o "$changes_dir"/combined.csv