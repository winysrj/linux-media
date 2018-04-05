Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40885 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751417AbeDERy3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 13:54:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Kukjin Kim <kgene@kernel.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Bhumika Goyal <bhumirks@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        linux-fbdev@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        dri-devel@lists.freedesktop.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 00/16] Make all drivers under drivers/media to build with COMPILE_TEST
Date: Thu,  5 Apr 2018 13:54:00 -0400
Message-Id: <cover.1522949748.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


The current media policy has been for a while to only accept new drivers 
that compile with COMPILE_TEST.

However, there are still several drivers under drivers/media that 
doesn't build with COMPILE_TEST.

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


Mauro Carvalho Chehab (16):
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
  media: omapfb_dss.h: add stubs to build with COMPILE_TEST
  media: omap: allow building it with COMPILE_TEST

 drivers/media/platform/Kconfig                   | 12 +++---
 drivers/media/platform/davinci/Kconfig           |  6 ++-
 drivers/media/platform/davinci/isif.c            |  2 -
 drivers/media/platform/davinci/vpbe.c            | 38 +++++++++--------
 drivers/media/platform/davinci/vpbe_display.c    | 21 +++++----
 drivers/media/platform/davinci/vpbe_osd.c        | 16 ++++---
 drivers/media/platform/davinci/vpbe_venc.c       |  9 ++--
 drivers/media/platform/exynos4-is/Kconfig        |  4 +-
 drivers/media/platform/fsl-viu.c                 | 20 ++++++---
 drivers/media/platform/marvell-ccic/Kconfig      |  5 ++-
 drivers/media/platform/marvell-ccic/mmp-driver.c |  4 +-
 drivers/media/platform/omap/Kconfig              |  6 +--
 drivers/media/platform/omap3isp/isp.c            | 14 +++---
 include/linux/omap-iommu.h                       |  5 +++
 include/linux/platform_data/media/mmp-camera.h   | 19 +++++++++
 include/video/omapfb_dss.h                       | 54 +++++++++++++++++++++++-
 16 files changed, 162 insertions(+), 73 deletions(-)

-- 
2.14.3
