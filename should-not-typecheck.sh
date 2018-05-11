#!/bin/bash

check_exit () {
    rc=$?
    if [[ $rc != 1 ]]
    then
        echo "Exit code for type error should have been 1 but was $rc !"
        exit $rc
    fi
}

stack exec -- ghc -o /tmp -hidir /tmp -tmpdir /tmp -odir /tmp -itest --make test/ReadWrite/ShouldNotTypeCheck/InsertRunRead.hs;

check_exit;

stack exec -- ghc -o /tmp -hidir /tmp -tmpdir /tmp -odir /tmp -itest --make test/ReadWrite/ShouldNotTypeCheck/DeleteRunRead.hs;

check_exit;

stack exec -- ghc -o /tmp -hidir /tmp -tmpdir /tmp -odir /tmp -itest --make test/ReadWrite/ShouldNotTypeCheck/UpdateRunRead.hs;

check_exit;
