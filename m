Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911Ab2HONsZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 09:48:25 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7FDmOHH027393
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 09:48:25 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/12] [media] move the remaining USB drivers to drivers/media/usb
Date: Wed, 15 Aug 2012 10:48:10 -0300
Message-Id: <1345038500-28734-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1345038500-28734-1-git-send-email-mchehab@redhat.com>
References: <502AC079.50902@gmail.com>
 <1345038500-28734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the 3 remaining usb drivers to their proper space.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 MAINTAINERS                                        |  2 +-
 drivers/media/usb/Kconfig                          |  3 ++
 drivers/media/usb/Makefile                         |  2 +
 drivers/media/usb/s2255/Kconfig                    |  9 ++++
 drivers/media/usb/s2255/Makefile                   |  2 +
 drivers/media/{video => usb/s2255}/s2255drv.c      |  0
 drivers/media/usb/stkwebcam/Kconfig                | 13 ++++++
 drivers/media/usb/stkwebcam/Makefile               |  4 ++
 .../media/{video => usb/stkwebcam}/stk-sensor.c    |  0
 .../media/{video => usb/stkwebcam}/stk-webcam.c    |  0
 .../media/{video => usb/stkwebcam}/stk-webcam.h    |  0
 drivers/media/usb/zr364xx/Kconfig                  | 14 ++++++
 drivers/media/usb/zr364xx/Makefile                 |  2 +
 drivers/media/{video => usb/zr364xx}/zr364xx.c     |  0
 drivers/media/video/Kconfig                        | 50 ----------------------
 drivers/media/video/Makefile                       |  8 ----
 16 files changed, 50 insertions(+), 59 deletions(-)
 create mode 100644 drivers/media/usb/s2255/Kconfig
 create mode 100644 drivers/media/usb/s2255/Makefile
 rename drivers/media/{video => usb/s2255}/s2255drv.c (100%)
 create mode 100644 drivers/media/usb/stkwebcam/Kconfig
 create mode 100644 drivers/media/usb/stkwebcam/Makefile
 rename drivers/media/{video => usb/stkwebcam}/stk-sensor.c (100%)
 rename drivers/media/{video => usb/stkwebcam}/stk-webcam.c (100%)
 rename drivers/media/{video => usb/stkwebcam}/stk-webcam.h (100%)
 create mode 100644 drivers/media/usb/zr364xx/Kconfig
 create mode 100644 drivers/media/usb/zr364xx/Makefile
 rename drivers/media/{video => usb/zr364xx}/zr364xx.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 13fd97f..99a930d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7371,7 +7371,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 W:	http://royale.zerezo.com/zr364xx/
 S:	Maintained
 F:	Documentation/video4linux/zr364xx.txt
-F:	drivers/media/video/zr364xx.c
+F:	drivers/media/usb/zr364xx.c
 
 USER-MODE LINUX (UML)
 M:	Jeff Dike <jdike@addtoit.com>
diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index a1e25ee..069a3c1 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -11,6 +11,9 @@ source "drivers/media/usb/uvc/Kconfig"
 source "drivers/media/usb/gspca/Kconfig"
 source "drivers/media/usb/pwc/Kconfig"
 source "drivers/media/usb/cpia2/Kconfig"
+source "drivers/media/usb/zr364xx/Kconfig"
+source "drivers/media/usb/stkwebcam/Kconfig"
+source "drivers/media/usb/s2255/Kconfig"
 source "drivers/media/usb/sn9c102/Kconfig"
 endif
 
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index 428827a..63e37bb 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -4,6 +4,8 @@
 
 # DVB USB-only drivers
 obj-y := ttusb-dec/ ttusb-budget/ dvb-usb/ dvb-usb-v2/ siano/ b2c2/
+obj-y := zr364xx/ stkwebcam/ s2255/
+
 obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
 obj-$(CONFIG_USB_GSPCA)         += gspca/
 obj-$(CONFIG_USB_PWC)           += pwc/
