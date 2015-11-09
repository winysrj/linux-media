Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:32016 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbbKIN0P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Nov 2015 08:26:15 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 1/4] libv4l2subdev: Switch to media bus formats
Date: Mon,  9 Nov 2015 15:25:22 +0200
Message-Id: <1447075525-32321-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1447075525-32321-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1447075525-32321-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No longer use the old V4L2 based MBUS_FMT definitions. Instead, use the
newer media bus format definitions.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/libv4l2subdev.c | 54 ++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 949eeff..b33d3fd 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -719,33 +719,33 @@ static struct {
 	const char *name;
 	enum v4l2_mbus_pixelcode code;
 } mbus_formats[] = {
-	{ "Y8", V4L2_MBUS_FMT_Y8_1X8},
-	{ "Y10", V4L2_MBUS_FMT_Y10_1X10 },
-	{ "Y12", V4L2_MBUS_FMT_Y12_1X12 },
-	{ "YUYV", V4L2_MBUS_FMT_YUYV8_1X16 },
-	{ "YUYV1_5X8", V4L2_MBUS_FMT_YUYV8_1_5X8 },
-	{ "YUYV2X8", V4L2_MBUS_FMT_YUYV8_2X8 },
-	{ "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },
-	{ "UYVY1_5X8", V4L2_MBUS_FMT_UYVY8_1_5X8 },
-	{ "UYVY2X8", V4L2_MBUS_FMT_UYVY8_2X8 },
-	{ "SBGGR8", V4L2_MBUS_FMT_SBGGR8_1X8 },
-	{ "SGBRG8", V4L2_MBUS_FMT_SGBRG8_1X8 },
-	{ "SGRBG8", V4L2_MBUS_FMT_SGRBG8_1X8 },
-	{ "SRGGB8", V4L2_MBUS_FMT_SRGGB8_1X8 },
-	{ "SBGGR10", V4L2_MBUS_FMT_SBGGR10_1X10 },
-	{ "SGBRG10", V4L2_MBUS_FMT_SGBRG10_1X10 },
-	{ "SGRBG10", V4L2_MBUS_FMT_SGRBG10_1X10 },
-	{ "SRGGB10", V4L2_MBUS_FMT_SRGGB10_1X10 },
-	{ "SBGGR10_DPCM8", V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8 },
-	{ "SGBRG10_DPCM8", V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8 },
-	{ "SGRBG10_DPCM8", V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 },
-	{ "SRGGB10_DPCM8", V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8 },
-	{ "SBGGR12", V4L2_MBUS_FMT_SBGGR12_1X12 },
-	{ "SGBRG12", V4L2_MBUS_FMT_SGBRG12_1X12 },
-	{ "SGRBG12", V4L2_MBUS_FMT_SGRBG12_1X12 },
-	{ "SRGGB12", V4L2_MBUS_FMT_SRGGB12_1X12 },
-	{ "AYUV32", V4L2_MBUS_FMT_AYUV8_1X32 },
-	{ "ARGB32", V4L2_MBUS_FMT_ARGB8888_1X32 },
+	{ "Y8", MEDIA_BUS_FMT_Y8_1X8},
+	{ "Y10", MEDIA_BUS_FMT_Y10_1X10 },
+	{ "Y12", MEDIA_BUS_FMT_Y12_1X12 },
+	{ "YUYV", MEDIA_BUS_FMT_YUYV8_1X16 },
+	{ "YUYV1_5X8", MEDIA_BUS_FMT_YUYV8_1_5X8 },
+	{ "YUYV2X8", MEDIA_BUS_FMT_YUYV8_2X8 },
+	{ "UYVY", MEDIA_BUS_FMT_UYVY8_1X16 },
+	{ "UYVY1_5X8", MEDIA_BUS_FMT_UYVY8_1_5X8 },
+	{ "UYVY2X8", MEDIA_BUS_FMT_UYVY8_2X8 },
+	{ "SBGGR8", MEDIA_BUS_FMT_SBGGR8_1X8 },
+	{ "SGBRG8", MEDIA_BUS_FMT_SGBRG8_1X8 },
+	{ "SGRBG8", MEDIA_BUS_FMT_SGRBG8_1X8 },
+	{ "SRGGB8", MEDIA_BUS_FMT_SRGGB8_1X8 },
+	{ "SBGGR10", MEDIA_BUS_FMT_SBGGR10_1X10 },
+	{ "SGBRG10", MEDIA_BUS_FMT_SGBRG10_1X10 },
+	{ "SGRBG10", MEDIA_BUS_FMT_SGRBG10_1X10 },
+	{ "SRGGB10", MEDIA_BUS_FMT_SRGGB10_1X10 },
+	{ "SBGGR10_DPCM8", MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8 },
+	{ "SGBRG10_DPCM8", MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8 },
+	{ "SGRBG10_DPCM8", MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8 },
+	{ "SRGGB10_DPCM8", MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8 },
+	{ "SBGGR12", MEDIA_BUS_FMT_SBGGR12_1X12 },
+	{ "SGBRG12", MEDIA_BUS_FMT_SGBRG12_1X12 },
+	{ "SGRBG12", MEDIA_BUS_FMT_SGRBG12_1X12 },
+	{ "SRGGB12", MEDIA_BUS_FMT_SRGGB12_1X12 },
+	{ "AYUV32", MEDIA_BUS_FMT_AYUV8_1X32 },
+	{ "ARGB32", MEDIA_BUS_FMT_ARGB8888_1X32 },
 };
 
 const char *v4l2_subdev_pixelcode_to_string(enum v4l2_mbus_pixelcode code)
-- 
2.1.0.231.g7484e3b

