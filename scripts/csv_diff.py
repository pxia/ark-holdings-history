#!/usr/bin/env python3

import csv
from collections import Counter


class Differ:
    def __init__(self):
        self.cusip_to_ticker_ = {}

    def do_row(self, ret, row):
        if row["cusip"]:
            ret.update({row["cusip"]: float(row["shares"])})
            if row["cusip"] not in self.cusip_to_ticker_:
                self.cusip_to_ticker_[row["cusip"]] = row["ticker"]

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

    def cusip_to_ticker(self):
        return self.cusip_to_ticker_


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Process some csvs.")
    parser.add_argument(
        "-c",
        "--combine",
        type=bool,
        default=False,
        help="Combine left and right before diff.",
    )
    parser.add_argument(
        "-l", "--left-files", nargs="+", default=[], help="Left (before) files"
    )
    parser.add_argument(
        "-r", "--right-files", nargs="+", default=[], help="Right (after) files"
    )
    args = parser.parse_args()

    d = Differ()
    res = d.diff(args.left_files, args.right_files)
    print(res)


if __name__ == "__main__":
    main()
