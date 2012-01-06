from __future__ import with_statement

import sys
import tarfile
import re

flags = re.MULTILINE

RE_IOPS = re.compile(r"iops=(.*?),", flags)
RE_KBS = re.compile(r"aggrb=(.*?),", flags)

def main():
    if len(sys.argv) != 3:
        print "Usage: # python %s filename.tar.gz outfilepath" % sys.argv[0]
        quit()
    opentar(sys.argv[1], sys.argv[2])

def opentar(filepath, outfilepath):
    result = None
    t = tarfile.open(sys.argv[1], "r:gz")
    result = extract2result(t)
    t.close()

    with open(outfilepath, "w") as f:
        for item in result:
            f.write("{name:20}, {kbs:>10}, {iops:>10}\n".format(**item))


def extract2result(t):
    result = []
    for name in t.getnames():
        data = None
        f = t.extractfile(name)
        data = f.read()
        f.close()

        iops = RE_IOPS.search(data).groups(1)[0]
        kbs = RE_KBS.search(data).groups(1)[0]
        result.append(dict(name=name, iops=iops, kbs=kbs))
    return result

if __name__ == "__main__":
    main()

