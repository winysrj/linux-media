Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47298 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753062AbdLUQSY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 11:18:24 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 06/11] media: move videobuf2 to drivers/media/common
Date: Thu, 21 Dec 2017 14:18:05 -0200
Message-Id: <f5d98a737941ccc776fd5c89ccb8c2c0d2e1014c.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that VB2 is used by both V4L2 and DVB core, move it to
the common part of the subsystem.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/Kconfig                       |  1 +
 drivers/media/common/Makefile                      |  2 +-
 drivers/media/common/videobuf/Kconfig              | 31 +++++++++++++++++++++
 drivers/media/common/videobuf/Makefile             |  7 +++++
 .../videobuf}/videobuf2-core.c                     |  0
 .../videobuf}/videobuf2-dma-contig.c               |  0
 .../videobuf}/videobuf2-dma-sg.c                   |  0
 .../{v4l2-core => common/videobuf}/videobuf2-dvb.c |  0
 .../videobuf}/videobuf2-memops.c                   |  0
 .../videobuf}/videobuf2-v4l2.c                     |  0
 .../videobuf}/videobuf2-vmalloc.c                  |  0
 drivers/media/v4l2-core/Kconfig                    | 32 ----------------------
 drivers/media/v4l2-core/Makefile                   |  7 -----
 13 files changed, 40 insertions(+), 40 deletions(-)
 create mode 100644 drivers/media/common/videobuf/Kconfig
 create mode 100644 drivers/media/common/videobuf/Makefile
 rename drivers/media/{v4l2-core => common/videobuf}/videobuf2-core.c (100%)
 rename drivers/media/{v4l2-core => common/videobuf}/videobuf2-dma-contig.c (100%)
 rename drivers/media/{v4l2-core => common/videobuf}/videobuf2-dma-sg.c (100%)
 rename drivers/media/{v4l2-core => common/videobuf}/videobuf2-dvb.c (100%)
 rename drivers/media/{v4l2-core => common/videobuf}/videobuf2-memops.c (100%)
 rename drivers/media/{v4l2-core => common/videobuf}/videobuf2-v4l2.c (100%)
 rename drivers/media/{v4l2-core => common/videobuf}/videobuf2-vmalloc.c (100%)

diff --git a/drivers/media/common/Kconfig b/drivers/media/common/Kconfig
index 326df0ad75c0..cdfc905967dc 100644
--- a/drivers/media/common/Kconfig
+++ b/drivers/media/common/Kconfig
@@ -16,6 +16,7 @@ config CYPRESS_FIRMWARE
 	tristate "Cypress firmware helper routines"
 	depends on USB
 
+source "drivers/media/common/videobuf/Kconfig"
 source "drivers/media/common/b2c2/Kconfig"
 source "drivers/media/common/saa7146/Kconfig"
 source "drivers/media/common/siano/Kconfig"
diff --git a/drivers/media/common/Makefile b/drivers/media/common/Makefile
index 2d1b0a025084..f24b5ed39982 100644
--- a/drivers/media/common/Makefile
+++ b/drivers/media/common/Makefile
@@ -1,4 +1,4 @@
-obj-y += b2c2/ saa7146/ siano/ v4l2-tpg/
+obj-y += b2c2/ saa7146/ siano/ v4l2-tpg/ videobuf/
 obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
 obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
 obj-$(CONFIG_CYPRESS_FIRMWARE) += cypress_firmware.o
