Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50868 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbeKCBqa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 21:46:30 -0400
Received: by mail-wm1-f68.google.com with SMTP id h2-v6so2535327wmb.0
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2018 09:38:46 -0700 (PDT)
From: Loic Poulain <loic.poulain@linaro.org>
To: slongerbeam@gmail.com
Cc: linux-media@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] media: ov5640: Add RAW bayer format support
Date: Fri,  2 Nov 2018 17:38:43 +0100
Message-Id: <1541176723-20398-1-git-send-email-loic.poulain@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OV5640 sensor supports raw image output (bayer).
Configure ISP mux/format registers accordingly.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/media/i2c/ov5640.c | 58 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 071f4bc..e38e05e 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -116,6 +116,15 @@ enum ov5640_frame_rate {
 	OV5640_NUM_FRAMERATES,
 };
 
+enum ov5640_format_mux {
+	OV5640_FMT_MUX_YUV422 = 0,
+	OV5640_FMT_MUX_RGB,
+	OV5640_FMT_MUX_DITHER,
+	OV5640_FMT_MUX_RAW_DPC,
+	OV5640_FMT_MUX_SNR_RAW,
+	OV5640_FMT_MUX_RAW_CIP,
+};
+
 struct ov5640_pixfmt {
 	u32 code;
 	u32 colorspace;
@@ -127,6 +136,10 @@ static const struct ov5640_pixfmt ov5640_formats[] = {
 	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_SRGB, },
 	{ MEDIA_BUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB, },
 	{ MEDIA_BUS_FMT_RGB565_2X8_BE, V4L2_COLORSPACE_SRGB, },
+	{ MEDIA_BUS_FMT_SBGGR8_1X8, V4L2_COLORSPACE_SRGB, },
+	{ MEDIA_BUS_FMT_SGBRG8_1X8, V4L2_COLORSPACE_SRGB, },
+	{ MEDIA_BUS_FMT_SGRBG8_1X8, V4L2_COLORSPACE_SRGB, },
+	{ MEDIA_BUS_FMT_SRGGB8_1X8, V4L2_COLORSPACE_SRGB, },
 };
 
 /*
@@ -1980,46 +1993,67 @@ static int ov5640_set_framefmt(struct ov5640_dev *sensor,
 			       struct v4l2_mbus_framefmt *format)
 {
 	int ret = 0;
-	bool is_rgb = false;
 	bool is_jpeg = false;
-	u8 val;
+	u8 fmt, mux;
 
 	switch (format->code) {
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 		/* YUV422, UYVY */
-		val = 0x3f;
+		fmt = 0x3f;
+		mux = OV5640_FMT_MUX_YUV422;
 		break;
 	case MEDIA_BUS_FMT_YUYV8_2X8:
 		/* YUV422, YUYV */
-		val = 0x30;
+		fmt = 0x30;
+		mux = OV5640_FMT_MUX_YUV422;
 		break;
 	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 		/* RGB565 {g[2:0],b[4:0]},{r[4:0],g[5:3]} */
-		val = 0x6F;
-		is_rgb = true;
+		fmt = 0x6F;
+		mux = OV5640_FMT_MUX_RGB;
 		break;
 	case MEDIA_BUS_FMT_RGB565_2X8_BE:
 		/* RGB565 {r[4:0],g[5:3]},{g[2:0],b[4:0]} */
-		val = 0x61;
-		is_rgb = true;
+		fmt = 0x61;
+		mux = OV5640_FMT_MUX_RGB;
 		break;
 	case MEDIA_BUS_FMT_JPEG_1X8:
 		/* YUV422, YUYV */
-		val = 0x30;
+		fmt = 0x30;
+		mux = OV5640_FMT_MUX_YUV422;
 		is_jpeg = true;
 		break;
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
+		/* Raw, BGBG... / GRGR... */
+		fmt = 0x00;
+		mux = OV5640_FMT_MUX_RAW_DPC;
+		break;
+	case MEDIA_BUS_FMT_SGBRG8_1X8:
+		/* Raw bayer, GBGB... / RGRG... */
+		fmt = 0x01;
+		mux = OV5640_FMT_MUX_RAW_DPC;
+		break;
+	case MEDIA_BUS_FMT_SGRBG8_1X8:
+		/* Raw bayer, GRGR... / BGBG... */
+		fmt = 0x02;
+		mux = OV5640_FMT_MUX_RAW_DPC;
+		break;
+	case MEDIA_BUS_FMT_SRGGB8_1X8:
+		/* Raw bayer, RGRG... / GBGB... */
+		fmt = 0x03;
+		mux = OV5640_FMT_MUX_RAW_DPC;
+		break;
 	default:
 		return -EINVAL;
 	}
 
 	/* FORMAT CONTROL00: YUV and RGB formatting */
-	ret = ov5640_write_reg(sensor, OV5640_REG_FORMAT_CONTROL00, val);
+	ret = ov5640_write_reg(sensor, OV5640_REG_FORMAT_CONTROL00, fmt);
 	if (ret)
 		return ret;
 
 	/* FORMAT MUX CONTROL: ISP YUV or RGB */
-	ret = ov5640_write_reg(sensor, OV5640_REG_ISP_FORMAT_MUX_CTRL,
-			       is_rgb ? 0x01 : 0x00);
+	ret = ov5640_write_reg(sensor, OV5640_REG_ISP_FORMAT_MUX_CTRL, mux);
 	if (ret)
 		return ret;
 
-- 
2.7.4
