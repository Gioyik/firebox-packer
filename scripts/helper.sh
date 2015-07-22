#!/bin/bash

echo "create .tools folder"
if [ ! -d .tools ]
then
    mkdir .tools
fi
curl https://raw.github.com/mozilla/moz-git-tools/master/git-patch-to-hg-patch > tool/git-patch-to-hg-patch
chmod a+x tool/git-patch-to-hg-patch

echo "configure git"
if [ -f .gitconfig ]
then
    echo "[user]"
    echo "     name = Firebox"
    echo "     email = firebox@moz.illa"
    echo "[color]"
    echo "    ui = auto"
fi > .gitconfig

echo "configure mercurial"
if [ -f .hgrc ]
then
    echo "[user]"
    echo "     name = Firebox"
    echo "     email = firebox@moz.illa"
    echo "[color]"
    echo "    ui = auto"
fi > .hgrc

echo "Create 'gui.sh' to start GUI                   "
echo "sudo startx" > gui.sh
chmod a+x gui.sh

echo "   Create 'home.sh' to go back to correct home    "
echo "cd /home/vagrant" > /root/home.sh
chmod a+x /root/home.sh

echo "   Create 'init_B2G.sh' to fetch B2G repository    "
echo "#!/bin/bash
if [ -d B2G/.git ]
then
    echo "The git directory exists."
    echo "update B2G repository"
    cd B2G
    git pull
    cd ..
else
    rm B2G/README.md
    # purge mac temp
    rm B2G/.DS_Store
    echo "clone B2G repository"
    git clone https://github.com/mozilla-b2g/B2G.git B2G
fi" > B2G_init.sh
chmod a+x B2G_init.sh

echo "   Create 'init_gecko.sh' to fetch gecko source    "
echo "#!/bin/bash
if [ -d gecko/.hg ]
then
    echo "The directory exists."
    echo "update gecko repository"
    cd gecko
    hg pull -u
#    git pull
    cd ..
else
    rm gecko/README.md
    # purge mac temp
    rm gecko/.DS_Store
    echo "setup gecko build environment"
    # https://developer.mozilla.org/en-US/docs/Developer_Guide/Build_Instructions/Linux_Prerequisites
    wget https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py && python bootstrap.py
    echo "clone gecko repository"
    hg clone http://hg.mozilla.org/mozilla-central gecko
    #git clone https://github.com/mozilla/gecko-dev gecko
    echo "create .mozconfig file in gecko"
    rm gecko/.mozconfig
    echo \"mk_add_options MOZ_OBJDIR=../build\"      > gecko/.mozconfig
    echo \"mk_add_options MOZ_MAKE_FLAGS=\\\"-j9 -s\\\"\"  >> gecko/.mozconfig
    echo \"\"                                        >> gecko/.mozconfig
    echo \"ac_add_options --enable-application=b2g\" >> gecko/.mozconfig
    echo \"ac_add_options --disable-libjpeg-turbo\"  >> gecko/.mozconfig
    echo \"\"                                        >> gecko/.mozconfig
    echo \"# This option is required if you want to be able to run Gaia tests\" >> gecko/.mozconfig
    echo \"ac_add_options --enable-tests\"           >> gecko/.mozconfig
    echo \"\"                                        >> gecko/.mozconfig
    echo \"# turn on mozTelephony/mozSms interfaces\" >> gecko/.mozconfig
    echo \"# Only turn this line on if you actually have a dev phone\" >> gecko/.mozconfig
    echo \"# you want to forward to. If you get crashes at startup,\" >> gecko/.mozconfig
    echo \"# make sure this line is commented.\"     >> gecko/.mozconfig
    echo \"#ac_add_options --enable-b2g-ril\"        >> gecko/.mozconfig
    echo "done. You can start build gecko with command: \'./mach build\'."
fi" > gecko_init.sh
chmod a+x gecko_init.sh

echo "   Create 'init_gaia.sh' to fetch gaia source    "
echo "#!/bin/bash
if [ -d gaia/.git ]
then
    echo "The git directory exists."
    echo "update gaia repository"
    cd gaia
    #gaia pull
    repo sync
    cd ..
else
    rm gaia/README.md
    # purge mac temp
    rm gaia/.DS_Store
    echo "clone gaia repository"
    #git clone https://github.com/mozilla-b2g/gaia.git gaia
    # use git-repo instead of clone gaia directly
    cd gaia
    repo init -u https://github.com/gasolin/gaia-repo.git
    repo sync
    cd ..
fi" > gaia_init.sh
chmod a+x gaia_init.sh

