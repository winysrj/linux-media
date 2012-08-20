Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab2HTSWT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 14:22:19 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7KIMJ41029979
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 20 Aug 2012 14:22:19 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/6] [media] Cleanup media Kconfig files
Date: Mon, 20 Aug 2012 15:22:13 -0300
Message-Id: <1345486935-18002-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1345486935-18002-1-git-send-email-mchehab@redhat.com>
References: <1345486935-18002-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- get rid of ridden V4L2_COMMON symbol

  This symbol is not needed anymore; it can be folded with V4L2
  one, simplifying the Kconfig a little bit;

- Comment why some Kconfig items are needed;

- Remove if test for MEDIA_CAMERA_SUPPORT, replacing it by
  depends on.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig            |  5 -----
 drivers/media/i2c/Kconfig        |  2 +-
 drivers/media/platform/Kconfig   |  6 ++----
 drivers/media/v4l2-core/Kconfig  | 27 ++++++++++++++++-----------
 drivers/media/v4l2-core/Makefile |  2 +-
 5 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index d5b4e72..9c3698a 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -99,11 +99,6 @@ config VIDEO_DEV
 	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT
 	default y
 
-config VIDEO_V4L2_COMMON
-	tristate
-	depends on (I2C || I2C=n) && VIDEO_DEV
-	default (I2C || I2C=n) && VIDEO_DEV
-
 config VIDEO_V4L2_SUBDEV_API
 	bool "V4L2 sub-device userspace API (EXPERIMENTAL)"
 	depends on VIDEO_DEV && MEDIA_CONTROLLER && EXPERIMENTAL
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 7fe4acf..ad2c9de 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -322,7 +322,7 @@ comment "MPEG video encoders"
 
 config VIDEO_CX2341X
 	tristate "Conexant CX2341x MPEG encoders"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_COMMON
+	depends on VIDEO_V4L2 && VIDEO_V4L2
 	---help---
 	  Support for the Conexant CX23416 MPEG encoders
 	  and CX23415 MPEG encoder/decoders.
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 54e9ebb..03ae4e3 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -1,5 +1,3 @@
-if MEDIA_CAMERA_SUPPORT
-
 #
 # Platform drivers
 #	All drivers here are currently for webcam support
@@ -37,6 +35,7 @@ source "drivers/media/platform/blackfin/Kconfig"
 
 config VIDEO_SH_VOU
 	tristate "SuperH VOU video output driver"
+	depends on MEDIA_CAMERA_SUPPORT
 	depends on VIDEO_DEV && ARCH_SHMOBILE
 	select VIDEOBUF_DMA_CONTIG
 	help
@@ -112,6 +111,7 @@ endif # V4L_PLATFORM_DRIVERS
 menuconfig V4L_MEM2MEM_DRIVERS
 	bool "Memory-to-memory multimedia devices"
 	depends on VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
 	default n
 	---help---
 	  Say Y here to enable selecting drivers for V4L devices that
@@ -205,5 +205,3 @@ config VIDEO_MEM2MEM_TESTDEV
 	  This is a virtual test device for the memory-to-memory driver
 	  framework.
 endif #V4L_TEST_DRIVERS
-
-endif # MEDIA_CAMERA_SUPPORT
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 05e530c..0c54e19 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -2,6 +2,12 @@
 # Generic video config states
 #
 
+# Enable the V4L2 core and API
+config VIDEO_V4L2
+	tristate
+	depends on (I2C || I2C=n) && VIDEO_DEV
+	default (I2C || I2C=n) && VIDEO_DEV
+
 config VIDEO_ADV_DEBUG
 	bool "Enable advanced debug functionality on V4L2 drivers"
 	default n
@@ -19,11 +25,17 @@ config VIDEO_FIXED_MINOR_RANGES
 
 	  When in doubt, say N.
 
-config VIDEO_V4L2
+# Used by drivers that need tuner.ko
+config VIDEO_TUNER
 	tristate
-	depends on VIDEO_V4L2_COMMON
-	default y
+	depends on MEDIA_TUNER
+
+# Used by drivers that need v4l2-mem2mem.ko
+config V4L2_MEM2MEM_DEV
+        tristate
+        depends on VIDEOBUF2_CORE
 
+# Used by drivers that need Videobuf modules
 config VIDEOBUF_GEN
 	tristate
 
@@ -45,14 +57,7 @@ config VIDEOBUF_DVB
 	tristate
 	select VIDEOBUF_GEN
 
-config VIDEO_TUNER
-	tristate
-	depends on MEDIA_TUNER
-
-config V4L2_MEM2MEM_DEV
-        tristate
-        depends on VIDEOBUF2_CORE
-
+# Used by drivers that need Videobuf2 modules
 config VIDEOBUF2_CORE
 	tristate
 
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index c0e90bc..c2d61d4 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -11,7 +11,7 @@ ifeq ($(CONFIG_COMPAT),y)
 endif
 
 obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-int-device.o
-obj-$(CONFIG_VIDEO_V4L2_COMMON) += v4l2-common.o
+obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
 
 obj-$(CONFIG_VIDEO_TUNER) += tuner.o
 
-- 
1.7.11.4

