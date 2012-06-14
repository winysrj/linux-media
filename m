Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505Ab2FNUix (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 16:38:53 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5EKcqk0027621
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 16:38:52 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 01/10] [media] v4l: move v4l2 core into a separate directory
Date: Thu, 14 Jun 2012 17:35:52 -0300
Message-Id: <1339706161-22713-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
References: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, the v4l2 core is mixed together with other non-core drivers.
Move them into a separate directory.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig                              |    1 +
 drivers/media/Makefile                             |    2 +-
 drivers/media/v4l2-core/Kconfig                    |   60 ++++++++++++++++++++
 drivers/media/v4l2-core/Makefile                   |   35 ++++++++++++
 drivers/media/{video => v4l2-core}/tuner-core.c    |    0
 drivers/media/{video => v4l2-core}/v4l2-common.c   |    0
 .../{video => v4l2-core}/v4l2-compat-ioctl32.c     |    0
 drivers/media/{video => v4l2-core}/v4l2-ctrls.c    |    0
 drivers/media/{video => v4l2-core}/v4l2-dev.c      |    0
 drivers/media/{video => v4l2-core}/v4l2-device.c   |    0
 drivers/media/{video => v4l2-core}/v4l2-event.c    |    0
 drivers/media/{video => v4l2-core}/v4l2-fh.c       |    0
 .../media/{video => v4l2-core}/v4l2-int-device.c   |    0
 drivers/media/{video => v4l2-core}/v4l2-ioctl.c    |    0
 drivers/media/{video => v4l2-core}/v4l2-mem2mem.c  |    0
 drivers/media/{video => v4l2-core}/v4l2-subdev.c   |    0
 drivers/media/{video => v4l2-core}/videobuf-core.c |    0
 .../{video => v4l2-core}/videobuf-dma-contig.c     |    0
 .../media/{video => v4l2-core}/videobuf-dma-sg.c   |    0
 drivers/media/{video => v4l2-core}/videobuf-dvb.c  |    0
 .../media/{video => v4l2-core}/videobuf-vmalloc.c  |    0
 .../media/{video => v4l2-core}/videobuf2-core.c    |    0
 .../{video => v4l2-core}/videobuf2-dma-contig.c    |    0
 .../media/{video => v4l2-core}/videobuf2-dma-sg.c  |    0
 .../media/{video => v4l2-core}/videobuf2-memops.c  |    0
 .../media/{video => v4l2-core}/videobuf2-vmalloc.c |    0
 drivers/media/video/Kconfig                        |   56 ------------------
 drivers/media/video/Makefile                       |   27 ---------
 28 files changed, 97 insertions(+), 84 deletions(-)
 create mode 100644 drivers/media/v4l2-core/Kconfig
 create mode 100644 drivers/media/v4l2-core/Makefile
 rename drivers/media/{video => v4l2-core}/tuner-core.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-common.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-compat-ioctl32.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-ctrls.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-dev.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-device.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-event.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-fh.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-int-device.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-ioctl.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-mem2mem.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-subdev.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf-core.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf-dma-contig.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf-dma-sg.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf-dvb.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf-vmalloc.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf2-core.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf2-dma-contig.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf2-dma-sg.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf2-memops.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf2-vmalloc.c (100%)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 2f5b395..8bb3b66 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -154,6 +154,7 @@ source "drivers/media/common/tuners/Kconfig"
 # Video/Radio/Hybrid adapters
 #
 
+source "drivers/media/v4l2-core/Kconfig"
 source "drivers/media/video/Kconfig"
 
 source "drivers/media/radio/Kconfig"
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 64755c9..2f9abaa 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -8,7 +8,7 @@ ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
   obj-$(CONFIG_MEDIA_SUPPORT) += media.o
 endif
 
