Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:22438 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933951Ab2AKV1Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 16:27:16 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH 10/23] omap3isp: Support additional in-memory compressed bayer formats
Date: Wed, 11 Jan 2012 23:26:47 +0200
Message-Id: <1326317220-15339-10-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4F0DFE92.80102@iki.fi>
References: <4F0DFE92.80102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This also prevents accessing NULL pointer in csi2_try_format().

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispvideo.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index f229057..9cc5090 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -46,6 +46,10 @@
  * Helper functions
  */
 
+/*
+ * NOTE: When adding new media bus codes, always remember to add
+ * corresponding in-memory formats to the table below!!!
+ */
 static struct isp_format_info formats[] = {
 	{ V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
 	  V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
@@ -68,9 +72,18 @@ static struct isp_format_info formats[] = {
 	{ V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
 	  V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
 	  V4L2_PIX_FMT_SRGGB8, 8, },
+	{ V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8, V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8,
+	  V4L2_MBUS_FMT_SBGGR10_1X10, 0,
+	  V4L2_PIX_FMT_SBGGR10DPCM8, 8, },
+	{ V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8, V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8,
+	  V4L2_MBUS_FMT_SGBRG10_1X10, 0,
+	  V4L2_PIX_FMT_SGBRG10DPCM8, 8, },
 	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
 	  V4L2_MBUS_FMT_SGRBG10_1X10, 0,
 	  V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
+	{ V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8, V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8,
+	  V4L2_MBUS_FMT_SRGGB10_1X10, 0,
+	  V4L2_PIX_FMT_SRGGB10DPCM8, 8, },
 	{ V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR10_1X10,
 	  V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR8_1X8,
 	  V4L2_PIX_FMT_SBGGR10, 10, },
-- 
1.7.2.5

