Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1746 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab0ESDTL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 23:19:11 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 19 May 2010 11:18:47 +0800
Subject: [PATCH v3 10/10] V4L2 ISP driver patchset for Intel Moorestown
 Camera Imaging Subsystem
Message-ID: <33AB447FBD802F4E932063B962385B351E895DAC@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From e81476bafd59afd7cc3474f7003e331fc4303e96 Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Tue, 18 May 2010 15:53:41 +0800
Subject: [PATCH 10/10] This patch is a part of v4l2 ISP patchset for Intel Moorestown camera imaging
 subsystem support which contain the chagne in the build system.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/media/video/mrstisp/Kconfig  |   24 ++++++++++++++++++++++++
 drivers/media/video/mrstisp/Makefile |    6 ++++++
 2 files changed, 30 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstisp/Kconfig
 create mode 100644 drivers/media/video/mrstisp/Makefile

diff --git a/drivers/media/video/mrstisp/Kconfig b/drivers/media/video/mrstisp/Kconfig
new file mode 100644
index 0000000..64f257c
--- /dev/null
+++ b/drivers/media/video/mrstisp/Kconfig
@@ -0,0 +1,24 @@
+config VIDEO_MRSTCI
+	tristate "Intel Moorestown CMOS Camera Controller support"
+	depends on PCI && I2C && VIDEO_V4L2
+	select VIDEOBUF_DMA_CONTIG
+	select VIDEO_OV2650
+	select VIDEO_OV5630
+	select VIDEO_OV9665
+	select VIDEO_S5K4E1
+	select VIDEO_OV5630_MOTOR
+	select VIDEO_S5K4E1_MOTOR
+	default y
+	---help---
+	  This is a video4linux2 driver for the Intel Atom (Moorestown)
+	  CMOS camera controller.
+
+config VIDEO_MRSTISP
+	tristate "Intel Moorestown ISP Controller support"
+	depends on VIDEO_MRSTCI
+	default y
+	---help---
+	  This is a video4linux2 driver for the Intel Atom (Moorestown)
+	  CMOS camera controller.
+	  To compile this driver as a module, choose M here: the
+	  module will be called mrstisp.ko.
diff --git a/drivers/media/video/mrstisp/Makefile b/drivers/media/video/mrstisp/Makefile
new file mode 100644
index 0000000..1511922
--- /dev/null
+++ b/drivers/media/video/mrstisp/Makefile
@@ -0,0 +1,6 @@
+mrstisp-objs	:= mrstisp_main.o mrstisp_hw.o mrstisp_isp.o	\
+                mrstisp_dp.o mrstisp_mif.o mrstisp_jpe.o	\
+		__mrstisp_private_ioctl.o
+
+obj-$(CONFIG_VIDEO_MRSTISP)	 	 += mrstisp.o
+EXTRA_CFLAGS	+=	 -I$(src)/include
-- 
1.6.3.2

