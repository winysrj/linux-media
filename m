Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:55204 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0JENMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 09:12:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v2 03/10] v4l: Group media bus pixel codes by types and sort them alphabetically
Date: Tue,  5 Oct 2010 15:12:49 +0200
Message-Id: <1286284376-12217-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286284376-12217-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286284376-12217-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Adding new pixel codes at the end of the enumeration will soon create a
mess, so sort the pixel codes by type and then sort them alphabetically.

As the codes are part of the kernel ABI their value can't change when a
new code is inserted in the enumeration, so they are given an explicit
numerical value. When inserting a new pixel code developers must use and
update the next free value.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/v4l2-mediabus.h |   61 +++++++++++++++++++++++++---------------
 1 files changed, 38 insertions(+), 23 deletions(-)

diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 75c2d55..1f24a22 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -24,31 +24,46 @@
  * transferred first, "BE" means that the most significant bits are transferred
  * first, and "PADHI" and "PADLO" define which bits - low or high, in the
  * incomplete high byte, are filled with padding bits.
+ *
+ * The pixel codes are grouped by types and sorted by width first and then
+ * alphabetically, using generic numerical sort order for numerical values
+ * (8 thus comes before 10).
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
-	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
-	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
-	V4L2_MBUS_FMT_RGB565_2X8_LE,
-	V4L2_MBUS_FMT_RGB565_2X8_BE,
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
+	/* RGB - next is 0x1005 */
+	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 0x1001,
+	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE = 0x1002,
+	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1003,
+	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1004,
+
+	/* YUV (including grey) - next is 0x200b */
+	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2001,
+	V4L2_MBUS_FMT_UYVY8_2X8 = 0x2002,
+	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
+	V4L2_MBUS_FMT_VYUY8_2X8 = 0x2004,
+	V4L2_MBUS_FMT_Y8_1X8 = 0x2005,
+	V4L2_MBUS_FMT_YUYV8_1_5X8 = 0x2006,
+	V4L2_MBUS_FMT_YUYV8_2X8 = 0x2007,
+	V4L2_MBUS_FMT_YVYU8_1_5X8 = 0x2008,
+	V4L2_MBUS_FMT_YVYU8_2X8 = 0x2009,
+	V4L2_MBUS_FMT_Y10_1X10 = 0x200a,
+
+	/* Bayer - next is 0x3009 */
+	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
+	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
+	V4L2_MBUS_FMT_SBGGR10_1X10 = 0x3003,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE = 0x3004,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE = 0x3005,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE = 0x3006,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE = 0x3007,
+	V4L2_MBUS_FMT_SBGGR12_1X12 = 0x3008,
 };
 
 /**
-- 
1.7.2.2