diff --git a/drivers/media/common/videobuf/Kconfig b/drivers/media/common/videobuf/Kconfig
new file mode 100644
index 000000000000..5df05250de94
--- /dev/null
+++ b/drivers/media/common/videobuf/Kconfig
@@ -0,0 +1,31 @@
+# Used by drivers that need Videobuf2 modules
+config VIDEOBUF2_CORE
+	select DMA_SHARED_BUFFER
+	tristate
+
+config VIDEOBUF2_MEMOPS
+	tristate
+	select FRAME_VECTOR
+
+config VIDEOBUF2_DMA_CONTIG
+	tristate
+	depends on HAS_DMA
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	select DMA_SHARED_BUFFER
+
+config VIDEOBUF2_VMALLOC
+	tristate
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	select DMA_SHARED_BUFFER
+
+config VIDEOBUF2_DMA_SG
+	tristate
+	depends on HAS_DMA
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+
+config VIDEOBUF2_DVB
+	tristate
+	select VIDEOBUF2_CORE
diff --git a/drivers/media/common/videobuf/Makefile b/drivers/media/common/videobuf/Makefile
new file mode 100644
index 000000000000..19de5ccda20b
--- /dev/null
+++ b/drivers/media/common/videobuf/Makefile
@@ -0,0 +1,7 @@
+
+obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-core.o videobuf2-v4l2.o
+obj-$(CONFIG_VIDEOBUF2_MEMOPS) += videobuf2-memops.o
+obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
+obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
+obj-$(CONFIG_VIDEOBUF2_DMA_SG) += videobuf2-dma-sg.o
+obj-$(CONFIG_VIDEOBUF2_DVB) += videobuf2-dvb.o
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/common/videobuf/videobuf2-core.c
similarity index 100%
rename from drivers/media/v4l2-core/videobuf2-core.c
rename to drivers/media/common/videobuf/videobuf2-core.c
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/common/videobuf/videobuf2-dma-contig.c
similarity index 100%
rename from drivers/media/v4l2-core/videobuf2-dma-contig.c
rename to drivers/media/common/videobuf/videobuf2-dma-contig.c
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/common/videobuf/videobuf2-dma-sg.c
similarity index 100%
rename from drivers/media/v4l2-core/videobuf2-dma-sg.c
rename to drivers/media/common/videobuf/videobuf2-dma-sg.c
diff --git a/drivers/media/v4l2-core/videobuf2-dvb.c b/drivers/media/common/videobuf/videobuf2-dvb.c
similarity index 100%
rename from drivers/media/v4l2-core/videobuf2-dvb.c
rename to drivers/media/common/videobuf/videobuf2-dvb.c
diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/common/videobuf/videobuf2-memops.c
similarity index 100%
rename from drivers/media/v4l2-core/videobuf2-memops.c
rename to drivers/media/common/videobuf/videobuf2-memops.c
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/common/videobuf/videobuf2-v4l2.c
similarity index 100%
rename from drivers/media/v4l2-core/videobuf2-v4l2.c
rename to drivers/media/common/videobuf/videobuf2-v4l2.c
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/common/videobuf/videobuf2-vmalloc.c
similarity index 100%
rename from drivers/media/v4l2-core/videobuf2-vmalloc.c
rename to drivers/media/common/videobuf/videobuf2-vmalloc.c
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index a35c33686abf..fbcb275e867b 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -79,35 +79,3 @@ config VIDEOBUF_DMA_CONTIG
 config VIDEOBUF_DVB
 	tristate
 	select VIDEOBUF_GEN
-
-# Used by drivers that need Videobuf2 modules
-config VIDEOBUF2_CORE
-	select DMA_SHARED_BUFFER
-	tristate
-
-config VIDEOBUF2_MEMOPS
-	tristate
-	select FRAME_VECTOR
-
-config VIDEOBUF2_DMA_CONTIG
-	tristate
-	depends on HAS_DMA
-	select VIDEOBUF2_CORE
-	select VIDEOBUF2_MEMOPS
-	select DMA_SHARED_BUFFER
-
-config VIDEOBUF2_VMALLOC
-	tristate
-	select VIDEOBUF2_CORE
-	select VIDEOBUF2_MEMOPS
-	select DMA_SHARED_BUFFER
-
-config VIDEOBUF2_DMA_SG
-	tristate
-	depends on HAS_DMA
-	select VIDEOBUF2_CORE
-	select VIDEOBUF2_MEMOPS
-
-config VIDEOBUF2_DVB
-	tristate
-	select VIDEOBUF2_CORE
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 77303286aef7..1618ce984674 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -33,13 +33,6 @@ obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
 obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
 obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
 
-obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-core.o videobuf2-v4l2.o
-obj-$(CONFIG_VIDEOBUF2_MEMOPS) += videobuf2-memops.o
-obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
-obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
-obj-$(CONFIG_VIDEOBUF2_DMA_SG) += videobuf2-dma-sg.o
-obj-$(CONFIG_VIDEOBUF2_DVB) += videobuf2-dvb.o
-
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 ccflags-y += -I$(srctree)/drivers/media/tuners
-- 
2.14.3
