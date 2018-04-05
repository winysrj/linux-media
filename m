Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60361 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751540AbeDEU3x (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 16:29:53 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 12/19] media: davinci: allow build vpbe_display with COMPILE_TEST
Date: Thu,  5 Apr 2018 16:29:39 -0400
Message-Id: <0538c91427253cffe4e2feee1865838a3504ce96.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Except for some includes (with doesn't seem to be used), this
driver builds fine with COMPILE_TEST.

So, add checks there to avoid building it if ARCH_DAVINCI
is not selected.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/davinci/Kconfig        | 3 ++-
 drivers/media/platform/davinci/vpbe_display.c | 3 +++
 drivers/media/platform/davinci/vpbe_osd.c     | 2 ++
 drivers/media/platform/davinci/vpbe_venc.c    | 3 +++
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index babdb4877b3f..b463d1726335 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -82,7 +82,8 @@ config VIDEO_DM365_ISIF
 
 config VIDEO_DAVINCI_VPBE_DISPLAY
 	tristate "TI DaVinci VPBE V4L2-Display driver"
-	depends on VIDEO_V4L2 && ARCH_DAVINCI
+	depends on VIDEO_V4L2
+	depends on ARCH_DAVINCI || COMPILE_TEST
 	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 6aabd21fe69f..7b6cd4b3ccc4 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -26,7 +26,10 @@
 #include <linux/slab.h>
 
 #include <asm/pgtable.h>
+
+#ifdef CONFIG_ARCH_DAVINCI
 #include <mach/cputype.h>
+#endif
 
 #include <media/v4l2-dev.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/platform/davinci/vpbe_osd.c b/drivers/media/platform/davinci/vpbe_osd.c
index 66449791c70c..10f2bf11edf3 100644
--- a/drivers/media/platform/davinci/vpbe_osd.c
+++ b/drivers/media/platform/davinci/vpbe_osd.c
@@ -24,8 +24,10 @@
 #include <linux/clk.h>
 #include <linux/slab.h>
 
+#ifdef CONFIG_ARCH_DAVINCI
 #include <mach/cputype.h>
 #include <mach/hardware.h>
+#endif
 
 #include <media/davinci/vpss.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/platform/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
index 3a4e78595149..add72a39ef2d 100644
--- a/drivers/media/platform/davinci/vpbe_venc.c
+++ b/drivers/media/platform/davinci/vpbe_venc.c
@@ -21,8 +21,11 @@
 #include <linux/videodev2.h>
 #include <linux/slab.h>
 
+#ifdef CONFIG_ARCH_DAVINCI
 #include <mach/hardware.h>
 #include <mach/mux.h>
+#endif
+
 #include <linux/platform_data/i2c-davinci.h>
 
 #include <linux/io.h>
-- 
2.14.3
