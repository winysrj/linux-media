Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51387 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab2IWT3G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 15:29:06 -0400
Received: by mail-we0-f174.google.com with SMTP id x8so2978759wey.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 12:29:05 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: g.liakhovetski@gmx.de
Cc: maramaopercheseimorto@gmail.com, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 2/3] ov2640: add support for V4L2_MBUS_FMT_YUYV8_2X8, V4L2_MBUS_FMT_RGB565_2X8_BE
Date: Sun, 23 Sep 2012 21:28:45 +0300
Message-Id: <1348424926-12864-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1348424926-12864-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1348424926-12864-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the result of experimenting with the SpeedLink VAD Laplace webcam.
The register sequence for V4L2_MBUS_FMT_YUYV8_2X8 has been identified by
analyzing USB-logs of this device running on MS Windows.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/i2c/soc_camera/ov2640.c |   49 ++++++++++++++++++++++++++++-----
 1 Datei geändert, 42 Zeilen hinzugefügt(+), 7 Zeilen entfernt(-)

diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index e4fc79e..182d5a1 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -586,9 +586,20 @@ static const struct regval_list ov2640_format_change_preamble_regs[] = {
 	ENDMARKER,
 };
 
-static const struct regval_list ov2640_yuv422_regs[] = {
+static const struct regval_list ov2640_yuyv_regs[] = {
+	{ IMAGE_MODE, IMAGE_MODE_YUV422 },
+	{ 0xd7, 0x03 },
+	{ 0x33, 0xa0 },
+	{ 0xe5, 0x1f },
+	{ 0xe1, 0x67 },
+	{ RESET,  0x00 },
+	{ R_BYPASS, R_BYPASS_USE_DSP },
+	ENDMARKER,
+};
+
+static const struct regval_list ov2640_uyvy_regs[] = {
 	{ IMAGE_MODE, IMAGE_MODE_LBYTE_FIRST | IMAGE_MODE_YUV422 },
-	{ 0xD7, 0x01 },
+	{ 0xd7, 0x01 },
 	{ 0x33, 0xa0 },
 	{ 0xe1, 0x67 },
 	{ RESET,  0x00 },
@@ -596,7 +607,15 @@ static const struct regval_list ov2640_yuv422_regs[] = {
 	ENDMARKER,
 };
 
-static const struct regval_list ov2640_rgb565_regs[] = {
+static const struct regval_list ov2640_rgb565_be_regs[] = {
+	{ IMAGE_MODE, IMAGE_MODE_RGB565 },
+	{ 0xd7, 0x03 },
+	{ RESET,  0x00 },
+	{ R_BYPASS, R_BYPASS_USE_DSP },
+	ENDMARKER,
+};
+
+static const struct regval_list ov2640_rgb565_le_regs[] = {
 	{ IMAGE_MODE, IMAGE_MODE_LBYTE_FIRST | IMAGE_MODE_RGB565 },
 	{ 0xd7, 0x03 },
 	{ RESET,  0x00 },
@@ -605,7 +624,9 @@ static const struct regval_list ov2640_rgb565_regs[] = {
 };
 
 static enum v4l2_mbus_pixelcode ov2640_codes[] = {
+	V4L2_MBUS_FMT_YUYV8_2X8,
 	V4L2_MBUS_FMT_UYVY8_2X8,
+	V4L2_MBUS_FMT_RGB565_2X8_BE,
 	V4L2_MBUS_FMT_RGB565_2X8_LE,
 };
 
@@ -790,14 +811,22 @@ static int ov2640_set_params(struct i2c_client *client, u32 *width, u32 *height,
 	/* select format */
 	priv->cfmt_code = 0;
 	switch (code) {
+	case V4L2_MBUS_FMT_RGB565_2X8_BE:
+		dev_dbg(&client->dev, "%s: Selected cfmt RGB565 BE", __func__);
+		selected_cfmt_regs = ov2640_rgb565_be_regs;
+		break;
 	case V4L2_MBUS_FMT_RGB565_2X8_LE:
-		dev_dbg(&client->dev, "%s: Selected cfmt RGB565", __func__);
-		selected_cfmt_regs = ov2640_rgb565_regs;
+		dev_dbg(&client->dev, "%s: Selected cfmt RGB565 LE", __func__);
+		selected_cfmt_regs = ov2640_rgb565_le_regs;
+		break;
+	case V4L2_MBUS_FMT_YUYV8_2X8:
+		dev_dbg(&client->dev, "%s: Selected cfmt YUYV (YUV422)", __func__);
+		selected_cfmt_regs = ov2640_yuyv_regs;
 		break;
 	default:
 	case V4L2_MBUS_FMT_UYVY8_2X8:
-		dev_dbg(&client->dev, "%s: Selected cfmt YUV422", __func__);
-		selected_cfmt_regs = ov2640_yuv422_regs;
+		dev_dbg(&client->dev, "%s: Selected cfmt UYVY", __func__);
+		selected_cfmt_regs = ov2640_uyvy_regs;
 	}
 
 	/* reset hardware */
@@ -862,10 +891,12 @@ static int ov2640_g_fmt(struct v4l2_subdev *sd,
 	mf->code	= priv->cfmt_code;
 
 	switch (mf->code) {
+	case V4L2_MBUS_FMT_RGB565_2X8_BE:
 	case V4L2_MBUS_FMT_RGB565_2X8_LE:
 		mf->colorspace = V4L2_COLORSPACE_SRGB;
 		break;
 	default:
+	case V4L2_MBUS_FMT_YUYV8_2X8:
 	case V4L2_MBUS_FMT_UYVY8_2X8:
 		mf->colorspace = V4L2_COLORSPACE_JPEG;
 	}
@@ -882,11 +913,13 @@ static int ov2640_s_fmt(struct v4l2_subdev *sd,
 
 
 	switch (mf->code) {
+	case V4L2_MBUS_FMT_RGB565_2X8_BE:
 	case V4L2_MBUS_FMT_RGB565_2X8_LE:
 		mf->colorspace = V4L2_COLORSPACE_SRGB;
 		break;
 	default:
 		mf->code = V4L2_MBUS_FMT_UYVY8_2X8;
+	case V4L2_MBUS_FMT_YUYV8_2X8:
 	case V4L2_MBUS_FMT_UYVY8_2X8:
 		mf->colorspace = V4L2_COLORSPACE_JPEG;
 	}
@@ -909,11 +942,13 @@ static int ov2640_try_fmt(struct v4l2_subdev *sd,
 	mf->field	= V4L2_FIELD_NONE;
 
 	switch (mf->code) {
+	case V4L2_MBUS_FMT_RGB565_2X8_BE:
 	case V4L2_MBUS_FMT_RGB565_2X8_LE:
 		mf->colorspace = V4L2_COLORSPACE_SRGB;
 		break;
 	default:
 		mf->code = V4L2_MBUS_FMT_UYVY8_2X8;
+	case V4L2_MBUS_FMT_YUYV8_2X8:
 	case V4L2_MBUS_FMT_UYVY8_2X8:
 		mf->colorspace = V4L2_COLORSPACE_JPEG;
 	}
-- 
1.7.10.4

