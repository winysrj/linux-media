Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48148 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbbDPH6l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 03:58:41 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 565A32074B
	for <linux-media@vger.kernel.org>; Thu, 16 Apr 2015 09:56:39 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] media-ctl: libv4l2subdev: Switch to MEDIA_BUS_FMT_*
Date: Thu, 16 Apr 2015 10:58:36 +0300
Message-Id: <1429171117-4866-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_MBUS_FMT_* macros have been replaced by corresponding
MEDIA_BUS_FMT_* macros. The old names have been preserved for
compatibility reasons, but new formats will use MEDIA_BUS_FMT_* only.
Switch to the new name.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 utils/media-ctl/libv4l2subdev.c | 54 ++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 8015330..6ea6648 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -699,33 +699,33 @@ static struct {
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
2.0.5

