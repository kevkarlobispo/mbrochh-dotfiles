#/bin/bash

# Script to dive into code space.
# Starts a screen session and opens all windows that I need

# $1: Screen sessionname
# $2: Project directory
# $3: Name of virtualenv
# $4: Path to the static/css/ folder relative from $2
# $5: Path to the root of the repo, where the docs/ and watchmedo.sh should be
# $6: Name of docs gorun file
# $7: Use watchmedo or not? (1 / 0)

# Kill old screen session with the same name.
screen -X -S $1 quit

# Start new screen session
screen -d -m -S $1

# Open all needed windows

# Start Django server
screen -S $1 -p 0 -X title runserver
screen -S $1 -p 0 -X stuff "`printf "cd $2\r"`"
screen -S $1 -p 0 -X stuff "`printf "workon $3\r"`"
screen -S $1 -p 0 -X stuff "`printf "./manage.py runserver\r"`"


# Start gorun.py to run tests on file changes
screen -x $1 -X screen
screen -x $1 -p 1 -X title gorun
screen -S $1 -p 1 -X stuff "`printf "cd $2\r"`"
screen -S $1 -p 1 -X stuff "`printf "workon $3\r"`"
if [ $7 = 0]; then
    screen -S $1 -p 1 -X stuff "`printf "gorun.py gorun_settings.py\r"`"
else
    screen -S $1 -p 1 -X stuff "`printf "./watchmedo.sh\r"`"
fi


# Start vim for test files
screen -x $1 -X screen
screen -x $1 -p 2 -X title tests
screen -S $1 -p 2 -X stuff "`printf "cd $2\r"`"
screen -S $1 -p 2 -X stuff "`printf "workon $3\r"`"
screen -S $1 -p 2 -X stuff "`printf "vim\r"`"


# Start vim for code files
screen -x $1 -X screen
screen -x $1 -p 3 -X title code
screen -S $1 -p 3 -X stuff "`printf "cd $2\r"`"
screen -S $1 -p 3 -X stuff "`printf "workon $3\r"`"
screen -S $1 -p 3 -X stuff "`printf "vim\r"`"


# Go to project folder
screen -x $1 -X screen
screen -x $1 -p 4 -X title files
screen -S $1 -p 4 -X stuff "`printf "cd $2\r"`"
screen -S $1 -p 4 -X stuff "`printf "workon $3\r"`"


# Start sass watcher
screen -x $1 -X screen
screen -x $1 -p 5 -X title sass
screen -S $1 -p 5 -X stuff "`printf "cd $2\r"`"
screen -S $1 -p 5 -X stuff "`printf "cd $4\r"`"
screen -S $1 -p 5 -X stuff "`printf "sass --watch *.sass\r"`"


# Start gorun.py to rebuild the sphinxdocs on each change
if [ $2 != '' ]; then
    screen -x $1 -X screen
    screen -x $1 -p 6 -X title sphinxdoc
    screen -S $1 -p 6 -X stuff "`printf "cd $5\r"`"
    screen -S $1 -p 6 -X stuff "`printf "workon $3\r"`"
    if [ $7 = 0]; then
        screen -S $1 -p 6 -X stuff "`printf "gorun.py $6\r"`"
    else
        screen -S $1 -p 6 -X stuff "`printf "./watchmedo.sh\r"`"
    fi
fi


# DIVE IN!
screen -R $1
