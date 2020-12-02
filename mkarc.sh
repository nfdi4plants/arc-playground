#! /bin/bash

set -o errexit
set -o nounset

readonly GIT_URL=http://adm:adm@localhost:3333/adm

function random_content(){
    sed -n "$RANDOM p" /usr/share/dict/words
}

#first ARC
echo "### arc-a ############################################"

test -e arc-a && rm -rf arc-a

mkdir arc-a && pushd arc-a 

    git init
    git remote add origin ${GIT_URL}/arc-a.git

    touch isa.investigation.xlsx isa.studies.xlsx arc.cwl
    git add *
    git commit -m "add base files"

    mkdir assays && pushd assays
        mkdir assay-1 && pushd assay-1
            touch isa.xlsx

            dd bs=1048576 count=1 if=/dev/urandom of=test1.dat
            git lfs track test1.dat

            dd bs=1048576 count=1 if=/dev/urandom of=test2.dat
            git lfs track test2.dat
        popd

        git add assay-1
        git commit -m "add assay-1"

        mkdir assay-2 && pushd assay-2
            touch isa.xlsx
            git add isa.xlsx

            touch fubar.raw
            git lfs track fubar.raw

            touch test.png
            git lfs track test.png
        popd

        git add assay-2
        git commit -m "add assay-2"
    popd

    mkdir workflows && pushd workflows
        mkdir workflow-1 && pushd workflow-1
            touch run.cwl
            touch test.sh
        popd

        git add workflow-1
        git commit -m "add workflow-1"

        mkdir workflow-2 && pushd workflow-2
            touch run.cwl
            touch foo.r
        popd

        git add workflow-2
        git commit -m "add workflow-2"
    popd
    
    # create large LFS history (~ 100 MB)
    pushd assays/assay-1
        for ((i=1; i<50; ++i)); do
            dd bs=1048576 count=1 if=/dev/urandom of=test1.dat
            dd bs=1048576 count=1 if=/dev/urandom of=test2.dat
            git add -u
            git commit -m "update assay-a-1 ($i)"
        done
    popd
popd

#second ARC
echo "### arc-b ############################################"

test -e arc-b && rm -rf arc-b

mkdir arc-b && pushd arc-b 

    git init
    git remote add origin ${GIT_URL}/arc-b.git

    touch isa.investigation.xlsx isa.studies.xlsx arc.cwl
    git add *
    git commit -m "add base files"

    mkdir assays && pushd assays
        # large assay
        mkdir assay-1 && pushd assay-1
            touch isa.xlsx

            dd bs=52428800 count=1 if=/dev/urandom of=large1.dat
            git lfs track large1.dat
        popd

        git add assay-1
        git commit -m "add assay-1"

        mkdir assay-2 && pushd assay-2
            touch isa.xlsx

            dd bs=52428800 count=1 if=/dev/urandom of=large2.dat
            git lfs track large2.dat
        popd

        git add assay-2
        git commit -m "add assay-2"

        # small assay
        mkdir assay-3 && pushd assay-3
            touch isa.xlsx
            echo "data" > data.txt
        popd

        git add assay-3
        git commit -m "add assay-3"
    popd

    mkdir workflows && pushd workflows
        # create a bunch of workflows
        for ((w=1; w<=10; ++w)) do
            echo "create workflow $w"
            mkdir workflow-$w && pushd workflow-$w
                touch run.cwl
                random_content > test.sh

                echo $(pwd)
                ls
            popd

            git add workflow-$w
            git commit -m "add workflow-$w"
        done

        # create a history of workflow updates
        for ((i=0; i<1000; ++i)) do
            w=$(( ( RANDOM % 10 )  + 1 ))
            random_content > workflow-$w/test.sh

            git add workflow-$w/test.sh
            git commit -m "update workflow-$w ($i)"
        done
    popd
    
    # remove one of the large assays
    git rm -r assays/assay-2
    git commit -m "remove assay-2"

popd
