Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50314 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab2GJVQL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 17:16:11 -0400
Received: by yenl2 with SMTP id l2so533165yen.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jul 2012 14:16:10 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 10 Jul 2012 23:16:10 +0200
Message-ID: <CADR1r6gQD-yQhzhfF0PUJq06Xw9Oq7YJHtRVWPXEEmwtR36k+Q@mail.gmail.com>
Subject: Make menuconfig doesn't work anymore
From: Martin Herrman <martin.herrman@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All,

I own a Cine CT v6 and compiled drivers for it succesfully using:
-  hg clone http://linuxtv.org/hg/~endriss/media_build_experimental
- cd media_build_experimental
- make download
- make untar
- make menuconfig (only select drivers I need)
- make install
- reboot

This worked succesfully on Ubuntu 11.10, Ubuntu 12.04 and on Gentoo
Linux. After another fresh install of Gentoo Linux (just a couple of
days after the previous one - now with custom compiled kernel), it
doesn't work anymore. The make menuconfig command fails:

htpc media_build_experimental # make menuconfig
make -C /usr/src/media_build_experimental/v4l menuconfig
make[1]: Entering directory `/usr/src/media_build_experimental/v4l'
No version yet, using 3.5.0-rc6
make[1]: Leaving directory `/usr/src/media_build_experimental/v4l'
make[1]: Entering directory `/usr/src/media_build_experimental/v4l'
make -C /lib/modules/3.5.0-rc6/build -f
/usr/src/media_build_experimental/v4l/Makefile.kernel config-targets=1
mixed-targets=0 dot-config=0 SRCDIR=/lib/modules/3.5.0-rc6/source
v4l-mconf
make[2]: Entering directory `/usr/src/linux-3.5-rc6'
  HOSTCC  scripts/basic/fixdep
make -f /lib/modules/3.5.0-rc6/source/scripts/Makefile.build
obj=scripts/kconfig hostprogs-y=mconf scripts/kconfig/mconf
  HOSTCC  scripts/kconfig/lxdialog/checklist.o
  HOSTCC  scripts/kconfig/lxdialog/inputbox.o
  HOSTCC  scripts/kconfig/lxdialog/menubox.o
  HOSTCC  scripts/kconfig/lxdialog/textbox.o
  HOSTCC  scripts/kconfig/lxdialog/util.o
  HOSTCC  scripts/kconfig/lxdialog/yesno.o
  HOSTCC  scripts/kconfig/mconf.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/zconf.lex.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/mconf
make[2]: Leaving directory `/usr/src/linux-3.5-rc6'
make[2]: Entering directory `/usr/src/media_build_experimental/linux'
Applying patches for kernel 3.5.0-rc6
patch -s -f -N -p1 -i ../backports/api_version.patch
1 out of 1 hunk FAILED -- saving rejects to file
drivers/media/video/v4l2-ioctl.c.rej
make[2]: *** [apply_patches] Error 1
make[2]: Leaving directory `/usr/src/media_build_experimental/linux'
make[1]: *** [Kconfig] Error 2
make[1]: Leaving directory `/usr/src/media_build_experimental/v4l'
make: *** [menuconfig] Error 2

Make menuconfig *does* work when configuring a new kernel. I have also
tried with kernel 3.2.22 and 3.4, but no succes either.

Any ideas what is going wrong?

Thanks in advance!

Martin
