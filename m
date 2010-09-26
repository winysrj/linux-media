Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:36166 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab0IZQNZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 12:13:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, g.liakhovetski@gmx.de
Subject: [RFC/PATCH 1/9] v4l: Move the media/v4l2-mediabus.h header to include/linux
Date: Sun, 26 Sep 2010 18:13:24 +0200
Message-Id: <1285517612-20230-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The header defines the v4l2_mbus_framefmt structure which will be used
by the V4L2 subdevs userspace API.

Change the type of the v4l2_mbus_framefmt::code field to __u32, as enum
sizes can differ between different ABIs on the same architectures.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/Kbuild          |    1 +
 include/linux/v4l2-mediabus.h |   70 +++++++++++++++++++++++++++++++++++++++++
 include/media/soc_mediabus.h  |    3 +-
 include/media/v4l2-mediabus.h |   53 +------------------------------
 4 files changed, 73 insertions(+), 54 deletions(-)
 create mode 100644 include/linux/v4l2-mediabus.h

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index f836ee4..38127c2 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -369,6 +369,7 @@ header-y += unistd.h
 header-y += usbdevice_fs.h
 header-y += utime.h
 header-y += utsname.h
+header-y += v4l2-mediabus.h
 header-y += veth.h
 header-y += vhost.h
 header-y += videodev.h
diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
new file mode 100644
index 0000000..127512a
--- /dev/null
+++ b/include/linux/v4l2-mediabus.h
@@ -0,0 +1,70 @@
+/*
+ * Media Bus API header
+ *
+ * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_V4L2_MEDIABUS_H
+#define __LINUX_V4L2_MEDIABUS_H
+
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+/*
+ * These pixel codes uniquely identify data formats on the media bus. Mostly
+ * they correspond to similarly named V4L2_PIX_FMT_* formats, format 0 is
+ * reserved, V4L2_MBUS_FMT_FIXED shall be used by host-client pairs, where the
+ * data format is fixed. Additionally, "2X8" means that one pixel is transferred
+ * in two 8-bit samples, "BE" or "LE" specify in which order those samples are
+ * transferred over the bus: "LE" means that the least significant bits are
+ * transferred first, "BE" means that the most significant bits are transferred
+ * first, and "PADHI" and "PADLO" define which bits - low or high, in the
+ * incomplete high byte, are filled with padding bits.
+ */
+enum v4l2_mbus_pixelcode {
+	V4L2_MBUS_FMT_FIXED = 1,
+	V4L2_MBUS_FMT_YUYV8_2X8,
+	V4L2_MBUS_FMT_YVYU8_2X8,
+	V4L2_MBUS_FMT_UYVY8_2X8,
+	V4L2_MBUS_FMT_VYUY8_2X8,
+	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
+	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
+	V4L2_MBUS_FMT_RGB565_2X8_LE,
+	V4L2_MBUS_FMT_RGB565_2X8_BE,
+	V4L2_MBUS_FMT_SBGGR8_1X8,
+	V4L2_MBUS_FMT_SBGGR10_1X10,
+	V4L2_MBUS_FMT_GREY8_1X8,
+	V4L2_MBUS_FMT_Y10_1X10,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
+	V4L2_MBUS_FMT_SGRBG8_1X8,
+	V4L2_MBUS_FMT_SBGGR12_1X12,
+	V4L2_MBUS_FMT_YUYV8_1_5X8,
+	V4L2_MBUS_FMT_YVYU8_1_5X8,
+	V4L2_MBUS_FMT_UYVY8_1_5X8,
+	V4L2_MBUS_FMT_VYUY8_1_5X8,
+};
+
+/**
+ * struct v4l2_mbus_framefmt - frame format on the media bus
+ * @width:	frame width
+ * @height:	frame height
+ * @code:	data format code
+ * @field:	used interlacing type
+ * @colorspace:	colorspace of the data
+ */
+struct v4l2_mbus_framefmt {
+	__u32				width;
+	__u32				height;
+	__u32				code;
+	enum v4l2_field			field;
+	enum v4l2_colorspace		colorspace;
+};
+
+#endif
diff --git a/include/media/soc_mediabus.h b/include/media/soc_mediabus.h
index 037cd7b..6243147 100644
--- a/include/media/soc_mediabus.h
+++ b/include/media/soc_mediabus.h
@@ -12,8 +12,7 @@
 #define SOC_MEDIABUS_H
 
 #include <linux/videodev2.h>
-
-#include <media/v4l2-mediabus.h>
+#include <linux/v4l2-mediabus.h>
 
 /**
  * enum soc_mbus_packing - data packing types on the media-bus
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index f0cf2e7..971c7fa 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -11,58 +11,7 @@
 #ifndef V4L2_MEDIABUS_H
 #define V4L2_MEDIABUS_H
 
-/*
- * These pixel codes uniquely identify data formats on the media bus. Mostly
- * they correspond to similarly named V4L2_PIX_FMT_* formats, format 0 is
- * reserved, V4L2_MBUS_FMT_FIXED shall be used by host-client pairs, where the
- * data format is fixed. Additionally, "2X8" means that one pixel is transferred
- * in two 8-bit samples, "BE" or "LE" specify in which order those samples are
- * transferred over the bus: "LE" means that the least significant bits are
- * transferred first, "BE" means that the most significant bits are transferred
- * first, and "PADHI" and "PADLO" define which bits - low or high, in the
- * incomplete high byte, are filled with padding bits.
- */
-enum v4l2_mbus_pixelcode {
-	V4L2_MBUS_FMT_FIXED = 1,
-	V4L2_MBUS_FMT_YUYV8_2X8,
-	V4L2_MBUS_FMT_YVYU8_2X8,
-	V4L2_MBUS_FMT_UYVY8_2X8,
-	V4L2_MBUS_FMT_VYUY8_2X8,
-	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
-	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
-	V4L2_MBUS_FMT_RGB565_2X8_LE,
-	V4L2_MBUS_FMT_RGB565_2X8_BE,
-	V4L2_MBUS_FMT_SBGGR8_1X8,
-	V4L2_MBUS_FMT_SBGGR10_1X10,
-	V4L2_MBUS_FMT_GREY8_1X8,
-	V4L2_MBUS_FMT_Y10_1X10,
-	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
-	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
-	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
-	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
-	V4L2_MBUS_FMT_SGRBG8_1X8,
-	V4L2_MBUS_FMT_SBGGR12_1X12,
-	V4L2_MBUS_FMT_YUYV8_1_5X8,
-	V4L2_MBUS_FMT_YVYU8_1_5X8,
-	V4L2_MBUS_FMT_UYVY8_1_5X8,
-	V4L2_MBUS_FMT_VYUY8_1_5X8,
-};
-
-/**
- * struct v4l2_mbus_framefmt - frame format on the media bus
- * @width:	frame width
- * @height:	frame height
- * @code:	data format code
- * @field:	used interlacing type
- * @colorspace:	colorspace of the data
- */
-struct v4l2_mbus_framefmt {
-	__u32				width;
-	__u32				height;
-	enum v4l2_mbus_pixelcode	code;
-	enum v4l2_field			field;
-	enum v4l2_colorspace		colorspace;
-};
+#include <linux/v4l2-mediabus.h>
 
 static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
 				const struct v4l2_mbus_framefmt *mbus_fmt)
-- 
1.7.2.2

