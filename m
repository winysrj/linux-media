Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:37412 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754931AbdLFKnj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Dec 2017 05:43:39 -0500
Received: by mail-pf0-f172.google.com with SMTP id n6so2091366pfa.4
        for <linux-media@vger.kernel.org>; Wed, 06 Dec 2017 02:43:39 -0800 (PST)
Received: from ubuntu.windy (c122-106-151-124.carlnfd1.nsw.optusnet.com.au. [122.106.151.124])
        by smtp.gmail.com with ESMTPSA id s73sm4228870pfi.167.2017.12.06.02.43.36
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Dec 2017 02:43:37 -0800 (PST)
Date: Wed, 6 Dec 2017 21:43:26 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: build failure on ubuntu 16.04 LTS
Message-ID: <20171206104324.GA7941@ubuntu.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

the build has been broken for over a week for me.
Possibly my checkout is out of date??
I am using the normal build --main-git method.

Setup details:

+ date
Wednesday 6 December  21:25:28 AEDT 2017
+ uname -a
Linux ubuntu 4.4.0-101-generic #124-Ubuntu SMP Fri Nov 10 18:29:59 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
+ cat /proc/version_signature
Ubuntu 4.4.0-101.124-generic 4.4.95

+ git --no-pager log -1
commit 320b9b80ebbf318a67a9479c18a0e4be244c8409
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Tue Nov 28 08:48:04 2017 +0100

    Update backports/pr_fmt.patch

    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

+ cd media
+ git --no-pager log -1
commit 781b045baefdabf7e0bc9f33672ca830d3db9f27
Author: Sakari Ailus <sakari.ailus@linux.intel.com>
Date:   Wed Nov 1 05:40:58 2017 -0400

    media: imx274: Fix error handling, add MAINTAINERS entry

    Add the missing MAINTAINERS entry for imx274, fix error handling in driver
    probe and unregister the correct control handler in driver remove.

    Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>


This is the build failure
...

Created default (all yes) .config file
./scripts/fix_kconfig.pl
make[1]: Leaving directory '/home/me/git/clones/media_build/v4l'
$ make
make -C /home/me/git/clones/media_build/v4l
make[1]: Entering directory '/home/me/git/clones/media_build/v4l'
scripts/make_makefile.pl
./scripts/make_myconfig.pl
perl scripts/make_config_compat.pl /lib/modules/4.4.0-101-generic/build ./.myconfig ./config-compat.h
creating symbolic links...
Kernel build directory is /lib/modules/4.4.0-101-generic/build
make -C ../linux apply_patches
make[2]: Entering directory '/home/me/git/clones/media_build/linux'
Syncing with dir ../media/
Patches for 4.4.0-101-generic already applied.
make[2]: Leaving directory '/home/me/git/clones/media_build/linux'
make -C /lib/modules/4.4.0-101-generic/build SUBDIRS=/home/me/git/clones/media_build/v4l  modules
make[2]: Entering directory '/usr/src/linux-headers-4.4.0-101-generic'
  CC [M]  /home/me/git/clones/media_build/v4l/msp3400-driver.o
In file included from include/linux/compiler.h:56:0,
                 from include/asm-generic/bug.h:4,
                 from ./arch/x86/include/asm/bug.h:35,
                 from include/linux/bug.h:4,
                 from include/linux/mmdebug.h:4,
                 from /home/me/git/clones/media_build/v4l/config-compat.h:12,
                 from /home/me/git/clones/media_build/v4l/compat.h:10,
                 from <command-line>:0:
/home/me/git/clones/media_build/v4l/../linux/include/linux/compiler-gcc.h:3:2: error: #error "Please don't include <linux/compiler-gcc.h> directly, include <linux/compiler.h> instead."
 #error "Please don't include <linux/compiler-gcc.h> directly, include <linux/compiler.h> instead."
  ^
scripts/Makefile.build:258: recipe for target '/home/me/git/clones/media_build/v4l/msp3400-driver.o' failed
make[3]: *** [/home/me/git/clones/media_build/v4l/msp3400-driver.o] Error 1
Makefile:1423: recipe for target '_module_/home/me/git/clones/media_build/v4l' failed
make[2]: *** [_module_/home/me/git/clones/media_build/v4l] Error 2
make[2]: Leaving directory '/usr/src/linux-headers-4.4.0-101-generic'
Makefile:51: recipe for target 'default' failed
make[1]: *** [default] Error 2
make[1]: Leaving directory '/home/me/git/clones/media_build/v4l'
Makefile:26: recipe for target 'all' failed
make: *** [all] Error 2
build failed at ./build line 526
+ status=29

I'm struggling to follow the depedency chain here so I thought I'd better ask.

ubuntu(master)$ grep -r compiler-gcc.h|grep -F '#include'

media/include/linux/compiler_types.h:#include <linux/compiler-gcc.h>
media/tools/include/linux/compiler.h:#include <linux/compiler-gcc.h>

Cheers
Vince
