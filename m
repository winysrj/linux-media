Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37324 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752652AbeDPRa6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 13:30:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "Guillermo O. Freschi" <kedrot@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        devel@driverdev.osuosl.org,
        Rene Hickersberger <renehickersberger@gmx.net>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Oliveira <Luis.Oliveira@synopsys.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aishwarya Pant <aishpant@gmail.com>
Subject: [PATCH 0/9] Do some atomisp cleanups
Date: Mon, 16 Apr 2018 12:37:03 -0400
Message-Id: <cover.1523896259.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When I started building media subsystem with the atomisp driver,
I ended by adding several hacks on their Makefiles, in order to
get rid of thousands of warnings. I felt a little guty of hiding how
broken is this driver, so I decided t remove two Makefile hacks that
affect sensors and fix the warnings. 

Yet, there's still one such hack at 
drivers/staging/media/atomisp/pci/atomisp2/Makefile, with:

# HACK! While this driver is in bad shape, don't enable several warnings
#       that would be otherwise enabled with W=1
ccflags-y += $(call cc-disable-warning, implicit-fallthrough)
ccflags-y += $(call cc-disable-warning, missing-prototypes)
ccflags-y += $(call cc-disable-warning, missing-declarations)
ccflags-y += $(call cc-disable-warning, suggest-attribute=format)
ccflags-y += $(call cc-disable-warning, unused-const-variable)
ccflags-y += $(call cc-disable-warning, unused-but-set-variable)

Getting his of those is a big task, as there are thousands of warnings
hidden there. In order to seriously get rid of them, one should start
getting rid of the several abstraction layers at the driver and have
hardware for test.

As I don't have any hardware to test, nor any reason why
dedicating myself to such task, I'll just leave this task for others
to do.

Mauro Carvalho Chehab (9):
  media: staging: atomisp: get rid of __KERNEL macros
  media: staging: atomisp: reenable warnings for I2C
  media: atomisp: ov2680.h: fix identation
  media: staging: atomisp-gc2235: don't fill an unused var
  media: staging: atomisp: Comment out several unused sensor resolutions
  media: atomisp: ov2680: don't declare unused vars
  media: atomisp-gc0310: return errors at gc0310_init()
  media: atomisp-mt9m114: remove dead data
  media: atomisp-mt9m114: comment out unused stuff

 drivers/staging/media/atomisp/i2c/Makefile         |   7 -
 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c |   2 +-
 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c |   6 +-
 .../staging/media/atomisp/i2c/atomisp-mt9m114.c    |  11 +-
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c |   6 +-
 drivers/staging/media/atomisp/i2c/gc2235.h         |   9 +-
 drivers/staging/media/atomisp/i2c/mt9m114.h        |  13 +-
 drivers/staging/media/atomisp/i2c/ov2680.h         | 900 +++++++++++----------
 drivers/staging/media/atomisp/i2c/ov2722.h         |   6 +
 drivers/staging/media/atomisp/i2c/ov5693/Makefile  |   7 -
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h  |  18 +-
 .../css_2401_csi2p_system/host/system_local.h      |  15 -
 .../hive_isp_css_common/host/system_local.h        |  15 -
 .../css2400/hive_isp_css_include/math_support.h    |   5 -
 .../css2400/hive_isp_css_include/print_support.h   |   3 -
 .../media/atomisp/pci/atomisp2/css2400/sh_css_sp.c |   4 -
 16 files changed, 503 insertions(+), 524 deletions(-)

-- 
2.14.3
