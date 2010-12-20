Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51294 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab0LTLhb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 06:37:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v5 04/13] v4l: Group media bus pixel codes by types and sort them alphabetically
Date: Mon, 20 Dec 2010 12:37:16 +0100
Message-Id: <1292845045-7945-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1292845045-7945-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1292845045-7945-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Adding new pixel codes at the end of the enumeration will soon create a
mess, so group the pixel codes by type and sort them by bus_width, bits
per component, samples per pixel and order of subsamples.

As the codes are part of the kernel ABI their value can't change when a
new code is inserted in the enumeration, so they are given an explicit
numerical value. When inserting a new pixel code developers must use and
update the next free value.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/v4l2-mediabus.h |   77 ++++++++++++++++++++++++----------------
 1 files changed, 46 insertions(+), 31 deletions(-)

diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 1171cac..ed5ac25 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -24,39 +24,54 @@
  * transferred first, "BE" means that the most significant bits are transferred
  * first, and "PADHI" and "PADLO" define which bits - low or high, in the
  * incomplete high byte, are filled with padding bits.
+ *
+ * The pixel codes are grouped by type, bus_width, bits per component, samples
+ * per pixel and order of subsamples. Numerical values are sorted using generic
+ * numerical sort order (8 thus comes before 10).
+ *
+ * As their value can't change when a new pixel code is inserted in the
+ * enumeration, the pixel codes are explicitly given a numerical value. The next
+ * free values for each category are listed below, update them when inserting
+ * new pixel codes.
  */
 enum v4l2_mbus_pixelcode {
-	V4L2_MBUS_FMT_FIXED = 1,
-	V4L2_MBUS_FMT_YUYV8_2X8,
-	V4L2_MBUS_FMT_YVYU8_2X8,
-	V4L2_MBUS_FMT_UYVY8_2X8,
-	V4L2_MBUS_FMT_VYUY8_2X8,
-	V4L2_MBUS_FMT_YVYU10_2X10,
-	V4L2_MBUS_FMT_YUYV10_2X10,
-	V4L2_MBUS_FMT_YVYU10_1X20,
-	V4L2_MBUS_FMT_YUYV10_1X20,
-	V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
-	V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE,
-	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
-	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
-	V4L2_MBUS_FMT_RGB565_2X8_LE,
-	V4L2_MBUS_FMT_RGB565_2X8_BE,
-	V4L2_MBUS_FMT_BGR565_2X8_LE,
-	V4L2_MBUS_FMT_BGR565_2X8_BE,
-	V4L2_MBUS_FMT_SBGGR8_1X8,
-	V4L2_MBUS_FMT_SBGGR10_1X10,
-	V4L2_MBUS_FMT_Y8_1X8,
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
+	V4L2_MBUS_FMT_FIXED = 0x0001,
+
+	/* RGB - next is 0x1009 */
+	V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
+	V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
+	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
+	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE = 0x1004,
+	V4L2_MBUS_FMT_BGR565_2X8_BE = 0x1005,
+	V4L2_MBUS_FMT_BGR565_2X8_LE = 0x1006,
+	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
+	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
+
+	/* YUV (including grey) - next is 0x200f */
+	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
+	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
+	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
+	V4L2_MBUS_FMT_YUYV8_1_5X8 = 0x2004,
+	V4L2_MBUS_FMT_YVYU8_1_5X8 = 0x2005,
+	V4L2_MBUS_FMT_UYVY8_2X8 = 0x2006,
+	V4L2_MBUS_FMT_VYUY8_2X8 = 0x2007,
+	V4L2_MBUS_FMT_YUYV8_2X8 = 0x2008,
+	V4L2_MBUS_FMT_YVYU8_2X8 = 0x2009,
+	V4L2_MBUS_FMT_Y10_1X10 = 0x200a,
+	V4L2_MBUS_FMT_YUYV10_2X10 = 0x200b,
+	V4L2_MBUS_FMT_YVYU10_2X10 = 0x200c,
+	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
+	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
+
+	/* Bayer - next is 0x3009 */
+	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
+	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE = 0x3003,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE = 0x3004,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE = 0x3005,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE = 0x3006,
+	V4L2_MBUS_FMT_SBGGR10_1X10 = 0x3007,
+	V4L2_MBUS_FMT_SBGGR12_1X12 = 0x3008,
 };
 
 /**
-- 
1.7.2.2

