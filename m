Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3MNTwUV015959
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 19:29:58 -0400
Received: from mailrelay007.isp.belgacom.be (mailrelay007.isp.belgacom.be
	[195.238.6.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3MNTcbH016000
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 19:29:38 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-usb@vger.kernel.org, video4linux-list@redhat.com
Date: Wed, 23 Apr 2008 01:37:11 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804230137.12502.laurent.pinchart@skynet.be>
Cc: 
Subject: [PATCH] USB Video Class driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi everybody,

after more than two years of development the Linux UVC driver is mostly ready
to jump the fence and get included in the mainline kernel.

This driver aims to support video input devices compliant with the USB Video
Class specification. This means lots of currently manufactured webcams, and
probably most of the future ones.

I plan to submit the driver through the V4L subsystem, but I'd like it to get
a proper review on both the linux-usb and video4linux mailing lists first.

Given the size of the patch I'm open to any suggestion that would make the
review process easier.

Laurent Pinchart

---
 MAINTAINERS                          |    7 +
 drivers/media/video/Kconfig          |    8 +
 drivers/media/video/Makefile         |    2 +
 drivers/media/video/uvc/Makefile     |    4 +
 drivers/media/video/uvc/uvc_ctrl.c   | 1257 ++++++++++++++++++++++
 drivers/media/video/uvc/uvc_driver.c | 1923 ++++++++++++++++++++++++++++++++++
 drivers/media/video/uvc/uvc_isight.c |  134 +++
 drivers/media/video/uvc/uvc_queue.c  |  455 ++++++++
 drivers/media/video/uvc/uvc_status.c |  208 ++++
 drivers/media/video/uvc/uvc_v4l2.c   | 1100 +++++++++++++++++++
 drivers/media/video/uvc/uvc_video.c  |  925 ++++++++++++++++
 drivers/media/video/uvc/uvcvideo.h   |  788 ++++++++++++++
 12 files changed, 6811 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/uvc/Makefile
 create mode 100644 drivers/media/video/uvc/uvc_ctrl.c
 create mode 100644 drivers/media/video/uvc/uvc_driver.c
 create mode 100644 drivers/media/video/uvc/uvc_isight.c
 create mode 100644 drivers/media/video/uvc/uvc_queue.c
 create mode 100644 drivers/media/video/uvc/uvc_status.c
 create mode 100644 drivers/media/video/uvc/uvc_v4l2.c
 create mode 100644 drivers/media/video/uvc/uvc_video.c
 create mode 100644 drivers/media/video/uvc/uvcvideo.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e467758..51227cb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4165,6 +4165,13 @@ L:	netdev@vger.kernel.org
 W:	http://www.linux-usb.org/usbnet
 S:	Maintained
 
+USB VIDEO CLASS
+P:	Laurent Pinchart
+M:	laurent.pinchart@skynet.be
+L:      linux-uvc-devel@berlios.de
+W:	http://linux-uvc.berlios.de
+S:	Maintained
+
 USB W996[87]CF DRIVER
 P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 1832966..7a91e95 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -730,6 +730,14 @@ menuconfig V4L_USB_DRIVERS
 
 if V4L_USB_DRIVERS && USB
 
+config USB_VIDEO_CLASS
+	tristate "USB Video Class (UVC)"
+	---help---
+	  Support for the USB Video Class (UVC).  Currently only video
+	  input devices, such as webcams, are supported.
+
+	  For more information see: <http://linux-uvc.berlios.de/>
+
 source "drivers/media/video/pvrusb2/Kconfig"
 
 source "drivers/media/video/em28xx/Kconfig"
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 3f209b3..94c47d7 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -135,5 +135,7 @@ obj-$(CONFIG_VIDEO_IVTV) += ivtv/
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 
+obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
+
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/uvc/Makefile b/drivers/media/video/uvc/Makefile
new file mode 100644
index 0000000..34fffc9
--- /dev/null
+++ b/drivers/media/video/uvc/Makefile
@@ -0,0 +1,4 @@
+uvcvideo-objs  := uvc_driver.o uvc_queue.o uvc_v4l2.o uvc_video.o uvc_ctrl.o \
+		  uvc_status.o uvc_isight.o
+obj-$(CONFIG_USB_VIDEO_CLASS) := uvcvideo.o
+
diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
new file mode 100644
index 0000000..eaaa369
--- /dev/null
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -0,0 +1,1257 @@
+/*
+ *      uvc_ctrl.c  --  USB Video Class driver - Controls
+ *
+ *      Copyright (C) 2005-2008
+ *          Laurent Pinchart (laurent.pinchart@skynet.be)
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/usb.h>
+#include <linux/videodev.h>
+#include <linux/vmalloc.h>
+#include <linux/wait.h>
+#include <asm/atomic.h>
+
+#include "uvcvideo.h"
+
+#define UVC_CTRL_NDATA		2
+#define UVC_CTRL_DATA_CURRENT	0
+#define UVC_CTRL_DATA_BACKUP	1
+
+/* ------------------------------------------------------------------------
+ * Control, formats, ...
+ */
+
+static struct uvc_control_info uvc_ctrls[] = {
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_BRIGHTNESS_CONTROL,
+		.index		= 0,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_CONTRAST_CONTROL,
+		.index		= 1,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_HUE_CONTROL,
+		.index		= 2,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_SATURATION_CONTROL,
+		.index		= 3,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_SHARPNESS_CONTROL,
+		.index		= 4,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_GAMMA_CONTROL,
+		.index		= 5,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_BACKLIGHT_COMPENSATION_CONTROL,
+		.index		= 8,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_GAIN_CONTROL,
+		.index		= 9,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_POWER_LINE_FREQUENCY_CONTROL,
+		.index		= 10,
+		.size		= 1,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_HUE_AUTO_CONTROL,
+		.index		= 11,
+		.size		= 1,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
+				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_AE_MODE_CONTROL,
+		.index		= 1,
+		.size		= 1,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
+				| UVC_CONTROL_GET_DEF | UVC_CONTROL_GET_RES
+				| UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_AE_PRIORITY_CONTROL,
+		.index		= 2,
+		.size		= 1,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
+				| UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_EXPOSURE_TIME_ABSOLUTE_CONTROL,
+		.index		= 3,
+		.size		= 4,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_FOCUS_ABSOLUTE_CONTROL,
+		.index		= 5,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_FOCUS_AUTO_CONTROL,
+		.index		= 17,
+		.size		= 1,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
+				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_WHITE_BALANCE_TEMPERATURE_AUTO_CONTROL,
+		.index		= 12,
+		.size		= 1,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
+				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_WHITE_BALANCE_TEMPERATURE_CONTROL,
+		.index		= 6,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_WHITE_BALANCE_COMPONENT_AUTO_CONTROL,
+		.index		= 13,
+		.size		= 1,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
+				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_WHITE_BALANCE_COMPONENT_CONTROL,
+		.index		= 7,
+		.size		= 4,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+	},
+};
+
+static struct uvc_menu_info power_line_frequency_controls[] = {
+	{ 0, "Disabled" },
+	{ 1, "50 Hz" },
+	{ 2, "60 Hz" },
+};
+
+static struct uvc_menu_info exposure_auto_controls[] = {
+	{ 1, "Manual Mode" },
+	{ 2, "Auto Mode" },
+	{ 4, "Shutter Priority Mode" },
+	{ 8, "Aperture Priority Mode" },
+};
+
+static struct uvc_control_mapping uvc_ctrl_mappings[] = {
+	{
+		.id		= V4L2_CID_BRIGHTNESS,
+		.name		= "Brightness",
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_BRIGHTNESS_CONTROL,
+		.size		= 16,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
+	},
+	{
+		.id		= V4L2_CID_CONTRAST,
+		.name		= "Contrast",
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_CONTRAST_CONTROL,
+		.size		= 16,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
+	},
+	{
+		.id		= V4L2_CID_HUE,
+		.name		= "Hue",
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_HUE_CONTROL,
+		.size		= 16,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
+	},
+	{
+		.id		= V4L2_CID_SATURATION,
+		.name		= "Saturation",
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_SATURATION_CONTROL,
+		.size		= 16,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
+	},
+	{
+		.id		= V4L2_CID_SHARPNESS,
+		.name		= "Sharpness",
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_SHARPNESS_CONTROL,
+		.size		= 16,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
+	},
+	{
+		.id		= V4L2_CID_GAMMA,
+		.name		= "Gamma",
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_GAMMA_CONTROL,
+		.size		= 16,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
+	},
+	{
+		.id		= V4L2_CID_BACKLIGHT_COMPENSATION,
+		.name		= "Backlight Compensation",
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_BACKLIGHT_COMPENSATION_CONTROL,
+		.size		= 16,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
+	},
+	{
+		.id		= V4L2_CID_GAIN,
+		.name		= "Gain",
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_GAIN_CONTROL,
+		.size		= 16,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
+	},
+	{
+		.id		= V4L2_CID_POWER_LINE_FREQUENCY,
+		.name		= "Power Line Frequency",
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_POWER_LINE_FREQUENCY_CONTROL,
+		.size		= 2,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
+		.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
+		.menu_info	= power_line_frequency_controls,
+		.menu_count	= ARRAY_SIZE(power_line_frequency_controls),
+	},
+	{
+		.id		= V4L2_CID_HUE_AUTO,
+		.name		= "Hue, Auto",
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_HUE_AUTO_CONTROL,
+		.size		= 1,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
+		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
+	},
+	{
+		.id		= V4L2_CID_EXPOSURE_AUTO,
+		.name		= "Exposure, Auto",
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_AE_MODE_CONTROL,
+		.size		= 4,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
+		.data_type	= UVC_CTRL_DATA_TYPE_BITMASK,
+		.menu_info	= exposure_auto_controls,
+		.menu_count	= ARRAY_SIZE(exposure_auto_controls),
+	},
+	{
+		.id		= V4L2_CID_EXPOSURE_AUTO_PRIORITY,
+		.name		= "Exposure, Auto Priority",
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_AE_PRIORITY_CONTROL,
+		.size		= 1,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
+		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
+	},
+	{
+		.id		= V4L2_CID_EXPOSURE_ABSOLUTE,
+		.name		= "Exposure (Absolute)",
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_EXPOSURE_TIME_ABSOLUTE_CONTROL,
+		.size		= 32,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
+	},
+	{
+		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
+		.name		= "White Balance Temperature, Auto",
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_WHITE_BALANCE_TEMPERATURE_AUTO_CONTROL,
+		.size		= 1,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
+		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
+	},
+	{
+		.id		= V4L2_CID_WHITE_BALANCE_TEMPERATURE,
+		.name		= "White Balance Temperature",
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_WHITE_BALANCE_TEMPERATURE_CONTROL,
+		.size		= 16,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
+	},
+	{
+		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
+		.name		= "White Balance Component, Auto",
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_WHITE_BALANCE_COMPONENT_AUTO_CONTROL,
+		.size		= 1,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
+		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
+	},
+	{
+		.id		= V4L2_CID_BLUE_BALANCE,
+		.name		= "White Balance Blue Component",
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_WHITE_BALANCE_COMPONENT_CONTROL,
+		.size		= 16,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
+	},
+	{
+		.id		= V4L2_CID_RED_BALANCE,
+		.name		= "White Balance Red Component",
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_WHITE_BALANCE_COMPONENT_CONTROL,
+		.size		= 16,
+		.offset		= 16,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
+	},
+	{
+		.id		= V4L2_CID_FOCUS_ABSOLUTE,
+		.name		= "Focus (absolute)",
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_FOCUS_ABSOLUTE_CONTROL,
+		.size		= 16,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
+	},
+	{
+		.id		= V4L2_CID_FOCUS_AUTO,
+		.name		= "Focus, Auto",
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_FOCUS_AUTO_CONTROL,
+		.size		= 1,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
+		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
+	},
+};
+
+/* ------------------------------------------------------------------------
+ * Utility functions
+ */
+
+static inline __u8 *uvc_ctrl_data(struct uvc_control *ctrl, int id)
+{
+	return ctrl->data + id * ctrl->info->size;
+}
+
+static inline int uvc_get_bit(const __u8 *data, int bit)
+{
+	return (data[bit >> 3] >> (bit & 7)) & 1;
+}
+
+/* Extract the bit string specified by mapping->offset and mapping->size
+ * from the little-endian data stored at 'data' and return the result as
+ * a signed 32bit integer. Sign extension will be performed if the mapping
+ * references a signed data type.
+ */
+static __s32 uvc_get_le_value(const __u8 *data,
+	struct uvc_control_mapping *mapping)
+{
+	int bits = mapping->size;
+	int offset = mapping->offset;
+	__s32 value = 0;
+	__u8 mask;
+
+	data += offset / 8;
+	offset &= 7;
+	mask = ((1LL << bits) - 1) << offset;
+
+	for (; bits > 0; data++) {
+		__u8 byte = *data & mask;
+		value |= offset > 0 ? (byte >> offset) : (byte << (-offset));
+		bits -= 8 - (offset > 0 ? offset : 0);
+		offset -= 8;
+		mask = (1 << bits) - 1;
+	}
+
+	/* Sign-extend the value if needed */
+	if (mapping->data_type == UVC_CTRL_DATA_TYPE_SIGNED)
+		value |= -(value & (1 << (mapping->size - 1)));
+
+	return value;
+}
+
+/* Set the bit string specified by mapping->offset and mapping->size
+ * in the little-endian data stored at 'data' to the value 'value'.
+ */
+static void uvc_set_le_value(__s32 value, __u8 *data,
+	struct uvc_control_mapping *mapping)
+{
+	int bits = mapping->size;
+	int offset = mapping->offset;
+	__u8 mask;
+
+	data += offset / 8;
+	offset &= 7;
+
+	for (; bits > 0; data++) {
+		mask = ((1LL << bits) - 1) << offset;
+		*data = (*data & ~mask) | ((value << offset) & mask);
+		value >>= offset ? offset : 8;
+		bits -= 8 - offset;
+		offset = 0;
+	}
+}
+
+/* ------------------------------------------------------------------------
+ * Terminal and unit management
+ */
+
+static const __u8 uvc_processing_guid[16] = UVC_GUID_UVC_PROCESSING;
+static const __u8 uvc_camera_guid[16] = UVC_GUID_UVC_CAMERA;
+static const __u8 uvc_media_transport_input_guid[16] =
+	UVC_GUID_UVC_MEDIA_TRANSPORT_INPUT;
+
+static int uvc_entity_match_guid(struct uvc_entity *entity, __u8 guid[16])
+{
+	switch (UVC_ENTITY_TYPE(entity)) {
+	case ITT_CAMERA:
+		return memcmp(uvc_camera_guid, guid, 16) == 0;
+
+	case ITT_MEDIA_TRANSPORT_INPUT:
+		return memcmp(uvc_media_transport_input_guid, guid, 16) == 0;
+
+	case VC_PROCESSING_UNIT:
+		return memcmp(uvc_processing_guid, guid, 16) == 0;
+
+	case VC_EXTENSION_UNIT:
+		return memcmp(entity->extension.guidExtensionCode,
+			      guid, 16) == 0;
+
+	default:
+		return 0;
+	}
+}
+
+/* ------------------------------------------------------------------------
+ * UVC Controls
+ */
+
+static void __uvc_find_control(struct uvc_entity *entity, __u32 v4l2_id,
+	struct uvc_control_mapping **mapping, struct uvc_control **control,
+	int next)
+{
+	struct uvc_control *ctrl;
+	struct uvc_control_mapping *map;
+	unsigned int i;
+
+	if (entity == NULL)
+		return;
+
+	for (i = 0; i < entity->ncontrols; ++i) {
+		ctrl = &entity->controls[i];
+		if (ctrl->info == NULL)
+			continue;
+
+		list_for_each_entry(map, &ctrl->info->mappings, list) {
+			if ((map->id == v4l2_id) && !next) {
+				*control = ctrl;
+				*mapping = map;
+				return;
+			}
+
+			if ((*mapping == NULL || (*mapping)->id > map->id) &&
+			    (map->id > v4l2_id) && next) {
+				*control = ctrl;
+				*mapping = map;
+			}
+		}
+	}
+}
+
+struct uvc_control *uvc_find_control(struct uvc_video_device *video,
+	__u32 v4l2_id, struct uvc_control_mapping **mapping)
+{
+	struct uvc_control *ctrl = NULL;
+	struct uvc_entity *entity;
+	int next = v4l2_id & V4L2_CTRL_FLAG_NEXT_CTRL;
+
+	*mapping = NULL;
+
+	/* Mask the query flags. */
+	v4l2_id &= V4L2_CTRL_ID_MASK;
+
+	/* Find the control. */
+	__uvc_find_control(video->processing, v4l2_id, mapping, &ctrl, next);
+	if (ctrl && !next)
+		return ctrl;
+
+	list_for_each_entry(entity, &video->iterms, chain) {
+		__uvc_find_control(entity, v4l2_id, mapping, &ctrl, next);
+		if (ctrl && !next)
+			return ctrl;
+	}
+
+	list_for_each_entry(entity, &video->extensions, chain) {
+		__uvc_find_control(entity, v4l2_id, mapping, &ctrl, next);
+		if (ctrl && !next)
+			return ctrl;
+	}
+
+	if (ctrl == NULL && !next)
+		uvc_trace(UVC_TRACE_CONTROL, "Control 0x%08x not found.\n",
+				v4l2_id);
+
+	return ctrl;
+}
+
+int uvc_query_v4l2_ctrl(struct uvc_video_device *video,
+	struct v4l2_queryctrl *v4l2_ctrl)
+{
+	struct uvc_control *ctrl;
+	struct uvc_control_mapping *mapping;
+	struct uvc_menu_info *menu;
+	unsigned int i;
+	__u8 data[8];
+	int ret;
+
+	ctrl = uvc_find_control(video, v4l2_ctrl->id, &mapping);
+	if (ctrl == NULL)
+		return -EINVAL;
+
+	v4l2_ctrl->id = mapping->id;
+	v4l2_ctrl->type = mapping->v4l2_type;
+	strncpy(v4l2_ctrl->name, mapping->name, sizeof v4l2_ctrl->name);
+	v4l2_ctrl->flags = 0;
+
+	if (!(ctrl->info->flags & UVC_CONTROL_SET_CUR))
+		v4l2_ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+
+	if (ctrl->info->flags & UVC_CONTROL_GET_DEF) {
+		if ((ret = uvc_query_ctrl(video->dev, GET_DEF, ctrl->entity->id,
+				video->dev->intfnum, ctrl->info->selector,
+				&data, ctrl->info->size)) < 0)
+			return ret;
+		v4l2_ctrl->default_value = uvc_get_le_value(data, mapping);
+	}
+
+	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
+		v4l2_ctrl->minimum = 0;
+		v4l2_ctrl->maximum = mapping->menu_count - 1;
+		v4l2_ctrl->step = 1;
+
+		menu = mapping->menu_info;
+		for (i = 0; i < mapping->menu_count; ++i, ++menu) {
+			if (menu->value == v4l2_ctrl->default_value) {
+				v4l2_ctrl->default_value = i;
+				break;
+			}
+		}
+
+		return 0;
+	}
+
+	if (ctrl->info->flags & UVC_CONTROL_GET_MIN) {
+		if ((ret = uvc_query_ctrl(video->dev, GET_MIN, ctrl->entity->id,
+				video->dev->intfnum, ctrl->info->selector,
+				&data, ctrl->info->size)) < 0)
+			return ret;
+		v4l2_ctrl->minimum = uvc_get_le_value(data, mapping);
+	}
+	if (ctrl->info->flags & UVC_CONTROL_GET_MAX) {
+		if ((ret = uvc_query_ctrl(video->dev, GET_MAX, ctrl->entity->id,
+				video->dev->intfnum, ctrl->info->selector,
+				&data, ctrl->info->size)) < 0)
+			return ret;
+		v4l2_ctrl->maximum = uvc_get_le_value(data, mapping);
+	}
+	if (ctrl->info->flags & UVC_CONTROL_GET_RES) {
+		if ((ret = uvc_query_ctrl(video->dev, GET_RES, ctrl->entity->id,
+				video->dev->intfnum, ctrl->info->selector,
+				&data, ctrl->info->size)) < 0)
+			return ret;
+		v4l2_ctrl->step = uvc_get_le_value(data, mapping);
+	}
+
+	return 0;
+}
+
+
+/* --------------------------------------------------------------------------
+ * Control transactions
+ *
+ * To make extended set operations as atomic as the hardware allows, controls
+ * are handled using begin/commit/rollback operations.
+ *
+ * At the beginning of a set request, uvc_ctrl_begin should be called to
+ * initialize the request. This function acquires the control lock.
+ *
+ * When setting a control, the new value is stored in the control data field
+ * at position UVC_CTRL_DATA_CURRENT. The control is then marked as dirty for
+ * later processing. If the UVC and V4L2 control sizes differ, the current
+ * value is loaded from the hardware before storing the new value in the data
+ * field.
+ *
+ * After processing all controls in the transaction, uvc_ctrl_commit or
+ * uvc_ctrl_rollback must be called to apply the pending changes to the
+ * hardware or revert them. When applying changes, all controls marked as
+ * dirty will be modified in the UVC device, and the dirty flag will be
+ * cleared. When reverting controls, the control data field
+ * UVC_CTRL_DATA_CURRENT is reverted to its previous value
+ * (UVC_CTRL_DATA_BACKUP) for all dirty controls. Both functions release the
+ * control lock.
+ */
+int uvc_ctrl_begin(struct uvc_video_device *video)
+{
+	return mutex_lock_interruptible(&video->ctrl_mutex) ? -ERESTARTSYS : 0;
+}
+
+static int uvc_ctrl_commit_entity(struct uvc_device *dev,
+	struct uvc_entity *entity, int rollback)
+{
+	struct uvc_control *ctrl;
+	unsigned int i;
+	int ret;
+
+	if (entity == NULL)
+		return 0;
+
+	for (i = 0; i < entity->ncontrols; ++i) {
+		ctrl = &entity->controls[i];
+		if (ctrl->info == NULL || !ctrl->dirty)
+			continue;
+
+		if (!rollback)
+			ret = uvc_query_ctrl(dev, SET_CUR, ctrl->entity->id,
+				dev->intfnum, ctrl->info->selector,
+				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
+				ctrl->info->size);
+		else
+			ret = 0;
+
+		if (rollback || ret < 0)
+			memcpy(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
+			       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
+			       ctrl->info->size);
+
+		if ((ctrl->info->flags & UVC_CONTROL_GET_CUR) == 0)
+			ctrl->loaded = 0;
+
+		ctrl->dirty = 0;
+
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+int __uvc_ctrl_commit(struct uvc_video_device *video, int rollback)
+{
+	struct uvc_entity *entity;
+	int ret = 0;
+
+	/* Find the control. */
+	ret = uvc_ctrl_commit_entity(video->dev, video->processing, rollback);
+	if (ret < 0)
+		goto done;
+
+	list_for_each_entry(entity, &video->iterms, chain) {
+		ret = uvc_ctrl_commit_entity(video->dev, entity, rollback);
+		if (ret < 0)
+			goto done;
+	}
+
+	list_for_each_entry(entity, &video->extensions, chain) {
+		ret = uvc_ctrl_commit_entity(video->dev, entity, rollback);
+		if (ret < 0)
+			goto done;
+	}
+
+done:
+	mutex_unlock(&video->ctrl_mutex);
+	return ret;
+}
+
+int uvc_ctrl_get(struct uvc_video_device *video,
+	struct v4l2_ext_control *xctrl)
+{
+	struct uvc_control *ctrl;
+	struct uvc_control_mapping *mapping;
+	struct uvc_menu_info *menu;
+	unsigned int i;
+	int ret;
+
+	ctrl = uvc_find_control(video, xctrl->id, &mapping);
+	if (ctrl == NULL || (ctrl->info->flags & UVC_CONTROL_GET_CUR) == 0)
+		return -EINVAL;
+
+	if (!ctrl->loaded) {
+		ret = uvc_query_ctrl(video->dev, GET_CUR, ctrl->entity->id,
+				video->dev->intfnum, ctrl->info->selector,
+				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
+				ctrl->info->size);
+		if (ret < 0)
+			return ret;
+
+		if ((ctrl->info->flags & UVC_CONTROL_AUTO_UPDATE) == 0)
+			ctrl->loaded = 1;
+	}
+
+	xctrl->value = uvc_get_le_value(
+		uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT), mapping);
+
+	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
+		menu = mapping->menu_info;
+		for (i = 0; i < mapping->menu_count; ++i, ++menu) {
+			if (menu->value == xctrl->value) {
+				xctrl->value = i;
+				break;
+			}
+		}
+	}
+
+	return 0;
+}
+
+int uvc_ctrl_set(struct uvc_video_device *video,
+	struct v4l2_ext_control *xctrl)
+{
+	struct uvc_control *ctrl;
+	struct uvc_control_mapping *mapping;
+	s32 value = xctrl->value;
+	int ret;
+
+	ctrl = uvc_find_control(video, xctrl->id, &mapping);
+	if (ctrl == NULL || (ctrl->info->flags & UVC_CONTROL_SET_CUR) == 0)
+		return -EINVAL;
+
+	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
+		if (value < 0 || value >= mapping->menu_count)
+			return -EINVAL;
+		value = mapping->menu_info[value].value;
+	}
+
+	if (!ctrl->loaded && (ctrl->info->size * 8) != mapping->size) {
+		if ((ctrl->info->flags & UVC_CONTROL_GET_CUR) == 0) {
+			memset(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
+				0, ctrl->info->size);
+		} else {
+			ret = uvc_query_ctrl(video->dev, GET_CUR,
+				ctrl->entity->id, video->dev->intfnum,
+				ctrl->info->selector,
+				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
+				ctrl->info->size);
+			if (ret < 0)
+				return ret;
+		}
+
+		if ((ctrl->info->flags & UVC_CONTROL_AUTO_UPDATE) == 0)
+			ctrl->loaded = 1;
+	}
+
+	if (!ctrl->dirty) {
+		memcpy(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
+		       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
+		       ctrl->info->size);
+	}
+
+	uvc_set_le_value(value,
+		uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT), mapping);
+
+	ctrl->dirty = 1;
+	ctrl->modified = 1;
+	return 0;
+}
+
+/* --------------------------------------------------------------------------
+ * Dynamic controls
+ */
+
+int uvc_xu_ctrl_query(struct uvc_video_device *video,
+	struct uvc_xu_control *xctrl, int set)
+{
+	struct uvc_entity *entity;
+	struct uvc_control *ctrl = NULL;
+	unsigned int i, found = 0;
+	__u8 *data;
+	int ret;
+
+	/* Find the extension unit. */
+	list_for_each_entry(entity, &video->extensions, chain) {
+		if (entity->id == xctrl->unit)
+			break;
+	}
+
+	if (entity->id != xctrl->unit) {
+		uvc_trace(UVC_TRACE_CONTROL, "Extension unit %u not found.\n",
+			xctrl->unit);
+		return -EINVAL;
+	}
+
+	/* Find the control. */
+	for (i = 0; i < entity->ncontrols; ++i) {
+		ctrl = &entity->controls[i];
+		if (ctrl->info == NULL)
+			continue;
+
+		if (ctrl->info->selector == xctrl->selector) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found) {
+		uvc_trace(UVC_TRACE_CONTROL,
+			"Control " UVC_GUID_FORMAT "/%u not found.\n",
+			UVC_GUID_ARGS(entity->extension.guidExtensionCode),
+			xctrl->selector);
+		return -EINVAL;
+	}
+
+	/* Validate control data size. */
+	if (ctrl->info->size != xctrl->size)
+		return -EINVAL;
+
+	if ((set && !(ctrl->info->flags & UVC_CONTROL_SET_CUR)) ||
+	    (!set && !(ctrl->info->flags & UVC_CONTROL_GET_CUR)))
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&video->ctrl_mutex))
+		return -ERESTARTSYS;
+
+	memcpy(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
+	       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
+	       xctrl->size);
+	data = uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT);
+
+	if (set && copy_from_user(data, xctrl->data, xctrl->size)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = uvc_query_ctrl(video->dev, set ? SET_CUR : GET_CUR, xctrl->unit,
+			     video->dev->intfnum, xctrl->selector, data,
+			     xctrl->size);
+	if (ret < 0)
+		goto out;
+
+	if (!set && copy_to_user(xctrl->data, data, xctrl->size)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+out:
+	if (ret)
+		memcpy(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
+		       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
+		       xctrl->size);
+
+	mutex_unlock(&video->ctrl_mutex);
+	return ret;
+}
+
+/* --------------------------------------------------------------------------
+ * Suspend/resume
+ */
+
+/*
+ * Restore control values after resume, skipping controls that haven't been
+ * changed.
+ *
+ * TODO
+ * - Don't restore modified controls that are back to their default value.
+ * - Handle restore order (Auto-Exposure Mode should be restored before
+ *   Exposure Time).
+ */
+int uvc_ctrl_resume_device(struct uvc_device *dev)
+{
+	struct uvc_control *ctrl;
+	struct uvc_entity *entity;
+	unsigned int i;
+	int ret;
+
+	/* Walk the entities list and restore controls when possible. */
+	list_for_each_entry(entity, &dev->entities, list) {
+
+		for (i = 0; i < entity->ncontrols; ++i) {
+			ctrl = &entity->controls[i];
+
+			if (ctrl->info == NULL || !ctrl->modified ||
+			    (ctrl->info->flags & UVC_CONTROL_RESTORE) == 0)
+				continue;
+
+			printk(KERN_INFO "restoring control " UVC_GUID_FORMAT
+				"/%u/%u\n", UVC_GUID_ARGS(ctrl->info->entity),
+				ctrl->info->index, ctrl->info->selector);
+			ctrl->dirty = 1;
+		}
+
+		ret = uvc_ctrl_commit_entity(dev, entity, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/* --------------------------------------------------------------------------
+ * Control and mapping handling
+ */
+
+static void uvc_ctrl_add_ctrl(struct uvc_device *dev,
+	struct uvc_control_info *info)
+{
+	struct uvc_entity *entity;
+	struct uvc_control *ctrl = NULL;
+	int ret, found = 0;
+	unsigned int i;
+
+	list_for_each_entry(entity, &dev->entities, list) {
+		if (!uvc_entity_match_guid(entity, info->entity))
+			continue;
+
+		for (i = 0; i < entity->ncontrols; ++i) {
+			ctrl = &entity->controls[i];
+			if (ctrl->index == info->index) {
+				found = 1;
+				break;
+			}
+		}
+
+		if (found)
+			break;
+	}
+
+	if (!found)
+		return;
+
+	if (UVC_ENTITY_TYPE(entity) == VC_EXTENSION_UNIT) {
+		/* Check if the device control information and length match
+		 * the user supplied information.
+		 */
+		__u32 flags;
+		__le16 size;
+		__u8 inf;
+
+		if ((ret = uvc_query_ctrl(dev, GET_LEN, ctrl->entity->id,
+			dev->intfnum, info->selector, (__u8 *)&size, 2)) < 0) {
+			uvc_trace(UVC_TRACE_CONTROL, "GET_LEN failed on "
+				"control " UVC_GUID_FORMAT "/%u (%d).\n",
+				UVC_GUID_ARGS(info->entity), info->selector,
+				ret);
+			return;
+		}
+
+		if (info->size != le16_to_cpu(size)) {
+			uvc_trace(UVC_TRACE_CONTROL, "Control " UVC_GUID_FORMAT
+				"/%u size doesn't match user supplied "
+				"value.\n", UVC_GUID_ARGS(info->entity),
+				info->selector);
+			return;
+		}
+
+		if ((ret = uvc_query_ctrl(dev, GET_INFO, ctrl->entity->id,
+			dev->intfnum, info->selector, &inf, 1)) < 0) {
+			uvc_trace(UVC_TRACE_CONTROL, "GET_INFO failed on "
+				"control " UVC_GUID_FORMAT "/%u (%d).\n",
+				UVC_GUID_ARGS(info->entity), info->selector,
+				ret);
+			return;
+		}
+
+		flags = info->flags;
+		if (((flags & UVC_CONTROL_GET_CUR) && !(inf & (1 << 0))) ||
+		    ((flags & UVC_CONTROL_SET_CUR) && !(inf & (1 << 1)))) {
+			uvc_trace(UVC_TRACE_CONTROL, "Control "
+				UVC_GUID_FORMAT "/%u flags don't match "
+				"supported operations.\n",
+				UVC_GUID_ARGS(info->entity), info->selector);
+			return;
+		}
+	}
+
+	ctrl->info = info;
+	ctrl->data = kmalloc(ctrl->info->size * UVC_CTRL_NDATA, GFP_KERNEL);
+	uvc_trace(UVC_TRACE_CONTROL, "Added control " UVC_GUID_FORMAT "/%u "
+		"to device %s entity %u\n", UVC_GUID_ARGS(ctrl->info->entity),
+		ctrl->info->selector, dev->udev->devpath, entity->id);
+}
+
+/*
+ * Add an item to the UVC control information list, and instantiate a control
+ * structure for each device that supports the control.
+ */
+int uvc_ctrl_add_info(struct uvc_control_info *info)
+{
+	struct uvc_control_info *ctrl;
+	struct uvc_device *dev;
+	int ret = 0;
+
+	/* Find matching controls by walking the devices, entities and
+	 * controls list.
+	 */
+	mutex_lock(&uvc_driver.ctrl_mutex);
+
+	/* First check if the list contains a control matching the new one.
+	 * Bail out if it does.
+	 */
+	list_for_each_entry(ctrl, &uvc_driver.controls, list) {
+		if (memcmp(ctrl->entity, info->entity, 16))
+			continue;
+
+		if (ctrl->selector == info->selector) {
+			uvc_trace(UVC_TRACE_CONTROL, "Control "
+				UVC_GUID_FORMAT "/%u is already defined.\n",
+				UVC_GUID_ARGS(info->entity), info->selector);
+			ret = -EEXIST;
+			goto end;
+		}
+		if (ctrl->index == info->index) {
+			uvc_trace(UVC_TRACE_CONTROL, "Control "
+				UVC_GUID_FORMAT "/%u would overwrite index "
+				"%d.\n", UVC_GUID_ARGS(info->entity),
+				info->selector, info->index);
+			ret = -EEXIST;
+			goto end;
+		}
+	}
+
+	list_for_each_entry(dev, &uvc_driver.devices, list)
+		uvc_ctrl_add_ctrl(dev, info);
+
+	INIT_LIST_HEAD(&info->mappings);
+	list_add_tail(&info->list, &uvc_driver.controls);
+end:
+	mutex_unlock(&uvc_driver.ctrl_mutex);
+	return ret;
+}
+
+int uvc_ctrl_add_mapping(struct uvc_control_mapping *mapping)
+{
+	struct uvc_control_info *info;
+	struct uvc_control_mapping *map;
+	int ret = -EINVAL;
+
+	if (mapping->id & ~V4L2_CTRL_ID_MASK) {
+		uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s' with "
+			"invalid control id 0x%08x\n", mapping->name,
+			mapping->id);
+		return -EINVAL;
+	}
+
+	mutex_lock(&uvc_driver.ctrl_mutex);
+	list_for_each_entry(info, &uvc_driver.controls, list) {
+		if (memcmp(info->entity, mapping->entity, 16) ||
+			info->selector != mapping->selector)
+			continue;
+
+		if (info->size * 8 < mapping->size + mapping->offset) {
+			uvc_trace(UVC_TRACE_CONTROL, "Mapping '%s' would "
+				"overflow control " UVC_GUID_FORMAT "/%u\n",
+				mapping->name, UVC_GUID_ARGS(info->entity),
+				info->selector);
+			ret = -EOVERFLOW;
+			goto end;
+		}
+
+		/* Check if the list contains a mapping matching the new one.
+		 * Bail out if it does.
+		 */
+		list_for_each_entry(map, &info->mappings, list) {
+			if (map->id == mapping->id) {
+				uvc_trace(UVC_TRACE_CONTROL, "Mapping '%s' is "
+					"already defined.\n", mapping->name);
+				ret = -EEXIST;
+				goto end;
+			}
+		}
+
+		mapping->ctrl = info;
+		list_add_tail(&mapping->list, &info->mappings);
+		uvc_trace(UVC_TRACE_CONTROL, "Adding mapping %s to control "
+			UVC_GUID_FORMAT "/%u.\n", mapping->name,
+			UVC_GUID_ARGS(info->entity), info->selector);
+
+		ret = 0;
+		break;
+	}
+end:
+	mutex_unlock(&uvc_driver.ctrl_mutex);
+	return ret;
+}
+
+/*
+ * Initialize device controls.
+ */
+int uvc_ctrl_init_device(struct uvc_device *dev)
+{
+	struct uvc_control_info *info;
+	struct uvc_control *ctrl;
+	struct uvc_entity *entity;
+	unsigned int i;
+
+	/* Walk the entities list and instantiate controls */
+	list_for_each_entry(entity, &dev->entities, list) {
+		unsigned int bControlSize = 0, ncontrols = 0;
+		__u8 *bmControls = NULL;
+
+		if (UVC_ENTITY_TYPE(entity) == VC_EXTENSION_UNIT) {
+			bmControls = entity->extension.bmControls;
+			bControlSize = entity->extension.bControlSize;
+		} else if (UVC_ENTITY_TYPE(entity) == VC_PROCESSING_UNIT) {
+			bmControls = entity->processing.bmControls;
+			bControlSize = entity->processing.bControlSize;
+		} else if (UVC_ENTITY_TYPE(entity) == ITT_CAMERA) {
+			bmControls = entity->camera.bmControls;
+			bControlSize = entity->camera.bControlSize;
+		}
+
+		for (i = 0; i < bControlSize; ++i)
+			ncontrols += hweight8(bmControls[i]);
+
+		if (ncontrols == 0)
+			continue;
+
+		entity->controls = kzalloc(ncontrols*sizeof *ctrl, GFP_KERNEL);
+		if (entity->controls == NULL)
+			return -ENOMEM;
+
+		entity->ncontrols = ncontrols;
+
+		ctrl = entity->controls;
+		for (i = 0; i < bControlSize * 8; ++i) {
+			if (uvc_get_bit(bmControls, i) == 0)
+				continue;
+
+			ctrl->entity = entity;
+			ctrl->index = i;
+			ctrl++;
+		}
+	}
+
+	/* Walk the controls info list and associate them with the device
+	 * controls, then add the device to the global device list. This has
+	 * to be done while holding the controls lock, to make sure
+	 * uvc_ctrl_add_info() will not get called in-between.
+	 */
+	mutex_lock(&uvc_driver.ctrl_mutex);
+	list_for_each_entry(info, &uvc_driver.controls, list)
+		uvc_ctrl_add_ctrl(dev, info);
+
+	list_add_tail(&dev->list, &uvc_driver.devices);
+	mutex_unlock(&uvc_driver.ctrl_mutex);
+
+	return 0;
+}
+
+/*
+ * Cleanup device controls.
+ */
+void uvc_ctrl_cleanup_device(struct uvc_device *dev)
+{
+	struct uvc_entity *entity;
+	unsigned int i;
+
+	/* Remove the device from the global devices list */
+	mutex_lock(&uvc_driver.ctrl_mutex);
+	if (dev->list.next != NULL)
+		list_del(&dev->list);
+	mutex_unlock(&uvc_driver.ctrl_mutex);
+
+	list_for_each_entry(entity, &dev->entities, list) {
+		for (i = 0; i < entity->ncontrols; ++i)
+			kfree(entity->controls[i].data);
+
+		kfree(entity->controls);
+	}
+}
+
+void uvc_ctrl_init(void)
+{
+	struct uvc_control_info *ctrl = uvc_ctrls;
+	struct uvc_control_info *cend = ctrl + ARRAY_SIZE(uvc_ctrls);
+	struct uvc_control_mapping *mapping = uvc_ctrl_mappings;
+	struct uvc_control_mapping *mend =
+		mapping + ARRAY_SIZE(uvc_ctrl_mappings);
+
+	for (; ctrl < cend; ++ctrl)
+		uvc_ctrl_add_info(ctrl);
+
+	for (; mapping < mend; ++mapping)
+		uvc_ctrl_add_mapping(mapping);
+}
+
diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
new file mode 100644
index 0000000..00b8f41
--- /dev/null
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -0,0 +1,1923 @@
+/*
+ *      uvc_driver.c  --  USB Video Class driver
+ *
+ *      Copyright (C) 2005-2008
+ *          Laurent Pinchart (laurent.pinchart@skynet.be)
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ */
+
+/*
+ * This driver aims to support video input devices compliant with the 'USB
+ * Video Class' specification.
+ *
+ * The driver doesn't support the deprecated v4l1 interface. It implements the
+ * mmap capture method only, and doesn't do any image format conversion in
+ * software. If your user-space application doesn't support YUYV or MJPEG, fix
+ * it :-). Please note that the MJPEG data have been stripped from their
+ * Huffman tables (DHT marker), you will need to add it back if your JPEG
+ * codec can't handle MJPEG data.
+ */
+
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/videodev.h>
+#include <linux/vmalloc.h>
+#include <linux/wait.h>
+#include <asm/atomic.h>
+
+#include <media/v4l2-common.h>
+
+#include "uvcvideo.h"
+
+#define DRIVER_AUTHOR		"Laurent Pinchart <laurent.pinchart@skynet.be>"
+#define DRIVER_DESC		"USB Video Class driver"
+#ifndef DRIVER_VERSION
+#define DRIVER_VERSION		"v0.1.0"
+#endif
+
+static unsigned int uvc_quirks_param;
+unsigned int uvc_trace_param;
+
+/* ------------------------------------------------------------------------
+ * Control, formats, ...
+ */
+
+static struct uvc_format_desc uvc_fmts[] = {
+	{
+		.name		= "YUV 4:2:2 (YUYV)",
+		.guid		= UVC_GUID_FORMAT_YUY2,
+		.fcc		= V4L2_PIX_FMT_YUYV,
+	},
+	{
+		.name		= "YUV 4:2:0 (NV12)",
+		.guid		= UVC_GUID_FORMAT_NV12,
+		.fcc		= V4L2_PIX_FMT_NV12,
+	},
+	{
+		.name		= "MJPEG",
+		.guid		= UVC_GUID_FORMAT_MJPEG,
+		.fcc		= V4L2_PIX_FMT_MJPEG,
+	},
+	{
+		.name		= "YVU 4:2:0 (YV12)",
+		.guid		= UVC_GUID_FORMAT_YV12,
+		.fcc		= V4L2_PIX_FMT_YVU420,
+	},
+	{
+		.name		= "YUV 4:2:0 (I420)",
+		.guid		= UVC_GUID_FORMAT_I420,
+		.fcc		= V4L2_PIX_FMT_YUV420,
+	},
+	{
+		.name		= "YUV 4:2:2 (UYVY)",
+		.guid		= UVC_GUID_FORMAT_UYVY,
+		.fcc		= V4L2_PIX_FMT_UYVY,
+	},
+	{
+		.name		= "Greyscale",
+		.guid		= UVC_GUID_FORMAT_Y800,
+		.fcc		= V4L2_PIX_FMT_GREY,
+	},
+	{
+		.name		= "RGB Bayer",
+		.guid		= UVC_GUID_FORMAT_BY8,
+		.fcc		= V4L2_PIX_FMT_SBGGR8,
+	},
+};
+
+/* ------------------------------------------------------------------------
+ * Utility functions
+ */
+
+struct usb_host_endpoint *uvc_find_endpoint(struct usb_host_interface *alts,
+		__u8 epaddr)
+{
+	struct usb_host_endpoint *ep;
+	unsigned int i;
+
+	for (i = 0; i < alts->desc.bNumEndpoints; ++i) {
+		ep = &alts->endpoint[i];
+		if (ep->desc.bEndpointAddress == epaddr)
+			return ep;
+	}
+
+	return NULL;
+}
+
+static struct uvc_format_desc *uvc_format_by_guid(const __u8 guid[16])
+{
+	unsigned int len = ARRAY_SIZE(uvc_fmts);
+	unsigned int i;
+
+	for (i = 0; i < len; ++i) {
+		if (memcmp(guid, uvc_fmts[i].guid, 16) == 0)
+			return &uvc_fmts[i];
+	}
+
+	return NULL;
+}
+
+static __u32 uvc_colorspace(const __u8 primaries)
+{
+	static const __u8 colorprimaries[] = {
+		0,
+		V4L2_COLORSPACE_SRGB,
+		V4L2_COLORSPACE_470_SYSTEM_M,
+		V4L2_COLORSPACE_470_SYSTEM_BG,
+		V4L2_COLORSPACE_SMPTE170M,
+		V4L2_COLORSPACE_SMPTE240M,
+	};
+
+	if (primaries < ARRAY_SIZE(colorprimaries))
+		return colorprimaries[primaries];
+
+	return 0;
+}
+
+/* Simplify a fraction using a simple continued fraction decomposition. The
+ * idea here is to convert fractions such as 333333/10000000 to 1/30 using
+ * 32 bit arithmetic only. The algorithm is not perfect and relies upon two
+ * arbitrary parameters to remove non-significative terms from the simple
+ * continued fraction decomposition. Using 8 and 333 for n_terms and threshold
+ * respectively seems to give nice results.
+ */
+void uvc_simplify_fraction(uint32_t *numerator, uint32_t *denominator,
+		unsigned int n_terms, unsigned int threshold)
+{
+	uint32_t *an;
+	uint32_t x, y, r;
+	unsigned int i, n;
+
+	an = kmalloc(n_terms * sizeof *an, GFP_KERNEL);
+	if (an == NULL)
+		return;
+
+	/* Convert the fraction to a simple continued fraction. See
+	 * http://mathforum.org/dr.math/faq/faq.fractions.html
+	 * Stop if the current term is bigger than or equal to the given
+	 * threshold.
+	 */
+	x = *numerator;
+	y = *denominator;
+
+	for (n = 0; n < n_terms && y != 0; ++n) {
+		an[n] = x / y;
+		if (an[n] >= threshold) {
+			if (n < 2)
+				n++;
+			break;
+		}
+
+		r = x - an[n] * y;
+		x = y;
+		y = r;
+	}
+
+	/* Expand the simple continued fraction back to an integer fraction. */
+	x = 0;
+	y = 1;
+
+	for (i = n; i > 0; --i) {
+		r = y;
+		y = an[i-1] * y + x;
+		x = r;
+	}
+
+	*numerator = y;
+	*denominator = x;
+	kfree(an);
+}
+
+/* Convert a fraction to a frame interval in 100ns multiples. The idea here is
+ * to compute numerator / denominator * 10000000 using 32 bit fixed point
+ * arithmetic only.
+ */
+uint32_t uvc_fraction_to_interval(uint32_t numerator, uint32_t denominator)
+{
+	uint32_t multiplier;
+
+	/* Saturate the result if the operation would overflow. */
+	if (denominator == 0 ||
+	    numerator/denominator >= ((uint32_t)-1)/10000000)
+		return (uint32_t)-1;
+
+	/* Divide both the denominator and the multiplier by two until
+	 * numerator * multiplier doesn't overflow. If anyone knows a better
+	 * algorithm please let me know.
+	 */
+	multiplier = 10000000;
+	while (numerator > ((uint32_t)-1)/multiplier) {
+		multiplier /= 2;
+		denominator /= 2;
+	}
+
+	return denominator ? numerator * multiplier / denominator : 0;
+}
+
+/* ------------------------------------------------------------------------
+ * Terminal and unit management
+ */
+
+static struct uvc_entity *uvc_entity_by_id(struct uvc_device *dev, int id)
+{
+	struct uvc_entity *entity;
+
+	list_for_each_entry(entity, &dev->entities, list) {
+		if (entity->id == id)
+			return entity;
+	}
+
+	return NULL;
+}
+
+static struct uvc_entity *uvc_entity_by_reference(struct uvc_device *dev,
+	int id, struct uvc_entity *entity)
+{
+	unsigned int i;
+
+	if (entity == NULL)
+		entity = list_entry(&dev->entities, struct uvc_entity, list);
+
+	list_for_each_entry_continue(entity, &dev->entities, list) {
+		switch (UVC_ENTITY_TYPE(entity)) {
+		case TT_STREAMING:
+			if (entity->output.bSourceID == id)
+				return entity;
+			break;
+
+		case VC_PROCESSING_UNIT:
+			if (entity->processing.bSourceID == id)
+				return entity;
+			break;
+
+		case VC_SELECTOR_UNIT:
+			for (i = 0; i < entity->selector.bNrInPins; ++i)
+				if (entity->selector.baSourceID[i] == id)
+					return entity;
+			break;
+
+		case VC_EXTENSION_UNIT:
+			for (i = 0; i < entity->extension.bNrInPins; ++i)
+				if (entity->extension.baSourceID[i] == id)
+					return entity;
+			break;
+		}
+	}
+
+	return NULL;
+}
+
+/* ------------------------------------------------------------------------
+ * Descriptors handling
+ */
+
+static int uvc_parse_format(struct uvc_device *dev,
+	struct uvc_streaming *streaming, struct uvc_format *format,
+	__u32 **intervals, unsigned char *buffer, int buflen)
+{
+	struct usb_interface *intf = streaming->intf;
+	struct usb_host_interface *alts = intf->cur_altsetting;
+	struct uvc_format_desc *fmtdesc;
+	struct uvc_frame *frame;
+	const unsigned char *start = buffer;
+	unsigned int interval;
+	unsigned int i, n;
+	__u8 ftype;
+
+	format->type = buffer[2];
+	format->index = buffer[3];
+
+	switch (buffer[2]) {
+	case VS_FORMAT_UNCOMPRESSED:
+	case VS_FORMAT_FRAME_BASED:
+		if (buflen < 27) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming"
+			       "interface %d FORMAT error\n",
+			       dev->udev->devnum,
+			       alts->desc.bInterfaceNumber);
+			return -EINVAL;
+		}
+
+		/* Find the format descriptor from its GUID. */
+		fmtdesc = uvc_format_by_guid(&buffer[5]);
+
+		if (fmtdesc != NULL) {
+			strncpy(format->name, fmtdesc->name,
+				sizeof format->name);
+			format->fcc = fmtdesc->fcc;
+		} else {
+			uvc_printk(KERN_INFO, "Unknown video format "
+				UVC_GUID_FORMAT "\n",
+				UVC_GUID_ARGS(&buffer[5]));
+			snprintf(format->name, sizeof format->name,
+				UVC_GUID_FORMAT, UVC_GUID_ARGS(&buffer[5]));
+			format->fcc = 0;
+		}
+
+		format->bpp = buffer[21];
+		if (buffer[2] == VS_FORMAT_UNCOMPRESSED) {
+			ftype = VS_FRAME_UNCOMPRESSED;
+		} else {
+			ftype = VS_FRAME_FRAME_BASED;
+			if (buffer[27])
+				format->flags = UVC_FMT_FLAG_COMPRESSED;
+		}
+		break;
+
+	case VS_FORMAT_MJPEG:
+		if (buflen < 11) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming"
+			       "interface %d FORMAT error\n",
+			       dev->udev->devnum,
+			       alts->desc.bInterfaceNumber);
+			return -EINVAL;
+		}
+
+		strncpy(format->name, "MJPEG", sizeof format->name);
+		format->fcc = V4L2_PIX_FMT_MJPEG;
+		format->flags = UVC_FMT_FLAG_COMPRESSED;
+		format->bpp = 0;
+		ftype = VS_FRAME_MJPEG;
+		break;
+
+	case VS_FORMAT_DV:
+		if (buflen < 9) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming"
+			       "interface %d FORMAT error\n",
+			       dev->udev->devnum,
+			       alts->desc.bInterfaceNumber);
+			return -EINVAL;
+		}
+
+		switch (buffer[8] & 0x7f) {
+		case 0:
+			strncpy(format->name, "SD-DV", sizeof format->name);
+			break;
+		case 1:
+			strncpy(format->name, "SDL-DV", sizeof format->name);
+			break;
+		case 2:
+			strncpy(format->name, "HD-DV", sizeof format->name);
+			break;
+		default:
+			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming"
+			       "interface %d: unknown DV format %u\n",
+			       dev->udev->devnum,
+			       alts->desc.bInterfaceNumber, buffer[8]);
+			return -EINVAL;
+		}
+
+		strncat(format->name, buffer[8] & (1 << 7) ? " 60Hz" : " 50Hz",
+			sizeof format->name);
+
+		format->fcc = V4L2_PIX_FMT_DV;
+		format->flags = UVC_FMT_FLAG_COMPRESSED | UVC_FMT_FLAG_STREAM;
+		format->bpp = 0;
+		ftype = 0;
+
+		/* Create a dummy frame descriptor. */
+		frame = &format->frame[0];
+		memset(&format->frame[0], 0, sizeof format->frame[0]);
+		frame->bFrameIntervalType = 1;
+		frame->dwDefaultFrameInterval = 1;
+		frame->dwFrameInterval = *intervals;
+		*(*intervals)++ = 1;
+		format->nframes = 1;
+		break;
+
+	case VS_FORMAT_MPEG2TS:
+	case VS_FORMAT_STREAM_BASED:
+		/* Not supported yet. */
+	default:
+		uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming"
+		       "interface %d unsupported format %u\n",
+		       dev->udev->devnum, alts->desc.bInterfaceNumber,
+		       buffer[2]);
+		return -EINVAL;
+	}
+
+	uvc_trace(UVC_TRACE_DESCR, "Found format %s.\n", format->name);
+
+	buflen -= buffer[0];
+	buffer += buffer[0];
+
+	/* Parse the frame descriptors. Only uncompressed, MJPEG and frame
+	 * based formats have frame descriptors.
+	 */
+	while (buflen > 2 && buffer[2] == ftype) {
+		frame = &format->frame[format->nframes];
+
+		if (ftype != VS_FRAME_FRAME_BASED)
+			n = buflen > 25 ? buffer[25] : 0;
+		else
+			n = buflen > 21 ? buffer[21] : 0;
+
+		n = n ? n : 3;
+
+		if (buflen < 26 + 4*n) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming"
+			       "interface %d FRAME error\n", dev->udev->devnum,
+			       alts->desc.bInterfaceNumber);
+			return -EINVAL;
+		}
+
+		frame->bFrameIndex = buffer[3];
+		frame->bmCapabilities = buffer[4];
+		frame->wWidth = le16_to_cpup((__le16 *)&buffer[5]);
+		frame->wHeight = le16_to_cpup((__le16 *)&buffer[7]);
+		frame->dwMinBitRate = le32_to_cpup((__le32 *)&buffer[9]);
+		frame->dwMaxBitRate = le32_to_cpup((__le32 *)&buffer[13]);
+		if (ftype != VS_FRAME_FRAME_BASED) {
+			frame->dwMaxVideoFrameBufferSize =
+				le32_to_cpup((__le32 *)&buffer[17]);
+			frame->dwDefaultFrameInterval =
+				le32_to_cpup((__le32 *)&buffer[21]);
+			frame->bFrameIntervalType = buffer[25];
+		} else {
+			frame->dwMaxVideoFrameBufferSize = 0;
+			frame->dwDefaultFrameInterval =
+				le32_to_cpup((__le32 *)&buffer[17]);
+			frame->bFrameIntervalType = buffer[21];
+		}
+		frame->dwFrameInterval = *intervals;
+
+		/* Some bogus devices report dwMinFrameInterval equal to
+		 * dwMaxFrameInterval and have dwFrameIntervalStep set to
+		 * zero. Setting all null intervals to 1 fixes the problem and
+		 * some other divisions by zero which could happen.
+		 */
+		for (i = 0; i < n; ++i) {
+			interval = le32_to_cpup((__le32 *)&buffer[26+4*i]);
+			*(*intervals)++ = interval ? interval : 1;
+		}
+
+		/* Make sure that the default frame interval stays between
+		 * the boundaries.
+		 */
+		n -= frame->bFrameIntervalType ? 1 : 2;
+		frame->dwDefaultFrameInterval =
+			min(frame->dwFrameInterval[n],
+			    max(frame->dwFrameInterval[0],
+				frame->dwDefaultFrameInterval));
+
+		uvc_trace(UVC_TRACE_DESCR, "- %ux%u (%u.%u fps)\n",
+			frame->wWidth, frame->wHeight,
+			10000000/frame->dwDefaultFrameInterval,
+			(100000000/frame->dwDefaultFrameInterval)%10);
+
+		format->nframes++;
+		buflen -= buffer[0];
+		buffer += buffer[0];
+	}
+
+	if (buflen > 2 && buffer[2] == VS_STILL_IMAGE_FRAME) {
+		buflen -= buffer[0];
+		buffer += buffer[0];
+	}
+
+	if (buflen > 2 && buffer[2] == VS_COLORFORMAT) {
+		if (buflen < 6) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming"
+			       "interface %d COLORFORMAT error\n",
+			       dev->udev->devnum,
+			       alts->desc.bInterfaceNumber);
+			return -EINVAL;
+		}
+
+		format->colorspace = uvc_colorspace(buffer[3]);
+
+		buflen -= buffer[0];
+		buffer += buffer[0];
+	}
+
+	return buffer - start;
+}
+
+static int uvc_parse_streaming(struct uvc_device *dev,
+	struct uvc_streaming *streaming)
+{
+	struct uvc_format *format;
+	struct uvc_frame *frame;
+	struct usb_interface *intf = streaming->intf;
+	struct usb_host_interface *alts = &intf->altsetting[0];
+	unsigned char *_buffer, *buffer = alts->extra;
+	int _buflen, buflen = alts->extralen;
+	unsigned int nformats = 0, nframes = 0, nintervals = 0;
+	unsigned int size, i, n, p;
+	__u32 *interval;
+	__u16 psize;
+	int ret;
+
+	/* The Pico iMage webcam has its class-specific interface descriptors
+	 * after the endpoint descriptors.
+	 */
+	if (buflen == 0) {
+		for (i = 0; i < alts->desc.bNumEndpoints; ++i) {
+			struct usb_host_endpoint *ep = &alts->endpoint[i];
+
+			if (ep->extralen == 0)
+				continue;
+
+			if (ep->extralen > 2 &&
+			    ep->extra[1] == USB_DT_CS_INTERFACE) {
+				uvc_trace(UVC_TRACE_DESCR, "trying extra data "
+					"from endpoint %u.\n", i);
+				buffer = alts->endpoint[i].extra;
+				buflen = alts->endpoint[i].extralen;
+				break;
+			}
+		}
+	}
+
+	/* Skip the standard interface descriptors. */
+	while (buflen > 2 && buffer[1] != USB_DT_CS_INTERFACE) {
+		buflen -= buffer[0];
+		buffer += buffer[0];
+	}
+
+	if (buflen <= 2) {
+		uvc_trace(UVC_TRACE_DESCR, "no class-specific streaming "
+			"interface descriptors found.\n");
+		return -EINVAL;
+	}
+
+	/* Parse the header descriptor. */
+	if (buffer[2] == VS_OUTPUT_HEADER) {
+		uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming interface "
+			"%d OUTPUT HEADER descriptor is not supported.\n",
+			dev->udev->devnum, alts->desc.bInterfaceNumber);
+		return -EINVAL;
+	} else if (buffer[2] == VS_INPUT_HEADER) {
+		p = buflen >= 5 ? buffer[3] : 0;
+		n = buflen >= 12 ? buffer[12] : 0;
+
+		if (buflen < 13 + p*n || buffer[2] != VS_INPUT_HEADER) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
+				"interface %d INPUT HEADER descriptor is "
+				"invalid.\n", dev->udev->devnum,
+				alts->desc.bInterfaceNumber);
+			return -EINVAL;
+		}
+
+		streaming->header.bNumFormats = p;
+		streaming->header.bEndpointAddress = buffer[6];
+		streaming->header.bmInfo = buffer[7];
+		streaming->header.bTerminalLink = buffer[8];
+		streaming->header.bStillCaptureMethod = buffer[9];
+		streaming->header.bTriggerSupport = buffer[10];
+		streaming->header.bTriggerUsage = buffer[11];
+		streaming->header.bControlSize = n;
+
+		streaming->header.bmaControls = kmalloc(p*n, GFP_KERNEL);
+		if (streaming->header.bmaControls == NULL)
+			return -ENOMEM;
+
+		memcpy(streaming->header.bmaControls, &buffer[13], p*n);
+	} else {
+		uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming interface "
+			"%d HEADER descriptor not found.\n", dev->udev->devnum,
+			alts->desc.bInterfaceNumber);
+		return -EINVAL;
+	}
+
+	buflen -= buffer[0];
+	buffer += buffer[0];
+
+	_buffer = buffer;
+	_buflen = buflen;
+
+	/* Count the format and frame descriptors. */
+	while (_buflen > 2) {
+		switch (_buffer[2]) {
+		case VS_FORMAT_UNCOMPRESSED:
+		case VS_FORMAT_MJPEG:
+		case VS_FORMAT_FRAME_BASED:
+			nformats++;
+			break;
+
+		case VS_FORMAT_DV:
+			/* DV format has no frame descriptor. We will create a
+			 * dummy frame descriptor with a dummy frame interval.
+			 */
+			nformats++;
+			nframes++;
+			nintervals++;
+			break;
+
+		case VS_FORMAT_MPEG2TS:
+		case VS_FORMAT_STREAM_BASED:
+			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
+				"interface %d FORMAT %u is not supported.\n",
+				dev->udev->devnum,
+				alts->desc.bInterfaceNumber, _buffer[2]);
+			break;
+
+		case VS_FRAME_UNCOMPRESSED:
+		case VS_FRAME_MJPEG:
+			nframes++;
+			if (_buflen > 25)
+				nintervals += _buffer[25] ? _buffer[25] : 3;
+			break;
+
+		case VS_FRAME_FRAME_BASED:
+			nframes++;
+			if (_buflen > 21)
+				nintervals += _buffer[21] ? _buffer[21] : 3;
+			break;
+		}
+
+		_buflen -= _buffer[0];
+		_buffer += _buffer[0];
+	}
+
+	if (nformats == 0) {
+		uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming interface "
+			"%d has no supported formats defined.\n",
+			dev->udev->devnum, alts->desc.bInterfaceNumber);
+		return -EINVAL;
+	}
+
+	size = nformats * sizeof *format + nframes * sizeof *frame
+	     + nintervals * sizeof *interval;
+	format = kzalloc(size, GFP_KERNEL);
+	if (format == NULL)
+		return -ENOMEM;
+
+	frame = (struct uvc_frame *)&format[nformats];
+	interval = (__u32 *)&frame[nframes];
+
+	streaming->format = format;
+	streaming->nformats = nformats;
+
+	/* Parse the format descriptors. */
+	while (buflen > 2) {
+		switch (buffer[2]) {
+		case VS_FORMAT_UNCOMPRESSED:
+		case VS_FORMAT_MJPEG:
+		case VS_FORMAT_DV:
+		case VS_FORMAT_FRAME_BASED:
+			format->frame = frame;
+			ret = uvc_parse_format(dev, streaming, format,
+				&interval, buffer, buflen);
+			if (ret < 0)
+				return ret;
+
+			frame += format->nframes;
+			format++;
+
+			buflen -= ret;
+			buffer += ret;
+			continue;
+
+		default:
+			break;
+		}
+
+		buflen -= buffer[0];
+		buffer += buffer[0];
+	}
+
+	/* Parse the alternate settings to find the maximum bandwidth. */
+	for (i = 0; i < intf->num_altsetting; ++i) {
+		struct usb_host_endpoint *ep;
+		alts = &intf->altsetting[i];
+		ep = uvc_find_endpoint(alts,
+				streaming->header.bEndpointAddress);
+		if (ep == NULL)
+			continue;
+
+		psize = le16_to_cpu(ep->desc.wMaxPacketSize);
+		psize = (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
+		if (psize > streaming->maxpsize)
+			streaming->maxpsize = psize;
+	}
+
+	return 0;
+}
+
+/* Parse vendor-specific extensions. */
+static int uvc_parse_vendor_control(struct uvc_device *dev,
+	const unsigned char *buffer, int buflen)
+{
+	struct usb_device *udev = dev->udev;
+	struct usb_host_interface *alts = dev->intf->cur_altsetting;
+	struct uvc_entity *unit;
+	unsigned int n, p;
+	int handled = 0;
+
+	switch (le16_to_cpu(dev->udev->descriptor.idVendor)) {
+	case 0x046d:		/* Logitech */
+		if (buffer[1] != 0x41 || buffer[2] != 0x01)
+			break;
+
+		/* Logitech implements several vendor specific functions
+		 * through vendor specific extension units (LXU).
+		 *
+		 * The LXU descriptors are similar to XU descriptors
+		 * (see "USB Device Video Class for Video Devices", section
+		 * 3.7.2.6 "Extension Unit Descriptor") with the following
+		 * differences:
+		 *
+		 * ----------------------------------------------------------
+		 * 0		bLength		1	 Number
+		 *	Size of this descriptor, in bytes: 24+p+n*2
+		 * ----------------------------------------------------------
+		 * 23+p+n	bmControlsType	N	Bitmap
+		 * 	Individual bits in the set are defined:
+		 * 	0: Absolute
+		 * 	1: Relative
+		 *
+		 * 	This bitset is mapped exactly the same as bmControls.
+		 * ----------------------------------------------------------
+		 * 23+p+n*2	bReserved	1	Boolean
+		 * ----------------------------------------------------------
+		 * 24+p+n*2	iExtension	1	Index
+		 *	Index of a string descriptor that describes this
+		 *	extension unit.
+		 * ----------------------------------------------------------
+		 */
+		p = buflen >= 22 ? buffer[21] : 0;
+		n = buflen >= 25 + p ? buffer[22+p] : 0;
+
+		if (buflen < 25 + p + 2*n) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
+				"interface %d EXTENSION_UNIT error\n",
+				udev->devnum, alts->desc.bInterfaceNumber);
+			break;
+		}
+
+		unit = kzalloc(sizeof *unit + p + 2*n, GFP_KERNEL);
+		if (unit == NULL)
+			return -ENOMEM;
+
+		unit->id = buffer[3];
+		unit->type = VC_EXTENSION_UNIT;
+		memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
+		unit->extension.bNumControls = buffer[20];
+		unit->extension.bNrInPins =
+			le16_to_cpup((__le16 *)&buffer[21]);
+		unit->extension.baSourceID = (__u8 *)unit + sizeof *unit;
+		memcpy(unit->extension.baSourceID, &buffer[22], p);
+		unit->extension.bControlSize = buffer[22+p];
+		unit->extension.bmControls = (__u8 *)unit + sizeof *unit + p;
+		unit->extension.bmControlsType = (__u8 *)unit + sizeof *unit
+					       + p + n;
+		memcpy(unit->extension.bmControls, &buffer[23+p], 2*n);
+
+		if (buffer[24+p+2*n] != 0)
+			usb_string(udev, buffer[24+p+2*n], unit->name,
+				   sizeof unit->name);
+		else
+			sprintf(unit->name, "Extension %u", buffer[3]);
+
+		list_add_tail(&unit->list, &dev->entities);
+		handled = 1;
+		break;
+	}
+
+	return handled;
+}
+
+static int uvc_parse_standard_control(struct uvc_device *dev,
+	const unsigned char *buffer, int buflen)
+{
+	struct usb_device *udev = dev->udev;
+	struct uvc_streaming *streaming;
+	struct uvc_entity *unit, *term;
+	struct usb_interface *intf;
+	struct usb_host_interface *alts = dev->intf->cur_altsetting;
+	unsigned int i, n, p, len;
+	__u16 type;
+
+	switch (buffer[2]) {
+	case VC_HEADER:
+		n = buflen >= 12 ? buffer[11] : 0;
+
+		if (buflen < 12 || buflen < 12 + n) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
+				"interface %d HEADER error\n", udev->devnum,
+				alts->desc.bInterfaceNumber);
+			return -EINVAL;
+		}
+
+		dev->uvc_version = le16_to_cpup((__le16 *)&buffer[3]);
+		dev->clock_frequency = le32_to_cpup((__le32 *)&buffer[7]);
+
+		/* Parse all USB Video Streaming interfaces. */
+		for (i = 0; i < n; ++i) {
+			intf = usb_ifnum_to_if(udev, buffer[12+i]);
+			if (intf == NULL) {
+				uvc_trace(UVC_TRACE_DESCR, "device %d "
+					"interface %d doesn't exists\n",
+					udev->devnum, i);
+				continue;
+			}
+
+			if (intf->cur_altsetting->desc.bInterfaceSubClass
+				!= SC_VIDEOSTREAMING) {
+				uvc_trace(UVC_TRACE_DESCR, "device %d "
+					"interface %d isn't a video "
+					"streaming interface\n",
+					udev->devnum, i);
+				continue;
+			}
+
+			if (usb_interface_claimed(intf)) {
+				uvc_trace(UVC_TRACE_DESCR, "device %d "
+					"interface %d is already claimed\n",
+					udev->devnum, i);
+				continue;
+			}
+
+			usb_driver_claim_interface(&uvc_driver.driver, intf,
+				dev);
+
+			streaming = kzalloc(sizeof *streaming, GFP_KERNEL);
+			if (streaming == NULL)
+				continue;
+			mutex_init(&streaming->mutex);
+			streaming->intf = usb_get_intf(intf);
+			streaming->intfnum =
+				intf->cur_altsetting->desc.bInterfaceNumber;
+
+			if (uvc_parse_streaming(dev, streaming) < 0) {
+				usb_put_intf(intf);
+				kfree(streaming->format);
+				kfree(streaming->header.bmaControls);
+				kfree(streaming);
+				continue;
+			}
+
+			list_add_tail(&streaming->list, &dev->streaming);
+		}
+		break;
+
+	case VC_INPUT_TERMINAL:
+		if (buflen < 8) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
+				"interface %d INPUT_TERMINAL error\n",
+				udev->devnum, alts->desc.bInterfaceNumber);
+			return -EINVAL;
+		}
+
+		/* Make sure the terminal type MSB is not null, otherwise it
+		 * could be confused with a unit.
+		 */
+		type = le16_to_cpup((__le16 *)&buffer[4]);
+		if ((type & 0xff00) == 0) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
+				"interface %d INPUT_TERMINAL %d has invalid "
+				"type 0x%04x, skipping\n", udev->devnum,
+				alts->desc.bInterfaceNumber,
+				buffer[3], type);
+			return 0;
+		}
+
+		n = 0;
+		p = 0;
+		len = 8;
+
+		if (type == ITT_CAMERA) {
+			n = buflen >= 15 ? buffer[14] : 0;
+			len = 15;
+
+		} else if (type == ITT_MEDIA_TRANSPORT_INPUT) {
+			n = buflen >= 9 ? buffer[8] : 0;
+			p = buflen >= 10 + n ? buffer[9+n] : 0;
+			len = 10;
+		}
+
+		if (buflen < len + n + p) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
+				"interface %d INPUT_TERMINAL error\n",
+				udev->devnum, alts->desc.bInterfaceNumber);
+			return -EINVAL;
+		}
+
+		term = kzalloc(sizeof *term + n + p, GFP_KERNEL);
+		if (term == NULL)
+			return -ENOMEM;
+
+		term->id = buffer[3];
+		term->type = type | UVC_TERM_INPUT;
+
+		if (UVC_ENTITY_TYPE(term) == ITT_CAMERA) {
+			term->camera.bControlSize = n;
+			term->camera.bmControls = (__u8 *)term + sizeof *term;
+			term->camera.wObjectiveFocalLengthMin =
+				le16_to_cpup((__le16 *)&buffer[8]);
+			term->camera.wObjectiveFocalLengthMax =
+				le16_to_cpup((__le16 *)&buffer[10]);
+			term->camera.wOcularFocalLength =
+				le16_to_cpup((__le16 *)&buffer[12]);
+			memcpy(term->camera.bmControls, &buffer[15], n);
+		} else if (UVC_ENTITY_TYPE(term) == ITT_MEDIA_TRANSPORT_INPUT) {
+			term->media.bControlSize = n;
+			term->media.bmControls = (__u8 *)term + sizeof *term;
+			term->media.bTransportModeSize = p;
+			term->media.bmTransportModes = (__u8 *)term
+						     + sizeof *term + n;
+			memcpy(term->media.bmControls, &buffer[9], n);
+			memcpy(term->media.bmTransportModes, &buffer[10+n], p);
+		}
+
+		if (buffer[7] != 0)
+			usb_string(udev, buffer[7], term->name,
+				   sizeof term->name);
+		else if (UVC_ENTITY_TYPE(term) == ITT_CAMERA)
+			sprintf(term->name, "Camera %u", buffer[3]);
+		else if (UVC_ENTITY_TYPE(term) == ITT_MEDIA_TRANSPORT_INPUT)
+			sprintf(term->name, "Media %u", buffer[3]);
+		else
+			sprintf(term->name, "Input %u", buffer[3]);
+
+		list_add_tail(&term->list, &dev->entities);
+		break;
+
+	case VC_OUTPUT_TERMINAL:
+		if (buflen < 9) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
+				"interface %d OUTPUT_TERMINAL error\n",
+				udev->devnum, alts->desc.bInterfaceNumber);
+			return -EINVAL;
+		}
+
+		/* Make sure the terminal type MSB is not null, otherwise it
+		 * could be confused with a unit.
+		 */
+		type = le16_to_cpup((__le16 *)&buffer[4]);
+		if ((type & 0xff00) == 0) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
+				"interface %d OUTPUT_TERMINAL %d has invalid "
+				"type 0x%04x, skipping\n", udev->devnum,
+				alts->desc.bInterfaceNumber, buffer[3], type);
+			return 0;
+		}
+
+		term = kzalloc(sizeof *term, GFP_KERNEL);
+		if (term == NULL)
+			return -ENOMEM;
+
+		term->id = buffer[3];
+		term->type = type | UVC_TERM_OUTPUT;
+		term->output.bSourceID = buffer[7];
+
+		if (buffer[8] != 0)
+			usb_string(udev, buffer[8], term->name,
+				   sizeof term->name);
+		else
+			sprintf(term->name, "Output %u", buffer[3]);
+
+		list_add_tail(&term->list, &dev->entities);
+		break;
+
+	case VC_SELECTOR_UNIT:
+		p = buflen >= 5 ? buffer[4] : 0;
+
+		if (buflen < 5 || buflen < 6 + p) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
+				"interface %d SELECTOR_UNIT error\n",
+				udev->devnum, alts->desc.bInterfaceNumber);
+			return -EINVAL;
+		}
+
+		unit = kzalloc(sizeof *unit + p, GFP_KERNEL);
+		if (unit == NULL)
+			return -ENOMEM;
+
+		unit->id = buffer[3];
+		unit->type = buffer[2];
+		unit->selector.bNrInPins = buffer[4];
+		unit->selector.baSourceID = (__u8 *)unit + sizeof *unit;
+		memcpy(unit->selector.baSourceID, &buffer[5], p);
+
+		if (buffer[5+p] != 0)
+			usb_string(udev, buffer[5+p], unit->name,
+				   sizeof unit->name);
+		else
+			sprintf(unit->name, "Selector %u", buffer[3]);
+
+		list_add_tail(&unit->list, &dev->entities);
+		break;
+
+	case VC_PROCESSING_UNIT:
+		n = buflen >= 8 ? buffer[7] : 0;
+		p = dev->uvc_version >= 0x0110 ? 10 : 9;
+
+		if (buflen < p + n) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
+				"interface %d PROCESSING_UNIT error\n",
+				udev->devnum, alts->desc.bInterfaceNumber);
+			return -EINVAL;
+		}
+
+		unit = kzalloc(sizeof *unit + n, GFP_KERNEL);
+		if (unit == NULL)
+			return -ENOMEM;
+
+		unit->id = buffer[3];
+		unit->type = buffer[2];
+		unit->processing.bSourceID = buffer[4];
+		unit->processing.wMaxMultiplier =
+			le16_to_cpup((__le16 *)&buffer[5]);
+		unit->processing.bControlSize = buffer[7];
+		unit->processing.bmControls = (__u8 *)unit + sizeof *unit;
+		memcpy(unit->processing.bmControls, &buffer[8], n);
+		if (dev->uvc_version >= 0x0110)
+			unit->processing.bmVideoStandards = buffer[9+n];
+
+		if (buffer[8+n] != 0)
+			usb_string(udev, buffer[8+n], unit->name,
+				   sizeof unit->name);
+		else
+			sprintf(unit->name, "Processing %u", buffer[3]);
+
+		list_add_tail(&unit->list, &dev->entities);
+		break;
+
+	case VC_EXTENSION_UNIT:
+		p = buflen >= 22 ? buffer[21] : 0;
+		n = buflen >= 24 + p ? buffer[22+p] : 0;
+
+		if (buflen < 24 + p + n) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
+				"interface %d EXTENSION_UNIT error\n",
+				udev->devnum, alts->desc.bInterfaceNumber);
+			return -EINVAL;
+		}
+
+		unit = kzalloc(sizeof *unit + p + n, GFP_KERNEL);
+		if (unit == NULL)
+			return -ENOMEM;
+
+		unit->id = buffer[3];
+		unit->type = buffer[2];
+		memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
+		unit->extension.bNumControls = buffer[20];
+		unit->extension.bNrInPins =
+			le16_to_cpup((__le16 *)&buffer[21]);
+		unit->extension.baSourceID = (__u8 *)unit + sizeof *unit;
+		memcpy(unit->extension.baSourceID, &buffer[22], p);
+		unit->extension.bControlSize = buffer[22+p];
+		unit->extension.bmControls = (__u8 *)unit + sizeof *unit + p;
+		memcpy(unit->extension.bmControls, &buffer[23+p], n);
+
+		if (buffer[23+p+n] != 0)
+			usb_string(udev, buffer[23+p+n], unit->name,
+				   sizeof unit->name);
+		else
+			sprintf(unit->name, "Extension %u", buffer[3]);
+
+		list_add_tail(&unit->list, &dev->entities);
+		break;
+
+	default:
+		uvc_trace(UVC_TRACE_DESCR, "Found an unknown CS_INTERFACE "
+			"descriptor (%u)\n", buffer[2]);
+		break;
+	}
+
+	return 0;
+}
+
+static int uvc_parse_control(struct uvc_device *dev)
+{
+	struct usb_host_interface *alts = dev->intf->cur_altsetting;
+	unsigned char *buffer = alts->extra;
+	int buflen = alts->extralen;
+	int ret;
+
+	/* Parse the default alternate setting only, as the UVC specification
+	 * defines a single alternate setting, the default alternate setting
+	 * zero.
+	 */
+
+	while (buflen > 2) {
+		if (uvc_parse_vendor_control(dev, buffer, buflen) ||
+		    buffer[1] != USB_DT_CS_INTERFACE)
+			goto next_descriptor;
+
+		if ((ret = uvc_parse_standard_control(dev, buffer, buflen)) < 0)
+			return ret;
+
+next_descriptor:
+		buflen -= buffer[0];
+		buffer += buffer[0];
+	}
+
+	/* Check if the optional status endpoint is present. */
+	if (alts->desc.bNumEndpoints == 1) {
+		struct usb_host_endpoint *ep = &alts->endpoint[0];
+		struct usb_endpoint_descriptor *desc = &ep->desc;
+
+		if (usb_endpoint_is_int_in(desc) &&
+		    le16_to_cpu(desc->wMaxPacketSize) >= 8 &&
+		    desc->bInterval != 0) {
+			uvc_trace(UVC_TRACE_DESCR, "Found a Status endpoint "
+				"(addr %02x).\n", desc->bEndpointAddress);
+			dev->int_ep = ep;
+		}
+	}
+
+	return 0;
+}
+
+/* ------------------------------------------------------------------------
+ * USB probe and disconnect
+ */
+
+/*
+ * Unregister the video devices.
+ */
+static void uvc_unregister_video(struct uvc_device *dev)
+{
+	if (dev->video.vdev) {
+		if (dev->video.vdev->minor == -1)
+			video_device_release(dev->video.vdev);
+		else
+			video_unregister_device(dev->video.vdev);
+		dev->video.vdev = NULL;
+	}
+}
+
+/*
+ * Scan the UVC descriptors to locate a chain starting at an Output Terminal
+ * and containing the following units:
+ *
+ * - a USB Streaming Output Terminal
+ * - zero or one Processing Unit
+ * - zero, one or mode single-input Selector Units
+ * - zero or one multiple-input Selector Units, provided all inputs are
+ *   connected to input terminals
+ * - zero, one or mode single-input Extension Units
+ * - one Camera Input Terminal, or one or more External terminals.
+ *
+ * A side forward scan is made on each detected entity to check for additional
+ * extension units.
+ */
+static int uvc_scan_chain_entity(struct uvc_video_device *video,
+	struct uvc_entity *entity)
+{
+	switch (UVC_ENTITY_TYPE(entity)) {
+	case VC_EXTENSION_UNIT:
+		if (uvc_trace_param & UVC_TRACE_PROBE)
+			printk(" <- XU %d", entity->id);
+
+		if (entity->extension.bNrInPins != 1) {
+			uvc_trace(UVC_TRACE_DESCR, "Extension unit %d has more "
+				"than 1 input pin.\n", entity->id);
+			return -1;
+		}
+
+		list_add_tail(&entity->chain, &video->extensions);
+		break;
+
+	case VC_PROCESSING_UNIT:
+		if (uvc_trace_param & UVC_TRACE_PROBE)
+			printk(" <- PU %d", entity->id);
+
+		if (video->processing != NULL) {
+			uvc_trace(UVC_TRACE_DESCR, "Found multiple "
+				"Processing Units in chain.\n");
+			return -1;
+		}
+
+		video->processing = entity;
+		break;
+
+	case VC_SELECTOR_UNIT:
+		if (uvc_trace_param & UVC_TRACE_PROBE)
+			printk(" <- SU %d", entity->id);
+
+		/* Single-input selector units are ignored. */
+		if (entity->selector.bNrInPins == 1)
+			break;
+
+		if (video->selector != NULL) {
+			uvc_trace(UVC_TRACE_DESCR, "Found multiple Selector "
+				"Units in chain.\n");
+			return -1;
+		}
+
+		video->selector = entity;
+		break;
+
+	case ITT_VENDOR_SPECIFIC:
+	case ITT_CAMERA:
+	case ITT_MEDIA_TRANSPORT_INPUT:
+		if (uvc_trace_param & UVC_TRACE_PROBE)
+			printk(" <- IT %d\n", entity->id);
+
+		list_add_tail(&entity->chain, &video->iterms);
+		break;
+
+	default:
+		uvc_trace(UVC_TRACE_DESCR, "Unsupported entity type "
+			"0x%04x found in chain.\n", UVC_ENTITY_TYPE(entity));
+		return -1;
+	}
+
+	return 0;
+}
+
+static int uvc_scan_chain_forward(struct uvc_video_device *video,
+	struct uvc_entity *entity, struct uvc_entity *prev)
+{
+	struct uvc_entity *forward;
+	int found;
+
+	/* Forward scan */
+	forward = NULL;
+	found = 0;
+
+	while (1) {
+		forward = uvc_entity_by_reference(video->dev, entity->id,
+			forward);
+		if (forward == NULL)
+			break;
+
+		if (UVC_ENTITY_TYPE(forward) != VC_EXTENSION_UNIT ||
+		    forward == prev)
+			continue;
+
+		if (forward->extension.bNrInPins != 1) {
+			uvc_trace(UVC_TRACE_DESCR, "Extension unit %d has"
+				"more than 1 input pin.\n", entity->id);
+			return -1;
+		}
+
+		list_add_tail(&forward->chain, &video->extensions);
+		if (uvc_trace_param & UVC_TRACE_PROBE) {
+			if (!found)
+				printk(" (-> XU");
+
+			printk(" %d", forward->id);
+			found = 1;
+		}
+	}
+	if (found)
+		printk(")");
+
+	return 0;
+}
+
+static int uvc_scan_chain_backward(struct uvc_video_device *video,
+	struct uvc_entity *entity)
+{
+	struct uvc_entity *term;
+	int id = -1, i;
+
+	switch (UVC_ENTITY_TYPE(entity)) {
+	case VC_EXTENSION_UNIT:
+		id = entity->extension.baSourceID[0];
+		break;
+
+	case VC_PROCESSING_UNIT:
+		id = entity->processing.bSourceID;
+		break;
+
+	case VC_SELECTOR_UNIT:
+		/* Single-input selector units are ignored. */
+		if (entity->selector.bNrInPins == 1) {
+			id = entity->selector.baSourceID[0];
+			break;
+		}
+
+		if (uvc_trace_param & UVC_TRACE_PROBE)
+			printk(" <- IT");
+
+		video->selector = entity;
+		for (i = 0; i < entity->selector.bNrInPins; ++i) {
+			id = entity->selector.baSourceID[i];
+			term = uvc_entity_by_id(video->dev, id);
+			if (term == NULL || !UVC_ENTITY_IS_ITERM(term)) {
+				uvc_trace(UVC_TRACE_DESCR, "Selector unit %d "
+					"input %d isn't connected to an "
+					"input terminal\n", entity->id, i);
+				return -1;
+			}
+
+			if (uvc_trace_param & UVC_TRACE_PROBE)
+				printk(" %d", term->id);
+
+			list_add_tail(&term->chain, &video->iterms);
+			uvc_scan_chain_forward(video, term, entity);
+		}
+
+		if (uvc_trace_param & UVC_TRACE_PROBE)
+			printk("\n");
+
+		id = 0;
+		break;
+	}
+
+	return id;
+}
+
+static int uvc_scan_chain(struct uvc_video_device *video)
+{
+	struct uvc_entity *entity, *prev;
+	int id;
+
+	entity = video->oterm;
+	uvc_trace(UVC_TRACE_PROBE, "Scanning UVC chain: OT %d", entity->id);
+	id = entity->output.bSourceID;
+	while (id != 0) {
+		prev = entity;
+		entity = uvc_entity_by_id(video->dev, id);
+		if (entity == NULL) {
+			uvc_trace(UVC_TRACE_DESCR, "Found reference to "
+				"unknown entity %d.\n", id);
+			return -1;
+		}
+
+		/* Process entity */
+		if (uvc_scan_chain_entity(video, entity) < 0)
+			return -1;
+
+		/* Forward scan */
+		if (uvc_scan_chain_forward(video, entity, prev) < 0)
+			return -1;
+
+		/* Stop when a terminal is found. */
+		if (!UVC_ENTITY_IS_UNIT(entity))
+			break;
+
+		/* Backward scan */
+		id = uvc_scan_chain_backward(video, entity);
+		if (id < 0)
+			return id;
+	}
+
+	/* Initialize the video buffers queue. */
+	uvc_queue_init(&video->queue);
+
+	return 0;
+}
+
+/*
+ * Register the video devices.
+ *
+ * The driver currently supports a single video device per control interface
+ * only. The terminal and units must match the following structure:
+ *
+ * ITT_CAMERA -> VC_PROCESSING_UNIT -> VC_EXTENSION_UNIT{0,n} -> TT_STREAMING
+ *
+ * The Extension Units, if present, must have a single input pin. The
+ * Processing Unit and Extension Units can be in any order. Additional
+ * Extension Units connected to the main chain as single-unit branches are
+ * also supported.
+ */
+static int uvc_register_video(struct uvc_device *dev)
+{
+	struct video_device *vdev;
+	struct uvc_entity *term;
+	int found = 0, ret;
+
+	/* Check if the control interface matches the structure we expect. */
+	list_for_each_entry(term, &dev->entities, list) {
+		struct uvc_streaming *streaming;
+
+		if (UVC_ENTITY_TYPE(term) != TT_STREAMING)
+			continue;
+
+		memset(&dev->video, 0, sizeof dev->video);
+		mutex_init(&dev->video.ctrl_mutex);
+		INIT_LIST_HEAD(&dev->video.iterms);
+		INIT_LIST_HEAD(&dev->video.extensions);
+		dev->video.oterm = term;
+		dev->video.dev = dev;
+		if (uvc_scan_chain(&dev->video) < 0)
+			continue;
+
+		list_for_each_entry(streaming, &dev->streaming, list) {
+			if (streaming->header.bTerminalLink == term->id) {
+				dev->video.streaming = streaming;
+				found = 1;
+				break;
+			}
+		}
+
+		if (found)
+			break;
+	}
+
+	if (!found) {
+		uvc_printk(KERN_INFO, "No valid video chain found.\n");
+		return -1;
+	}
+
+	if (uvc_trace_param & UVC_TRACE_PROBE) {
+		uvc_printk(KERN_INFO, "Found a valid video chain (");
+		list_for_each_entry(term, &dev->video.iterms, chain) {
+			printk("%d", term->id);
+			if (term->chain.next != &dev->video.iterms)
+				printk(",");
+		}
+		printk(" -> %d).\n", dev->video.oterm->id);
+	}
+
+	/* Initialize the streaming interface with default streaming
+	 * parameters.
+	 */
+	if ((ret = uvc_video_init(&dev->video)) < 0) {
+		uvc_printk(KERN_ERR, "Failed to initialize the device "
+			"(%d).\n", ret);
+		return ret;
+	}
+
+	/* Register the device with V4L. */
+	vdev = video_device_alloc();
+	if (vdev == NULL)
+		return -1;
+
+	/* We already hold a reference to dev->udev. The video device will be
+	 * unregistered before the reference is released, so we don't need to
+	 * get another one.
+	 */
+	vdev->dev = &dev->intf->dev;
+	vdev->type = 0;
+	vdev->type2 = 0;
+	vdev->minor = -1;
+	vdev->fops = &uvc_fops;
+	vdev->release = video_device_release;
+	strncpy(vdev->name, dev->name, sizeof vdev->name);
+
+	/* Set the driver data before calling video_register_device, otherwise
+	 * uvc_v4l2_open might race us.
+	 *
+	 * FIXME: usb_set_intfdata hasn't been called so far. Is that a
+	 * 	  problem ? Does any function which could be called here get
+	 * 	  a pointer to the usb_interface ?
+	 */
+	dev->video.vdev = vdev;
+	video_set_drvdata(vdev, &dev->video);
+
+	if (video_register_device(vdev, VFL_TYPE_GRABBER, -1) < 0) {
+		dev->video.vdev = NULL;
+		video_device_release(vdev);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Delete the UVC device.
+ *
+ * Called by the kernel when the last reference to the uvc_device structure
+ * is released.
+ *
+ * Unregistering the video devices is done here because every opened instance
+ * must be closed before the device can be unregistered. An alternative would
+ * have been to use another reference count for uvc_v4l2_open/uvc_release, and
+ * unregister the video devices on disconnect when that reference count drops
+ * to zero.
+ *
+ * As this function is called after or during disconnect(), all URBs have
+ * already been canceled by the USB core. There is no need to kill the
+ * interrupt URB manually.
+ */
+void uvc_delete(struct kref *kref)
+{
+	struct uvc_device *dev = container_of(kref, struct uvc_device, kref);
+	struct list_head *p, *n;
+
+	/* Unregister the video device */
+	uvc_unregister_video(dev);
+	usb_put_intf(dev->intf);
+	usb_put_dev(dev->udev);
+
+	uvc_status_cleanup(dev);
+	uvc_ctrl_cleanup_device(dev);
+
+	list_for_each_safe(p, n, &dev->entities) {
+		struct uvc_entity *entity;
+		entity = list_entry(p, struct uvc_entity, list);
+		kfree(entity);
+	}
+
+	list_for_each_safe(p, n, &dev->streaming) {
+		struct uvc_streaming *streaming;
+		streaming = list_entry(p, struct uvc_streaming, list);
+		usb_put_intf(streaming->intf);
+		kfree(streaming->format);
+		kfree(streaming->header.bmaControls);
+		kfree(streaming);
+	}
+
+	kfree(dev);
+}
+
+static int uvc_probe(struct usb_interface *intf,
+		     const struct usb_device_id *id)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct uvc_device *dev;
+	int ret;
+
+	if (id->idVendor && id->idProduct)
+		uvc_trace(UVC_TRACE_PROBE, "Probing known UVC device %s "
+				"(%04x:%04x)\n", udev->devpath, id->idVendor,
+				id->idProduct);
+	else
+		uvc_trace(UVC_TRACE_PROBE, "Probing generic UVC device %s\n",
+				udev->devpath);
+
+	/* Allocate memory for the device and initialize it */
+	if ((dev = kzalloc(sizeof *dev, GFP_KERNEL)) == NULL)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&dev->entities);
+	INIT_LIST_HEAD(&dev->streaming);
+	kref_init(&dev->kref);
+
+	dev->udev = usb_get_dev(udev);
+	dev->intf = usb_get_intf(intf);
+	dev->intfnum = intf->cur_altsetting->desc.bInterfaceNumber;
+	dev->quirks = id->driver_info | uvc_quirks_param;
+
+	if (udev->product != NULL)
+		strncpy(dev->name, udev->product, sizeof dev->name);
+	else
+		snprintf(dev->name, sizeof dev->name,
+			"UVC Camera (%04x:%04x)",
+			le16_to_cpu(udev->descriptor.idVendor),
+			le16_to_cpu(udev->descriptor.idProduct));
+
+	/* Parse the Video Class control descriptor */
+	if (uvc_parse_control(dev) < 0) {
+		uvc_trace(UVC_TRACE_PROBE, "Unable to parse UVC "
+			"descriptors.\n");
+		goto error;
+	}
+
+	uvc_printk(KERN_INFO, "Found UVC %u.%02u device %s (%04x:%04x)\n",
+		dev->uvc_version >> 8, dev->uvc_version & 0xff,
+		udev->product ? udev->product : "<unnamed>",
+		le16_to_cpu(udev->descriptor.idVendor),
+		le16_to_cpu(udev->descriptor.idProduct));
+
+	if (uvc_quirks_param != 0) {
+		uvc_printk(KERN_INFO, "Forcing device quirks 0x%x by module "
+			"parameter for testing purpose.\n", uvc_quirks_param);
+		uvc_printk(KERN_INFO, "Please report required quirks to the "
+			"linux-uvc-devel mailing list.\n");
+	}
+
+	/* Initialize controls */
+	if (uvc_ctrl_init_device(dev) < 0)
+		goto error;
+
+	/* Register the video devices */
+	if (uvc_register_video(dev) < 0)
+		goto error;
+
+	/* Save our data pointer in the interface data */
+	usb_set_intfdata(intf, dev);
+
+	/* Initialize the interrupt URB */
+	if ((ret = uvc_status_init(dev)) < 0) {
+		uvc_printk(KERN_INFO, "Unable to initialize the status "
+			"endpoint (%d), status interrupt will not be "
+			"supported.\n", ret);
+	}
+
+	uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
+	return 0;
+
+error:
+	kref_put(&dev->kref, uvc_delete);
+	return -ENODEV;
+}
+
+static void uvc_disconnect(struct usb_interface *intf)
+{
+	struct uvc_device *dev = usb_get_intfdata(intf);
+
+	/* Set the USB interface data to NULL. This can be done outside the
+	 * lock, as there's no other reader.
+	 */
+	usb_set_intfdata(intf, NULL);
+
+	if (intf->cur_altsetting->desc.bInterfaceSubClass == SC_VIDEOSTREAMING)
+		return;
+
+	/* uvc_v4l2_open() might race uvc_disconnect(). A static driver-wide
+	 * lock is needed to prevent uvc_disconnect from releasing its
+	 * reference to the uvc_device instance after uvc_v4l2_open() received
+	 * the pointer to the device (video_devdata) but before it got the
+	 * chance to increase the reference count (kref_get). An alternative
+	 * (used by the usb-skeleton driver) would have been to use the big
+	 * kernel lock instead of a driver-specific mutex (open calls on
+	 * char devices are protected by the BKL), but that approach is not
+	 * recommended for new code.
+	 */
+	mutex_lock(&uvc_driver.open_mutex);
+
+	dev->state |= UVC_DEV_DISCONNECTED;
+	kref_put(&dev->kref, uvc_delete);
+
+	mutex_unlock(&uvc_driver.open_mutex);
+}
+
+static int uvc_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct uvc_device *dev = usb_get_intfdata(intf);
+
+	uvc_trace(UVC_TRACE_SUSPEND, "Suspending interface %u\n",
+		intf->cur_altsetting->desc.bInterfaceNumber);
+
+	/* Controls are cached on the fly so they don't need to be saved. */
+	if (intf->cur_altsetting->desc.bInterfaceSubClass == SC_VIDEOCONTROL)
+		return uvc_status_suspend(dev);
+
+	if (dev->video.streaming->intf != intf) {
+		uvc_trace(UVC_TRACE_SUSPEND, "Suspend: video streaming USB "
+				"interface mismatch.\n");
+		return -EINVAL;
+	}
+
+	return uvc_video_suspend(&dev->video);
+}
+
+static int uvc_resume(struct usb_interface *intf)
+{
+	struct uvc_device *dev = usb_get_intfdata(intf);
+	int ret;
+
+	uvc_trace(UVC_TRACE_SUSPEND, "Resuming interface %u\n",
+		intf->cur_altsetting->desc.bInterfaceNumber);
+
+	if (intf->cur_altsetting->desc.bInterfaceSubClass == SC_VIDEOCONTROL) {
+		if ((ret = uvc_ctrl_resume_device(dev)) < 0)
+			return ret;
+
+		return uvc_status_resume(dev);
+	}
+
+	if (dev->video.streaming->intf != intf) {
+		uvc_trace(UVC_TRACE_SUSPEND, "Resume: video streaming USB "
+				"interface mismatch.\n");
+		return -EINVAL;
+	}
+
+	return uvc_video_resume(&dev->video);
+}
+
+/* ------------------------------------------------------------------------
+ * Driver initialization and cleanup
+ */
+
+/*
+ * The Logitech cameras listed below have their interface class set to
+ * VENDOR_SPEC because they don't announce themselves as UVC devices, even
+ * though they are compliant.
+ */
+static struct usb_device_id uvc_ids[] = {
+	/* ALi M5606 (Clevo M540SR) */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x0402,
+	  .idProduct		= 0x5606,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	/* Creative Live! Optia */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x041e,
+	  .idProduct		= 0x4057,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	/* Microsoft Lifecam NX-6000 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x045e,
+	  .idProduct		= 0x00f8,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	/* Microsoft Lifecam VX-7000 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x045e,
+	  .idProduct		= 0x0723,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	/* Logitech Quickcam Fusion */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x046d,
+	  .idProduct		= 0x08c1,
+	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0 },
+	/* Logitech Quickcam Orbit MP */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x046d,
+	  .idProduct		= 0x08c2,
+	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0 },
+	/* Logitech Quickcam Pro for Notebook */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x046d,
+	  .idProduct		= 0x08c3,
+	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0 },
+	/* Logitech Quickcam Pro 5000 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x046d,
+	  .idProduct		= 0x08c5,
+	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0 },
+	/* Logitech Quickcam OEM Dell Notebook */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x046d,
+	  .idProduct		= 0x08c6,
+	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0 },
+	/* Logitech Quickcam OEM Cisco VT Camera II */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x046d,
+	  .idProduct		= 0x08c7,
+	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0 },
+	/* Apple Built-In iSight */
+	{ .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x05ac,
+	  .idProduct		= 0x8501,
+	  .bInterfaceClass      = USB_CLASS_VIDEO,
+	  .bInterfaceSubClass   = 1,
+	  .bInterfaceProtocol   = 0,
+	  .driver_info 		= UVC_QUIRK_PROBE_MINMAX
+				| UVC_QUIRK_BUILTIN_ISIGHT },
+	/* Genesys Logic USB 2.0 PC Camera */
+	{ .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor             = 0x05e3,
+	  .idProduct            = 0x0505,
+	  .bInterfaceClass      = USB_CLASS_VIDEO,
+	  .bInterfaceSubClass   = 1,
+	  .bInterfaceProtocol   = 0,
+	  .driver_info          = UVC_QUIRK_STREAM_NO_FID },
+	/* Silicon Motion SM371 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x090c,
+	  .idProduct		= 0xb371,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	/* MT6227 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x0e8d,
+	  .idProduct		= 0x0004,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	/* Syntek (HP Spartan) */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x174f,
+	  .idProduct		= 0x5212,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
+	/* Ecamm Pico iMage */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x18cd,
+	  .idProduct		= 0xcafe,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_EXTRAFIELDS },
+	/* Bodelin ProScopeHR */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x19ab,
+	  .idProduct		= 0x1000,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_STATUS_INTERVAL },
+	/* Acer OEM Webcam - Unknown vendor */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x5986,
+	  .idProduct		= 0x0100,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	/* Packard Bell OEM Webcam */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x5986,
+	  .idProduct		= 0x0101,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	/* Acer Crystal Eye webcam */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x5986,
+	  .idProduct		= 0x0102,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	/* Acer OrbiCam - Unknown vendor */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x5986,
+	  .idProduct		= 0x0200,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	/* Generic USB Video Class */
+	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, 0) },
+	{}
+};
+
+MODULE_DEVICE_TABLE(usb, uvc_ids);
+
+struct uvc_driver uvc_driver = {
+	.driver = {
+		.name		= "uvcvideo",
+		.probe		= uvc_probe,
+		.disconnect	= uvc_disconnect,
+		.suspend	= uvc_suspend,
+		.resume		= uvc_resume,
+		.id_table	= uvc_ids,
+		.supports_autosuspend = 1,
+	},
+};
+
+static int __init uvc_init(void)
+{
+	int result;
+
+	INIT_LIST_HEAD(&uvc_driver.devices);
+	INIT_LIST_HEAD(&uvc_driver.controls);
+	mutex_init(&uvc_driver.open_mutex);
+	mutex_init(&uvc_driver.ctrl_mutex);
+
+	uvc_ctrl_init();
+
+	result = usb_register(&uvc_driver.driver);
+	if (result == 0)
+		printk(KERN_INFO DRIVER_DESC " (" DRIVER_VERSION ")\n");
+	return result;
+}
+
+static void __exit uvc_cleanup(void)
+{
+	usb_deregister(&uvc_driver.driver);
+}
+
+module_init(uvc_init);
+module_exit(uvc_cleanup);
+
+module_param_named(quirks, uvc_quirks_param, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(quirks, "Forced device quirks");
+module_param_named(trace, uvc_trace_param, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(trace, "Trace level bitmask");
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRIVER_VERSION);
+
diff --git a/drivers/media/video/uvc/uvc_isight.c b/drivers/media/video/uvc/uvc_isight.c
new file mode 100644
index 0000000..37bdefd
--- /dev/null
+++ b/drivers/media/video/uvc/uvc_isight.c
@@ -0,0 +1,134 @@
+/*
+ *      uvc_isight.c  --  USB Video Class driver - iSight support
+ *
+ *	Copyright (C) 2006-2007
+ *		Ivan N. Zlatev <contact@i-nz.net>
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ */
+
+#include <linux/usb.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+
+#include "uvcvideo.h"
+
+/* Built-in iSight webcams implements most of UVC 1.0 except a
+ * different packet format. Instead of sending a header at the
+ * beginning of each isochronous transfer payload, the webcam sends a
+ * single header per image (on its own in a packet), followed by
+ * packets containing data only.
+ *
+ * Offset   Size (bytes)	Description
+ * ------------------------------------------------------------------
+ * 0x00 	1   	Header length
+ * 0x01 	1   	Flags (UVC-compliant)
+ * 0x02 	4   	Always equal to '11223344'
+ * 0x06 	8   	Always equal to 'deadbeefdeadface'
+ * 0x0e 	16  	Unknown
+ *
+ * The header can be prefixed by an optional, unknown-purpose byte.
+ */
+
+static int isight_decode(struct uvc_video_queue *queue, struct uvc_buffer *buf,
+		const __u8 *data, unsigned int len)
+{
+	static const __u8 hdr[] = {
+		0x11, 0x22, 0x33, 0x44,
+		0xde, 0xad, 0xbe, 0xef,
+		0xde, 0xad, 0xfa, 0xce
+	};
+
+	unsigned int maxlen, nbytes;
+	__u8 *mem;
+	int is_header = 0;
+
+	if (buf == NULL)
+		return 0;
+
+	if ((len >= 14 && memcmp(&data[2], hdr, 12) == 0) ||
+	    (len >= 15 && memcmp(&data[3], hdr, 12) == 0)) {
+		uvc_trace(UVC_TRACE_FRAME, "iSight header found\n");
+		is_header = 1;
+	}
+
+	/* Synchronize to the input stream by waiting for a header packet. */
+	if (buf->state != UVC_BUF_STATE_ACTIVE) {
+		if (!is_header) {
+			uvc_trace(UVC_TRACE_FRAME, "Dropping packet (out of "
+				  "sync).\n");
+			return 0;
+		}
+
+		buf->state = UVC_BUF_STATE_ACTIVE;
+	}
+
+	/* Mark the buffer as done if we're at the beginning of a new frame.
+	 *
+	 * Empty buffers (bytesused == 0) don't trigger end of frame detection
+	 * as it doesn't make sense to return an empty buffer.
+	 */
+	if (is_header && buf->buf.bytesused != 0) {
+		buf->state = UVC_BUF_STATE_DONE;
+		return -EAGAIN;
+	}
+
+	/* Copy the video data to the buffer. Skip header packets, as they
+	 * contain no data.
+	 */
+	if (!is_header) {
+		maxlen = buf->buf.length - buf->buf.bytesused;
+		mem = queue->mem + buf->buf.m.offset + buf->buf.bytesused;
+		nbytes = min(len, maxlen);
+		memcpy(mem, data, nbytes);
+		buf->buf.bytesused += nbytes;
+
+		if (len > maxlen || buf->buf.bytesused == buf->buf.length) {
+			uvc_trace(UVC_TRACE_FRAME, "Frame complete "
+				  "(overflow).\n");
+			buf->state = UVC_BUF_STATE_DONE;
+		}
+	}
+
+	return 0;
+}
+
+void uvc_video_decode_isight(struct urb *urb, struct uvc_video_device *video,
+		struct uvc_buffer *buf)
+{
+	int ret, i;
+
+	for (i = 0; i < urb->number_of_packets; ++i) {
+		if (urb->iso_frame_desc[i].status < 0) {
+			uvc_trace(UVC_TRACE_FRAME, "USB isochronous frame "
+				  "lost (%d).\n",
+				  urb->iso_frame_desc[i].status);
+		}
+
+		/* Decode the payload packet.
+		 * uvc_video_decode is entered twice when a frame transition
+		 * has been detected because the end of frame can only be
+		 * reliably detected when the first packet of the new frame
+		 * is processed. The first pass detects the transition and
+		 * closes the previous frame's buffer, the second pass
+		 * processes the data of the first payload of the new frame.
+		 */
+		do {
+			ret = isight_decode(&video->queue, buf,
+					urb->transfer_buffer +
+					urb->iso_frame_desc[i].offset,
+					urb->iso_frame_desc[i].actual_length);
+
+			if (buf == NULL)
+				break;
+
+			if (buf->state == UVC_BUF_STATE_DONE ||
+			    buf->state == UVC_BUF_STATE_ERROR)
+				buf = uvc_queue_next_buffer(&video->queue, buf);
+		} while (ret == -EAGAIN);
+	}
+}
diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
new file mode 100644
index 0000000..db29f89
--- /dev/null
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -0,0 +1,455 @@
+/*
+ *      uvc_queue.c  --  USB Video Class driver - Buffers management
+ *
+ *      Copyright (C) 2005-2008
+ *          Laurent Pinchart (laurent.pinchart@skynet.be)
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/videodev.h>
+#include <linux/vmalloc.h>
+#include <linux/wait.h>
+#include <asm/atomic.h>
+
+#include "uvcvideo.h"
+
+/* ------------------------------------------------------------------------
+ * Video buffers queue management.
+ *
+ * Video queues is initialized by uvc_queue_init(). The function performs
+ * basic initialization of the uvc_video_queue struct and never fails.
+ *
+ * Video buffer allocation and freeing are performed by uvc_alloc_buffers and
+ * uvc_free_buffers respectively. The former acquires the video queue lock,
+ * while the later must be called with the lock held (so that allocation can
+ * free previously allocated buffers). Trying to free buffers that are mapped
+ * to user space will return -EBUSY.
+ *
+ * Video buffers are managed using two queues. However, unlike most USB video
+ * drivers which use an in queue and an out queue, we use a main queue which
+ * holds all queued buffers (both 'empty' and 'done' buffers), and an irq
+ * queue which holds empty buffers. This design (copied from video-buf)
+ * minimizes locking in interrupt, as only one queue is shared between
+ * interrupt and user contexts.
+ *
+ * Use cases
+ * ---------
+ *
+ * Unless stated otherwise, all operations which modify the irq buffers queue
+ * are protected by the irq spinlock.
+ *
+ * 1. The user queues the buffers, starts streaming and dequeues a buffer.
+ *
+ *    The buffers are added to the main and irq queues. Both operations are
+ *    protected by the queue lock, and the latert is protected by the irq
+ *    spinlock as well.
+ *
+ *    The completion handler fetches a buffer from the irq queue and fills it
+ *    with video data. If no buffer is available (irq queue empty), the handler
+ *    returns immediately.
+ *
+ *    When the buffer is full, the completion handler removes it from the irq
+ *    queue, marks it as ready (UVC_BUF_STATE_DONE) and wake its wait queue.
+ *    At that point, any process waiting on the buffer will be woken up. If a
+ *    process tries to dequeue a buffer after it has been marked ready, the
+ *    dequeing will succeed immediately.
+ *
+ * 2. Buffers are queued, user is waiting on a buffer and the device gets
+ *    disconnected.
+ *
+ *    When the device is disconnected, the kernel calls the completion handler
+ *    with an appropriate status code. The handler marks all buffers in the
+ *    irq queue as being erroneous (UVC_BUF_STATE_ERROR) and wakes them up so
+ *    that any process waiting on a buffer gets woken up.
+ *
+ *    Waking up up the first buffer on the irq list is not enough, as the
+ *    process waiting on the buffer might restart the dequeue operation
+ *    immediately.
+ *
+ */
+
+void uvc_queue_init(struct uvc_video_queue *queue)
+{
+	mutex_init(&queue->mutex);
+	spin_lock_init(&queue->irqlock);
+	INIT_LIST_HEAD(&queue->mainqueue);
+	INIT_LIST_HEAD(&queue->irqqueue);
+}
+
+/*
+ * Allocate the video buffers.
+ *
+ * Pages are reserved to make sure they will not be swaped, as they will be
+ * filled in URB completion handler.
+ *
+ * Buffers will be individually mapped, so they must all be page aligned.
+ */
+int uvc_alloc_buffers(struct uvc_video_queue *queue, unsigned int nbuffers,
+		unsigned int buflength)
+{
+	unsigned int bufsize = PAGE_ALIGN(buflength);
+	unsigned int i;
+	void *mem = NULL;
+	int ret;
+
+	if (nbuffers > UVC_MAX_VIDEO_BUFFERS)
+		nbuffers = UVC_MAX_VIDEO_BUFFERS;
+
+	mutex_lock(&queue->mutex);
+
+	if ((ret = uvc_free_buffers(queue)) < 0)
+		goto done;
+
+	/* Bail out if no buffers should be allocated. */
+	if (nbuffers == 0)
+		goto done;
+
+	/* Decrement the number of buffers until allocation succeeds. */
+	for (; nbuffers > 0; --nbuffers) {
+		mem = vmalloc_32(nbuffers * bufsize);
+		if (mem != NULL)
+			break;
+	}
+
+	if (mem == NULL) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	for (i = 0; i < nbuffers; ++i) {
+		memset(&queue->buffer[i], 0, sizeof queue->buffer[i]);
+		queue->buffer[i].buf.index = i;
+		queue->buffer[i].buf.m.offset = i * bufsize;
+		queue->buffer[i].buf.length = buflength;
+		queue->buffer[i].buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		queue->buffer[i].buf.sequence = 0;
+		queue->buffer[i].buf.field = V4L2_FIELD_NONE;
+		queue->buffer[i].buf.memory = V4L2_MEMORY_MMAP;
+		queue->buffer[i].buf.flags = 0;
+		init_waitqueue_head(&queue->buffer[i].wait);
+	}
+
+	queue->mem = mem;
+	queue->count = nbuffers;
+	queue->buf_size = bufsize;
+	ret = nbuffers;
+
+done:
+	mutex_unlock(&queue->mutex);
+	return ret;
+}
+
+/*
+ * Free the video buffers.
+ *
+ * This function must be called with the queue lock held.
+ */
+int uvc_free_buffers(struct uvc_video_queue *queue)
+{
+	unsigned int i;
+
+	for (i = 0; i < queue->count; ++i) {
+		if (queue->buffer[i].vma_use_count != 0)
+			return -EBUSY;
+	}
+
+	if (queue->count) {
+		vfree(queue->mem);
+		queue->count = 0;
+	}
+
+	return 0;
+}
+
+static void __uvc_query_buffer(struct uvc_buffer *buf,
+		struct v4l2_buffer *v4l2_buf)
+{
+	memcpy(v4l2_buf, &buf->buf, sizeof *v4l2_buf);
+
+	if (buf->vma_use_count)
+		v4l2_buf->flags |= V4L2_BUF_FLAG_MAPPED;
+
+	switch (buf->state) {
+	case UVC_BUF_STATE_ERROR:
+	case UVC_BUF_STATE_DONE:
+		v4l2_buf->flags |= V4L2_BUF_FLAG_DONE;
+		break;
+	case UVC_BUF_STATE_QUEUED:
+	case UVC_BUF_STATE_ACTIVE:
+		v4l2_buf->flags |= V4L2_BUF_FLAG_QUEUED;
+		break;
+	case UVC_BUF_STATE_IDLE:
+	default:
+		break;
+	}
+}
+
+int uvc_query_buffer(struct uvc_video_queue *queue,
+		struct v4l2_buffer *v4l2_buf)
+{
+	int ret = 0;
+
+	mutex_lock(&queue->mutex);
+	if (v4l2_buf->index >= queue->count) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	__uvc_query_buffer(&queue->buffer[v4l2_buf->index], v4l2_buf);
+
+done:
+       mutex_unlock(&queue->mutex);
+       return ret;
+}
+
+/*
+ * Queue a video buffer. Attempting to queue a buffer that has already been
+ * queued will return -EINVAL.
+ */
+int uvc_queue_buffer(struct uvc_video_queue *queue,
+	struct v4l2_buffer *v4l2_buf)
+{
+	struct uvc_buffer *buf;
+	unsigned long flags;
+	int ret = 0;
+
+	uvc_trace(UVC_TRACE_CAPTURE, "Queuing buffer %u.\n", v4l2_buf->index);
+
+	if (v4l2_buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+	    v4l2_buf->memory != V4L2_MEMORY_MMAP) {
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Invalid buffer type (%u) "
+			"and/or memory (%u).\n", v4l2_buf->type,
+			v4l2_buf->memory);
+		return -EINVAL;
+	}
+
+	mutex_lock(&queue->mutex);
+	if (v4l2_buf->index >= queue->count)  {
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Out of range index.\n");
+		ret = -EINVAL;
+		goto done;
+	}
+
+	buf = &queue->buffer[v4l2_buf->index];
+	if (buf->state != UVC_BUF_STATE_IDLE) {
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Invalid buffer state "
+			"(%u).\n", buf->state);
+		ret = -EINVAL;
+		goto done;
+	}
+
+	buf->state = UVC_BUF_STATE_QUEUED;
+	buf->buf.bytesused = 0;
+	list_add_tail(&buf->stream, &queue->mainqueue);
+	spin_lock_irqsave(&queue->irqlock, flags);
+	list_add_tail(&buf->queue, &queue->irqqueue);
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+
+done:
+	mutex_unlock(&queue->mutex);
+	return ret;
+}
+
+static int uvc_queue_waiton(struct uvc_buffer *buf, int nonblocking)
+{
+	if (nonblocking) {
+		return (buf->state != UVC_BUF_STATE_QUEUED &&
+			buf->state != UVC_BUF_STATE_ACTIVE)
+			? 0 : -EAGAIN;
+	}
+
+	return wait_event_interruptible(buf->wait,
+		buf->state != UVC_BUF_STATE_QUEUED &&
+		buf->state != UVC_BUF_STATE_ACTIVE);
+}
+
+/*
+ * Dequeue a video buffer. If nonblocking is false, block until a buffer is
+ * available.
+ */
+int uvc_dequeue_buffer(struct uvc_video_queue *queue,
+		struct v4l2_buffer *v4l2_buf, int nonblocking)
+{
+	struct uvc_buffer *buf;
+	int ret = 0;
+
+	if (v4l2_buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+	    v4l2_buf->memory != V4L2_MEMORY_MMAP) {
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Invalid buffer type (%u) "
+			"and/or memory (%u).\n", v4l2_buf->type,
+			v4l2_buf->memory);
+		return -EINVAL;
+	}
+
+	mutex_lock(&queue->mutex);
+	if (list_empty(&queue->mainqueue)) {
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Empty buffer queue.\n");
+		ret = -EINVAL;
+		goto done;
+	}
+
+	buf = list_first_entry(&queue->mainqueue, struct uvc_buffer, stream);
+	if ((ret = uvc_queue_waiton(buf, nonblocking)) < 0)
+		goto done;
+
+	uvc_trace(UVC_TRACE_CAPTURE, "Dequeuing buffer %u (%u, %u bytes).\n",
+		buf->buf.index, buf->state, buf->buf.bytesused);
+
+	switch (buf->state) {
+	case UVC_BUF_STATE_ERROR:
+		uvc_trace(UVC_TRACE_CAPTURE, "[W] Corrupted data "
+			"(transmission error).\n");
+		ret = -EIO;
+	case UVC_BUF_STATE_DONE:
+		buf->state = UVC_BUF_STATE_IDLE;
+		break;
+
+	case UVC_BUF_STATE_IDLE:
+	case UVC_BUF_STATE_QUEUED:
+	case UVC_BUF_STATE_ACTIVE:
+	default:
+		uvc_trace(UVC_TRACE_CAPTURE, "[E] Invalid buffer state %u "
+			"(driver bug?).\n", buf->state);
+		ret = -EINVAL;
+		goto done;
+	}
+
+	list_del(&buf->stream);
+	__uvc_query_buffer(buf, v4l2_buf);
+
+done:
+	mutex_unlock(&queue->mutex);
+	return ret;
+}
+
+/*
+ * Poll the video queue.
+ *
+ * This function implements video queue polling and is intended to be used by
+ * the device poll handler.
+ */
+unsigned int uvc_queue_poll(struct uvc_video_queue *queue, struct file *file,
+		poll_table *wait)
+{
+	struct uvc_buffer *buf;
+	unsigned int mask = 0;
+
+	mutex_lock(&queue->mutex);
+	if (list_empty(&queue->mainqueue)) {
+		mask |= POLLERR;
+		goto done;
+	}
+	buf = list_first_entry(&queue->mainqueue, struct uvc_buffer, stream);
+
+	poll_wait(file, &buf->wait, wait);
+	if (buf->state == UVC_BUF_STATE_DONE ||
+	    buf->state == UVC_BUF_STATE_ERROR)
+		mask |= POLLIN | POLLRDNORM;
+
+done:
+	mutex_unlock(&queue->mutex);
+	return mask;
+}
+
+/*
+ * Enable or disable the video buffers queue.
+ *
+ * The queue must be enabled before starting video acquisition and must be
+ * disabled after stopping it. This ensures that the video buffers queue
+ * state can be properly initialized before buffers are accessed from the
+ * interrupt handler.
+ *
+ * Enabling the video queue initializes parameters (such as sequence number,
+ * sync pattern, ...). If the queue is already enabled, return -EBUSY.
+ *
+ * Disabling the video queue cancels the queue and removes all buffers from
+ * the main queue.
+ *
+ * This function can't be called from interrupt context. Use
+ * uvc_queue_cancel() instead.
+ */
+int uvc_queue_enable(struct uvc_video_queue *queue, int enable)
+{
+	unsigned int i;
+	int ret = 0;
+
+	mutex_lock(&queue->mutex);
+	if (enable) {
+		if (queue->streaming) {
+			ret = -EBUSY;
+			goto done;
+		}
+		queue->sequence = 0;
+		queue->streaming = 1;
+	} else {
+		uvc_queue_cancel(queue);
+		INIT_LIST_HEAD(&queue->mainqueue);
+
+		for (i = 0; i < queue->count; ++i)
+			queue->buffer[i].state = UVC_BUF_STATE_IDLE;
+
+		queue->streaming = 0;
+	}
+
+done:
+	mutex_unlock(&queue->mutex);
+	return ret;
+}
+
+/*
+ * Cancel the video buffers queue.
+ *
+ * Cancelling the queue marks all buffers on the irq queue as erroneous,
+ * wakes them up and remove them from the queue.
+ *
+ * This function acquires the irq spinlock and can be called from interrupt
+ * context.
+ */
+void uvc_queue_cancel(struct uvc_video_queue *queue)
+{
+	struct uvc_buffer *buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->irqlock, flags);
+	while (!list_empty(&queue->irqqueue)) {
+		buf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
+				       queue);
+		list_del(&buf->queue);
+		buf->state = UVC_BUF_STATE_ERROR;
+		wake_up(&buf->wait);
+	}
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+}
+
+struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
+		struct uvc_buffer *buf)
+{
+	struct uvc_buffer *nextbuf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->irqlock, flags);
+	list_del(&buf->queue);
+	if (!list_empty(&queue->irqqueue))
+		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
+					   queue);
+	else
+		nextbuf = NULL;
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+
+	buf->buf.sequence = queue->sequence++;
+	do_gettimeofday(&buf->buf.timestamp);
+
+	wake_up(&buf->wait);
+	return nextbuf;
+}
+
diff --git a/drivers/media/video/uvc/uvc_status.c b/drivers/media/video/uvc/uvc_status.c
new file mode 100644
index 0000000..f401c44
--- /dev/null
+++ b/drivers/media/video/uvc/uvc_status.c
@@ -0,0 +1,208 @@
+/*
+ *      uvc_status.c  --  USB Video Class driver - Status endpoint
+ *
+ *      Copyright (C) 2007-2008
+ *          Laurent Pinchart (laurent.pinchart@skynet.be)
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/input.h>
+#include <linux/usb.h>
+#include <linux/usb/input.h>
+
+#include "uvcvideo.h"
+
+/* --------------------------------------------------------------------------
+ * Input device
+ */
+static int uvc_input_init(struct uvc_device *dev)
+{
+	struct usb_device *udev = dev->udev;
+	struct input_dev *input;
+	char *phys = NULL;
+	int ret;
+
+	input = input_allocate_device();
+	if (input == NULL)
+		return -ENOMEM;
+
+	phys = kmalloc(6 + strlen(udev->bus->bus_name) + strlen(udev->devpath),
+			GFP_KERNEL);
+	if (phys == NULL) {
+		ret = -ENOMEM;
+		goto error;
+	}
+	sprintf(phys, "usb-%s-%s", udev->bus->bus_name, udev->devpath);
+
+	input->name = dev->name;
+	input->phys = phys;
+	usb_to_input_id(udev, &input->id);
+	input->dev.parent = &dev->intf->dev;
+
+	set_bit(EV_KEY, input->evbit);
+	set_bit(BTN_0, input->keybit);
+
+	if ((ret = input_register_device(input)) < 0)
+		goto error;
+
+	dev->input = input;
+	return 0;
+
+error:
+	input_free_device(input);
+	kfree(phys);
+	return ret;
+}
+
+static void uvc_input_cleanup(struct uvc_device *dev)
+{
+	if (dev->input)
+		input_unregister_device(dev->input);
+}
+
+/* --------------------------------------------------------------------------
+ * Status interrupt endpoint
+ */
+static void uvc_event_streaming(struct uvc_device *dev, __u8 *data, int len)
+{
+	if (len < 3) {
+		uvc_trace(UVC_TRACE_STATUS, "Invalid streaming status event "
+				"received.\n");
+		return;
+	}
+
+	if (data[2] == 0) {
+		if (len < 4)
+			return;
+		uvc_trace(UVC_TRACE_STATUS, "Button (intf %u) %s len %d\n",
+			data[1], data[3] ? "pressed" : "released", len);
+		if (dev->input)
+			input_report_key(dev->input, BTN_0, data[3]);
+	} else {
+		uvc_trace(UVC_TRACE_STATUS, "Stream %u error event %02x %02x "
+			"len %d.\n", data[1], data[2], data[3], len);
+	}
+}
+
+static void uvc_event_control(struct uvc_device *dev, __u8 *data, int len)
+{
+	char *attrs[3] = { "value", "info", "failure" };
+
+	if (len < 6 || data[2] != 0 || data[4] > 2) {
+		uvc_trace(UVC_TRACE_STATUS, "Invalid control status event "
+				"received.\n");
+		return;
+	}
+
+	uvc_trace(UVC_TRACE_STATUS, "Control %u/%u %s change len %d.\n",
+		data[1], data[3], attrs[data[4]], len);
+}
+
+static void uvc_status_complete(struct urb *urb)
+{
+	struct uvc_device *dev = urb->context;
+	int len, ret;
+
+	switch (urb->status) {
+	case 0:
+		break;
+
+	case -ENOENT:		/* usb_kill_urb() called. */
+	case -ECONNRESET:	/* usb_unlink_urb() called. */
+	case -ESHUTDOWN:	/* The endpoint is being disabled. */
+	case -EPROTO:		/* Device is disconnected (reported by some
+				 * host controller). */
+		return;
+
+	default:
+		uvc_printk(KERN_WARNING, "Non-zero status (%d) in status "
+			"completion handler.\n", urb->status);
+		return;
+	}
+
+	len = urb->actual_length;
+	if (len > 0) {
+		switch (dev->status[0] & 0x0f) {
+		case UVC_STATUS_TYPE_CONTROL:
+			uvc_event_control(dev, dev->status, len);
+			break;
+
+		case UVC_STATUS_TYPE_STREAMING:
+			uvc_event_streaming(dev, dev->status, len);
+			break;
+
+		default:
+			uvc_printk(KERN_INFO, "unknown event type %u.\n",
+				dev->status[0]);
+			break;
+		}
+	}
+
+	/* Resubmit the URB. */
+	urb->interval = dev->int_ep->desc.bInterval;
+	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
+		uvc_printk(KERN_ERR, "Failed to resubmit status URB (%d).\n",
+			ret);
+	}
+}
+
+int uvc_status_init(struct uvc_device *dev)
+{
+	struct usb_host_endpoint *ep = dev->int_ep;
+	unsigned int pipe;
+	int interval;
+
+	if (ep == NULL)
+		return 0;
+
+	uvc_input_init(dev);
+
+	dev->int_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (dev->int_urb == NULL)
+		return -ENOMEM;
+
+	pipe = usb_rcvintpipe(dev->udev, ep->desc.bEndpointAddress);
+
+	/* For high-speed interrupt endpoints, the bInterval value is used as
+	 * an exponent of two. Some developers forgot about it.
+	 */
+	interval = ep->desc.bInterval;
+	if (interval > 16 && dev->udev->speed == USB_SPEED_HIGH &&
+	    (dev->quirks & UVC_QUIRK_STATUS_INTERVAL))
+		interval = fls(interval) - 1;
+
+	usb_fill_int_urb(dev->int_urb, dev->udev, pipe,
+		dev->status, sizeof dev->status, uvc_status_complete,
+		dev, interval);
+
+	return usb_submit_urb(dev->int_urb, GFP_KERNEL);
+}
+
+void uvc_status_cleanup(struct uvc_device *dev)
+{
+	usb_kill_urb(dev->int_urb);
+	usb_free_urb(dev->int_urb);
+	uvc_input_cleanup(dev);
+}
+
+int uvc_status_suspend(struct uvc_device *dev)
+{
+	usb_kill_urb(dev->int_urb);
+	return 0;
+}
+
+int uvc_status_resume(struct uvc_device *dev)
+{
+	if (dev->int_urb == NULL)
+		return 0;
+
+	return usb_submit_urb(dev->int_urb, GFP_KERNEL);
+}
+
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
new file mode 100644
index 0000000..cce01cb
--- /dev/null
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -0,0 +1,1100 @@
+/*
+ *      uvc_v4l2.c  --  USB Video Class driver - V4L2 API
+ *
+ *      Copyright (C) 2005-2008
+ *          Laurent Pinchart (laurent.pinchart@skynet.be)
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/videodev.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/wait.h>
+#include <asm/atomic.h>
+
+#include <media/v4l2-common.h>
+
+#include "uvcvideo.h"
+
+/* ------------------------------------------------------------------------
+ * V4L2 interface
+ */
+
+/*
+ * Mapping V4L2 controls to UVC controls can be straighforward if done well.
+ * Most of the UVC controls exist in V4L2, and can be mapped directly. Some
+ * must be grouped (for instance the Red Balance, Blue Balance and Do White
+ * Balance V4L2 controls use the White Balance Component UVC control) or
+ * otherwise translated. The approach we take here is to use a translation
+ * table for the controls which can be mapped directly, and handle the others
+ * manually.
+ */
+static int uvc_v4l2_query_menu(struct uvc_video_device *video,
+	struct v4l2_querymenu *query_menu)
+{
+	struct uvc_menu_info *menu_info;
+	struct uvc_control_mapping *mapping;
+	struct uvc_control *ctrl;
+
+	ctrl = uvc_find_control(video, query_menu->id, &mapping);
+	if (ctrl == NULL || mapping->v4l2_type != V4L2_CTRL_TYPE_MENU)
+		return -EINVAL;
+
+	if (query_menu->index >= mapping->menu_count)
+		return -EINVAL;
+
+	menu_info = &mapping->menu_info[query_menu->index];
+	strncpy(query_menu->name, menu_info->name, 32);
+	return 0;
+}
+
+/*
+ * Find the frame interval closest to the requested frame interval for the
+ * given frame format and size. This should be done by the device as part of
+ * the Video Probe and Commit negotiation, but some hardware don't implement
+ * that feature.
+ */
+static __u32 uvc_try_frame_interval(struct uvc_frame *frame, __u32 interval)
+{
+	unsigned int i;
+
+	if (frame->bFrameIntervalType) {
+		__u32 best = -1, dist;
+
+		for (i = 0; i < frame->bFrameIntervalType; ++i) {
+			dist = interval > frame->dwFrameInterval[i]
+			     ? interval - frame->dwFrameInterval[i]
+			     : frame->dwFrameInterval[i] - interval;
+
+			if (dist > best)
+				break;
+
+			best = dist;
+		}
+
+		interval = frame->dwFrameInterval[i-1];
+	} else {
+		const __u32 min = frame->dwFrameInterval[0];
+		const __u32 max = frame->dwFrameInterval[1];
+		const __u32 step = frame->dwFrameInterval[2];
+
+		interval = min + (interval - min + step/2) / step * step;
+		if (interval > max)
+			interval = max;
+	}
+
+	return interval;
+}
+
+static int uvc_v4l2_try_format(struct uvc_video_device *video,
+	struct v4l2_format *fmt, struct uvc_streaming_control *probe,
+	struct uvc_format **uvc_format, struct uvc_frame **uvc_frame)
+{
+	struct uvc_format *format = NULL;
+	struct uvc_frame *frame = NULL;
+	__u16 rw, rh;
+	unsigned int d, maxd;
+	unsigned int i;
+	__u32 interval;
+	int ret = 0;
+	__u8 *fcc;
+
+	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	fcc = (__u8 *)&fmt->fmt.pix.pixelformat;
+	uvc_trace(UVC_TRACE_FORMAT, "Trying format 0x%08x (%c%c%c%c): %ux%u.\n",
+			fmt->fmt.pix.pixelformat,
+			fcc[0], fcc[1], fcc[2], fcc[3],
+			fmt->fmt.pix.width, fmt->fmt.pix.height);
+
+	/* Check if the hardware supports the requested format. */
+	for (i = 0; i < video->streaming->nformats; ++i) {
+		format = &video->streaming->format[i];
+		if (format->fcc == fmt->fmt.pix.pixelformat)
+			break;
+	}
+
+	if (format == NULL || format->fcc != fmt->fmt.pix.pixelformat) {
+		uvc_trace(UVC_TRACE_FORMAT, "Unsupported format 0x%08x.\n",
+				fmt->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	/* Find the closest image size. The distance between image sizes is
+	 * the size in pixels of the non-overlapping regions between the
+	 * requested size and the frame-specified size.
+	 */
+	rw = fmt->fmt.pix.width;
+	rh = fmt->fmt.pix.height;
+	maxd = (unsigned int)-1;
+
+	for (i = 0; i < format->nframes; ++i) {
+		__u16 w = format->frame[i].wWidth;
+		__u16 h = format->frame[i].wHeight;
+
+		d = min(w, rw) * min(h, rh);
+		d = w*h + rw*rh - 2*d;
+		if (d < maxd) {
+			maxd = d;
+			frame = &format->frame[i];
+		}
+
+		if (maxd == 0)
+			break;
+	}
+
+	if (frame == NULL) {
+		uvc_trace(UVC_TRACE_FORMAT, "Unsupported size %ux%u.\n",
+				fmt->fmt.pix.width, fmt->fmt.pix.height);
+		return -EINVAL;
+	}
+
+	/* Use the default frame interval. */
+	interval = frame->dwDefaultFrameInterval;
+	uvc_trace(UVC_TRACE_FORMAT, "Using default frame interval %u.%u us "
+		"(%u.%u fps).\n", interval/10, interval%10, 10000000/interval,
+		(100000000/interval)%10);
+
+	/* Set the format index, frame index and frame interval. */
+	memset(probe, 0, sizeof *probe);
+	probe->bmHint = 1;	/* dwFrameInterval */
+	probe->bFormatIndex = format->index;
+	probe->bFrameIndex = frame->bFrameIndex;
+	probe->dwFrameInterval = uvc_try_frame_interval(frame, interval);
+	/* Some webcams stall the probe control set request when the
+	 * dwMaxVideoFrameSize field is set to zero. The UVC specification
+	 * clearly states that the field is read-only from the host, so this
+	 * is a webcam bug. Set dwMaxVideoFrameSize to the value reported by
+	 * the webcam to work around the problem.
+	 *
+	 * The workaround could probably be enabled for all webcams, so the
+	 * quirk can be removed if needed. It's currently useful to detect
+	 * webcam bugs and fix them before they hit the market (providing
+	 * developers test their webcams with the Linux driver as well as with
+	 * the Windows driver).
+	 */
+	if (video->dev->quirks & UVC_QUIRK_PROBE_EXTRAFIELDS)
+		probe->dwMaxVideoFrameSize =
+			video->streaming->ctrl.dwMaxVideoFrameSize;
+
+	/* Probe the device */
+	if ((ret = uvc_probe_video(video, probe)) < 0)
+		goto done;
+
+	fmt->fmt.pix.width = frame->wWidth;
+	fmt->fmt.pix.height = frame->wHeight;
+	fmt->fmt.pix.field = V4L2_FIELD_NONE;
+	fmt->fmt.pix.bytesperline = format->bpp * frame->wWidth / 8;
+	fmt->fmt.pix.sizeimage = probe->dwMaxVideoFrameSize;
+	fmt->fmt.pix.colorspace = format->colorspace;
+	fmt->fmt.pix.priv = 0;
+
+	if (uvc_format != NULL)
+		*uvc_format = format;
+	if (uvc_frame != NULL)
+		*uvc_frame = frame;
+
+done:
+	return ret;
+}
+
+static int uvc_v4l2_get_format(struct uvc_video_device *video,
+	struct v4l2_format *fmt)
+{
+	struct uvc_format *format = video->streaming->cur_format;
+	struct uvc_frame *frame = video->streaming->cur_frame;
+
+	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (format == NULL || frame == NULL)
+		return -EINVAL;
+
+	fmt->fmt.pix.pixelformat = format->fcc;
+	fmt->fmt.pix.width = frame->wWidth;
+	fmt->fmt.pix.height = frame->wHeight;
+	fmt->fmt.pix.field = V4L2_FIELD_NONE;
+	fmt->fmt.pix.bytesperline = format->bpp * frame->wWidth / 8;
+	fmt->fmt.pix.sizeimage = video->streaming->ctrl.dwMaxVideoFrameSize;
+	fmt->fmt.pix.colorspace = format->colorspace;
+	fmt->fmt.pix.priv = 0;
+
+	return 0;
+}
+
+static int uvc_v4l2_set_format(struct uvc_video_device *video,
+	struct v4l2_format *fmt)
+{
+	struct uvc_streaming_control probe;
+	struct uvc_format *format;
+	struct uvc_frame *frame;
+	int ret;
+
+	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (video->queue.streaming)
+		return -EBUSY;
+
+	ret = uvc_v4l2_try_format(video, fmt, &probe, &format, &frame);
+	if (ret < 0)
+		return ret;
+
+	if ((ret = uvc_set_video_ctrl(video, &probe, 0)) < 0)
+		return ret;
+
+	memcpy(&video->streaming->ctrl, &probe, sizeof probe);
+	video->streaming->cur_format = format;
+	video->streaming->cur_frame = frame;
+
+	return 0;
+}
+
+static int uvc_v4l2_get_streamparm(struct uvc_video_device *video,
+		struct v4l2_streamparm *parm)
+{
+	uint32_t numerator, denominator;
+
+	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	numerator = video->streaming->ctrl.dwFrameInterval;
+	denominator = 10000000;
+	uvc_simplify_fraction(&numerator, &denominator, 8, 333);
+
+	memset(parm, 0, sizeof *parm);
+	parm->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	parm->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
+	parm->parm.capture.capturemode = 0;
+	parm->parm.capture.timeperframe.numerator = numerator;
+	parm->parm.capture.timeperframe.denominator = denominator;
+	parm->parm.capture.extendedmode = 0;
+	parm->parm.capture.readbuffers = 0;
+
+	return 0;
+}
+
+static int uvc_v4l2_set_streamparm(struct uvc_video_device *video,
+		struct v4l2_streamparm *parm)
+{
+	struct uvc_frame *frame = video->streaming->cur_frame;
+	struct uvc_streaming_control probe;
+	uint32_t interval;
+	int ret;
+
+	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (video->queue.streaming)
+		return -EBUSY;
+
+	memcpy(&probe, &video->streaming->ctrl, sizeof probe);
+	interval = uvc_fraction_to_interval(
+			parm->parm.capture.timeperframe.numerator,
+			parm->parm.capture.timeperframe.denominator);
+
+	uvc_trace(UVC_TRACE_FORMAT, "Setting frame interval to %u/%u (%u).\n",
+			parm->parm.capture.timeperframe.numerator,
+			parm->parm.capture.timeperframe.denominator,
+			interval);
+	probe.dwFrameInterval = uvc_try_frame_interval(frame, interval);
+
+	/* Probe the device with the new settings. */
+	if ((ret = uvc_probe_video(video, &probe)) < 0)
+		return ret;
+
+	/* Commit the new settings. */
+	if ((ret = uvc_set_video_ctrl(video, &probe, 0)) < 0)
+		return ret;
+
+	memcpy(&video->streaming->ctrl, &probe, sizeof probe);
+
+	/* Return the actual frame period. */
+	parm->parm.capture.timeperframe.numerator = probe.dwFrameInterval;
+	parm->parm.capture.timeperframe.denominator = 10000000;
+	uvc_simplify_fraction(&parm->parm.capture.timeperframe.numerator,
+				&parm->parm.capture.timeperframe.denominator,
+				8, 333);
+
+	return 0;
+}
+
+/* ------------------------------------------------------------------------
+ * Privilege management
+ */
+
+/*
+ * Privilege management is the multiple-open implementation basis. The current
+ * implementation is completely transparent for the end-user and doesn't
+ * require explicit use of the VIDIOC_G_PRIORITY and VIDIOC_S_PRIORITY ioctls.
+ * Those ioctls enable finer control on the device (by making possible for a
+ * user to request exclusive access to a device), but are not mature yet.
+ * Switching to the V4L2 priority mechanism might be considered in the future
+ * if this situation changes.
+ *
+ * Each open instance of a UVC device can either be in a privileged or
+ * unprivileged state. Only a single instance can be in a privileged state at
+ * a given time. Trying to perform an operation which requires privileges will
+ * automatically acquire the required privileges if possible, or return -EBUSY
+ * otherwise. Privileges are dismissed when closing the instance.
+ *
+ * Operations which require privileges are:
+ *
+ * - VIDIOC_S_INPUT
+ * - VIDIOC_S_PARM
+ * - VIDIOC_S_FMT
+ * - VIDIOC_TRY_FMT
+ * - VIDIOC_REQBUFS
+ */
+static int uvc_acquire_privileges(struct uvc_fh *handle)
+{
+	int ret = 0;
+
+	/* Always succeed if the handle is already privileged. */
+	if (handle->state == UVC_HANDLE_ACTIVE)
+		return 0;
+
+	/* Check if the device already has a privileged handle. */
+	mutex_lock(&uvc_driver.open_mutex);
+	if (atomic_inc_return(&handle->device->active) != 1) {
+		atomic_dec(&handle->device->active);
+		ret = -EBUSY;
+		goto done;
+	}
+
+	handle->state = UVC_HANDLE_ACTIVE;
+
+done:
+	mutex_unlock(&uvc_driver.open_mutex);
+	return ret;
+}
+
+static void uvc_dismiss_privileges(struct uvc_fh *handle)
+{
+	if (handle->state == UVC_HANDLE_ACTIVE)
+		atomic_dec(&handle->device->active);
+
+	handle->state = UVC_HANDLE_PASSIVE;
+}
+
+static int uvc_has_privileges(struct uvc_fh *handle)
+{
+	return handle->state == UVC_HANDLE_ACTIVE;
+}
+
+/* ------------------------------------------------------------------------
+ * V4L2 file operations
+ */
+
+static int uvc_v4l2_open(struct inode *inode, struct file *file)
+{
+	struct video_device *vdev;
+	struct uvc_video_device *video;
+	struct uvc_fh *handle;
+	int ret = 0;
+
+	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_open\n");
+	mutex_lock(&uvc_driver.open_mutex);
+	vdev = video_devdata(file);
+	video = video_get_drvdata(vdev);
+
+	if (video->dev->state & UVC_DEV_DISCONNECTED) {
+		ret = -ENODEV;
+		goto done;
+	}
+
+	ret = usb_autopm_get_interface(video->dev->intf);
+	if (ret < 0)
+		goto done;
+
+	/* Create the device handle. */
+	handle = kzalloc(sizeof *handle, GFP_KERNEL);
+	if (handle == NULL) {
+		usb_autopm_put_interface(video->dev->intf);
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	handle->device = video;
+	handle->state = UVC_HANDLE_PASSIVE;
+	file->private_data = handle;
+
+	kref_get(&video->dev->kref);
+
+done:
+	mutex_unlock(&uvc_driver.open_mutex);
+	return ret;
+}
+
+static int uvc_v4l2_release(struct inode *inode, struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_video_device *video = video_get_drvdata(vdev);
+	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
+
+	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_release\n");
+
+	/* Only free resources if this is a privileged handle. */
+	if (uvc_has_privileges(handle)) {
+		uvc_video_enable(video, 0);
+
+		mutex_lock(&video->queue.mutex);
+		if (uvc_free_buffers(&video->queue) < 0)
+			uvc_printk(KERN_ERR, "uvc_v4l2_release: Unable to "
+					"free buffers.\n");
+		mutex_unlock(&video->queue.mutex);
+	}
+
+	/* Release the file handle. */
+	uvc_dismiss_privileges(handle);
+	kfree(handle);
+	file->private_data = NULL;
+
+	usb_autopm_put_interface(video->dev->intf);
+	kref_put(&video->dev->kref, uvc_delete);
+	return 0;
+}
+
+static int uvc_v4l2_do_ioctl(struct inode *inode, struct file *file,
+		     unsigned int cmd, void *arg)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_video_device *video = video_get_drvdata(vdev);
+	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
+	int ret = 0;
+
+	if (uvc_trace_param & UVC_TRACE_IOCTL)
+		v4l_printk_ioctl(cmd);
+
+	switch (cmd) {
+	/* Query capabilities */
+	case VIDIOC_QUERYCAP:
+	{
+		struct v4l2_capability *cap = arg;
+
+		memset(cap, 0, sizeof *cap);
+		strncpy(cap->driver, "uvcvideo", sizeof cap->driver);
+		strncpy(cap->card, vdev->name, 32);
+		strncpy(cap->bus_info, video->dev->udev->bus->bus_name,
+			sizeof cap->bus_info);
+		cap->version = DRIVER_VERSION_NUMBER;
+		cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
+				  | V4L2_CAP_STREAMING;
+	}
+		break;
+
+	/* Get, Set & Query control */
+	case VIDIOC_QUERYCTRL:
+		return uvc_query_v4l2_ctrl(video, arg);
+
+	case VIDIOC_G_CTRL:
+	{
+		struct v4l2_control *ctrl = arg;
+		struct v4l2_ext_control xctrl;
+
+		memset(&xctrl, 0, sizeof xctrl);
+		xctrl.id = ctrl->id;
+
+		uvc_ctrl_begin(video);
+		ret = uvc_ctrl_get(video, &xctrl);
+		uvc_ctrl_rollback(video);
+		if (ret >= 0)
+			ctrl->value = xctrl.value;
+	}
+		break;
+
+	case VIDIOC_S_CTRL:
+	{
+		struct v4l2_control *ctrl = arg;
+		struct v4l2_ext_control xctrl;
+
+		memset(&xctrl, 0, sizeof xctrl);
+		xctrl.id = ctrl->id;
+		xctrl.value = ctrl->value;
+
+		uvc_ctrl_begin(video);
+		ret = uvc_ctrl_set(video, &xctrl);
+		if (ret < 0) {
+			uvc_ctrl_rollback(video);
+			return ret;
+		}
+		ret = uvc_ctrl_commit(video);
+	}
+		break;
+
+	case VIDIOC_QUERYMENU:
+		return uvc_v4l2_query_menu(video, arg);
+
+	case VIDIOC_G_EXT_CTRLS:
+	{
+		struct v4l2_ext_controls *ctrls = arg;
+		struct v4l2_ext_control *ctrl = ctrls->controls;
+		unsigned int i;
+
+		uvc_ctrl_begin(video);
+		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
+			ret = uvc_ctrl_get(video, ctrl);
+			if (ret < 0) {
+				uvc_ctrl_rollback(video);
+				ctrls->error_idx = i;
+				return ret;
+			}
+		}
+		ctrls->error_idx = 0;
+		ret = uvc_ctrl_rollback(video);
+	}
+		break;
+
+	case VIDIOC_S_EXT_CTRLS:
+	case VIDIOC_TRY_EXT_CTRLS:
+	{
+		struct v4l2_ext_controls *ctrls = arg;
+		struct v4l2_ext_control *ctrl = ctrls->controls;
+		unsigned int i;
+
+		ret = uvc_ctrl_begin(video);
+		if (ret < 0)
+			return ret;
+
+		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
+			ret = uvc_ctrl_set(video, ctrl);
+			if (ret < 0) {
+				uvc_ctrl_rollback(video);
+				ctrls->error_idx = i;
+				return ret;
+			}
+		}
+
+		ctrls->error_idx = 0;
+
+		if (cmd == VIDIOC_S_EXT_CTRLS)
+			ret = uvc_ctrl_commit(video);
+		else
+			ret = uvc_ctrl_rollback(video);
+	}
+		break;
+
+	/* Get, Set & Enum input */
+	case VIDIOC_ENUMINPUT:
+	{
+		const struct uvc_entity *selector = video->selector;
+		struct v4l2_input *input = arg;
+		struct uvc_entity *iterm = NULL;
+		u32 index = input->index;
+		int pin = 0;
+
+		if (selector == NULL) {
+			if (index != 0)
+				return -EINVAL;
+			iterm = list_first_entry(&video->iterms,
+					struct uvc_entity, chain);
+			pin = iterm->id;
+		} else if (pin < selector->selector.bNrInPins) {
+			pin = selector->selector.baSourceID[index];
+			list_for_each_entry(iterm, video->iterms.next, chain) {
+				if (iterm->id == pin)
+					break;
+			}
+		}
+
+		if (iterm == NULL || iterm->id != pin)
+			return -EINVAL;
+
+		memset(input, 0, sizeof *input);
+		input->index = index;
+		strncpy(input->name, iterm->name, sizeof input->name);
+		if (UVC_ENTITY_TYPE(iterm) == ITT_CAMERA)
+			input->type = V4L2_INPUT_TYPE_CAMERA;
+	}
+		break;
+
+	case VIDIOC_G_INPUT:
+	{
+		u8 input;
+
+		if (video->selector == NULL) {
+			*(int *)arg = 0;
+			break;
+		}
+
+		ret = uvc_query_ctrl(video->dev, GET_CUR, video->selector->id,
+			video->dev->intfnum, SU_INPUT_SELECT_CONTROL,
+			&input, 1);
+		if (ret < 0)
+			return ret;
+
+		*(int *)arg = input - 1;
+	}
+		break;
+
+	case VIDIOC_S_INPUT:
+	{
+		u8 input = *(u32 *)arg + 1;
+
+		if ((ret = uvc_acquire_privileges(handle)) < 0)
+			return ret;
+
+		if (video->selector == NULL) {
+			if (input != 1)
+				return -EINVAL;
+			break;
+		}
+
+		if (input > video->selector->selector.bNrInPins)
+			return -EINVAL;
+
+		return uvc_query_ctrl(video->dev, SET_CUR, video->selector->id,
+			video->dev->intfnum, SU_INPUT_SELECT_CONTROL,
+			&input, 1);
+	}
+
+	/* Try, Get, Set & Enum format */
+	case VIDIOC_ENUM_FMT:
+	{
+		struct v4l2_fmtdesc *fmt = arg;
+		struct uvc_format *format;
+
+		if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+		    fmt->index >= video->streaming->nformats)
+			return -EINVAL;
+
+		format = &video->streaming->format[fmt->index];
+		fmt->flags = 0;
+		if (format->flags & UVC_FMT_FLAG_COMPRESSED)
+			fmt->flags |= V4L2_FMT_FLAG_COMPRESSED;
+		strncpy(fmt->description, format->name,
+			sizeof fmt->description);
+		fmt->description[sizeof fmt->description - 1] = 0;
+		fmt->pixelformat = format->fcc;
+
+	}
+		break;
+
+	case VIDIOC_TRY_FMT:
+	{
+		struct uvc_streaming_control probe;
+
+		if ((ret = uvc_acquire_privileges(handle)) < 0)
+			return ret;
+
+		return uvc_v4l2_try_format(video, arg, &probe, NULL, NULL);
+	}
+
+	case VIDIOC_S_FMT:
+		if ((ret = uvc_acquire_privileges(handle)) < 0)
+			return ret;
+
+		return uvc_v4l2_set_format(video, arg);
+
+	case VIDIOC_G_FMT:
+		return uvc_v4l2_get_format(video, arg);
+
+	/* Frame size enumeration */
+	case VIDIOC_ENUM_FRAMESIZES:
+	{
+		struct v4l2_frmsizeenum *fsize = arg;
+		struct uvc_format *format = NULL;
+		struct uvc_frame *frame;
+		int i;
+
+		/* Look for the given pixel format */
+		for (i = 0; i < video->streaming->nformats; i++) {
+			if (video->streaming->format[i].fcc ==
+					fsize->pixel_format) {
+				format = &video->streaming->format[i];
+				break;
+			}
+		}
+		if (format == NULL)
+			return -EINVAL;
+
+		if (fsize->index >= format->nframes)
+			return -EINVAL;
+
+		frame = &format->frame[fsize->index];
+		fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+		fsize->discrete.width = frame->wWidth;
+		fsize->discrete.height = frame->wHeight;
+	}
+		break;
+
+	/* Frame interval enumeration */
+	case VIDIOC_ENUM_FRAMEINTERVALS:
+	{
+		struct v4l2_frmivalenum *fival = arg;
+		struct uvc_format *format = NULL;
+		struct uvc_frame *frame = NULL;
+		int i;
+
+		/* Look for the given pixel format and frame size */
+		for (i = 0; i < video->streaming->nformats; i++) {
+			if (video->streaming->format[i].fcc !=
+					fival->pixel_format) {
+				format = &video->streaming->format[i];
+				break;
+			}
+		}
+		if (format == NULL)
+			return -EINVAL;
+
+		for (i = 0; i < format->nframes; i++) {
+			if (format->frame[i].wWidth == fival->width &&
+			    format->frame[i].wHeight == fival->height) {
+				frame = &format->frame[i];
+				break;
+			}
+		}
+		if (frame == NULL)
+			return -EINVAL;
+
+		if (frame->bFrameIntervalType) {
+			if (fival->index >= frame->bFrameIntervalType)
+				return -EINVAL;
+
+			fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+			fival->discrete.numerator =
+				frame->dwFrameInterval[fival->index];
+			fival->discrete.denominator = 10000000;
+			uvc_simplify_fraction(&fival->discrete.numerator,
+				&fival->discrete.denominator, 8, 333);
+		} else {
+			fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
+			fival->stepwise.min.numerator =
+				frame->dwFrameInterval[0];
+			fival->stepwise.min.denominator = 10000000;
+			fival->stepwise.max.numerator =
+				frame->dwFrameInterval[1];
+			fival->stepwise.max.denominator = 10000000;
+			fival->stepwise.step.numerator =
+				frame->dwFrameInterval[2];
+			fival->stepwise.step.denominator = 10000000;
+			uvc_simplify_fraction(&fival->stepwise.min.numerator,
+				&fival->stepwise.min.denominator, 8, 333);
+			uvc_simplify_fraction(&fival->stepwise.max.numerator,
+				&fival->stepwise.max.denominator, 8, 333);
+			uvc_simplify_fraction(&fival->stepwise.step.numerator,
+				&fival->stepwise.step.denominator, 8, 333);
+		}
+	}
+		break;
+
+	/* Get & Set streaming parameters */
+	case VIDIOC_G_PARM:
+		return uvc_v4l2_get_streamparm(video, arg);
+
+	case VIDIOC_S_PARM:
+		if ((ret = uvc_acquire_privileges(handle)) < 0)
+			return ret;
+
+		return uvc_v4l2_set_streamparm(video, arg);
+
+	/* Cropping and scaling */
+	case VIDIOC_CROPCAP:
+	{
+		struct v4l2_cropcap *ccap = arg;
+		struct uvc_frame *frame = video->streaming->cur_frame;
+
+		if (ccap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			return -EINVAL;
+
+		ccap->bounds.left = 0;
+		ccap->bounds.top = 0;
+		ccap->bounds.width = frame->wWidth;
+		ccap->bounds.height = frame->wHeight;
+
+		ccap->defrect = ccap->bounds;
+
+		ccap->pixelaspect.numerator = 1;
+		ccap->pixelaspect.denominator = 1;
+	}
+		break;
+
+	case VIDIOC_G_CROP:
+	case VIDIOC_S_CROP:
+		return -EINVAL;
+
+	/* Buffers & streaming */
+	case VIDIOC_REQBUFS:
+	{
+		struct v4l2_requestbuffers *rb = arg;
+		unsigned int bufsize =
+			video->streaming->ctrl.dwMaxVideoFrameSize;
+
+		if (rb->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+		    rb->memory != V4L2_MEMORY_MMAP)
+			return -EINVAL;
+
+		if ((ret = uvc_acquire_privileges(handle)) < 0)
+			return ret;
+
+		ret = uvc_alloc_buffers(&video->queue, rb->count, bufsize);
+		if (ret < 0)
+			return ret;
+
+		rb->count = ret;
+		ret = 0;
+	}
+		break;
+
+	case VIDIOC_QUERYBUF:
+	{
+		struct v4l2_buffer *buf = arg;
+
+		if (buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			return -EINVAL;
+
+		if (!uvc_has_privileges(handle))
+			return -EBUSY;
+
+		return uvc_query_buffer(&video->queue, buf);
+	}
+
+	case VIDIOC_QBUF:
+		if (!uvc_has_privileges(handle))
+			return -EBUSY;
+
+		return uvc_queue_buffer(&video->queue, arg);
+
+	case VIDIOC_DQBUF:
+		if (!uvc_has_privileges(handle))
+			return -EBUSY;
+
+		return uvc_dequeue_buffer(&video->queue, arg,
+			file->f_flags & O_NONBLOCK);
+
+	case VIDIOC_STREAMON:
+	{
+		int *type = arg;
+
+		if (*type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			return -EINVAL;
+
+		if (!uvc_has_privileges(handle))
+			return -EBUSY;
+
+		if ((ret = uvc_video_enable(video, 1)) < 0)
+			return ret;
+	}
+		break;
+
+	case VIDIOC_STREAMOFF:
+	{
+		int *type = arg;
+
+		if (*type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			return -EINVAL;
+
+		if (!uvc_has_privileges(handle))
+			return -EBUSY;
+
+		return uvc_video_enable(video, 0);
+	}
+
+	/* Analog video standards make no sense for digital cameras. */
+	case VIDIOC_ENUMSTD:
+	case VIDIOC_QUERYSTD:
+	case VIDIOC_G_STD:
+	case VIDIOC_S_STD:
+
+	case VIDIOC_OVERLAY:
+
+	case VIDIOC_ENUMAUDIO:
+	case VIDIOC_ENUMAUDOUT:
+
+	case VIDIOC_ENUMOUTPUT:
+		uvc_trace(UVC_TRACE_IOCTL, "Unsupported ioctl 0x%08x\n", cmd);
+		return -EINVAL;
+
+	/* Dynamic controls. */
+	case UVCIOC_CTRL_ADD:
+	{
+		struct uvc_xu_control_info *xinfo = arg;
+		struct uvc_control_info *info;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		info = kmalloc(sizeof *info, GFP_KERNEL);
+		if (info == NULL)
+			return -ENOMEM;
+
+		memcpy(info->entity, xinfo->entity, sizeof info->entity);
+		info->index = xinfo->index;
+		info->selector = xinfo->selector;
+		info->size = xinfo->size;
+		info->flags = xinfo->flags;
+
+		info->flags |= UVC_CONTROL_GET_MIN | UVC_CONTROL_GET_MAX |
+				UVC_CONTROL_GET_RES | UVC_CONTROL_GET_DEF;
+
+		ret = uvc_ctrl_add_info(info);
+		if (ret < 0)
+			kfree(info);
+	}
+		break;
+
+	case UVCIOC_CTRL_MAP:
+	{
+		struct uvc_xu_control_mapping *xmap = arg;
+		struct uvc_control_mapping *map;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		map = kmalloc(sizeof *map, GFP_KERNEL);
+		if (map == NULL)
+			return -ENOMEM;
+
+		map->id = xmap->id;
+		memcpy(map->name, xmap->name, sizeof map->name);
+		memcpy(map->entity, xmap->entity, sizeof map->entity);
+		map->selector = xmap->selector;
+		map->size = xmap->size;
+		map->offset = xmap->offset;
+		map->v4l2_type = xmap->v4l2_type;
+		map->data_type = xmap->data_type;
+
+		ret = uvc_ctrl_add_mapping(map);
+		if (ret < 0)
+			kfree(map);
+	}
+		break;
+
+	case UVCIOC_CTRL_GET:
+		return uvc_xu_ctrl_query(video, arg, 0);
+
+	case UVCIOC_CTRL_SET:
+		return uvc_xu_ctrl_query(video, arg, 1);
+
+	default:
+		if ((ret = v4l_compat_translate_ioctl(inode, file, cmd, arg,
+			uvc_v4l2_do_ioctl)) == -ENOIOCTLCMD)
+			uvc_trace(UVC_TRACE_IOCTL, "Unknown ioctl 0x%08x\n",
+				  cmd);
+		return ret;
+	}
+
+	return ret;
+}
+
+static int uvc_v4l2_ioctl(struct inode *inode, struct file *file,
+		     unsigned int cmd, unsigned long arg)
+{
+	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_ioctl\n");
+	return video_usercopy(inode, file, cmd, arg, uvc_v4l2_do_ioctl);
+}
+
+static ssize_t uvc_v4l2_read(struct file *file, char __user *data,
+		    size_t count, loff_t *ppos)
+{
+	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_read: not implemented.\n");
+	return -ENODEV;
+}
+
+/*
+ * VMA operations.
+ */
+static void uvc_vm_open(struct vm_area_struct *vma)
+{
+	struct uvc_buffer *buffer = vma->vm_private_data;
+	buffer->vma_use_count++;
+}
+
+static void uvc_vm_close(struct vm_area_struct *vma)
+{
+	struct uvc_buffer *buffer = vma->vm_private_data;
+	buffer->vma_use_count--;
+}
+
+static struct vm_operations_struct uvc_vm_ops = {
+	.open		= uvc_vm_open,
+	.close		= uvc_vm_close,
+};
+
+static int uvc_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_video_device *video = video_get_drvdata(vdev);
+	struct uvc_buffer *buffer;
+	struct page *page;
+	unsigned long addr, start, size;
+	unsigned int i;
+	int ret = 0;
+
+	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_mmap\n");
+
+	start = vma->vm_start;
+	size = vma->vm_end - vma->vm_start;
+
+	mutex_lock(&video->queue.mutex);
+
+	for (i = 0; i < video->queue.count; ++i) {
+		buffer = &video->queue.buffer[i];
+		if ((buffer->buf.m.offset >> PAGE_SHIFT) == vma->vm_pgoff)
+			break;
+	}
+
+	if (i == video->queue.count || size != video->queue.buf_size) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	/*
+	 * VM_IO marks the area as being an mmaped region for I/O to a
+	 * device. It also prevents the region from being core dumped.
+	 */
+	vma->vm_flags |= VM_IO;
+
+	addr = (unsigned long)video->queue.mem + buffer->buf.m.offset;
+	while (size > 0) {
+		page = vmalloc_to_page((void *)addr);
+		if ((ret = vm_insert_page(vma, start, page)) < 0)
+			goto done;
+
+		start += PAGE_SIZE;
+		addr += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
+
+	vma->vm_ops = &uvc_vm_ops;
+	vma->vm_private_data = buffer;
+	uvc_vm_open(vma);
+
+done:
+	mutex_unlock(&video->queue.mutex);
+	return ret;
+}
+
+static unsigned int uvc_v4l2_poll(struct file *file, poll_table *wait)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct uvc_video_device *video = video_get_drvdata(vdev);
+
+	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_poll\n");
+
+	return uvc_queue_poll(&video->queue, file, wait);
+}
+
+struct file_operations uvc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= uvc_v4l2_open,
+	.release	= uvc_v4l2_release,
+	.ioctl		= uvc_v4l2_ioctl,
+	.compat_ioctl	= v4l_compat_ioctl32,
+	.llseek		= no_llseek,
+	.read		= uvc_v4l2_read,
+	.mmap		= uvc_v4l2_mmap,
+	.poll		= uvc_v4l2_poll,
+};
+
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
new file mode 100644
index 0000000..f4c84a2
--- /dev/null
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -0,0 +1,925 @@
+/*
+ *      uvc_video.c  --  USB Video Class driver - Video handling
+ *
+ *      Copyright (C) 2005-2008
+ *          Laurent Pinchart (laurent.pinchart@skynet.be)
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/videodev.h>
+#include <linux/vmalloc.h>
+#include <linux/wait.h>
+#include <asm/atomic.h>
+#include <asm/unaligned.h>
+
+#include <media/v4l2-common.h>
+
+#include "uvcvideo.h"
+
+/* ------------------------------------------------------------------------
+ * UVC Controls
+ */
+
+static int __uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
+			__u8 intfnum, __u8 cs, void *data, __u16 size,
+			int timeout)
+{
+	__u8 type = USB_TYPE_CLASS | USB_RECIP_INTERFACE;
+	unsigned int pipe;
+	int ret;
+
+	pipe = (query & 0x80) ? usb_rcvctrlpipe(dev->udev, 0)
+			      : usb_sndctrlpipe(dev->udev, 0);
+	type |= (query & 0x80) ? USB_DIR_IN : USB_DIR_OUT;
+
+	ret = usb_control_msg(dev->udev, pipe, query, type, cs << 8,
+			unit << 8 | intfnum, data, size, timeout);
+
+	if (ret != size) {
+		uvc_printk(KERN_ERR, "Failed to query (%u) UVC control %u "
+			"(unit %u) : %d (exp. %u).\n", query, cs, unit, ret,
+			size);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
+			__u8 intfnum, __u8 cs, void *data, __u16 size)
+{
+	return __uvc_query_ctrl(dev, query, unit, intfnum, cs, data, size,
+				UVC_CTRL_CONTROL_TIMEOUT);
+}
+
+static int uvc_get_video_ctrl(struct uvc_video_device *video,
+	struct uvc_streaming_control *ctrl, int probe, __u8 query)
+{
+	__u8 data[34];
+	__u8 size;
+	int ret;
+
+	size = video->dev->uvc_version >= 0x0110 ? 34 : 26;
+	ret = __uvc_query_ctrl(video->dev, query, 0, video->streaming->intfnum,
+		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, &data, size,
+		UVC_CTRL_STREAMING_TIMEOUT);
+
+	if (ret < 0)
+		return ret;
+
+	ctrl->bmHint = le16_to_cpup((__le16 *)&data[0]);
+	ctrl->bFormatIndex = data[2];
+	ctrl->bFrameIndex = data[3];
+	ctrl->dwFrameInterval = le32_to_cpup((__le32 *)&data[4]);
+	ctrl->wKeyFrameRate = le16_to_cpup((__le16 *)&data[8]);
+	ctrl->wPFrameRate = le16_to_cpup((__le16 *)&data[10]);
+	ctrl->wCompQuality = le16_to_cpup((__le16 *)&data[12]);
+	ctrl->wCompWindowSize = le16_to_cpup((__le16 *)&data[14]);
+	ctrl->wDelay = le16_to_cpup((__le16 *)&data[16]);
+	ctrl->dwMaxVideoFrameSize =
+		le32_to_cpu(get_unaligned((__le32 *)&data[18]));
+	ctrl->dwMaxPayloadTransferSize =
+		le32_to_cpu(get_unaligned((__le32 *)&data[22]));
+
+	if (size == 34) {
+		ctrl->dwClockFrequency =
+			le32_to_cpu(get_unaligned((__le32 *)&data[26]));
+		ctrl->bmFramingInfo = data[30];
+		ctrl->bPreferedVersion = data[31];
+		ctrl->bMinVersion = data[32];
+		ctrl->bMaxVersion = data[33];
+	} else {
+		ctrl->dwClockFrequency = video->dev->clock_frequency;
+		ctrl->bmFramingInfo = 0;
+		ctrl->bPreferedVersion = 0;
+		ctrl->bMinVersion = 0;
+		ctrl->bMaxVersion = 0;
+	}
+
+	if (ctrl->dwMaxVideoFrameSize == 0 &&
+	    video->dev->uvc_version < 0x0110) {
+		/* Some broken UVC 1.0 devices return a null
+		 * dwMaxVideoFrameSize. Try to get the value from the format
+		 * and frame descriptor.
+		 */
+		const unsigned int fmt_index = ctrl->bFormatIndex;
+		const unsigned int frm_index = ctrl->bFrameIndex;
+		struct uvc_format *format = NULL;
+		struct uvc_frame *frame = NULL;
+
+		if (fmt_index <= video->streaming->nformats && fmt_index != 0)
+			format = &video->streaming->format[fmt_index - 1];
+		if (format && frm_index <= format->nframes && frm_index != 0) {
+			frame = &format->frame[frm_index - 1];
+			ctrl->dwMaxVideoFrameSize =
+				frame->dwMaxVideoFrameBufferSize;
+		}
+	}
+
+	return 0;
+}
+
+int uvc_set_video_ctrl(struct uvc_video_device *video,
+	struct uvc_streaming_control *ctrl, int probe)
+{
+	__u8 data[34];
+	__u8 size;
+
+	size = video->dev->uvc_version >= 0x0110 ? 34 : 26;
+	memset(data, 0, sizeof data);
+
+	*(__le16 *)&data[0] = cpu_to_le16(ctrl->bmHint);
+	data[2] = ctrl->bFormatIndex;
+	data[3] = ctrl->bFrameIndex;
+	*(__le32 *)&data[4] = cpu_to_le32(ctrl->dwFrameInterval);
+	*(__le16 *)&data[8] = cpu_to_le16(ctrl->wKeyFrameRate);
+	*(__le16 *)&data[10] = cpu_to_le16(ctrl->wPFrameRate);
+	*(__le16 *)&data[12] = cpu_to_le16(ctrl->wCompQuality);
+	*(__le16 *)&data[14] = cpu_to_le16(ctrl->wCompWindowSize);
+	*(__le16 *)&data[16] = cpu_to_le16(ctrl->wDelay);
+	/* Note: Some of the fields below are not required for IN devices (see
+	 * UVC spec, 4.3.1.1), but we still copy them in case support for OUT
+	 * devices is added in the future. */
+	put_unaligned(cpu_to_le32(ctrl->dwMaxVideoFrameSize),
+		(__le32 *)&data[18]);
+	put_unaligned(cpu_to_le32(ctrl->dwMaxPayloadTransferSize),
+		(__le32 *)&data[22]);
+
+	if (size == 34) {
+		put_unaligned(cpu_to_le32(ctrl->dwClockFrequency),
+			(__le32 *)&data[26]);
+		data[30] = ctrl->bmFramingInfo;
+		data[31] = ctrl->bPreferedVersion;
+		data[32] = ctrl->bMinVersion;
+		data[33] = ctrl->bMaxVersion;
+	}
+
+	return __uvc_query_ctrl(video->dev, SET_CUR, 0,
+		video->streaming->intfnum,
+		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, &data, size,
+		UVC_CTRL_STREAMING_TIMEOUT);
+}
+
+int uvc_probe_video(struct uvc_video_device *video,
+	struct uvc_streaming_control *probe)
+{
+	struct uvc_streaming_control probe_min, probe_max;
+	__u16 bandwidth;
+	unsigned int i;
+	int ret;
+
+	mutex_lock(&video->streaming->mutex);
+
+	/* Perform probing. The device should adjust the requested values
+	 * according to its capabilities. However, some devices, namely the
+	 * first generation UVC Logitech webcams, don't implement the Video
+	 * Probe control properly, and just return the needed bandwidth. For
+	 * that reason, if the needed bandwidth exceeds the maximum available
+	 * bandwidth, try to lower the quality.
+	 */
+	if ((ret = uvc_set_video_ctrl(video, probe, 1)) < 0)
+		goto done;
+
+	/* Get the minimum and maximum values for compression settings. */
+	if (!(video->dev->quirks & UVC_QUIRK_PROBE_MINMAX)) {
+		ret = uvc_get_video_ctrl(video, &probe_min, 1, GET_MIN);
+		if (ret < 0)
+			goto done;
+		ret = uvc_get_video_ctrl(video, &probe_max, 1, GET_MAX);
+		if (ret < 0)
+			goto done;
+
+		probe->wCompQuality = probe_max.wCompQuality;
+	}
+
+	for (i = 0; i < 2; ++i) {
+		if ((ret = uvc_set_video_ctrl(video, probe, 1)) < 0 ||
+		    (ret = uvc_get_video_ctrl(video, probe, 1, GET_CUR)) < 0)
+			goto done;
+
+		if (video->streaming->intf->num_altsetting == 1)
+			break;
+
+		bandwidth = probe->dwMaxPayloadTransferSize;
+		if (bandwidth <= video->streaming->maxpsize)
+			break;
+
+		if (video->dev->quirks & UVC_QUIRK_PROBE_MINMAX) {
+			ret = -ENOSPC;
+			goto done;
+		}
+
+		/* TODO: negotiate compression parameters */
+		probe->wKeyFrameRate = probe_min.wKeyFrameRate;
+		probe->wPFrameRate = probe_min.wPFrameRate;
+		probe->wCompQuality = probe_max.wCompQuality;
+		probe->wCompWindowSize = probe_min.wCompWindowSize;
+	}
+
+done:
+	mutex_unlock(&video->streaming->mutex);
+	return ret;
+}
+
+/* ------------------------------------------------------------------------
+ * Video codecs
+ */
+
+/* Values for bmHeaderInfo (Video and Still Image Payload Headers, 2.4.3.3) */
+#define UVC_STREAM_EOH	(1 << 7)
+#define UVC_STREAM_ERR	(1 << 6)
+#define UVC_STREAM_STI	(1 << 5)
+#define UVC_STREAM_RES	(1 << 4)
+#define UVC_STREAM_SCR	(1 << 3)
+#define UVC_STREAM_PTS	(1 << 2)
+#define UVC_STREAM_EOF	(1 << 1)
+#define UVC_STREAM_FID	(1 << 0)
+
+/* Video payload decoding is handled by uvc_video_decode_start(),
+ * uvc_video_decode_data() and uvc_video_decode_end().
+ *
+ * uvc_video_decode_start is called with URB data at the start of a bulk or
+ * isochronous payload. It processes header data and returns the header size
+ * in bytes if successful. If an error occurs, it returns a negative error
+ * code. The following error codes have special meanings.
+ *
+ * - EAGAIN informs the caller that the current video buffer should be marked
+ *   as done, and that the function should be called again with the same data
+ *   and a new video buffer. This is used when end of frame conditions can be
+ *   reliably detected at the beginning of the next frame only.
+ *
+ * If an error other than -EAGAIN is returned, the caller will drop the current
+ * payload. No call to uvc_video_decode_data and uvc_video_decode_end will be
+ * made until the next payload. -ENODATA can be used to drop the current
+ * payload if no other error code is appropriate.
+ *
+ * uvc_video_decode_data is called for every URB with URB data. It copies the
+ * data to the video buffer.
+ *
+ * uvc_video_decode_end is called with header data at the end of a bulk or
+ * isochronous payload. It performs any additional header data processing and
+ * returns 0 or a negative error code if an error occured. As header data have
+ * already been processed by uvc_video_decode_start, this functions isn't
+ * required to perform sanity checks a second time.
+ *
+ * For isochronous transfers where a payload is always transfered in a single
+ * URB, the three functions will be called in a row.
+ *
+ * To let the decoder process header data and update its internal state even
+ * when no video buffer is available, uvc_video_decode_start must be prepared
+ * to be called with a NULL buf parameter. uvc_video_decode_data and
+ * uvc_video_decode_end will never be called with a NULL buffer.
+ */
+static int uvc_video_decode_start(struct uvc_video_device *video,
+		struct uvc_buffer *buf, const __u8 *data, int len)
+{
+	__u8 fid;
+
+	/* Sanity checks:
+	 * - packet must be at least 2 bytes long
+	 * - bHeaderLength value must be at least 2 bytes (see above)
+	 * - bHeaderLength value can't be larger than the packet size.
+	 */
+	if (len < 2 || data[0] < 2 || data[0] > len)
+		return -EINVAL;
+
+	/* Skip payloads marked with the error bit ("error frames"). */
+	if (data[1] & UVC_STREAM_ERR) {
+		uvc_trace(UVC_TRACE_FRAME, "Dropping payload (error bit "
+			  "set).\n");
+		return -ENODATA;
+	}
+
+	fid = data[1] & UVC_STREAM_FID;
+
+	/* Store the payload FID bit and return immediately when the buffer is
+	 * NULL.
+	 */
+	if (buf == NULL) {
+		video->last_fid = fid;
+		return -ENODATA;
+	}
+
+	/* Synchronize to the input stream by waiting for the FID bit to be
+	 * toggled when the the buffer state is not UVC_BUF_STATE_ACTIVE.
+	 * queue->last_fid is initialized to -1, so the first isochronous
+	 * frame will always be in sync.
+	 *
+	 * If the device doesn't toggle the FID bit, invert video->last_fid
+	 * when the EOF bit is set to force synchronisation on the next packet.
+	 */
+	if (buf->state != UVC_BUF_STATE_ACTIVE) {
+		if (fid == video->last_fid) {
+			uvc_trace(UVC_TRACE_FRAME, "Dropping payload (out of "
+				"sync).\n");
+			if ((video->dev->quirks & UVC_QUIRK_STREAM_NO_FID) &&
+			    (data[1] & UVC_STREAM_EOF))
+				video->last_fid ^= UVC_STREAM_FID;
+			return -ENODATA;
+		}
+
+		/* TODO: Handle PTS and SCR. */
+		buf->state = UVC_BUF_STATE_ACTIVE;
+	}
+
+	/* Mark the buffer as done if we're at the beginning of a new frame.
+	 * End of frame detection is better implemented by checking the EOF
+	 * bit (FID bit toggling is delayed by one frame compared to the EOF
+	 * bit), but some devices don't set the bit at end of frame (and the
+	 * last payload can be lost anyway). We thus must check if the FID has
+	 * been toggled.
+	 *
+	 * queue->last_fid is initialized to -1, so the first isochronous
+	 * frame will never trigger an end of frame detection.
+	 *
+	 * Empty buffers (bytesused == 0) don't trigger end of frame detection
+	 * as it doesn't make sense to return an empty buffer. This also
+	 * avoids detecting and of frame conditions at FID toggling if the
+	 * previous payload had the EOF bit set.
+	 */
+	if (fid != video->last_fid && buf->buf.bytesused != 0) {
+		uvc_trace(UVC_TRACE_FRAME, "Frame complete (FID bit "
+				"toggled).\n");
+		buf->state = UVC_BUF_STATE_DONE;
+		return -EAGAIN;
+	}
+
+	video->last_fid = fid;
+
+	return data[0];
+}
+
+static void uvc_video_decode_data(struct uvc_video_device *video,
+		struct uvc_buffer *buf, const __u8 *data, int len)
+{
+	struct uvc_video_queue *queue = &video->queue;
+	unsigned int maxlen, nbytes;
+	void *mem;
+
+	if (len <= 0)
+		return;
+
+	/* Copy the video data to the buffer. */
+	maxlen = buf->buf.length - buf->buf.bytesused;
+	mem = queue->mem + buf->buf.m.offset + buf->buf.bytesused;
+	nbytes = min((unsigned int)len, maxlen);
+	memcpy(mem, data, nbytes);
+	buf->buf.bytesused += nbytes;
+
+	/* Complete the current frame if the buffer size was exceeded. */
+	if (len > maxlen) {
+		uvc_trace(UVC_TRACE_FRAME, "Frame complete (overflow).\n");
+		buf->state = UVC_BUF_STATE_DONE;
+	}
+}
+
+static void uvc_video_decode_end(struct uvc_video_device *video,
+		struct uvc_buffer *buf, const __u8 *data, int len)
+{
+	/* Mark the buffer as done if the EOF marker is set. */
+	if (data[1] & UVC_STREAM_EOF && buf->buf.bytesused != 0) {
+		uvc_trace(UVC_TRACE_FRAME, "Frame complete (EOF found).\n");
+		if (data[0] == len)
+			uvc_trace(UVC_TRACE_FRAME, "EOF in empty payload.\n");
+		buf->state = UVC_BUF_STATE_DONE;
+		if (video->dev->quirks & UVC_QUIRK_STREAM_NO_FID)
+			video->last_fid ^= UVC_STREAM_FID;
+	}
+}
+
+/* ------------------------------------------------------------------------
+ * URB handling
+ */
+
+/*
+ * Completion handler for video URBs.
+ */
+static void uvc_video_decode_isoc(struct urb *urb,
+	struct uvc_video_device *video, struct uvc_buffer *buf)
+{
+	u8 *mem;
+	int ret, i;
+
+	for (i = 0; i < urb->number_of_packets; ++i) {
+		if (urb->iso_frame_desc[i].status < 0) {
+			uvc_trace(UVC_TRACE_FRAME, "USB isochronous frame "
+				"lost (%d).\n", urb->iso_frame_desc[i].status);
+			continue;
+		}
+
+		/* Decode the payload header. */
+		mem = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
+		do {
+			ret = uvc_video_decode_start(video, buf, mem,
+				urb->iso_frame_desc[i].actual_length);
+			if (ret == -EAGAIN)
+				buf = uvc_queue_next_buffer(&video->queue, buf);
+		} while (ret == -EAGAIN);
+
+		if (ret < 0)
+			continue;
+
+		/* Decode the payload data. */
+		uvc_video_decode_data(video, buf, mem + ret,
+			urb->iso_frame_desc[i].actual_length - ret);
+
+		/* Process the header again. */
+		uvc_video_decode_end(video, buf, mem, ret);
+
+		if (buf->state == UVC_BUF_STATE_DONE ||
+		    buf->state == UVC_BUF_STATE_ERROR)
+			buf = uvc_queue_next_buffer(&video->queue, buf);
+	}
+}
+
+static void uvc_video_decode_bulk(struct urb *urb,
+	struct uvc_video_device *video, struct uvc_buffer *buf)
+{
+	u8 *mem;
+	int len, ret;
+
+	mem = urb->transfer_buffer;
+	len = urb->actual_length;
+	video->bulk.payload_size += len;
+
+	/* If the URB is the first of its payload, decode and save the
+	 * header.
+	 */
+	if (video->bulk.header_size == 0) {
+		do {
+			ret = uvc_video_decode_start(video, buf, mem, len);
+			if (ret == -EAGAIN)
+				buf = uvc_queue_next_buffer(&video->queue, buf);
+		} while (ret == -EAGAIN);
+
+		/* If an error occured skip the rest of the payload. */
+		if (ret < 0 || buf == NULL) {
+			video->bulk.skip_payload = 1;
+			return;
+		}
+
+		video->bulk.header_size = ret;
+		memcpy(video->bulk.header, mem, video->bulk.header_size);
+
+		mem += ret;
+		len -= ret;
+	}
+
+	/* The buffer queue might have been cancelled while a bulk transfer
+	 * was in progress, so we can reach here with buf equal to NULL. Make
+	 * sure buf is never dereferenced if NULL.
+	 */
+
+	/* Process video data. */
+	if (!video->bulk.skip_payload && buf != NULL)
+		uvc_video_decode_data(video, buf, mem, len);
+
+	/* Detect the payload end by a URB smaller than the maximum size (or
+	 * a payload size equal to the maximum) and process the header again.
+	 */
+	if (urb->actual_length < urb->transfer_buffer_length ||
+	    video->bulk.payload_size >= video->bulk.max_payload_size) {
+		if (!video->bulk.skip_payload && buf != NULL) {
+			uvc_video_decode_end(video, buf, video->bulk.header,
+				video->bulk.header_size);
+			if (buf->state == UVC_BUF_STATE_DONE ||
+			    buf->state == UVC_BUF_STATE_ERROR)
+				buf = uvc_queue_next_buffer(&video->queue, buf);
+		}
+
+		video->bulk.header_size = 0;
+		video->bulk.skip_payload = 0;
+		video->bulk.payload_size = 0;
+	}
+}
+
+static void uvc_video_complete(struct urb *urb)
+{
+	struct uvc_video_device *video = urb->context;
+	struct uvc_video_queue *queue = &video->queue;
+	struct uvc_buffer *buf = NULL;
+	unsigned long flags;
+	int ret;
+
+	switch (urb->status) {
+	case 0:
+		break;
+
+	default:
+		uvc_printk(KERN_WARNING, "Non-zero status (%d) in video "
+			"completion handler.\n", urb->status);
+
+	case -ENOENT:		/* usb_kill_urb() called. */
+		if (queue->frozen)
+			return;
+
+	case -ECONNRESET:	/* usb_unlink_urb() called. */
+	case -ESHUTDOWN:	/* The endpoint is being disabled. */
+		uvc_queue_cancel(queue);
+		return;
+	}
+
+	spin_lock_irqsave(&queue->irqlock, flags);
+	if (!list_empty(&queue->irqqueue))
+		buf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
+				       queue);
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+
+	video->decode(urb, video, buf);
+
+	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
+		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
+			ret);
+	}
+}
+
+/*
+ * Uninitialize isochronous/bulk URBs and free transfer buffers.
+ */
+static void uvc_uninit_video(struct uvc_video_device *video)
+{
+	struct urb *urb;
+	unsigned int i;
+
+	for (i = 0; i < UVC_URBS; ++i) {
+		if ((urb = video->urb[i]) == NULL)
+			continue;
+
+		usb_kill_urb(urb);
+		/* urb->transfer_buffer_length is not touched by USB core, so
+		 * we can use it here as the buffer length.
+		 */
+		if (video->urb_buffer[i]) {
+			usb_buffer_free(video->dev->udev,
+				urb->transfer_buffer_length,
+				video->urb_buffer[i], urb->transfer_dma);
+			video->urb_buffer[i] = NULL;
+		}
+
+		usb_free_urb(urb);
+		video->urb[i] = NULL;
+	}
+}
+
+/*
+ * Initialize isochronous URBs and allocate transfer buffers. The packet size
+ * is given by the endpoint.
+ */
+static int uvc_init_video_isoc(struct uvc_video_device *video,
+	struct usb_host_endpoint *ep)
+{
+	struct urb *urb;
+	unsigned int npackets, i, j;
+	__u16 psize;
+	__u32 size;
+
+	/* Compute the number of isochronous packets to allocate by dividing
+	 * the maximum video frame size by the packet size. Limit the result
+	 * to UVC_MAX_ISO_PACKETS.
+	 */
+	psize = le16_to_cpu(ep->desc.wMaxPacketSize);
+	psize = (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
+
+	size = video->streaming->ctrl.dwMaxVideoFrameSize;
+	if (size > UVC_MAX_FRAME_SIZE)
+		return -EINVAL;
+
+	npackets = (size + psize - 1) / psize;
+	if (npackets > UVC_MAX_ISO_PACKETS)
+		npackets = UVC_MAX_ISO_PACKETS;
+
+	size = npackets * psize;
+
+	for (i = 0; i < UVC_URBS; ++i) {
+		urb = usb_alloc_urb(npackets, GFP_KERNEL);
+		if (urb == NULL) {
+			uvc_uninit_video(video);
+			return -ENOMEM;
+		}
+
+		video->urb_buffer[i] = usb_buffer_alloc(video->dev->udev,
+			size, GFP_KERNEL, &urb->transfer_dma);
+		if (video->urb_buffer[i] == NULL) {
+			usb_free_urb(urb);
+			uvc_uninit_video(video);
+			return -ENOMEM;
+		}
+
+		urb->dev = video->dev->udev;
+		urb->context = video;
+		urb->pipe = usb_rcvisocpipe(video->dev->udev,
+				ep->desc.bEndpointAddress);
+		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
+		urb->interval = ep->desc.bInterval;
+		urb->transfer_buffer = video->urb_buffer[i];
+		urb->complete = uvc_video_complete;
+		urb->number_of_packets = npackets;
+		urb->transfer_buffer_length = size;
+
+		for (j = 0; j < npackets; ++j) {
+			urb->iso_frame_desc[j].offset = j * psize;
+			urb->iso_frame_desc[j].length = psize;
+		}
+
+		video->urb[i] = urb;
+	}
+
+	return 0;
+}
+
+/*
+ * Initialize bulk URBs and allocate transfer buffers. The packet size is
+ * given by the endpoint.
+ */
+static int uvc_init_video_bulk(struct uvc_video_device *video,
+	struct usb_host_endpoint *ep)
+{
+	struct urb *urb;
+	unsigned int pipe, i;
+	__u16 psize;
+	__u32 size;
+
+	/* Compute the bulk URB size. Some devices set the maximum payload
+	 * size to a value too high for memory-constrained devices. We must
+	 * then transfer the payload accross multiple URBs. To be consistant
+	 * with isochronous mode, allocate maximum UVC_MAX_ISO_PACKETS per bulk
+	 * URB.
+	 */
+	psize = le16_to_cpu(ep->desc.wMaxPacketSize) & 0x07ff;
+	size = video->streaming->ctrl.dwMaxPayloadTransferSize;
+	video->bulk.max_payload_size = size;
+	if (size > psize * UVC_MAX_ISO_PACKETS)
+		size = psize * UVC_MAX_ISO_PACKETS;
+
+	pipe = usb_rcvbulkpipe(video->dev->udev, ep->desc.bEndpointAddress);
+
+	for (i = 0; i < UVC_URBS; ++i) {
+		urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (urb == NULL) {
+			uvc_uninit_video(video);
+			return -ENOMEM;
+		}
+
+		video->urb_buffer[i] = usb_buffer_alloc(video->dev->udev,
+			size, GFP_KERNEL, &urb->transfer_dma);
+		if (video->urb_buffer[i] == NULL) {
+			usb_free_urb(urb);
+			uvc_uninit_video(video);
+			return -ENOMEM;
+		}
+
+		usb_fill_bulk_urb(urb, video->dev->udev, pipe,
+			video->urb_buffer[i], size, uvc_video_complete,
+			video);
+		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
+
+		video->urb[i] = urb;
+	}
+
+	return 0;
+}
+
+/*
+ * Initialize isochronous/bulk URBs and allocate transfer buffers.
+ */
+static int uvc_init_video(struct uvc_video_device *video)
+{
+	struct usb_interface *intf = video->streaming->intf;
+	struct usb_host_interface *alts;
+	struct usb_host_endpoint *ep = NULL;
+	int intfnum = video->streaming->intfnum;
+	unsigned int bandwidth, psize, i;
+	int ret;
+
+	video->last_fid = -1;
+	video->bulk.header_size = 0;
+	video->bulk.skip_payload = 0;
+	video->bulk.payload_size = 0;
+
+	if (intf->num_altsetting > 1) {
+		/* Isochronous endpoint, select the alternate setting. */
+		bandwidth = video->streaming->ctrl.dwMaxPayloadTransferSize;
+
+		if (bandwidth == 0) {
+			uvc_printk(KERN_WARNING, "device %s requested null "
+				"bandwidth, defaulting to lowest.\n",
+				video->vdev->name);
+			bandwidth = 1;
+		}
+
+		for (i = 0; i < intf->num_altsetting; ++i) {
+			alts = &intf->altsetting[i];
+			ep = uvc_find_endpoint(alts,
+				video->streaming->header.bEndpointAddress);
+			if (ep == NULL)
+				continue;
+
+			/* Check if the bandwidth is high enough. */
+			psize = le16_to_cpu(ep->desc.wMaxPacketSize);
+			psize = (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
+			if (psize >= bandwidth)
+				break;
+		}
+
+		if (i >= intf->num_altsetting)
+			return -EIO;
+
+		if ((ret = usb_set_interface(video->dev->udev, intfnum, i)) < 0)
+			return ret;
+
+		ret = uvc_init_video_isoc(video, ep);
+	} else {
+		/* Bulk endpoint, proceed to URB initialization. */
+		ep = uvc_find_endpoint(&intf->altsetting[0],
+				video->streaming->header.bEndpointAddress);
+		if (ep == NULL)
+			return -EIO;
+
+		ret = uvc_init_video_bulk(video, ep);
+	}
+
+	if (ret < 0)
+		return ret;
+
+	/* Submit the URBs. */
+	for (i = 0; i < UVC_URBS; ++i) {
+		if ((ret = usb_submit_urb(video->urb[i], GFP_KERNEL)) < 0) {
+			uvc_printk(KERN_ERR, "Failed to submit URB %u "
+					"(%d).\n", i, ret);
+			uvc_uninit_video(video);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+/* --------------------------------------------------------------------------
+ * Suspend/resume
+ */
+
+/*
+ * Stop streaming without disabling the video queue.
+ *
+ * To let userspace applications resume without trouble, we must not touch the
+ * video buffers in any way. We mark the queue as frozen to make sure the URB
+ * completion handler won't try to cancel the queue when we kill the URBs.
+ */
+int uvc_video_suspend(struct uvc_video_device *video)
+{
+	if (!video->queue.streaming)
+		return 0;
+
+	video->queue.frozen = 1;
+	uvc_uninit_video(video);
+	usb_set_interface(video->dev->udev, video->streaming->intfnum, 0);
+	return 0;
+}
+
+/*
+ * Reconfigure the video interface and restart streaming if it was enable
+ * before suspend.
+ *
+ * If an error occurs, disable the video queue. This will wake all pending
+ * buffers, making sure userspace applications are notified of the problem
+ * instead of waiting forever.
+ */
+int uvc_video_resume(struct uvc_video_device *video)
+{
+	int ret;
+
+	video->queue.frozen = 0;
+
+	if ((ret = uvc_set_video_ctrl(video, &video->streaming->ctrl, 0)) < 0) {
+		uvc_queue_enable(&video->queue, 0);
+		return ret;
+	}
+
+	if (!video->queue.streaming)
+		return 0;
+
+	if ((ret = uvc_init_video(video)) < 0)
+		uvc_queue_enable(&video->queue, 0);
+
+	return ret;
+}
+
+/* ------------------------------------------------------------------------
+ * Video device
+ */
+
+/*
+ * Initialize the UVC video device by retrieving the default format and
+ * committing it.
+ *
+ * Some cameras (namely the Fuji Finepix) set the format and frame
+ * indexes to zero. The UVC standard doesn't clearly make this a spec
+ * violation, so try to silently fix the values if possible.
+ *
+ * This function is called before registering the device with V4L.
+ */
+int uvc_video_init(struct uvc_video_device *video)
+{
+	struct uvc_streaming_control *probe = &video->streaming->ctrl;
+	struct uvc_format *format = NULL;
+	struct uvc_frame *frame = NULL;
+	unsigned int i;
+	int ret;
+
+	if (video->streaming->nformats == 0) {
+		uvc_printk(KERN_INFO, "No supported video formats found.\n");
+		return -EINVAL;
+	}
+
+	/* Alternate setting 0 should be the default, yet the XBox Live Vision
+	 * Cam (and possibly other devices) crash or otherwise misbehave if
+	 * they don't receive a SET_INTERFACE request before any other video
+	 * control request.
+	 */
+	usb_set_interface(video->dev->udev, video->streaming->intfnum, 0);
+
+	/* Some webcams don't suport GET_DEF request on the probe control. We
+	 * fall back to GET_CUR if GET_DEF fails.
+	 */
+	if ((ret = uvc_get_video_ctrl(video, probe, 1, GET_DEF)) < 0 &&
+	    (ret = uvc_get_video_ctrl(video, probe, 1, GET_CUR)) < 0)
+		return ret;
+
+	/* Check if the default format descriptor exists. Use the first
+	 * available format otherwise.
+	 */
+	for (i = video->streaming->nformats; i > 0; --i) {
+		format = &video->streaming->format[i-1];
+		if (format->index == probe->bFormatIndex)
+			break;
+	}
+
+	if (format->nframes == 0) {
+		uvc_printk(KERN_INFO, "No frame descriptor found for the "
+			"default format.\n");
+		return -EINVAL;
+	}
+
+	/* Zero bFrameIndex might be correct. Stream-based formats (including
+	 * MPEG-2 TS and DV) do not support frames but have a dummy frame
+	 * descriptor with bFrameIndex set to zero. If the default frame
+	 * descriptor is not found, use the first avalable frame.
+	 */
+	for (i = format->nframes; i > 0; --i) {
+		frame = &format->frame[i-1];
+		if (frame->bFrameIndex == probe->bFrameIndex)
+			break;
+	}
+
+	/* Commit the default settings. */
+	probe->bFormatIndex = format->index;
+	probe->bFrameIndex = frame->bFrameIndex;
+	if ((ret = uvc_set_video_ctrl(video, probe, 0)) < 0)
+		return ret;
+
+	video->streaming->cur_format = format;
+	video->streaming->cur_frame = frame;
+	atomic_set(&video->active, 0);
+
+	/* Select the video decoding function */
+	if (video->dev->quirks & UVC_QUIRK_BUILTIN_ISIGHT)
+		video->decode = uvc_video_decode_isight;
+	else if (video->streaming->intf->num_altsetting > 1)
+		video->decode = uvc_video_decode_isoc;
+	else
+		video->decode = uvc_video_decode_bulk;
+
+	return 0;
+}
+
+/*
+ * Enable or disable the video stream.
+ */
+int uvc_video_enable(struct uvc_video_device *video, int enable)
+{
+	int ret;
+
+	if (!enable) {
+		uvc_uninit_video(video);
+		usb_set_interface(video->dev->udev,
+			video->streaming->intfnum, 0);
+		uvc_queue_enable(&video->queue, 0);
+		return 0;
+	}
+
+	if ((ret = uvc_queue_enable(&video->queue, 1)) < 0)
+		return ret;
+
+	return uvc_init_video(video);
+}
+
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
new file mode 100644
index 0000000..ef9074f
--- /dev/null
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -0,0 +1,788 @@
+#ifndef _USB_VIDEO_H_
+#define _USB_VIDEO_H_
+
+#include <linux/kernel.h>
+#include <linux/videodev.h>
+
+
+/*
+ * Dynamic controls
+ */
+/* Data types for UVC control data */
+enum uvc_control_data_type {
+	UVC_CTRL_DATA_TYPE_RAW = 0,
+	UVC_CTRL_DATA_TYPE_SIGNED,
+	UVC_CTRL_DATA_TYPE_UNSIGNED,
+	UVC_CTRL_DATA_TYPE_BOOLEAN,
+	UVC_CTRL_DATA_TYPE_ENUM,
+	UVC_CTRL_DATA_TYPE_BITMASK,
+};
+
+#define UVC_CONTROL_SET_CUR	(1 << 0)
+#define UVC_CONTROL_GET_CUR	(1 << 1)
+#define UVC_CONTROL_GET_MIN	(1 << 2)
+#define UVC_CONTROL_GET_MAX	(1 << 3)
+#define UVC_CONTROL_GET_RES	(1 << 4)
+#define UVC_CONTROL_GET_DEF	(1 << 5)
+/* Control should be saved at suspend and restored at resume. */
+#define UVC_CONTROL_RESTORE	(1 << 6)
+/* Control can be updated by the camera. */
+#define UVC_CONTROL_AUTO_UPDATE	(1 << 7)
+
+#define UVC_CONTROL_GET_RANGE	(UVC_CONTROL_GET_CUR | UVC_CONTROL_GET_MIN | \
+				 UVC_CONTROL_GET_MAX | UVC_CONTROL_GET_RES | \
+				 UVC_CONTROL_GET_DEF)
+
+struct uvc_xu_control_info {
+	__u8 entity[16];
+	__u8 index;
+	__u8 selector;
+	__u16 size;
+	__u32 flags;
+};
+
+struct uvc_xu_control_mapping {
+	__u32 id;
+	__u8 name[32];
+	__u8 entity[16];
+	__u8 selector;
+
+	__u8 size;
+	__u8 offset;
+	enum v4l2_ctrl_type v4l2_type;
+	enum uvc_control_data_type data_type;
+};
+
+struct uvc_xu_control {
+	__u8 unit;
+	__u8 selector;
+	__u16 size;
+	__u8 __user *data;
+};
+
+#define UVCIOC_CTRL_ADD		_IOW('U', 1, struct uvc_xu_control_info)
+#define UVCIOC_CTRL_MAP		_IOWR('U', 2, struct uvc_xu_control_mapping)
+#define UVCIOC_CTRL_GET		_IOWR('U', 3, struct uvc_xu_control)
+#define UVCIOC_CTRL_SET		_IOW('U', 4, struct uvc_xu_control)
+
+#ifdef __KERNEL__
+
+#include <linux/poll.h>
+
+/* --------------------------------------------------------------------------
+ * UVC constants
+ */
+
+#define SC_UNDEFINED                    0x00
+#define SC_VIDEOCONTROL                 0x01
+#define SC_VIDEOSTREAMING               0x02
+#define SC_VIDEO_INTERFACE_COLLECTION   0x03
+
+#define PC_PROTOCOL_UNDEFINED           0x00
+
+#define CS_UNDEFINED                    0x20
+#define CS_DEVICE                       0x21
+#define CS_CONFIGURATION                0x22
+#define CS_STRING                       0x23
+#define CS_INTERFACE                    0x24
+#define CS_ENDPOINT                     0x25
+
+/* VideoControl class specific interface descriptor */
+#define VC_DESCRIPTOR_UNDEFINED         0x00
+#define VC_HEADER                       0x01
+#define VC_INPUT_TERMINAL               0x02
+#define VC_OUTPUT_TERMINAL              0x03
+#define VC_SELECTOR_UNIT                0x04
+#define VC_PROCESSING_UNIT              0x05
+#define VC_EXTENSION_UNIT               0x06
+
+/* VideoStreaming class specific interface descriptor */
+#define VS_UNDEFINED                    0x00
+#define VS_INPUT_HEADER                 0x01
+#define VS_OUTPUT_HEADER                0x02
+#define VS_STILL_IMAGE_FRAME            0x03
+#define VS_FORMAT_UNCOMPRESSED          0x04
+#define VS_FRAME_UNCOMPRESSED           0x05
+#define VS_FORMAT_MJPEG                 0x06
+#define VS_FRAME_MJPEG                  0x07
+#define VS_FORMAT_MPEG2TS               0x0a
+#define VS_FORMAT_DV                    0x0c
+#define VS_COLORFORMAT                  0x0d
+#define VS_FORMAT_FRAME_BASED           0x10
+#define VS_FRAME_FRAME_BASED            0x11
+#define VS_FORMAT_STREAM_BASED          0x12
+
+/* Endpoint type */
+#define EP_UNDEFINED                    0x00
+#define EP_GENERAL                      0x01
+#define EP_ENDPOINT                     0x02
+#define EP_INTERRUPT                    0x03
+
+/* Request codes */
+#define RC_UNDEFINED                    0x00
+#define SET_CUR                         0x01
+#define GET_CUR                         0x81
+#define GET_MIN                         0x82
+#define GET_MAX                         0x83
+#define GET_RES                         0x84
+#define GET_LEN                         0x85
+#define GET_INFO                        0x86
+#define GET_DEF                         0x87
+
+/* VideoControl interface controls */
+#define VC_CONTROL_UNDEFINED            0x00
+#define VC_VIDEO_POWER_MODE_CONTROL     0x01
+#define VC_REQUEST_ERROR_CODE_CONTROL   0x02
+
+/* Terminal controls */
+#define TE_CONTROL_UNDEFINED            0x00
+
+/* Selector Unit controls */
+#define SU_CONTROL_UNDEFINED            0x00
+#define SU_INPUT_SELECT_CONTROL         0x01
+
+/* Camera Terminal controls */
+#define CT_CONTROL_UNDEFINED            		0x00
+#define CT_SCANNING_MODE_CONTROL        		0x01
+#define CT_AE_MODE_CONTROL              		0x02
+#define CT_AE_PRIORITY_CONTROL          		0x03
+#define CT_EXPOSURE_TIME_ABSOLUTE_CONTROL               0x04
+#define CT_EXPOSURE_TIME_RELATIVE_CONTROL               0x05
+#define CT_FOCUS_ABSOLUTE_CONTROL       		0x06
+#define CT_FOCUS_RELATIVE_CONTROL       		0x07
+#define CT_FOCUS_AUTO_CONTROL           		0x08
+#define CT_IRIS_ABSOLUTE_CONTROL        		0x09
+#define CT_IRIS_RELATIVE_CONTROL        		0x0a
+#define CT_ZOOM_ABSOLUTE_CONTROL        		0x0b
+#define CT_ZOOM_RELATIVE_CONTROL        		0x0c
+#define CT_PANTILT_ABSOLUTE_CONTROL     		0x0d
+#define CT_PANTILT_RELATIVE_CONTROL     		0x0e
+#define CT_ROLL_ABSOLUTE_CONTROL        		0x0f
+#define CT_ROLL_RELATIVE_CONTROL        		0x10
+#define CT_PRIVACY_CONTROL              		0x11
+
+/* Processing Unit controls */
+#define PU_CONTROL_UNDEFINED            		0x00
+#define PU_BACKLIGHT_COMPENSATION_CONTROL               0x01
+#define PU_BRIGHTNESS_CONTROL           		0x02
+#define PU_CONTRAST_CONTROL             		0x03
+#define PU_GAIN_CONTROL                 		0x04
+#define PU_POWER_LINE_FREQUENCY_CONTROL 		0x05
+#define PU_HUE_CONTROL                  		0x06
+#define PU_SATURATION_CONTROL           		0x07
+#define PU_SHARPNESS_CONTROL            		0x08
+#define PU_GAMMA_CONTROL                		0x09
+#define PU_WHITE_BALANCE_TEMPERATURE_CONTROL            0x0a
+#define PU_WHITE_BALANCE_TEMPERATURE_AUTO_CONTROL       0x0b
+#define PU_WHITE_BALANCE_COMPONENT_CONTROL              0x0c
+#define PU_WHITE_BALANCE_COMPONENT_AUTO_CONTROL         0x0d
+#define PU_DIGITAL_MULTIPLIER_CONTROL   		0x0e
+#define PU_DIGITAL_MULTIPLIER_LIMIT_CONTROL             0x0f
+#define PU_HUE_AUTO_CONTROL             		0x10
+#define PU_ANALOG_VIDEO_STANDARD_CONTROL                0x11
+#define PU_ANALOG_LOCK_STATUS_CONTROL   		0x12
+
+#define LXU_MOTOR_PANTILT_RELATIVE_CONTROL		0x01
+#define LXU_MOTOR_PANTILT_RESET_CONTROL			0x02
+#define LXU_MOTOR_FOCUS_MOTOR_CONTROL			0x03
+
+/* VideoStreaming interface controls */
+#define VS_CONTROL_UNDEFINED            0x00
+#define VS_PROBE_CONTROL                0x01
+#define VS_COMMIT_CONTROL               0x02
+#define VS_STILL_PROBE_CONTROL          0x03
+#define VS_STILL_COMMIT_CONTROL         0x04
+#define VS_STILL_IMAGE_TRIGGER_CONTROL  0x05
+#define VS_STREAM_ERROR_CODE_CONTROL    0x06
+#define VS_GENERATE_KEY_FRAME_CONTROL   0x07
+#define VS_UPDATE_FRAME_SEGMENT_CONTROL 0x08
+#define VS_SYNC_DELAY_CONTROL           0x09
+
+#define TT_VENDOR_SPECIFIC              0x0100
+#define TT_STREAMING                    0x0101
+
+/* Input Terminal types */
+#define ITT_VENDOR_SPECIFIC             0x0200
+#define ITT_CAMERA                      0x0201
+#define ITT_MEDIA_TRANSPORT_INPUT       0x0202
+
+/* Output Terminal types */
+#define OTT_VENDOR_SPECIFIC             0x0300
+#define OTT_DISPLAY                     0x0301
+#define OTT_MEDIA_TRANSPORT_OUTPUT      0x0302
+
+/* External Terminal types */
+#define EXTERNAL_VENDOR_SPECIFIC        0x0400
+#define COMPOSITE_CONNECTOR             0x0401
+#define SVIDEO_CONNECTOR                0x0402
+#define COMPONENT_CONNECTOR             0x0403
+
+#define UVC_TERM_INPUT			0x0000
+#define UVC_TERM_OUTPUT			0x8000
+
+#define UVC_ENTITY_TYPE(entity)		((entity)->type & 0x7fff)
+#define UVC_ENTITY_IS_UNIT(entity)	(((entity)->type & 0xff00) == 0)
+#define UVC_ENTITY_IS_TERM(entity)	(((entity)->type & 0xff00) != 0)
+#define UVC_ENTITY_IS_ITERM(entity) \
+	(((entity)->type & 0x8000) == UVC_TERM_INPUT)
+#define UVC_ENTITY_IS_OTERM(entity) \
+	(((entity)->type & 0x8000) == UVC_TERM_OUTPUT)
+
+#define UVC_STATUS_TYPE_CONTROL		1
+#define UVC_STATUS_TYPE_STREAMING	2
+
+/* ------------------------------------------------------------------------
+ * GUIDs
+ */
+#define UVC_GUID_UVC_CAMERA \
+	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
+	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01}
+#define UVC_GUID_UVC_OUTPUT \
+	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
+	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02}
+#define UVC_GUID_UVC_MEDIA_TRANSPORT_INPUT \
+	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
+	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03}
+#define UVC_GUID_UVC_PROCESSING \
+	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
+	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01}
+#define UVC_GUID_UVC_SELECTOR \
+	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
+	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x02}
+
+#define UVC_GUID_LOGITECH_DEV_INFO \
+	{0x82, 0x06, 0x61, 0x63, 0x70, 0x50, 0xab, 0x49, \
+	 0xb8, 0xcc, 0xb3, 0x85, 0x5e, 0x8d, 0x22, 0x1e}
+#define UVC_GUID_LOGITECH_USER_HW \
+	{0x82, 0x06, 0x61, 0x63, 0x70, 0x50, 0xab, 0x49, \
+	 0xb8, 0xcc, 0xb3, 0x85, 0x5e, 0x8d, 0x22, 0x1f}
+#define UVC_GUID_LOGITECH_VIDEO \
+	{0x82, 0x06, 0x61, 0x63, 0x70, 0x50, 0xab, 0x49, \
+	 0xb8, 0xcc, 0xb3, 0x85, 0x5e, 0x8d, 0x22, 0x50}
+#define UVC_GUID_LOGITECH_MOTOR \
+	{0x82, 0x06, 0x61, 0x63, 0x70, 0x50, 0xab, 0x49, \
+	 0xb8, 0xcc, 0xb3, 0x85, 0x5e, 0x8d, 0x22, 0x56}
+
+#define UVC_GUID_FORMAT_MJPEG \
+	{ 'M',  'J',  'P',  'G', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_YUY2 \
+	{ 'Y',  'U',  'Y',  '2', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_NV12 \
+	{ 'N',  'V',  '1',  '2', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_YV12 \
+	{ 'Y',  'V',  '1',  '2', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_I420 \
+	{ 'I',  '4',  '2',  '0', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_UYVY \
+	{ 'U',  'Y',  'V',  'Y', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_Y800 \
+	{ 'Y',  '8',  '0',  '0', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_BY8 \
+	{ 'B',  'Y',  '8',  ' ', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+
+
+/* ------------------------------------------------------------------------
+ * Driver specific constants.
+ */
+
+#define DRIVER_VERSION_NUMBER	KERNEL_VERSION(0, 1, 0)
+
+/* Number of isochronous URBs. */
+#define UVC_URBS		5
+/* Maximum number of packets per isochronous URB. */
+#define UVC_MAX_ISO_PACKETS	40
+/* Maximum frame size in bytes, for sanity checking. */
+#define UVC_MAX_FRAME_SIZE	(16*1024*1024)
+/* Maximum number of video buffers. */
+#define UVC_MAX_VIDEO_BUFFERS	32
+
+#define UVC_CTRL_CONTROL_TIMEOUT	300
+#define UVC_CTRL_STREAMING_TIMEOUT	1000
+
+/* Devices quirks */
+#define UVC_QUIRK_STATUS_INTERVAL	0x00000001
+#define UVC_QUIRK_PROBE_MINMAX		0x00000002
+#define UVC_QUIRK_PROBE_EXTRAFIELDS	0x00000004
+#define UVC_QUIRK_BUILTIN_ISIGHT	0x00000008
+#define UVC_QUIRK_STREAM_NO_FID		0x00000010
+
+/* Format flags */
+#define UVC_FMT_FLAG_COMPRESSED		0x00000001
+#define UVC_FMT_FLAG_STREAM		0x00000002
+
+/* ------------------------------------------------------------------------
+ * Structures.
+ */
+
+struct uvc_device;
+
+/* TODO: Put the most frequently accessed fields at the beginning of
+ * structures to maximize cache efficiency.
+ */
+struct uvc_streaming_control {
+	__u16 bmHint;
+	__u8  bFormatIndex;
+	__u8  bFrameIndex;
+	__u32 dwFrameInterval;
+	__u16 wKeyFrameRate;
+	__u16 wPFrameRate;
+	__u16 wCompQuality;
+	__u16 wCompWindowSize;
+	__u16 wDelay;
+	__u32 dwMaxVideoFrameSize;
+	__u32 dwMaxPayloadTransferSize;
+	__u32 dwClockFrequency;
+	__u8  bmFramingInfo;
+	__u8  bPreferedVersion;
+	__u8  bMinVersion;
+	__u8  bMaxVersion;
+};
+
+struct uvc_menu_info {
+	__u32 value;
+	__u8 name[32];
+};
+
+struct uvc_control_info {
+	struct list_head list;
+	struct list_head mappings;
+
+	__u8 entity[16];
+	__u8 index;
+	__u8 selector;
+
+	__u16 size;
+	__u32 flags;
+};
+
+struct uvc_control_mapping {
+	struct list_head list;
+
+	struct uvc_control_info *ctrl;
+
+	__u32 id;
+	__u8 name[32];
+	__u8 entity[16];
+	__u8 selector;
+
+	__u8 size;
+	__u8 offset;
+	enum v4l2_ctrl_type v4l2_type;
+	enum uvc_control_data_type data_type;
+
+	struct uvc_menu_info *menu_info;
+	__u32 menu_count;
+};
+
+struct uvc_control {
+	struct uvc_entity *entity;
+	struct uvc_control_info *info;
+
+	__u8 index;	/* Used to match the uvc_control entry with a
+			   uvc_control_info. */
+	__u8 dirty : 1,
+	     loaded : 1,
+	     modified : 1;
+
+	__u8 *data;
+};
+
+struct uvc_format_desc {
+	char *name;
+	__u8 guid[16];
+	__u32 fcc;
+};
+
+/* The term 'entity' refers to both UVC units and UVC terminals.
+ *
+ * The type field is either the terminal type (wTerminalType in the terminal
+ * descriptor), or the unit type (bDescriptorSubtype in the unit descriptor).
+ * As the bDescriptorSubtype field is one byte long, the type value will
+ * always have a null MSB for units. All terminal types defined by the UVC
+ * specification have a non-null MSB, so it is safe to use the MSB to
+ * differentiate between units and terminals as long as the descriptor parsing
+ * code makes sure terminal types have a non-null MSB.
+ *
+ * For terminals, the type's most significant bit stores the terminal
+ * direction (either UVC_TERM_INPUT or UVC_TERM_OUTPUT). The type field should
+ * always be accessed with the UVC_ENTITY_* macros and never directly.
+ */
+
+struct uvc_entity {
+	struct list_head list;		/* Entity as part of a UVC device. */
+	struct list_head chain;		/* Entity as part of a video device
+					 * chain. */
+	__u8 id;
+	__u16 type;
+	char name[64];
+
+	union {
+		struct {
+			__u16 wObjectiveFocalLengthMin;
+			__u16 wObjectiveFocalLengthMax;
+			__u16 wOcularFocalLength;
+			__u8  bControlSize;
+			__u8  *bmControls;
+		} camera;
+
+		struct {
+			__u8  bControlSize;
+			__u8  *bmControls;
+			__u8  bTransportModeSize;
+			__u8  *bmTransportModes;
+		} media;
+
+		struct {
+			__u8  bSourceID;
+		} output;
+
+		struct {
+			__u8  bSourceID;
+			__u16 wMaxMultiplier;
+			__u8  bControlSize;
+			__u8  *bmControls;
+			__u8  bmVideoStandards;
+		} processing;
+
+		struct {
+			__u8  bNrInPins;
+			__u8  *baSourceID;
+		} selector;
+
+		struct {
+			__u8  guidExtensionCode[16];
+			__u8  bNumControls;
+			__u8  bNrInPins;
+			__u8  *baSourceID;
+			__u8  bControlSize;
+			__u8  *bmControls;
+			__u8  *bmControlsType;
+		} extension;
+	};
+
+	unsigned int ncontrols;
+	struct uvc_control *controls;
+};
+
+struct uvc_frame {
+	__u8  bFrameIndex;
+	__u8  bmCapabilities;
+	__u16 wWidth;
+	__u16 wHeight;
+	__u32 dwMinBitRate;
+	__u32 dwMaxBitRate;
+	__u32 dwMaxVideoFrameBufferSize;
+	__u8  bFrameIntervalType;
+	__u32 dwDefaultFrameInterval;
+	__u32 *dwFrameInterval;
+};
+
+struct uvc_format {
+	__u8 type;
+	__u8 index;
+	__u8 bpp;
+	__u8 colorspace;
+	__u32 fcc;
+	__u32 flags;
+
+	char name[32];
+
+	unsigned int nframes;
+	struct uvc_frame *frame;
+};
+
+struct uvc_streaming_header {
+	__u8 bNumFormats;
+	__u8 bEndpointAddress;
+	__u8 bTerminalLink;
+	__u8 bControlSize;
+	__u8 *bmaControls;
+	/* The following fields are used by input headers only. */
+	__u8 bmInfo;
+	__u8 bStillCaptureMethod;
+	__u8 bTriggerSupport;
+	__u8 bTriggerUsage;
+};
+
+struct uvc_streaming {
+	struct list_head list;
+
+	struct usb_interface *intf;
+	int intfnum;
+	__u16 maxpsize;
+
+	struct uvc_streaming_header header;
+
+	unsigned int nformats;
+	struct uvc_format *format;
+
+	struct uvc_streaming_control ctrl;
+	struct uvc_format *cur_format;
+	struct uvc_frame *cur_frame;
+
+	struct mutex mutex;
+};
+
+enum uvc_buffer_state {
+	UVC_BUF_STATE_IDLE       = 0,
+	UVC_BUF_STATE_QUEUED     = 1,
+	UVC_BUF_STATE_ACTIVE     = 2,
+	UVC_BUF_STATE_DONE       = 3,
+	UVC_BUF_STATE_ERROR      = 4,
+};
+
+struct uvc_buffer {
+	unsigned long vma_use_count;
+	struct list_head stream;
+
+	/* Touched by interrupt handler. */
+	struct v4l2_buffer buf;
+	struct list_head queue;
+	wait_queue_head_t wait;
+	enum uvc_buffer_state state;
+};
+
+struct uvc_video_queue {
+	void *mem;
+	unsigned int streaming : 1,
+		     frozen : 1;
+	__u32 sequence;
+
+	unsigned int count;
+	unsigned int buf_size;
+	struct uvc_buffer buffer[UVC_MAX_VIDEO_BUFFERS];
+	struct mutex mutex;	/* protects buffers and mainqueue */
+	spinlock_t irqlock;	/* protects irqqueue */
+
+	struct list_head mainqueue;
+	struct list_head irqqueue;
+};
+
+struct uvc_video_device {
+	struct uvc_device *dev;
+	struct video_device *vdev;
+	atomic_t active;
+
+	struct list_head iterms;
+	struct uvc_entity *oterm;
+	struct uvc_entity *processing;
+	struct uvc_entity *selector;
+	struct list_head extensions;
+	struct mutex ctrl_mutex;
+
+	struct uvc_video_queue queue;
+
+	/* Video streaming object, must always be non-NULL. */
+	struct uvc_streaming *streaming;
+
+	void (*decode) (struct urb *urb, struct uvc_video_device *video,
+			struct uvc_buffer *buf);
+
+	/* Context data used by the bulk completion handler. */
+	struct {
+		__u8 header[256];
+		unsigned int header_size;
+		int skip_payload;
+		__u32 payload_size;
+		__u32 max_payload_size;
+	} bulk;
+
+	struct urb *urb[UVC_URBS];
+	char *urb_buffer[UVC_URBS];
+
+	__u8 last_fid;
+};
+
+enum uvc_device_state {
+	UVC_DEV_DISCONNECTED = 1,
+};
+
+struct uvc_device {
+	struct usb_device *udev;
+	struct usb_interface *intf;
+	__u32 quirks;
+	int intfnum;
+	char name[32];
+
+	enum uvc_device_state state;
+	struct kref kref;
+	struct list_head list;
+
+	/* Video control interface */
+	__u16 uvc_version;
+	__u32 clock_frequency;
+
+	struct list_head entities;
+
+	struct uvc_video_device video;
+
+	/* Status Interrupt Endpoint */
+	struct usb_host_endpoint *int_ep;
+	struct urb *int_urb;
+	__u8 status[16];
+	struct input_dev *input;
+
+	/* Video Streaming interfaces */
+	struct list_head streaming;
+};
+
+enum uvc_handle_state {
+	UVC_HANDLE_PASSIVE	= 0,
+	UVC_HANDLE_ACTIVE	= 1,
+};
+
+struct uvc_fh {
+	struct uvc_video_device *device;
+	enum uvc_handle_state state;
+};
+
+struct uvc_driver {
+	struct usb_driver driver;
+
+	struct mutex open_mutex;	/* protects from open/disconnect race */
+
+	struct list_head devices;	/* struct uvc_device list */
+	struct list_head controls;	/* struct uvc_control_info list */
+	struct mutex ctrl_mutex;	/* protects controls and devices
+					   lists */
+};
+
+/* ------------------------------------------------------------------------
+ * Debugging, printing and logging
+ */
+
+#define UVC_TRACE_PROBE		(1 << 0)
+#define UVC_TRACE_DESCR		(1 << 1)
+#define UVC_TRACE_CONTROL	(1 << 2)
+#define UVC_TRACE_FORMAT	(1 << 3)
+#define UVC_TRACE_CAPTURE	(1 << 4)
+#define UVC_TRACE_CALLS		(1 << 5)
+#define UVC_TRACE_IOCTL		(1 << 6)
+#define UVC_TRACE_FRAME		(1 << 7)
+#define UVC_TRACE_SUSPEND	(1 << 8)
+#define UVC_TRACE_STATUS	(1 << 9)
+
+extern unsigned int uvc_trace_param;
+
+#define uvc_trace(flag, msg...) \
+	do { \
+		if (uvc_trace_param & flag) \
+			printk(KERN_DEBUG "uvcvideo: " msg); \
+	} while (0)
+
+#define uvc_printk(level, msg...) \
+	printk(level "uvcvideo: " msg)
+
+#define UVC_GUID_FORMAT "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-" \
+			"%02x%02x%02x%02x%02x%02x"
+#define UVC_GUID_ARGS(guid) \
+	(guid)[3],  (guid)[2],  (guid)[1],  (guid)[0], \
+	(guid)[5],  (guid)[4], \
+	(guid)[7],  (guid)[6], \
+	(guid)[8],  (guid)[9], \
+	(guid)[10], (guid)[11], (guid)[12], \
+	(guid)[13], (guid)[14], (guid)[15]
+
+/* --------------------------------------------------------------------------
+ * Internal functions.
+ */
+
+/* Core driver */
+extern struct uvc_driver uvc_driver;
+extern void uvc_delete(struct kref *kref);
+
+/* Video buffers queue management. */
+extern void uvc_queue_init(struct uvc_video_queue *queue);
+extern int uvc_alloc_buffers(struct uvc_video_queue *queue,
+		unsigned int nbuffers, unsigned int buflength);
+extern int uvc_free_buffers(struct uvc_video_queue *queue);
+extern int uvc_query_buffer(struct uvc_video_queue *queue,
+		struct v4l2_buffer *v4l2_buf);
+extern int uvc_queue_buffer(struct uvc_video_queue *queue,
+		struct v4l2_buffer *v4l2_buf);
+extern int uvc_dequeue_buffer(struct uvc_video_queue *queue,
+		struct v4l2_buffer *v4l2_buf, int nonblocking);
+extern int uvc_queue_enable(struct uvc_video_queue *queue, int enable);
+extern void uvc_queue_cancel(struct uvc_video_queue *queue);
+extern struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
+		struct uvc_buffer *buf);
+extern unsigned int uvc_queue_poll(struct uvc_video_queue *queue,
+		struct file *file, poll_table *wait);
+
+/* V4L2 interface */
+extern struct file_operations uvc_fops;
+
+/* Video */
+extern int uvc_video_init(struct uvc_video_device *video);
+extern int uvc_video_suspend(struct uvc_video_device *video);
+extern int uvc_video_resume(struct uvc_video_device *video);
+extern int uvc_video_enable(struct uvc_video_device *video, int enable);
+extern int uvc_probe_video(struct uvc_video_device *video,
+		struct uvc_streaming_control *probe);
+extern int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
+		__u8 intfnum, __u8 cs, void *data, __u16 size);
+extern int uvc_set_video_ctrl(struct uvc_video_device *video,
+		struct uvc_streaming_control *ctrl, int probe);
+
+/* Status */
+extern int uvc_status_init(struct uvc_device *dev);
+extern void uvc_status_cleanup(struct uvc_device *dev);
+extern int uvc_status_suspend(struct uvc_device *dev);
+extern int uvc_status_resume(struct uvc_device *dev);
+
+/* Controls */
+extern struct uvc_control *uvc_find_control(struct uvc_video_device *video,
+		__u32 v4l2_id, struct uvc_control_mapping **mapping);
+extern int uvc_query_v4l2_ctrl(struct uvc_video_device *video,
+		struct v4l2_queryctrl *v4l2_ctrl);
+
+extern int uvc_ctrl_add_info(struct uvc_control_info *info);
+extern int uvc_ctrl_add_mapping(struct uvc_control_mapping *mapping);
+extern int uvc_ctrl_init_device(struct uvc_device *dev);
+extern void uvc_ctrl_cleanup_device(struct uvc_device *dev);
+extern int uvc_ctrl_resume_device(struct uvc_device *dev);
+extern void uvc_ctrl_init(void);
+
+extern int uvc_ctrl_begin(struct uvc_video_device *video);
+extern int __uvc_ctrl_commit(struct uvc_video_device *video, int rollback);
+static inline int uvc_ctrl_commit(struct uvc_video_device *video)
+{
+	return __uvc_ctrl_commit(video, 0);
+}
+static inline int uvc_ctrl_rollback(struct uvc_video_device *video)
+{
+	return __uvc_ctrl_commit(video, 1);
+}
+
+extern int uvc_ctrl_get(struct uvc_video_device *video,
+		struct v4l2_ext_control *xctrl);
+extern int uvc_ctrl_set(struct uvc_video_device *video,
+		struct v4l2_ext_control *xctrl);
+
+extern int uvc_xu_ctrl_query(struct uvc_video_device *video,
+		struct uvc_xu_control *ctrl, int set);
+
+/* Utility functions */
+extern void uvc_simplify_fraction(uint32_t *numerator, uint32_t *denominator,
+		unsigned int n_terms, unsigned int threshold);
+extern uint32_t uvc_fraction_to_interval(uint32_t numerator,
+		uint32_t denominator);
+extern struct usb_host_endpoint *uvc_find_endpoint(
+		struct usb_host_interface *alts, __u8 epaddr);
+
+/* Quirks support */
+void uvc_video_decode_isight(struct urb *urb, struct uvc_video_device *video,
+		struct uvc_buffer *buf);
+
+#endif /* __KERNEL__ */
+
+#endif
+
-- 
1.5.3.7

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
