Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:42353 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab1CDI6i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 03:58:38 -0500
From: Michael Jones <michael.jones@matrix-vision.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/4] media: add 8-bit bayer formats and Y12
Date: Fri,  4 Mar 2011 09:58:02 +0100
Message-Id: <1299229084-8335-3-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1299229084-8335-1-git-send-email-michael.jones@matrix-vision.de>
References: <1299229084-8335-1-git-send-email-michael.jones@matrix-vision.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 include/linux/v4l2-mediabus.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 7054a7a..46caecd 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -47,8 +47,9 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
 	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
 
-	/* YUV (including grey) - next is 0x2013 */
+	/* YUV (including grey) - next is 0x2014 */
 	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
+	V4L2_MBUS_FMT_Y12_1X12 = 0x2013,
 	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
 	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
 	V4L2_MBUS_FMT_YUYV8_1_5X8 = 0x2004,
@@ -67,9 +68,11 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
 	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
 
-	/* Bayer - next is 0x3013 */
+	/* Bayer - next is 0x3015 */
 	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
+	V4L2_MBUS_FMT_SGBRG8_1X8 = 0x3013,
 	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
+	V4L2_MBUS_FMT_SRGGB8_1X8 = 0x3014,
 	V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8 = 0x300b,
 	V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8 = 0x300c,
 	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 = 0x3009,
-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
