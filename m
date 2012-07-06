Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60067 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488Ab2GFOe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 10:34:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 08/10] ov772x: Add support for SBGGR10 format
Date: Fri,  6 Jul 2012 16:34:59 +0200
Message-Id: <1341585301-1003-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/ov772x.c |   43 +++++++++++++++++++++++++++++++++++------
 1 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 67c385b..07ff709 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -274,6 +274,7 @@
 #define SLCT_VGA        0x00	/*   0 : VGA */
 #define SLCT_QVGA       0x40	/*   1 : QVGA */
 #define ITU656_ON_OFF   0x20	/* ITU656 protocol ON/OFF selection */
+#define SENSOR_RAW	0x10	/* Sensor RAW */
 				/* RGB output format control */
 #define FMT_MASK        0x0c	/*      Mask of color format */
 #define FMT_GBR422      0x00	/*      00 : GBR 4:2:2 */
@@ -337,6 +338,12 @@
 #define CBAR_ON         0x20	/*   ON */
 #define CBAR_OFF        0x00	/*   OFF */
 
+/* DSP_CTRL4 */
+#define DSP_OFMT_YUV	0x00
+#define DSP_OFMT_RGB	0x00
+#define DSP_OFMT_RAW8	0x02
+#define DSP_OFMT_RAW10	0x03
+
 /* HSTART */
 #define HST_VGA         0x23
 #define HST_QVGA        0x3F
@@ -388,6 +395,7 @@ struct ov772x_color_format {
 	enum v4l2_mbus_pixelcode code;
 	enum v4l2_colorspace colorspace;
 	u8 dsp3;
+	u8 dsp4;
 	u8 com3;
 	u8 com7;
 };
@@ -498,6 +506,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 		.code		= V4L2_MBUS_FMT_YUYV8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.dsp3		= 0x0,
+		.dsp4		= DSP_OFMT_YUV,
 		.com3		= SWAP_YUV,
 		.com7		= OFMT_YUV,
 	},
@@ -505,6 +514,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 		.code		= V4L2_MBUS_FMT_YVYU8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.dsp3		= UV_ON,
+		.dsp4		= DSP_OFMT_YUV,
 		.com3		= SWAP_YUV,
 		.com7		= OFMT_YUV,
 	},
@@ -512,6 +522,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 		.code		= V4L2_MBUS_FMT_UYVY8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.dsp3		= 0x0,
+		.dsp4		= DSP_OFMT_YUV,
 		.com3		= 0x0,
 		.com7		= OFMT_YUV,
 	},
@@ -519,6 +530,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 		.code		= V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.dsp3		= 0x0,
+		.dsp4		= DSP_OFMT_YUV,
 		.com3		= SWAP_RGB,
 		.com7		= FMT_RGB555 | OFMT_RGB,
 	},
@@ -526,6 +538,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 		.code		= V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.dsp3		= 0x0,
+		.dsp4		= DSP_OFMT_YUV,
 		.com3		= 0x0,
 		.com7		= FMT_RGB555 | OFMT_RGB,
 	},
@@ -533,6 +546,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 		.code		= V4L2_MBUS_FMT_RGB565_2X8_LE,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.dsp3		= 0x0,
+		.dsp4		= DSP_OFMT_YUV,
 		.com3		= SWAP_RGB,
 		.com7		= FMT_RGB565 | OFMT_RGB,
 	},
@@ -540,9 +554,22 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 		.code		= V4L2_MBUS_FMT_RGB565_2X8_BE,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.dsp3		= 0x0,
+		.dsp4		= DSP_OFMT_YUV,
 		.com3		= 0x0,
 		.com7		= FMT_RGB565 | OFMT_RGB,
 	},
+	{
+		/* Setting DSP4 to DSP_OFMT_RAW8 still gives 10-bit output,
+		 * regardless of the COM7 value. We can thus only support 10-bit
+		 * Bayer until someone figures it out.
+		 */
+		.code		= V4L2_MBUS_FMT_SBGGR10_1X10,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
+		.dsp3		= 0x0,
+		.dsp4		= DSP_OFMT_RAW10,
+		.com3		= 0x0,
+		.com7		= SENSOR_RAW | OFMT_BRAW,
+	},
 };
 
 #define VGA_WIDTH   640
@@ -684,6 +711,13 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 			goto ov772x_set_fmt_error;
 	}
 
+	/* DSP_CTRL4: AEC reference point and DSP output format. */
+	if (cfmt->dsp4) {
+		ret = ov772x_write(client, DSP_CTRL4, cfmt->dsp4);
+		if (ret < 0)
+			goto ov772x_set_fmt_error;
+	}
+
 	/*
 	 * set COM3
 	 */
@@ -702,13 +736,8 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 	if (ret < 0)
 		goto ov772x_set_fmt_error;
 
-	/*
-	 * set COM7
-	 */
-	val = win->com7_bit | cfmt->com7;
-	ret = ov772x_mask_set(client,
-			      COM7, SLCT_MASK | FMT_MASK | OFMT_MASK,
-			      val);
+	/* COM7: Sensor resolution and output format control. */
+	ret = ov772x_write(client, COM7, win->com7_bit | cfmt->com7);
 	if (ret < 0)
 		goto ov772x_set_fmt_error;
 
-- 
1.7.8.6

