import pandas as pd


def convert(postfix):
    df = pd.read_csv("unisonflow_throughput_{0}.csv".format(postfix),
                     names=["timestamp", "dpid", "port", "rx_pps", "rx_bps",
                            "tx_pps", "tx_bps"])

    offset = df["timestamp"][0]
    print("Offset for", postfix, "is", offset)

    df["timestamp"] -= offset

    for (dpid, port), gdf in df.groupby(["dpid", "port"]):
        fname = "coll-{0}-{1}-{2}.csv".format(postfix, dpid, port)

        gdf.to_csv(fname, columns=["timestamp", "tx_bps", "rx_bps"],
                   index=False, header=False)


def main():
    convert("conv")
    convert("prop")


if __name__ == "__main__":
    main()
