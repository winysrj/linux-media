Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3883 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758562Ab1I3MUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 08:20:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 1/7] V4L menu: move USB drivers section to the top.
Date: Fri, 30 Sep 2011 14:18:28 +0200
Message-Id: <9198dc44ea6f7b8e481c8e6bb24c80fc1b2429ed.1317384926.git.hans.verkuil@cisco.com>
In-Reply-To: <1317385114-7475-1-git-send-email-hverkuil@xs4all.nl>
References: <1317385114-7475-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

USB webcams are some of the most used V4L devices, so move it to a more
prominent place in the menu instead of being at the end.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/Kconfig |  145 ++++++++++++++++++++++---------------------
 1 files changed, 73 insertions(+), 72 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index aed5b3d..0f8ccb4 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -573,6 +573,79 @@ config VIDEO_M52790
 
 endmenu # encoder / decoder chips
 
+#
+# USB Multimedia device configuration
+#
+
+menuconfig V4L_USB_DRIVERS
+	bool "V4L USB devices"
+	depends on USB
+	default y
+
+if V4L_USB_DRIVERS && USB
+
+source "drivers/media/video/uvc/Kconfig"
+
+source "drivers/media/video/gspca/Kconfig"
+
+source "drivers/media/video/pvrusb2/Kconfig"
+
+source "drivers/media/video/hdpvr/Kconfig"
+
+source "drivers/media/video/em28xx/Kconfig"
+
+source "drivers/media/video/tlg2300/Kconfig"
+
+source "drivers/media/video/cx231xx/Kconfig"
+
+source "drivers/media/video/tm6000/Kconfig"
+
+source "drivers/media/video/usbvision/Kconfig"
+
+source "drivers/media/video/et61x251/Kconfig"
+
+source "drivers/media/video/sn9c102/Kconfig"
+
+source "drivers/media/video/pwc/Kconfig"
+
+config USB_ZR364XX
+	tristate "USB ZR364XX Camera support"
+	depends on VIDEO_V4L2
+	select VIDEOBUF_GEN
+	select VIDEOBUF_VMALLOC
+	---help---
+	  Say Y here if you want to connect this type of camera to your
+	  computer's USB port.
+	  See <file:Documentation/video4linux/zr364xx.txt> for more info
+	  and list of supported cameras.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called zr364xx.
+
+config USB_STKWEBCAM
+	tristate "USB Syntek DC1125 Camera support"
+	depends on VIDEO_V4L2 && EXPERIMENTAL
+	---help---
+	  Say Y here if you want to use this type of camera.
+	  Supported devices are typically found in some Asus laptops,
+	  with USB id 174f:a311 and 05e1:0501. Other Syntek cameras
+	  may be supported by the stk11xx driver, from which this is
+	  derived, see <http://sourceforge.net/projects/syntekdriver/>
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called stkwebcam.
+
+config USB_S2255
+	tristate "USB Sensoray 2255 video capture device"
+	depends on VIDEO_V4L2
+	select VIDEOBUF_VMALLOC
+	default n
+	help
+	  Say Y here if you want support for the Sensoray 2255 USB device.
+	  This driver can be compiled as a module, called s2255drv.
+
+endif # V4L_USB_DRIVERS
+
 config VIDEO_SH_VOU
 	tristate "SuperH VOU video output driver"
 	depends on VIDEO_DEV && ARCH_SHMOBILE
@@ -994,78 +1067,6 @@ config VIDEO_S5P_MIPI_CSIS
 
 source "drivers/media/video/s5p-tv/Kconfig"
 
-#
-# USB Multimedia device configuration
-#
-
-menuconfig V4L_USB_DRIVERS
-	bool "V4L USB devices"
-	depends on USB
-	default y
-
-if V4L_USB_DRIVERS && USB
-
-source "drivers/media/video/uvc/Kconfig"
-
-source "drivers/media/video/gspca/Kconfig"
-
-source "drivers/media/video/pvrusb2/Kconfig"
-
-source "drivers/media/video/hdpvr/Kconfig"
-
-source "drivers/media/video/em28xx/Kconfig"
-
-source "drivers/media/video/tlg2300/Kconfig"
-
-source "drivers/media/video/cx231xx/Kconfig"
-
-source "drivers/media/video/tm6000/Kconfig"
-
-source "drivers/media/video/usbvision/Kconfig"
-
-source "drivers/media/video/et61x251/Kconfig"
-
-source "drivers/media/video/sn9c102/Kconfig"
-
-source "drivers/media/video/pwc/Kconfig"
-
-config USB_ZR364XX
-	tristate "USB ZR364XX Camera support"
-	depends on VIDEO_V4L2
-	select VIDEOBUF_GEN
-	select VIDEOBUF_VMALLOC
-	---help---
-	  Say Y here if you want to connect this type of camera to your
-	  computer's USB port.
-	  See <file:Documentation/video4linux/zr364xx.txt> for more info
-	  and list of supported cameras.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called zr364xx.
-
-config USB_STKWEBCAM
-	tristate "USB Syntek DC1125 Camera support"
-	depends on VIDEO_V4L2 && EXPERIMENTAL
-	---help---
-	  Say Y here if you want to use this type of camera.
-	  Supported devices are typically found in some Asus laptops,
-	  with USB id 174f:a311 and 05e1:0501. Other Syntek cameras
-	  may be supported by the stk11xx driver, from which this is
-	  derived, see <http://sourceforge.net/projects/syntekdriver/>
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called stkwebcam.
-
-config USB_S2255
-	tristate "USB Sensoray 2255 video capture device"
-	depends on VIDEO_V4L2
-	select VIDEOBUF_VMALLOC
-	default n
-	help
-	  Say Y here if you want support for the Sensoray 2255 USB device.
-	  This driver can be compiled as a module, called s2255drv.
-
-endif # V4L_USB_DRIVERS
 endif # VIDEO_CAPTURE_DRIVERS
 
 menuconfig V4L_MEM2MEM_DRIVERS
-- 
1.7.6.3