diff --git a/drivers/media/usb/s2255/Kconfig b/drivers/media/usb/s2255/Kconfig
new file mode 100644
index 0000000..7e8ee1f
--- /dev/null
+++ b/drivers/media/usb/s2255/Kconfig
@@ -0,0 +1,9 @@
+config USB_S2255
+	tristate "USB Sensoray 2255 video capture device"
+	depends on VIDEO_V4L2
+	select VIDEOBUF_VMALLOC
+	default n
+	help
+	  Say Y here if you want support for the Sensoray 2255 USB device.
+	  This driver can be compiled as a module, called s2255drv.
+
diff --git a/drivers/media/usb/s2255/Makefile b/drivers/media/usb/s2255/Makefile
new file mode 100644
index 0000000..197d0bb
--- /dev/null
+++ b/drivers/media/usb/s2255/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_USB_S2255)		+= s2255drv.o
+
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
similarity index 100%
rename from drivers/media/video/s2255drv.c
rename to drivers/media/usb/s2255/s2255drv.c
diff --git a/drivers/media/usb/stkwebcam/Kconfig b/drivers/media/usb/stkwebcam/Kconfig
new file mode 100644
index 0000000..2fb0c2b
--- /dev/null
+++ b/drivers/media/usb/stkwebcam/Kconfig
@@ -0,0 +1,13 @@
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
diff --git a/drivers/media/usb/stkwebcam/Makefile b/drivers/media/usb/stkwebcam/Makefile
new file mode 100644
index 0000000..20ef8a4
--- /dev/null
+++ b/drivers/media/usb/stkwebcam/Makefile
@@ -0,0 +1,4 @@
+stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
+
+obj-$(CONFIG_USB_STKWEBCAM)     += stkwebcam.o
+
diff --git a/drivers/media/video/stk-sensor.c b/drivers/media/usb/stkwebcam/stk-sensor.c
similarity index 100%
rename from drivers/media/video/stk-sensor.c
rename to drivers/media/usb/stkwebcam/stk-sensor.c
diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
similarity index 100%
rename from drivers/media/video/stk-webcam.c
rename to drivers/media/usb/stkwebcam/stk-webcam.c
diff --git a/drivers/media/video/stk-webcam.h b/drivers/media/usb/stkwebcam/stk-webcam.h
similarity index 100%
rename from drivers/media/video/stk-webcam.h
rename to drivers/media/usb/stkwebcam/stk-webcam.h
diff --git a/drivers/media/usb/zr364xx/Kconfig b/drivers/media/usb/zr364xx/Kconfig
new file mode 100644
index 0000000..0f58566
--- /dev/null
+++ b/drivers/media/usb/zr364xx/Kconfig
@@ -0,0 +1,14 @@
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
diff --git a/drivers/media/usb/zr364xx/Makefile b/drivers/media/usb/zr364xx/Makefile
new file mode 100644
index 0000000..a577788
--- /dev/null
+++ b/drivers/media/usb/zr364xx/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_USB_ZR364XX)       += zr364xx.o
+
diff --git a/drivers/media/video/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
similarity index 100%
rename from drivers/media/video/zr364xx.c
rename to drivers/media/usb/zr364xx/zr364xx.c
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 097b17ce..f527992 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -606,56 +606,6 @@ config VIDEO_VIVI
 	  In doubt, say N.
 
 #
-# USB Multimedia device configuration
-#
-
-menuconfig V4L_USB_DRIVERS
-	bool "V4L USB devices"
-	depends on USB
-	default y
-
-if V4L_USB_DRIVERS && MEDIA_CAMERA_SUPPORT
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
-
-endif # V4L_USB_DRIVERS && MEDIA_CAMERA_SUPPORT
-
-#
 # PCI drivers configuration - No devices here are for webcams
 #
 
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index a22a258..4ad5bd9 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -4,8 +4,6 @@
 
 msp3400-objs	:=	msp3400-driver.o msp3400-kthreads.o
 
-stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
-
 omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
 # Helper modules
@@ -119,12 +117,6 @@ obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
 
 obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
 
-obj-$(CONFIG_USB_ZR364XX)       += zr364xx.o
-obj-$(CONFIG_USB_STKWEBCAM)     += stkwebcam.o
-
-
-obj-$(CONFIG_USB_S2255)		+= s2255drv.o
-
 obj-$(CONFIG_VIDEO_IVTV) += ivtv/
 obj-$(CONFIG_VIDEO_CX18) += cx18/
 
-- 
1.7.11.2

