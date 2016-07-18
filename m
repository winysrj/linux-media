Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45854 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbcGRB4a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 18/36] [media] doc-rst: add documentation for fimc driver
Date: Sun, 17 Jul 2016 22:56:01 -0300
Message-Id: <f0726e4275c169c17238328df9648bea95622879.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the document to rst and add it to the v4l-drivers
book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/fimc.rst  | 95 +++++++++++++++++++------------
 Documentation/media/v4l-drivers/index.rst |  1 +
 2 files changed, 60 insertions(+), 36 deletions(-)

diff --git a/Documentation/media/v4l-drivers/fimc.rst b/Documentation/media/v4l-drivers/fimc.rst
index 4fab231be52e..d9f950d90eb5 100644
--- a/Documentation/media/v4l-drivers/fimc.rst
+++ b/Documentation/media/v4l-drivers/fimc.rst
@@ -1,7 +1,9 @@
-Samsung S5P/EXYNOS4 FIMC driver
+.. include:: <isonum.txt>
 
-Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
----------------------------------------------------------------------------
+The Samsung S5P/EXYNOS4 FIMC driver
+===================================
+
+Copyright |copy| 2012 - 2013 Samsung Electronics Co., Ltd.
 
 The FIMC (Fully Interactive Mobile Camera) device available in Samsung
 SoC Application Processors is an integrated camera host interface, color
@@ -12,50 +14,53 @@ slightly different capabilities, like pixel alignment constraints, rotator
 availability, LCD writeback support, etc. The driver is located at
 drivers/media/platform/exynos4-is directory.
 
-1. Supported SoCs
-=================
+Supported SoCs
+--------------
 
 S5PC100 (mem-to-mem only), S5PV210, EXYNOS4210
 
-2. Supported features
-=====================
+Supported features
+------------------
 
- - camera parallel interface capture (ITU-R.BT601/565);
- - camera serial interface capture (MIPI-CSI2);
- - memory-to-memory processing (color space conversion, scaling, mirror
-   and rotation);
- - dynamic pipeline re-configuration at runtime (re-attachment of any FIMC
-   instance to any parallel video input or any MIPI-CSI front-end);
- - runtime PM and system wide suspend/resume
+- camera parallel interface capture (ITU-R.BT601/565);
+- camera serial interface capture (MIPI-CSI2);
+- memory-to-memory processing (color space conversion, scaling, mirror
+  and rotation);
+- dynamic pipeline re-configuration at runtime (re-attachment of any FIMC
+  instance to any parallel video input or any MIPI-CSI front-end);
+- runtime PM and system wide suspend/resume
 
-Not currently supported:
- - LCD writeback input
- - per frame clock gating (mem-to-mem)
+Not currently supported
+-----------------------
 
-3. Files partitioning
-=====================
+- LCD writeback input
+- per frame clock gating (mem-to-mem)
+
+Files partitioning
+------------------
 
 - media device driver
   drivers/media/platform/exynos4-is/media-dev.[ch]
 
- - camera capture video device driver
+- camera capture video device driver
   drivers/media/platform/exynos4-is/fimc-capture.c
 
- - MIPI-CSI2 receiver subdev
+- MIPI-CSI2 receiver subdev
   drivers/media/platform/exynos4-is/mipi-csis.[ch]
 
- - video post-processor (mem-to-mem)
+- video post-processor (mem-to-mem)
   drivers/media/platform/exynos4-is/fimc-core.c
 
- - common files
+- common files
   drivers/media/platform/exynos4-is/fimc-core.h
   drivers/media/platform/exynos4-is/fimc-reg.h
   drivers/media/platform/exynos4-is/regs-fimc.h
 
-4. User space interfaces
-========================
+User space interfaces
+---------------------
 
-4.1. Media device interface
+Media device interface
+~~~~~~~~~~~~~~~~~~~~~~
 
 The driver supports Media Controller API as defined at
 https://linuxtv.org/downloads/v4l-dvb-apis/media_common.html
@@ -72,7 +77,8 @@ Reconfiguration is done by enabling/disabling media links created by the driver
 during initialization. The internal device topology can be easily discovered
 through media entity and links enumeration.
 
-4.2. Memory-to-memory video node
+Memory-to-memory video node
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 V4L2 memory-to-memory interface at /dev/video? device node.  This is standalone
 video device, it has no media pads. However please note the mem-to-mem and
@@ -80,7 +86,8 @@ capture video node operation on same FIMC instance is not allowed.  The driver
 detects such cases but the applications should prevent them to avoid an
 undefined behaviour.
 
-4.3. Capture video node
+Capture video node
+~~~~~~~~~~~~~~~~~~
 
 The driver supports V4L2 Video Capture Interface as defined at:
 https://linuxtv.org/downloads/v4l-dvb-apis/devices.html
@@ -89,13 +96,15 @@ At the capture and mem-to-mem video nodes only the multi-planar API is
 supported. For more details see:
 https://linuxtv.org/downloads/v4l-dvb-apis/planar-apis.html
 
-4.4. Camera capture subdevs
+Camera capture subdevs
+~~~~~~~~~~~~~~~~~~~~~~
 
 Each FIMC instance exports a sub-device node (/dev/v4l-subdev?), a sub-device
 node is also created per each available and enabled at the platform level
 MIPI-CSI receiver device (currently up to two).
 
-4.5. sysfs
+sysfs
+~~~~~
 
 In order to enable more precise camera pipeline control through the sub-device
 API the driver creates a sysfs entry associated with "s5p-fimc-md" platform
@@ -115,15 +124,22 @@ when the last configuration steps at the video node is performed.
 
 For full sub-device control support (subdevs configured at user space before
 starting streaming):
-# echo "sub-dev" > /sys/platform/devices/s5p-fimc-md/subdev_conf_mode
+
+.. code-block:: none
+
+	# echo "sub-dev" > /sys/platform/devices/s5p-fimc-md/subdev_conf_mode
 
 For V4L2 video node control only (subdevs configured internally by the host
 driver):
-# echo "vid-dev" > /sys/platform/devices/s5p-fimc-md/subdev_conf_mode
+
+.. code-block:: none
+
+	# echo "vid-dev" > /sys/platform/devices/s5p-fimc-md/subdev_conf_mode
+
 This is a default option.
 
 5. Device mapping to video and subdev device nodes
-==================================================
+--------------------------------------------------
 
 There are associated two video device nodes with each device instance in
 hardware - video capture and mem-to-mem and additionally a subdev node for
@@ -134,14 +150,21 @@ How to find out which /dev/video? or /dev/v4l-subdev? is assigned to which
 device?
 
 You can either grep through the kernel log to find relevant information, i.e.
-# dmesg | grep -i fimc
+
+.. code-block:: none
+
+	# dmesg | grep -i fimc
+
 (note that udev, if present, might still have rearranged the video nodes),
 
 or retrieve the information from /dev/media? with help of the media-ctl tool:
-# media-ctl -p
+
+.. code-block:: none
+
+	# media-ctl -p
 
 7. Build
-========
+--------
 
 If the driver is built as a loadable kernel module (CONFIG_VIDEO_SAMSUNG_S5P_FIMC=m)
 two modules are created (in addition to the core v4l2 modules): s5p-fimc.ko and
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 1ab7a84de0ff..333f84b9c17e 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -25,4 +25,5 @@ License".
 	cx18
 	cx88
 	davinci-vpbe
+	fimc
 	zr364xx
-- 
2.7.4

