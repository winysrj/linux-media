Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44934 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751746AbeDEUaA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 16:30:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH v2 19/19] media: staging: davinci_vpfe: allow building with COMPILE_TEST
Date: Thu,  5 Apr 2018 16:29:46 -0400
Message-Id: <51b55b8a47aac8f712a5aff2fe79d20f9f7b9cf7.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a little bit hashish, but this driver is at staging,
so it won't become worse.

With this small change at Makefile, we can now build it with
COMPILE_TEST.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/davinci_vpfe/Kconfig  | 3 ++-
 drivers/staging/media/davinci_vpfe/Makefile | 5 +++++
 drivers/staging/media/davinci_vpfe/TODO     | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/Kconfig b/drivers/staging/media/davinci_vpfe/Kconfig
index f40a06954a92..bcba9a64c514 100644
--- a/drivers/staging/media/davinci_vpfe/Kconfig
+++ b/drivers/staging/media/davinci_vpfe/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_DM365_VPFE
 	tristate "DM365 VPFE Media Controller Capture Driver"
-	depends on VIDEO_V4L2 && ARCH_DAVINCI_DM365 && !VIDEO_DM365_ISIF
+	depends on VIDEO_V4L2
+	depends on (ARCH_DAVINCI_DM365 && !VIDEO_DM365_ISIF) || COMPILE_TEST
 	depends on HAS_DMA
 	depends on VIDEO_V4L2_SUBDEV_API
 	depends on VIDEO_DAVINCI_VPBE_DISPLAY
diff --git a/drivers/staging/media/davinci_vpfe/Makefile b/drivers/staging/media/davinci_vpfe/Makefile
index 3019c9ecd548..9c57042c877d 100644
--- a/drivers/staging/media/davinci_vpfe/Makefile
+++ b/drivers/staging/media/davinci_vpfe/Makefile
@@ -3,3 +3,8 @@ obj-$(CONFIG_VIDEO_DM365_VPFE) += davinci-vfpe.o
 davinci-vfpe-objs := \
 	dm365_isif.o dm365_ipipe_hw.o dm365_ipipe.o \
 	dm365_resizer.o dm365_ipipeif.o vpfe_mc_capture.o vpfe_video.o
+
+# Allow building it with COMPILE_TEST on other archs
+ifndef CONFIG_ARCH_DAVINCI
+ccflags-y += -Iarch/arm/mach-davinci/include/
+endif
diff --git a/drivers/staging/media/davinci_vpfe/TODO b/drivers/staging/media/davinci_vpfe/TODO
index 3e5477e8cfa5..cc8bd9306f2a 100644
--- a/drivers/staging/media/davinci_vpfe/TODO
+++ b/drivers/staging/media/davinci_vpfe/TODO
@@ -20,6 +20,7 @@ TODO (general):
 - While replacing the older driver in media folder, provide a compatibility
   layer and compatibility tests that warrants (using the libv4l's LD_PRELOAD
   approach) there is no regression for the users using the older driver.
+- make it independent of arch-specific APIs (mach/mux.h).
 
 Building of uImage and Applications:
 ==================================
-- 
2.14.3