-obj-y += common/ rc/ video/
+obj-y += v4l2-core/ common/ rc/ video/
 
 obj-$(CONFIG_VIDEO_DEV) += radio/
 obj-$(CONFIG_DVB_CORE)  += dvb/
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
new file mode 100644
index 0000000..6f53337
--- /dev/null
+++ b/drivers/media/v4l2-core/Kconfig
@@ -0,0 +1,60 @@
+#
+# Generic video config states
+#
+
+config VIDEO_V4L2
+	tristate
+	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
+	default y
+
+config VIDEOBUF_GEN
+	tristate
+
+config VIDEOBUF_DMA_SG
+	depends on HAS_DMA
+	select VIDEOBUF_GEN
+	tristate
+
+config VIDEOBUF_VMALLOC
+	select VIDEOBUF_GEN
+	tristate
+
+config VIDEOBUF_DMA_CONTIG
+	depends on HAS_DMA
+	select VIDEOBUF_GEN
+	tristate
+
+config VIDEOBUF_DVB
+	tristate
+	select VIDEOBUF_GEN
+
+config VIDEO_TUNER
+	tristate
+	depends on MEDIA_TUNER
+
+config V4L2_MEM2MEM_DEV
+        tristate
+        depends on VIDEOBUF2_CORE
+
+config VIDEOBUF2_CORE
+	tristate
+
+config VIDEOBUF2_MEMOPS
+	tristate
+
+config VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	tristate
+
+config VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	tristate
+
+config VIDEOBUF2_DMA_SG
+	#depends on HAS_DMA
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	tristate
+
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
new file mode 100644
index 0000000..7319c27
--- /dev/null
+++ b/drivers/media/v4l2-core/Makefile
@@ -0,0 +1,35 @@
+#
+# Makefile for the V4L2 core
+#
+
+tuner-objs	:=	tuner-core.o
+
+videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
+			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o
+ifeq ($(CONFIG_COMPAT),y)
+  videodev-objs += v4l2-compat-ioctl32.o
+endif
+
+obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-int-device.o
+obj-$(CONFIG_VIDEO_V4L2_COMMON) += v4l2-common.o
+
+obj-$(CONFIG_VIDEO_TUNER) += tuner.o
+
+obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
+
+obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
+obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
+obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
+obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
+obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
+
+obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-core.o
+obj-$(CONFIG_VIDEOBUF2_MEMOPS) += videobuf2-memops.o
+obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
+obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
+obj-$(CONFIG_VIDEOBUF2_DMA_SG) += videobuf2-dma-sg.o
+
+ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
+ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
+ccflags-y += -I$(srctree)/drivers/media/common/tuners
+
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
similarity index 100%
rename from drivers/media/video/tuner-core.c
rename to drivers/media/v4l2-core/tuner-core.c
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
similarity index 100%
rename from drivers/media/video/v4l2-common.c
rename to drivers/media/v4l2-core/v4l2-common.c
diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
similarity index 100%
rename from drivers/media/video/v4l2-compat-ioctl32.c
rename to drivers/media/v4l2-core/v4l2-compat-ioctl32.c
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
similarity index 100%
rename from drivers/media/video/v4l2-ctrls.c
rename to drivers/media/v4l2-core/v4l2-ctrls.c
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
similarity index 100%
rename from drivers/media/video/v4l2-dev.c
rename to drivers/media/v4l2-core/v4l2-dev.c
diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
similarity index 100%
rename from drivers/media/video/v4l2-device.c
rename to drivers/media/v4l2-core/v4l2-device.c
diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
similarity index 100%
rename from drivers/media/video/v4l2-event.c
rename to drivers/media/v4l2-core/v4l2-event.c
diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
similarity index 100%
rename from drivers/media/video/v4l2-fh.c
rename to drivers/media/v4l2-core/v4l2-fh.c
diff --git a/drivers/media/video/v4l2-int-device.c b/drivers/media/v4l2-core/v4l2-int-device.c
similarity index 100%
rename from drivers/media/video/v4l2-int-device.c
rename to drivers/media/v4l2-core/v4l2-int-device.c
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
similarity index 100%
rename from drivers/media/video/v4l2-ioctl.c
rename to drivers/media/v4l2-core/v4l2-ioctl.c
diff --git a/drivers/media/video/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
similarity index 100%
rename from drivers/media/video/v4l2-mem2mem.c
rename to drivers/media/v4l2-core/v4l2-mem2mem.c
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
similarity index 100%
rename from drivers/media/video/v4l2-subdev.c
rename to drivers/media/v4l2-core/v4l2-subdev.c
diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/v4l2-core/videobuf-core.c
similarity index 100%
rename from drivers/media/video/videobuf-core.c
rename to drivers/media/v4l2-core/videobuf-core.c
diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
similarity index 100%
rename from drivers/media/video/videobuf-dma-contig.c
rename to drivers/media/v4l2-core/videobuf-dma-contig.c
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
similarity index 100%
rename from drivers/media/video/videobuf-dma-sg.c
rename to drivers/media/v4l2-core/videobuf-dma-sg.c
diff --git a/drivers/media/video/videobuf-dvb.c b/drivers/media/v4l2-core/videobuf-dvb.c
similarity index 100%
rename from drivers/media/video/videobuf-dvb.c
rename to drivers/media/v4l2-core/videobuf-dvb.c
diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/v4l2-core/videobuf-vmalloc.c
similarity index 100%
rename from drivers/media/video/videobuf-vmalloc.c
rename to drivers/media/v4l2-core/videobuf-vmalloc.c
diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
similarity index 100%
rename from drivers/media/video/videobuf2-core.c
rename to drivers/media/v4l2-core/videobuf2-core.c
diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
similarity index 100%
rename from drivers/media/video/videobuf2-dma-contig.c
rename to drivers/media/v4l2-core/videobuf2-dma-contig.c
diff --git a/drivers/media/video/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
similarity index 100%
rename from drivers/media/video/videobuf2-dma-sg.c
rename to drivers/media/v4l2-core/videobuf2-dma-sg.c
diff --git a/drivers/media/video/videobuf2-memops.c b/drivers/media/v4l2-core/videobuf2-memops.c
similarity index 100%
rename from drivers/media/video/videobuf2-memops.c
rename to drivers/media/v4l2-core/videobuf2-memops.c
diff --git a/drivers/media/video/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
similarity index 100%
rename from drivers/media/video/videobuf2-vmalloc.c
rename to drivers/media/v4l2-core/videobuf2-vmalloc.c
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index c3ef5e4..2d51f52 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -2,32 +2,6 @@
 # Generic video config states
 #
 
