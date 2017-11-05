Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:50789 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752394AbdKEATE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Nov 2017 20:19:04 -0400
Received: by mail-pg0-f45.google.com with SMTP id y5so5437446pgq.7
        for <linux-media@vger.kernel.org>; Sat, 04 Nov 2017 17:19:03 -0700 (PDT)
Received: from ubuntu.windy (c122-106-151-124.carlnfd1.nsw.optusnet.com.au. [122.106.151.124])
        by smtp.gmail.com with ESMTPSA id b22sm17167137pfj.123.2017.11.04.17.19.00
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Nov 2017 17:19:01 -0700 (PDT)
Date: Sun, 5 Nov 2017 11:18:49 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: broken build against 4.4.0
Message-ID: <20171105001846.GA10360@ubuntu.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
can someone take a look please?

+ uname -a
Linux ubuntu 4.4.0-97-generic #120-Ubuntu SMP Tue Sep 19 17:28:18 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
+ cat /proc/version_signature
Ubuntu 4.4.0-97.120-generic 4.4.87

This was with a fresh clone,

+ git --no-pager log -1
commit c93534951f5d66bef7f17f16293acf2be346b726
Author: Jasmin Jessich <jasmin@anw.at>
Date:   Sat Oct 14 01:41:32 2017 +0200

    build: Fixed patches for Kernel 2.6.35
    
    Signed-off-by: Jasmin Jessich <jasmin@anw.at>
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

...

make[2]: Leaving directory '/home/me/git/clones/media_build/linux'
make -C /lib/modules/4.4.0-97-generic/build SUBDIRS=/home/me/git/clones/media_buildmodules
make[2]: Entering directory '/usr/src/linux-headers-4.4.0-97-generic'
  CC [M]  /home/me/git/clones/media_build/v4l/msp3400-driver.o
  CC [M]  /home/me/git/clones/media_build/v4l/msp3400-kthreads.o
  LD [M]  /home/me/git/clones/media_build/v4l/msp3400.o
  CC [M]  /home/me/git/clones/media_build/v4l/smiapp-core.o
  CC [M]  /home/me/git/clones/media_build/v4l/smiapp-regs.o
  CC [M]  /home/me/git/clones/media_build/v4l/smiapp-quirk.o
  CC [M]  /home/me/git/clones/media_build/v4l/smiapp-limits.o
  LD [M]  /home/me/git/clones/media_build/v4l/smiapp.o
  CC [M]  /home/me/git/clones/media_build/v4l/et8ek8_mode.o
  CC [M]  /home/me/git/clones/media_build/v4l/et8ek8_driver.o
  LD [M]  /home/me/git/clones/media_build/v4l/et8ek8.o
  CC [M]  /home/me/git/clones/media_build/v4l/cx25840-core.o
  CC [M]  /home/me/git/clones/media_build/v4l/cx25840-audio.o
  CC [M]  /home/me/git/clones/media_build/v4l/cx25840-firmware.o
  CC [M]  /home/me/git/clones/media_build/v4l/cx25840-vbi.o
  CC [M]  /home/me/git/clones/media_build/v4l/cx25840-ir.o
  LD [M]  /home/me/git/clones/media_build/v4l/cx25840.o
  CC [M]  /home/me/git/clones/media_build/v4l/m5mols_core.o
  CC [M]  /home/me/git/clones/media_build/v4l/m5mols_controls.o
  CC [M]  /home/me/git/clones/media_build/v4l/m5mols_capture.o
  LD [M]  /home/me/git/clones/media_build/v4l/m5mols.o
  CC [M]  /home/me/git/clones/media_build/v4l/imx074.o
  CC [M]  /home/me/git/clones/media_build/v4l/mt9m001.o
  CC [M]  /home/me/git/clones/media_build/v4l/mt9t031.o
  CC [M]  /home/me/git/clones/media_build/v4l/mt9t112.o
  CC [M]  /home/me/git/clones/media_build/v4l/mt9v022.o
  CC [M]  /home/me/git/clones/media_build/v4l/ov5642.o
  CC [M]  /home/me/git/clones/media_build/v4l/ov772x.o
  CC [M]  /home/me/git/clones/media_build/v4l/ov9640.o
  CC [M]  /home/me/git/clones/media_build/v4l/ov9740.o
  CC [M]  /home/me/git/clones/media_build/v4l/rj54n1cb0c.o
  CC [M]  /home/me/git/clones/media_build/v4l/tw9910.o
  CC [M]  /home/me/git/clones/media_build/v4l/aptina-pll.o
  CC [M]  /home/me/git/clones/media_build/v4l/tvaudio.o
/home/me/git/clones/media_build/v4l/tvaudio.c: In function 'chip_thread_wake':
/home/me/git/clones/media_build/v4l/tvaudio.c:305:27: error: implicit declaration of function 'from_timer' [-Werror=implicit-function-declaration]
  struct CHIPSTATE *chip = from_timer(chip, t, wt);
                           ^
/home/me/git/clones/media_build/v4l/tvaudio.c:305:47: error: 'wt' undeclared (first use in this function)
  struct CHIPSTATE *chip = from_timer(chip, t, wt);
                                               ^
/home/me/git/clones/media_build/v4l/tvaudio.c:305:47: note: each undeclared identifier is reported only once for each function it appears in
/home/me/git/clones/media_build/v4l/tvaudio.c: In function 'tvaudio_probe':
/home/me/git/clones/media_build/v4l/tvaudio.c:1998:2: error: implicit declaration of function 'timer_setup' [-Werror=implicit-function-declaration]
  timer_setup(&chip->wt, chip_thread_wake, 0);
  ^
cc1: some warnings being treated as errors
scripts/Makefile.build:264: recipe for target '/home/me/git/clones/media_build/v4l/o.o' failed
make[3]: *** [/home/me/git/clones/media_build/v4l/tvaudio.o] Error 1
Makefile:1423: recipe for target '_module_/home/me/git/clones/media_build/v4l' fail
make[2]: *** [_module_/home/me/git/clones/media_build/v4l] Error 2
make[2]: Leaving directory '/usr/src/linux-headers-4.4.0-97-generic'
Makefile:51: recipe for target 'default' failed
make[1]: *** [default] Error 2
make[1]: Leaving directory '/home/me/git/clones/media_build/v4l'
Makefile:26: recipe for target 'all' failed
make: *** [all] Error 2
build failed at ./build line 526
