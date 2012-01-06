#!/bin/sh

RESULT=bench_result.txt
TEMPDIR=/tmp/bench
TEMPFILE=/tmp/bench/tmp
HOST=`hostname`

BIN=`which fio`
if [ $? -eq 1 ]; then
    echo "Install fio"
    sudo apt-get install fio
fi

BIN=`which fio`

if [ ! -d $TEMPDIR ]; then
    mkdir $TEMPDIR
fi

# fio settings
NUMJOBS=1
GROUPREPORTING=--group_reporting
LOOPS=1
SIZE=1G
DIRECT=1


NAME=SequentialRead
RW=read
BS=1m
$BIN --filename=$TEMPFILE --direct=$DIRECT --rw=$RW --bs=$BS --size=$SIZE --numjobs=$NUMJOBS --loops=$LOOPS $GROUPREPORTING --name=$NAME > $TEMPDIR/$NAME

NAME=SequentialWrite
RW=write
$BIN --filename=$TEMPFILE --direct=$DIRECT --rw=$RW --bs=$BS --size=$SIZE --numjobs=$NUMJOBS --loops=$LOOPS $GROUPREPORTING --name=$NAME > $TEMPDIR/$NAME


NAME=RandomRead512k
RW=randread
BS=512k
$BIN --filename=$TEMPFILE --direct=$DIRECT --rw=$RW --bs=$BS --size=$SIZE --numjobs=$NUMJOBS --loops=$LOOPS $GROUPREPORTING --name=$NAME > $TEMPDIR/$NAME

NAME=RandomWrite512k
RW=randwrite
$BIN --filename=$TEMPFILE --direct=$DIRECT --rw=$RW --bs=$BS --size=$SIZE --numjobs=$NUMJOBS --loops=$LOOPS $GROUPREPORTING --name=$NAME > $TEMPDIR/$NAME


NAME=RandomRead4k
RW=randread
BS=4k
SIZE=100m
LOOPS=3
$BIN --filename=$TEMPFILE --direct=$DIRECT --rw=$RW --bs=$BS --size=$SIZE --numjobs=$NUMJOBS --loops=$LOOPS $GROUPREPORTING --name=$NAME > $TEMPDIR/$NAME

NAME=RandomWrite4k
RW=randwrite
$BIN --filename=$TEMPFILE --direct=$DIRECT --rw=$RW --bs=$BS --size=$SIZE --numjobs=$NUMJOBS --loops=$LOOPS $GROUPREPORTING --name=$NAME > $TEMPDIR/$NAME


NAME=RandomRead4k32
RW=randread
BS=4k
SIZE=10m
LOOPS=3
NUMJOBS=32
$BIN --filename=$TEMPFILE --direct=$DIRECT --rw=$RW --bs=$BS --size=$SIZE --numjobs=$NUMJOBS --loops=$LOOPS $GROUPREPORTING --name=$NAME > $TEMPDIR/$NAME

NAME=RandomWrite4k32
RW=randwrite
$BIN --filename=$TEMPFILE --direct=$DIRECT --rw=$RW --bs=$BS --size=$SIZE --numjobs=$NUMJOBS --loops=$LOOPS $GROUPREPORTING --name=$NAME > $TEMPDIR/$NAME


rm $TEMPFILE

cd $TEMPDIR
tar zcf $HOST.tar.gz *
cd

mv $TEMPDIR/$HOST.tar.gz ./
python bench_result.py $HOST.tar.gz $HOST.result.txt

