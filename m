Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:53371 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751389AbeDEU3v (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 16:29:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 00/19] Make all media drivers build with COMPILE_TEST
Date: Thu,  5 Apr 2018 16:29:27 -0400
Message-Id: <cover.1522959716.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current media policy has been for a while to only accept new drivers 
that compile with COMPILE_TEST.

However, there are still several drivers under that  doesn't build
with COMPILE_TEST.

So, this series makes the existing ones also compatible with it.

Not building with COMPILE_TEST is a bad thing, for several reasons.

The main ones is that:

1) the licence the Kernel community has for Coverity only builds for 
   x86. So, drivers that don't build on such archtecture were likely 
   never tested by it.

2) That affects my per-patch handling process, with should be quick 
   enough to not delay my patch handling process. So, I only build for one 
   architecture (i386).

3) When appliying a patch, I always run two static code analyzers (W=1, 
   smatch and sparse). Those drivers weren't checked by me. At the end 
   of the day, that leads to a lower quality check for the drivers that 
   don't build on i386.

There are two situations on this patch series that proof the lower 
quality of those drivers:

- There is a case of a driver that was added broken in 2013. Only two 
  years later, someone noticed and "fixed" it by markin it as BROKEN!

- 5 patches in this series (about 1/3) are just to fix build issues on 
  those drivers, most of them due to gcc warnings.

With this patch series, all "config FOO" and "menuconfig FOO"
symbols under media will be built with allyes config.

Tested with:
	$ make ARCH=i386 allyesconfig
	$ for i in  $(grep "config " $(find drivers/staging/media/ -name Kconfig) $(find drivers/media/ -name Kconfig) |grep -v "\#.*Kconfig"|cut -d' ' -f 2) ; do if [ "$(grep $i .config)" == "" ]; then echo $i; fi;done

v2:

- did some changes as per Laurent's feedback from the past series;
- added a patch to compile both si470x drivers at the same time;
- added patches to also build all media staging drivers.

I opted to preserve patch 03/16 (omap3isp build) as I don't see
any strong reason why this driver should not be allowed to
build with COMPILE_TEST.

Mauro Carvalho Chehab (19):
  omap: omap-iommu.h: allow building drivers with COMPILE_TEST
  media: omap3isp: allow it to build with COMPILE_TEST
  media: omap3isp/isp: remove an unused static var
  media: fsl-viu: mark static functions as such
  media: fsl-viu: allow building it with COMPILE_TEST
  media: cec_gpio: allow building CEC_GPIO with COMPILE_TEST
  media: exymos4-is: allow compile test for EXYNOS FIMC-LITE
  media: mmp-camera.h: add missing platform data
  media: marvel-ccic: re-enable mmp-driver build
  media: mmp-driver: make two functions static
  media: davinci: allow building isif code
  media: davinci: allow build vpbe_display with COMPILE_TEST
  media: vpbe_venc: don't store return codes if they won't be used
  media: davinci: get rid of lots of kernel-doc warnings
  omap2: omapfb: allow building it with COMPILE_TEST
  media: omap: allow building it with COMPILE_TEST
  media: omap4iss: make it build with COMPILE_TEST
  media: si470x: allow build both USB and I2C at the same time
  media: staging: davinci_vpfe: allow building with COMPILE_TEST

 drivers/media/platform/Kconfig                   | 12 ++---
 drivers/media/platform/davinci/Kconfig           |  6 ++-
 drivers/media/platform/davinci/isif.c            |  2 -
 drivers/media/platform/davinci/vpbe.c            | 38 ++++++++-------
 drivers/media/platform/davinci/vpbe_display.c    | 21 ++++----
 drivers/media/platform/davinci/vpbe_osd.c        | 16 ++++---
 drivers/media/platform/davinci/vpbe_venc.c       |  9 ++--
 drivers/media/platform/exynos4-is/Kconfig        |  4 +-
 drivers/media/platform/fsl-viu.c                 | 20 +++++---
 drivers/media/platform/marvell-ccic/Kconfig      |  5 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c |  4 +-
 drivers/media/platform/omap/Kconfig              |  8 ++--
 drivers/media/platform/omap3isp/isp.c            | 14 +++---
 drivers/media/radio/Kconfig                      |  4 --
 drivers/media/radio/si470x/Kconfig               | 16 ++++++-
 drivers/media/radio/si470x/Makefile              |  8 ++--
 drivers/media/radio/si470x/radio-si470x-common.c | 61 +++++++++++++++++-------
 drivers/media/radio/si470x/radio-si470x-i2c.c    | 18 ++++---
 drivers/media/radio/si470x/radio-si470x-usb.c    | 18 ++++---
 drivers/media/radio/si470x/radio-si470x.h        | 15 +++---
 drivers/staging/media/davinci_vpfe/Kconfig       |  3 +-
 drivers/staging/media/davinci_vpfe/Makefile      |  5 ++
 drivers/staging/media/davinci_vpfe/TODO          |  1 +
 drivers/staging/media/omap4iss/Kconfig           |  3 +-
 drivers/video/fbdev/omap2/Kconfig                |  2 +-
 include/linux/omap-iommu.h                       |  5 ++
 include/linux/platform_data/media/mmp-camera.h   | 19 ++++++++
 27 files changed, 217 insertions(+), 120 deletions(-)

-- 
2.14.3
