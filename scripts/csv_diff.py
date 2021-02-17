#!/usr/bin/env python3

import csv
from collections import Counter


class Differ:
    def __init__(self):
        self.cusip_to_row_ = {}

    def do_row(self, ret, row):
        if row["cusip"]:
            ret.update({row["cusip"]: float(row["shares"])})
            if row["cusip"] not in self.cusip_to_row_:
                self.cusip_to_row_[row["cusip"]] = row

    def read_files(self, files):
        ret = Counter()
        for file in files:
            with open(file, newline="") as csvfile:
                reader = csv.DictReader(csvfile)
                for row in reader:
                    self.do_row(ret, row)
        return ret

    def diff(self, left_files, right_files):
        return self.read_files(right_files) - self.read_files(left_files)

    def diff_to_csv(self, left_files, right_files, outfile):
        res = self.diff(left_files, right_files)
        fieldnames = ['date', 'company', 'ticker', 'cusip', 'change', 'new_shares']
        with open(outfile, 'w', newline='') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()
            for (cusip, change) in res.items():
                source_row = self.cusip_to_row_[cusip]
                writer.writerow({
                    'date': source_row['date'],
                    'company': source_row['company'],
                    'ticker': source_row['ticker'],
                    'cusip': cusip,
                    'change': change,
                    'new_shares': source_row['shares'],
                    })

    def cusip_to_row(self):
        # right file rows are prioritized
        return self.cusip_to_row_



def main():
    import argparse

    parser = argparse.ArgumentParser(description="Process some csvs.")
    parser.add_argument(
        "-l", "--left-files", nargs="+", default=[], help="Left (before) files"
    )
    parser.add_argument(
        "-r", "--right-files", nargs="+", default=[], help="Right (after) files"
    )
    parser.add_argument(
        "-o", "--output", default="", help="Output file"
    )
    args = parser.parse_args()

    d = Differ()
    d.diff_to_csv(args.left_files, args.right_files, args.output)


if __name__ == "__main__":
    main()
