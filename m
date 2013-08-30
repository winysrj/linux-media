Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:36039 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab3H3Uyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 16:54:35 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] gspca-stk1135: Add variable resolution support
Date: Fri, 30 Aug 2013 22:54:25 +0200
Message-Id: <1377896065-29392-3-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1377896065-29392-2-git-send-email-linux@rainbow-software.org>
References: <1377896065-29392-1-git-send-email-linux@rainbow-software.org>
 <1377896065-29392-2-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add variable resolution support to Syntek STK1135 subdriver.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/usb/gspca/stk1135.c |   68 ++++++++++++++++++------------------
 1 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/media/usb/gspca/stk1135.c b/drivers/media/usb/gspca/stk1135.c
index 5a6ed49..8add2f7 100644
--- a/drivers/media/usb/gspca/stk1135.c
+++ b/drivers/media/usb/gspca/stk1135.c
@@ -48,42 +48,11 @@ struct sd {
 };
 
 static const struct v4l2_pix_format stk1135_modes[] = {
-	{160, 120, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-		.bytesperline = 160,
-		.sizeimage = 160 * 120,
-		.colorspace = V4L2_COLORSPACE_SRGB},
-	{176, 144, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-		.bytesperline = 176,
-		.sizeimage = 176 * 144,
-		.colorspace = V4L2_COLORSPACE_SRGB},
-	{320, 240, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-		.bytesperline = 320,
-		.sizeimage = 320 * 240,
-		.colorspace = V4L2_COLORSPACE_SRGB},
-	{352, 288, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-		.bytesperline = 352,
-		.sizeimage = 352 * 288,
-		.colorspace = V4L2_COLORSPACE_SRGB},
+	/* default mode (this driver supports variable resolution) */
 	{640, 480, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
 		.bytesperline = 640,
 		.sizeimage = 640 * 480,
 		.colorspace = V4L2_COLORSPACE_SRGB},
-	{720, 576, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-		.bytesperline = 720,
-		.sizeimage = 720 * 576,
-		.colorspace = V4L2_COLORSPACE_SRGB},
-	{800, 600, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-		.bytesperline = 800,
-		.sizeimage = 800 * 600,
-		.colorspace = V4L2_COLORSPACE_SRGB},
-	{1024, 768, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-		.bytesperline = 1024,
-		.sizeimage = 1024 * 768,
-		.colorspace = V4L2_COLORSPACE_SRGB},
-	{1280, 1024, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-		.bytesperline = 1280,
-		.sizeimage = 1280 * 1024,
-		.colorspace = V4L2_COLORSPACE_SRGB},
 };
 
 /* -- read a register -- */
@@ -349,14 +318,14 @@ static void stk1135_configure_mt9m112(struct gspca_dev *gspca_dev)
 	/* set output size */
 	width = gspca_dev->pixfmt.width;
 	height = gspca_dev->pixfmt.height;
-	if (width <= 640) { /* use context A (half readout speed by default) */
+	if (width <= 640 && height <= 512) { /* context A (half readout speed)*/
 		sensor_write(gspca_dev, 0x1a7, width);
 		sensor_write(gspca_dev, 0x1aa, height);
 		/* set read mode context A */
 		sensor_write(gspca_dev, 0x0c8, 0x0000);
 		/* set resize, read mode, vblank, hblank context A */
 		sensor_write(gspca_dev, 0x2c8, 0x0000);
-	} else { /* use context B (full readout speed by default) */
+	} else { /* context B (full readout speed) */
 		sensor_write(gspca_dev, 0x1a1, width);
 		sensor_write(gspca_dev, 0x1a4, height);
 		/* set read mode context B */
@@ -643,6 +612,35 @@ static int sd_init_controls(struct gspca_dev *gspca_dev)
 	return 0;
 }
 
+void stk1135_try_fmt(struct gspca_dev *gspca_dev, struct v4l2_format *fmt)
+{
+	fmt->fmt.pix.width = clamp(fmt->fmt.pix.width, 32U, 1280U);
+	fmt->fmt.pix.height = clamp(fmt->fmt.pix.height, 32U, 1024U);
+	/* round up to even numbers */
+	fmt->fmt.pix.width += (fmt->fmt.pix.width & 1);
+	fmt->fmt.pix.height += (fmt->fmt.pix.height & 1);
+
+	fmt->fmt.pix.bytesperline = fmt->fmt.pix.width;
+	fmt->fmt.pix.sizeimage = fmt->fmt.pix.width * fmt->fmt.pix.height;
+}
+
+int stk1135_enum_framesizes(struct gspca_dev *gspca_dev,
+			struct v4l2_frmsizeenum *fsize)
+{
+	if (fsize->index != 0 || fsize->pixel_format != V4L2_PIX_FMT_SBGGR8)
+		return -EINVAL;
+
+	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+	fsize->stepwise.min_width = 32;
+	fsize->stepwise.min_height = 32;
+	fsize->stepwise.max_width = 1280;
+	fsize->stepwise.max_height = 1024;
+	fsize->stepwise.step_width = 2;
+	fsize->stepwise.step_height = 2;
+
+	return 0;
+}
+
 /* sub-driver description */
 static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
@@ -653,6 +651,8 @@ static const struct sd_desc sd_desc = {
 	.stopN = sd_stopN,
 	.pkt_scan = sd_pkt_scan,
 	.dq_callback = stk1135_dq_callback,
+	.try_fmt = stk1135_try_fmt,
+	.enum_framesizes = stk1135_enum_framesizes,
 };
 
 /* -- module initialisation -- */
-- 
Ondrej Zary

