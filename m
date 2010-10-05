Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:55204 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab0JENMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 09:12:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v2 04/10] v4l: Add 8-bit YUYV on 16-bit bus and SGRBG10 media bus pixel codes
Date: Tue,  5 Oct 2010 15:12:50 +0200
Message-Id: <1286284376-12217-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286284376-12217-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286284376-12217-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add the following media bus format code definitions:

- V4L2_MBUS_FMT_SGRBG10_1X10 for 10-bit GRBG Bayer
- V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 for 10-bit DPCM compressed GRBG Bayer
- V4L2_MBUS_FMT_YUYV16_1X16 for 8-bit YUYV on 16-bit bus
- V4L2_MBUS_FMT_UYVY16_1X16 for 8-bit UYVY on 16-bit bus
- V4L2_MBUS_FMT_YVYU16_1X16 for 8-bit YVYU on 16-bit bus
- V4L2_MBUS_FMT_VYUY16_1X16 for 8-bit VYUY on 16-bit bus

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/v4l2-mediabus.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 1f24a22..897c13a 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -43,19 +43,23 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1003,
 	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1004,
 
-	/* YUV (including grey) - next is 0x200b */
+	/* YUV (including grey) - next is 0x200f */
+	V4L2_MBUS_FMT_UYVY8_1X16 = 0x200b,
 	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2001,
 	V4L2_MBUS_FMT_UYVY8_2X8 = 0x2002,
+	V4L2_MBUS_FMT_VYUY8_1X16 = 0x200c,
 	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
 	V4L2_MBUS_FMT_VYUY8_2X8 = 0x2004,
 	V4L2_MBUS_FMT_Y8_1X8 = 0x2005,
+	V4L2_MBUS_FMT_YUYV8_1X16 = 0x200d,
 	V4L2_MBUS_FMT_YUYV8_1_5X8 = 0x2006,
 	V4L2_MBUS_FMT_YUYV8_2X8 = 0x2007,
+	V4L2_MBUS_FMT_YVYU8_1X16 = 0x200e,
 	V4L2_MBUS_FMT_YVYU8_1_5X8 = 0x2008,
 	V4L2_MBUS_FMT_YVYU8_2X8 = 0x2009,
 	V4L2_MBUS_FMT_Y10_1X10 = 0x200a,
 
-	/* Bayer - next is 0x3009 */
+	/* Bayer - next is 0x300b */
 	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
 	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
 	V4L2_MBUS_FMT_SBGGR10_1X10 = 0x3003,
@@ -63,6 +67,8 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE = 0x3005,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE = 0x3006,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE = 0x3007,
+	V4L2_MBUS_FMT_SGRBG10_1X10 = 0x3009,
+	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 = 0x300a,
 	V4L2_MBUS_FMT_SBGGR12_1X12 = 0x3008,
 };
 
-- 
1.7.2.2

