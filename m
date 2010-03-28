Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63559 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab0C1HsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 03:48:15 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Zhu, Daniel" <daniel.zhu@intel.com>,
	"Yu, Jinlu" <jinlu.yu@intel.com>,
	"Wang, Wen W" <wen.w.wang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>,
	"Ba, Zheng" <zheng.ba@intel.com>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Date: Sun, 28 Mar 2010 15:48:11 +0800
Subject: [PATCH v2 10/10] V4L2 patches for Intel Moorestown Camera Imaging
 Drivers
Message-ID: <33AB447FBD802F4E932063B962385B351D6D5354@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 166299cfa17bb5e16613eff962cce841d2c15f0f Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Sun, 28 Mar 2010 14:19:12 +0800
Subject: [PATCH 10/10] this patch is the make/kconfig files changes to enable the camera drivers for
 intel moorestown platform.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/media/video/Kconfig         |    1 +
 drivers/media/video/Makefile        |    9 +++++++++
 drivers/media/video/mrstci/Kconfig  |   26 ++++++++++++++++++++++++++
 drivers/media/video/mrstci/Makefile |    8 ++++++++
 4 files changed, 44 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstci/Kconfig
 create mode 100644 drivers/media/video/mrstci/Makefile

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index dcf9fa9..1b3726f 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -954,4 +954,5 @@ config USB_S2255
 	  This driver can be compiled as a module, called s2255drv.
 
 endif # V4L_USB_DRIVERS
+source "drivers/media/video/mrstci/Kconfig"
 endif # VIDEO_CAPTURE_DRIVERS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 9f2e321..6a4b5ff 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -160,6 +160,15 @@ obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
 
 obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
 
+obj-$(CONFIG_VIDEO_MRST_OV2650) += mrstci/mrstov2650/
+obj-$(CONFIG_VIDEO_MRST_OV5630) += mrstci/mrstov5630/
+obj-$(CONFIG_VIDEO_MRST_OV5630_MOTOR) += mrstci/mrstov5630_motor/
+obj-$(CONFIG_VIDEO_MRST_S5K4E1) += mrstci/mrsts5k4e1/
+obj-$(CONFIG_VIDEO_MRST_S5K4E1_MOTOR) += mrstci/mrsts5k4e1_motor/
+obj-$(CONFIG_VIDEO_MRST_OV9665) += mrstci/mrstov9665/
+obj-$(CONFIG_VIDEO_MRST_FLASH) += mrstci/mrstflash/
+obj-$(CONFIG_VIDEO_MRST_ISP) += mrstci/mrstisp/
+
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
diff --git a/drivers/media/video/mrstci/Kconfig b/drivers/media/video/mrstci/Kconfig
new file mode 100644
index 0000000..9ac7065
--- /dev/null
+++ b/drivers/media/video/mrstci/Kconfig
@@ -0,0 +1,26 @@
+menuconfig VIDEO_MRSTCI
+        bool "Moorestown Langwell Camera Imaging Subsystem support"
+        depends on VIDEO_V4L2
+        default y
+
+        ---help---
+	Say Y here to enable selecting the Intel Moorestown Langwell Camera Imaging Subsystem for webcams.
+
+if VIDEO_MRSTCI && VIDEO_V4L2
+
+source "drivers/media/video/mrstci/mrstisp/Kconfig"
+
+source "drivers/media/video/mrstci/mrstov5630/Kconfig"
+source "drivers/media/video/mrstci/mrstov5630_motor/Kconfig"
+
+source "drivers/media/video/mrstci/mrsts5k4e1/Kconfig"
+source "drivers/media/video/mrstci/mrsts5k4e1_motor/Kconfig"
+
+source "drivers/media/video/mrstci/mrstflash/Kconfig"
+
+source "drivers/media/video/mrstci/mrstov2650/Kconfig"
+
+source "drivers/media/video/mrstci/mrstov9665/Kconfig"
+
+endif # VIDEO_MRSTCI
+
diff --git a/drivers/media/video/mrstci/Makefile b/drivers/media/video/mrstci/Makefile
new file mode 100644
index 0000000..9d3449e
--- /dev/null
+++ b/drivers/media/video/mrstci/Makefile
@@ -0,0 +1,8 @@
+obj-$(CONFIG_VIDEO_MRST_OV2650) += mrstov2650/
+obj-$(CONFIG_VIDEO_MRST_OV9665) += mrstov9665/
+obj-$(CONFIG_VIDEO_MRST_OV5630) += mrstov5630/
+obj-$(CONFIG_VIDEO_MRST_OV5630_MOTOR) += mrstov5630_motor/
+obj-$(CONFIG_VIDEO_MRST_S5K4E1) += mrsts5k4e1/
+obj-$(CONFIG_VIDEO_MRST_S5K4E1_MOTOR) += mrsts5k4e1_motor/
+obj-$(CONFIG_VIDEO_MRST_FLASH) += mrstflash/
+obj-$(CONFIG_VIDEO_MRST_ISP) += mrstisp/
-- 
1.6.3.2

