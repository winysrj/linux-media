Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37279 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab2FZNpk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 09:45:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, Enrico <ebutera@users.berlios.de>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Abhishek Reddy Kondaveeti <areddykondaveeti@aptina.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH 1/6] omap3isp: video: Split format info bpp field into width and bpp
Date: Tue, 26 Jun 2012 15:45:34 +0200
Message-Id: <1340718339-29915-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1340718339-29915-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1340718339-29915-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The bpp field currently stores the sample width and is aligned to the
next multiple of 8 bits when computing data size in memory. This won't
work anymore for YUYV8_2X8 formats. Split the bpp field into a sample
width and a bits per pixel value.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispccdc.c  |    8 +++---
 drivers/media/video/omap3isp/ispvideo.c |   45 ++++++++++++++++---------------
 drivers/media/video/omap3isp/ispvideo.h |    6 +++-
 3 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index b74f7e9..e4231ef 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1143,12 +1143,12 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	if (!v4l2_subdev_call(sensor, pad, get_fmt, NULL, &fmt_src)) {
 		fmt_info = omap3isp_video_format_info(fmt_src.format.code);
-		depth_in = fmt_info->bpp;
+		depth_in = fmt_info->width;
 	}
 
 	fmt_info = omap3isp_video_format_info
 		(isp->isp_ccdc.formats[CCDC_PAD_SINK].code);
-	depth_out = fmt_info->bpp;
+	depth_out = fmt_info->width;
 
 	shift = depth_in - depth_out;
 	omap3isp_configure_bridge(isp, ccdc->input, pdata, shift);
@@ -1179,7 +1179,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
 
 	/* Use PACK8 mode for 1byte per pixel formats. */
-	if (omap3isp_video_format_info(format->code)->bpp <= 8)
+	if (omap3isp_video_format_info(format->code)->width <= 8)
 		syn_mode |= ISPCCDC_SYN_MODE_PACK8;
 	else
 		syn_mode &= ~ISPCCDC_SYN_MODE_PACK8;
@@ -2182,7 +2182,7 @@ static bool ccdc_is_shiftable(enum v4l2_mbus_pixelcode in,
 	if (in_info->flavor != out_info->flavor)
 		return false;
 
-	return in_info->bpp - out_info->bpp + additional_shift <= 6;
+	return in_info->width - out_info->width + additional_shift <= 6;
 }
 
 static int ccdc_link_validate(struct v4l2_subdev *sd,
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index b37379d..f0ed2ec 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -53,67 +53,67 @@
 static struct isp_format_info formats[] = {
 	{ V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
 	  V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
-	  V4L2_PIX_FMT_GREY, 8, },
+	  V4L2_PIX_FMT_GREY, 8, 8, },
 	{ V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y10_1X10,
 	  V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y8_1X8,
-	  V4L2_PIX_FMT_Y10, 10, },
+	  V4L2_PIX_FMT_Y10, 10, 16, },
 	{ V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y10_1X10,
 	  V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y8_1X8,
-	  V4L2_PIX_FMT_Y12, 12, },
+	  V4L2_PIX_FMT_Y12, 12, 16, },
 	{ V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
 	  V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
-	  V4L2_PIX_FMT_SBGGR8, 8, },
+	  V4L2_PIX_FMT_SBGGR8, 8, 8, },
 	{ V4L2_MBUS_FMT_SGBRG8_1X8, V4L2_MBUS_FMT_SGBRG8_1X8,
 	  V4L2_MBUS_FMT_SGBRG8_1X8, V4L2_MBUS_FMT_SGBRG8_1X8,
-	  V4L2_PIX_FMT_SGBRG8, 8, },
+	  V4L2_PIX_FMT_SGBRG8, 8, 8, },
 	{ V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
 	  V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
-	  V4L2_PIX_FMT_SGRBG8, 8, },
+	  V4L2_PIX_FMT_SGRBG8, 8, 8, },
 	{ V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
 	  V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
-	  V4L2_PIX_FMT_SRGGB8, 8, },
+	  V4L2_PIX_FMT_SRGGB8, 8, 8, },
 	{ V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8, V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8,
 	  V4L2_MBUS_FMT_SBGGR10_1X10, 0,
-	  V4L2_PIX_FMT_SBGGR10DPCM8, 8, },
+	  V4L2_PIX_FMT_SBGGR10DPCM8, 8, 8, },
 	{ V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8, V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8,
 	  V4L2_MBUS_FMT_SGBRG10_1X10, 0,
-	  V4L2_PIX_FMT_SGBRG10DPCM8, 8, },
+	  V4L2_PIX_FMT_SGBRG10DPCM8, 8, 8, },
 	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
 	  V4L2_MBUS_FMT_SGRBG10_1X10, 0,
