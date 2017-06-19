Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:49948 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750846AbdFSSnr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 14:43:47 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [media-build] Can't compile for Kernel 3.13 after recent changes
Message-ID: <e7955c6a-06d4-1cf4-f776-f0db0bd61f18@anw.at>
Date: Mon, 19 Jun 2017 20:43:32 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

After the recent changes, I can no longer compile for Kernel 3.13

BR,
   Jasmin

Here the build Log:

Kernel build directory is /lib/modules/3.13.0-117-generic/build
make -C ../linux apply_patches
make[2]: Entering directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
Patches for 3.13.0-117-generic already applied.
make[2]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
make -C /lib/modules/3.13.0-117-generic/build SUBDIRS=/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l  modules
make[2]: Entering directory '/mnt/home_hdd/jasmin/vdr/dd_driver/linux-headers-3.13.0-117-generic'
  CC [M]  /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-lpt.o
  CC [M]  /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-jtag.o
  CC [M]  /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-comp.o
In file included from <command-line>:0:0:
/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/compat.h: In function 'dev_fwnode':
/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/compat.h:2017:12: error: 'struct device' has no member named 'fwnode'
  return dev->fwnode;
            ^
/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-lpt.c: At top level:
cc1: warning: unrecognized command line option '-Wno-implicit-fallthrough'
cc1: warning: unrecognized command line option '-Wno-unused-const-variable'
scripts/Makefile.build:308: recipe for target '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-lpt.o' failed
make[3]: *** [/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-lpt.o] Error 1
make[3]: *** Waiting for unfinished jobs....
In file included from <command-line>:0:0:
/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/compat.h: In function 'dev_fwnode':
/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/compat.h:2017:12: error: 'struct device' has no member named 'fwnode'
  return dev->fwnode;
            ^
/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-comp.c: At top level:
cc1: warning: unrecognized command line option '-Wno-implicit-fallthrough'
cc1: warning: unrecognized command line option '-Wno-unused-const-variable'
scripts/Makefile.build:308: recipe for target '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-comp.o' failed
make[3]: *** [/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-comp.o] Error 1
In file included from <command-line>:0:0:
/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/compat.h: In function 'dev_fwnode':
/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/compat.h:2017:12: error: 'struct device' has no member named 'fwnode'
  return dev->fwnode;
            ^
/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-jtag.c: At top level:
cc1: warning: unrecognized command line option '-Wno-implicit-fallthrough'
cc1: warning: unrecognized command line option '-Wno-unused-const-variable'
scripts/Makefile.build:308: recipe for target '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-jtag.o' failed
make[3]: *** [/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-jtag.o] Error 1
Makefile:1279: recipe for target '_module_/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l' failed
make[2]: *** [_module_/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l] Error 2
make[2]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/linux-headers-3.13.0-117-generic'
Makefile:51: recipe for target 'default' failed
make[1]: *** [default] Error 2
make[1]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l'
Makefile:26: recipe for target 'all' failed