-config VIDEO_V4L2
-	tristate
-	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
-	default y
-
-config VIDEOBUF_GEN
-	tristate
-
-config VIDEOBUF_DMA_SG
-	depends on HAS_DMA
-	select VIDEOBUF_GEN
-	tristate
-
-config VIDEOBUF_VMALLOC
-	select VIDEOBUF_GEN
-	tristate
-
-config VIDEOBUF_DMA_CONTIG
-	depends on HAS_DMA
-	select VIDEOBUF_GEN
-	tristate
-
-config VIDEOBUF_DVB
-	tristate
-	select VIDEOBUF_GEN
-
 config VIDEO_BTCX
 	depends on PCI
 	tristate
@@ -36,36 +10,6 @@ config VIDEO_TVEEPROM
 	tristate
 	depends on I2C
 
-config VIDEO_TUNER
-	tristate
-	depends on MEDIA_TUNER
-
-config V4L2_MEM2MEM_DEV
-	tristate
-	depends on VIDEOBUF2_CORE
-
-config VIDEOBUF2_CORE
-	tristate
-
-config VIDEOBUF2_MEMOPS
-	tristate
-
-config VIDEOBUF2_DMA_CONTIG
-	select VIDEOBUF2_CORE
-	select VIDEOBUF2_MEMOPS
-	tristate
-
-config VIDEOBUF2_VMALLOC
-	select VIDEOBUF2_CORE
-	select VIDEOBUF2_MEMOPS
-	tristate
-
-
-config VIDEOBUF2_DMA_SG
-	#depends on HAS_DMA
-	select VIDEOBUF2_CORE
-	select VIDEOBUF2_MEMOPS
-	tristate
 #
 # Multimedia Video device configuration
 #
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index d209de0..088d834 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -2,32 +2,18 @@
 # Makefile for the video capture/playback device drivers.
 #
 
-tuner-objs	:=	tuner-core.o
-
 msp3400-objs	:=	msp3400-driver.o msp3400-kthreads.o
 
 stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
 
 omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
-videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
-			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o
-ifeq ($(CONFIG_COMPAT),y)
-  videodev-objs += v4l2-compat-ioctl32.o
-endif
-
-# V4L2 core modules
-
-obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-int-device.o
-obj-$(CONFIG_VIDEO_V4L2_COMMON) += v4l2-common.o
-
 # Helper modules
 
 obj-$(CONFIG_VIDEO_APTINA_PLL) += aptina-pll.o
 
 # All i2c modules must come first:
 
-obj-$(CONFIG_VIDEO_TUNER) += tuner.o
 obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
 obj-$(CONFIG_VIDEO_TDA7432) += tda7432.o
 obj-$(CONFIG_VIDEO_SAA6588) += saa6588.o
@@ -126,21 +112,8 @@ obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
 obj-$(CONFIG_STA2X11_VIP) += sta2x11_vip.o
 obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
 
-obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
-obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
-obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
-obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
-obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
 obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
 
-obj-$(CONFIG_VIDEOBUF2_CORE)		+= videobuf2-core.o
-obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
-obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2-vmalloc.o
-obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG)	+= videobuf2-dma-contig.o
-obj-$(CONFIG_VIDEOBUF2_DMA_SG)		+= videobuf2-dma-sg.o
-
-obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
-
 obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
 
 obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
-- 
1.7.10.2