-	  V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
+	  V4L2_PIX_FMT_SGRBG10DPCM8, 8, 8, },
 	{ V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8, V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8,
 	  V4L2_MBUS_FMT_SRGGB10_1X10, 0,
-	  V4L2_PIX_FMT_SRGGB10DPCM8, 8, },
+	  V4L2_PIX_FMT_SRGGB10DPCM8, 8, 8, },
 	{ V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR10_1X10,
 	  V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR8_1X8,
-	  V4L2_PIX_FMT_SBGGR10, 10, },
+	  V4L2_PIX_FMT_SBGGR10, 10, 16, },
 	{ V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_MBUS_FMT_SGBRG10_1X10,
 	  V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_MBUS_FMT_SGBRG8_1X8,
-	  V4L2_PIX_FMT_SGBRG10, 10, },
+	  V4L2_PIX_FMT_SGBRG10, 10, 16, },
 	{ V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG10_1X10,
 	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG8_1X8,
-	  V4L2_PIX_FMT_SGRBG10, 10, },
+	  V4L2_PIX_FMT_SGRBG10, 10, 16, },
 	{ V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_MBUS_FMT_SRGGB10_1X10,
 	  V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_MBUS_FMT_SRGGB8_1X8,
-	  V4L2_PIX_FMT_SRGGB10, 10, },
+	  V4L2_PIX_FMT_SRGGB10, 10, 16, },
 	{ V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_MBUS_FMT_SBGGR10_1X10,
 	  V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_MBUS_FMT_SBGGR8_1X8,
-	  V4L2_PIX_FMT_SBGGR12, 12, },
+	  V4L2_PIX_FMT_SBGGR12, 12, 16, },
 	{ V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_MBUS_FMT_SGBRG10_1X10,
 	  V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_MBUS_FMT_SGBRG8_1X8,
-	  V4L2_PIX_FMT_SGBRG12, 12, },
+	  V4L2_PIX_FMT_SGBRG12, 12, 16, },
 	{ V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_MBUS_FMT_SGRBG10_1X10,
 	  V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_MBUS_FMT_SGRBG8_1X8,
-	  V4L2_PIX_FMT_SGRBG12, 12, },
+	  V4L2_PIX_FMT_SGRBG12, 12, 16, },
 	{ V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB10_1X10,
 	  V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB8_1X8,
-	  V4L2_PIX_FMT_SRGGB12, 12, },
+	  V4L2_PIX_FMT_SRGGB12, 12, 16, },
 	{ V4L2_MBUS_FMT_UYVY8_1X16, V4L2_MBUS_FMT_UYVY8_1X16,
 	  V4L2_MBUS_FMT_UYVY8_1X16, 0,
-	  V4L2_PIX_FMT_UYVY, 16, },
+	  V4L2_PIX_FMT_UYVY, 16, 16, },
 	{ V4L2_MBUS_FMT_YUYV8_1X16, V4L2_MBUS_FMT_YUYV8_1X16,
 	  V4L2_MBUS_FMT_YUYV8_1X16, 0,
-	  V4L2_PIX_FMT_YUYV, 16, },
+	  V4L2_PIX_FMT_YUYV, 16, 16, },
 };
 
 const struct isp_format_info *
@@ -921,7 +921,8 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 		return ret;
 	}
 
-	pipe->external_bpp = omap3isp_video_format_info(fmt.format.code)->bpp;
+	pipe->external_width =
+		omap3isp_video_format_info(fmt.format.code)->width;
 
 	memset(&ctrls, 0, sizeof(ctrls));
 	memset(&ctrl, 0, sizeof(ctrl));
diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/video/omap3isp/ispvideo.h
index 5acc909..f8092cc 100644
--- a/drivers/media/video/omap3isp/ispvideo.h
+++ b/drivers/media/video/omap3isp/ispvideo.h
@@ -51,7 +51,8 @@ struct v4l2_pix_format;
  * @flavor: V4L2 media bus format code for the same pixel layout but
  *	shifted to be 8 bits per pixel. =0 if format is not shiftable.
  * @pixelformat: V4L2 pixel format FCC identifier
- * @bpp: Bits per pixel
+ * @width: Data bus width
+ * @bpp: Bits per pixel (when stored in memory)
  */
 struct isp_format_info {
 	enum v4l2_mbus_pixelcode code;
@@ -59,6 +60,7 @@ struct isp_format_info {
 	enum v4l2_mbus_pixelcode uncompressed;
 	enum v4l2_mbus_pixelcode flavor;
 	u32 pixelformat;
+	unsigned int width;
 	unsigned int bpp;
 };
 
@@ -106,7 +108,7 @@ struct isp_pipeline {
 	struct v4l2_fract max_timeperframe;
 	struct v4l2_subdev *external;
 	unsigned int external_rate;
-	unsigned int external_bpp;
+	unsigned int external_width;
 };
 
 #define to_isp_pipeline(__e) \
-- 
1.7.3.4

