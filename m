Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44099 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab3LDA4f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:35 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id A84D8366A6
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:40 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 17/25] v4l: omap4iss: Add description field to iss_format_info structure
Date: Wed,  4 Dec 2013 01:56:17 +0100
Message-Id: <1386118585-12449-18-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The field stores the format description in a human-readable form.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 38 +++++++++++++++---------------
 drivers/staging/media/omap4iss/iss_video.h |  2 ++
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 7763b8d..b4ffde8 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -33,61 +33,61 @@
 static struct iss_format_info formats[] = {
 	{ V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
 	  V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
-	  V4L2_PIX_FMT_GREY, 8, },
+	  V4L2_PIX_FMT_GREY, 8, "Greyscale 8 bpp", },
 	{ V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y10_1X10,
 	  V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y8_1X8,
-	  V4L2_PIX_FMT_Y10, 10, },
+	  V4L2_PIX_FMT_Y10, 10, "Greyscale 10 bpp", },
 	{ V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y10_1X10,
 	  V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y8_1X8,
-	  V4L2_PIX_FMT_Y12, 12, },
+	  V4L2_PIX_FMT_Y12, 12, "Greyscale 12 bpp", },
 	{ V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
 	  V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
-	  V4L2_PIX_FMT_SBGGR8, 8, },
+	  V4L2_PIX_FMT_SBGGR8, 8, "BGGR Bayer 8 bpp", },
 	{ V4L2_MBUS_FMT_SGBRG8_1X8, V4L2_MBUS_FMT_SGBRG8_1X8,
 	  V4L2_MBUS_FMT_SGBRG8_1X8, V4L2_MBUS_FMT_SGBRG8_1X8,
-	  V4L2_PIX_FMT_SGBRG8, 8, },
+	  V4L2_PIX_FMT_SGBRG8, 8, "GBRG Bayer 8 bpp", },
 	{ V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
 	  V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
-	  V4L2_PIX_FMT_SGRBG8, 8, },
+	  V4L2_PIX_FMT_SGRBG8, 8, "GRBG Bayer 8 bpp", },
 	{ V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
 	  V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
-	  V4L2_PIX_FMT_SRGGB8, 8, },
+	  V4L2_PIX_FMT_SRGGB8, 8, "RGGB Bayer 8 bpp", },
 	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
 	  V4L2_MBUS_FMT_SGRBG10_1X10, 0,
-	  V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
+	  V4L2_PIX_FMT_SGRBG10DPCM8, 8, "GRBG Bayer 10 bpp DPCM8",  },
 	{ V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR10_1X10,
 	  V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR8_1X8,
-	  V4L2_PIX_FMT_SBGGR10, 10, },
+	  V4L2_PIX_FMT_SBGGR10, 10, "BGGR Bayer 10 bpp", },
 	{ V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_MBUS_FMT_SGBRG10_1X10,
 	  V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_MBUS_FMT_SGBRG8_1X8,
-	  V4L2_PIX_FMT_SGBRG10, 10, },
+	  V4L2_PIX_FMT_SGBRG10, 10, "GBRG Bayer 10 bpp", },
 	{ V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG10_1X10,
 	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG8_1X8,
-	  V4L2_PIX_FMT_SGRBG10, 10, },
+	  V4L2_PIX_FMT_SGRBG10, 10, "GRBG Bayer 10 bpp", },
 	{ V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_MBUS_FMT_SRGGB10_1X10,
 	  V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_MBUS_FMT_SRGGB8_1X8,
-	  V4L2_PIX_FMT_SRGGB10, 10, },
+	  V4L2_PIX_FMT_SRGGB10, 10, "RGGB Bayer 10 bpp", },
 	{ V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_MBUS_FMT_SBGGR10_1X10,
 	  V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_MBUS_FMT_SBGGR8_1X8,
-	  V4L2_PIX_FMT_SBGGR12, 12, },
+	  V4L2_PIX_FMT_SBGGR12, 12, "BGGR Bayer 12 bpp", },
 	{ V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_MBUS_FMT_SGBRG10_1X10,
 	  V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_MBUS_FMT_SGBRG8_1X8,
-	  V4L2_PIX_FMT_SGBRG12, 12, },
+	  V4L2_PIX_FMT_SGBRG12, 12, "GBRG Bayer 12 bpp", },
 	{ V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_MBUS_FMT_SGRBG10_1X10,
 	  V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_MBUS_FMT_SGRBG8_1X8,
-	  V4L2_PIX_FMT_SGRBG12, 12, },
+	  V4L2_PIX_FMT_SGRBG12, 12, "GRBG Bayer 12 bpp", },
 	{ V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB10_1X10,
 	  V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB8_1X8,
-	  V4L2_PIX_FMT_SRGGB12, 12, },
+	  V4L2_PIX_FMT_SRGGB12, 12, "RGGB Bayer 12 bpp", },
 	{ V4L2_MBUS_FMT_UYVY8_1X16, V4L2_MBUS_FMT_UYVY8_1X16,
 	  V4L2_MBUS_FMT_UYVY8_1X16, 0,
-	  V4L2_PIX_FMT_UYVY, 16, },
+	  V4L2_PIX_FMT_UYVY, 16, "YUV 4:2:2 (UYVY)", },
 	{ V4L2_MBUS_FMT_YUYV8_1X16, V4L2_MBUS_FMT_YUYV8_1X16,
 	  V4L2_MBUS_FMT_YUYV8_1X16, 0,
-	  V4L2_PIX_FMT_YUYV, 16, },
+	  V4L2_PIX_FMT_YUYV, 16, "YUV 4:2:2 (YUYV)", },
 	{ V4L2_MBUS_FMT_YUYV8_1_5X8, V4L2_MBUS_FMT_YUYV8_1_5X8,
 	  V4L2_MBUS_FMT_YUYV8_1_5X8, 0,
-	  V4L2_PIX_FMT_NV12, 8, },
+	  V4L2_PIX_FMT_NV12, 8, "YUV 4:2:0 (NV12)", },
 };
 
 const struct iss_format_info *
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index 35f14d8..2c8d256 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -40,6 +40,7 @@ struct v4l2_pix_format;
  *	shifted to be 8 bits per pixel. =0 if format is not shiftable.
  * @pixelformat: V4L2 pixel format FCC identifier
  * @bpp: Bits per pixel
+ * @description: Human-readable format description
  */
 struct iss_format_info {
 	enum v4l2_mbus_pixelcode code;
@@ -48,6 +49,7 @@ struct iss_format_info {
 	enum v4l2_mbus_pixelcode flavor;
 	u32 pixelformat;
 	unsigned int bpp;
+	const char *description;
 };
 
 enum iss_pipeline_stream_state {
-- 
1.8.3.2

