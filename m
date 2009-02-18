Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41983 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750970AbZBRAEL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 19:04:11 -0500
Date: Wed, 18 Feb 2009 01:04:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
cc: Agustin <gatoguan-os@yahoo.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] mt9t031: fix gain and hflip controls, register update,
 and scaling
In-Reply-To: <alpine.DEB.2.00.0902180044120.6986@axis700.grange>
Message-ID: <alpine.DEB.2.00.0902180054010.6986@axis700.grange>
References: <50561.11594.qm@web32108.mail.mud.yahoo.com> <499B2A60.9080009@epfl.ch> <alpine.DEB.2.00.0902180044120.6986@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <lg@denx.de>

Multiple fixes:
1. allow register update by setting the Output Control register to 2 and not 3
2. fix scaling factor calculations
3. recover lost HFLIP control
4. fix Global Gain calculation

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---

This one might need an update.

 drivers/media/video/mt9t031.c |  127 +++++++++++++++++++++++++++--------------
 1 files changed, 84 insertions(+), 43 deletions(-)

diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 1a9d539..ffcdd21 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -150,7 +150,7 @@ static int mt9t031_init(struct soc_camera_device *icd)
 	if (ret >= 0)
 		ret = reg_write(icd, MT9T031_RESET, 0);
 	if (ret >= 0)
-		ret = reg_clear(icd, MT9T031_OUTPUT_CONTROL, 3);
+		ret = reg_clear(icd, MT9T031_OUTPUT_CONTROL, 2);
 
 	return ret >= 0 ? 0 : -EIO;
 }
@@ -158,14 +158,14 @@ static int mt9t031_init(struct soc_camera_device *icd)
 static int mt9t031_release(struct soc_camera_device *icd)
 {
 	/* Disable the chip */
-	reg_clear(icd, MT9T031_OUTPUT_CONTROL, 3);
+	reg_clear(icd, MT9T031_OUTPUT_CONTROL, 2);
 	return 0;
 }
 
 static int mt9t031_start_capture(struct soc_camera_device *icd)
 {
 	/* Switch to master "normal" mode */
-	if (reg_set(icd, MT9T031_OUTPUT_CONTROL, 3) < 0)
+	if (reg_set(icd, MT9T031_OUTPUT_CONTROL, 2) < 0)
 		return -EIO;
 	return 0;
 }
@@ -173,7 +173,7 @@ static int mt9t031_start_capture(struct soc_camera_device *icd)
 static int mt9t031_stop_capture(struct soc_camera_device *icd)
 {
 	/* Stop sensor readout */
-	if (reg_clear(icd, MT9T031_OUTPUT_CONTROL, 3) < 0)
+	if (reg_clear(icd, MT9T031_OUTPUT_CONTROL, 2) < 0)
 		return -EIO;
 	return 0;
 }
@@ -201,6 +201,18 @@ static unsigned long mt9t031_query_bus_param(struct soc_camera_device *icd)
 	return soc_camera_apply_sensor_flags(icl, MT9T031_BUS_PARAM);
 }
 
+/* Round up minima and round down maxima */
+static void recalculate_limits(struct soc_camera_device *icd,
+			       u16 xskip, u16 yskip)
+{
+	icd->x_min = (MT9T031_COLUMN_SKIP + xskip - 1) / xskip;
+	icd->y_min = (MT9T031_ROW_SKIP + yskip - 1) / yskip;
+	icd->width_min = (MT9T031_MIN_WIDTH + xskip - 1) / xskip;
+	icd->height_min = (MT9T031_MIN_HEIGHT + yskip - 1) / yskip;
+	icd->width_max = MT9T031_MAX_WIDTH / xskip;
+	icd->height_max = MT9T031_MAX_HEIGHT / yskip;
+}
+
 static int mt9t031_set_fmt(struct soc_camera_device *icd,
 			   __u32 pixfmt, struct v4l2_rect *rect)
 {
@@ -208,54 +220,70 @@ static int mt9t031_set_fmt(struct soc_camera_device *icd,
 	int ret;
 	const u16 hblank = MT9T031_HORIZONTAL_BLANK,
 		vblank = MT9T031_VERTICAL_BLANK;
-	u16 xbin, xskip = mt9t031->xskip, ybin, yskip = mt9t031->yskip,
-		width = rect->width * xskip, height = rect->height * yskip;
+	u16 xbin, xskip, ybin, yskip, width, height, left, top;
 
 	if (pixfmt) {
-		/* S_FMT - use binning and skipping for scaling, recalculate */
+		/*
+		 * try_fmt has put rectangle within limits.
+		 * S_FMT - use binning and skipping for scaling, recalculate
+		 * limits, used for cropping
+		 */
 		/* Is this more optimal than just a division? */
 		for (xskip = 8; xskip > 1; xskip--)
-			if (rect->width * xskip <= icd->width_max)
+			if (rect->width * xskip <= MT9T031_MAX_WIDTH)
 				break;
 
 		for (yskip = 8; yskip > 1; yskip--)
-			if (rect->height * yskip <= icd->height_max)
+			if (rect->height * yskip <= MT9T031_MAX_HEIGHT)
 				break;
 
-		width = rect->width * xskip;
-		height = rect->height * yskip;
-
-		dev_dbg(&icd->dev, "xskip %u, width %u, yskip %u, height %u\n",
-			xskip, width, yskip, height);
+		recalculate_limits(icd, xskip, yskip);
+	} else {
+		/* CROP - no change in scaling, or in limits */
+		xskip = mt9t031->xskip;
+		yskip = mt9t031->yskip;
 	}
 
+	/* Make sure we don't exceed sensor limits */
+	if (rect->left + rect->width > icd->width_max)
+		rect->left = (icd->width_max - rect->width) / 2 + icd->x_min;
+
+	if (rect->top + rect->height > icd->height_max)
+		rect->top = (icd->height_max - rect->height) / 2 + icd->y_min;
+
+	width = rect->width * xskip;
+	height = rect->height * yskip;
+	left = rect->left * xskip;
+	top = rect->top * yskip;
+
 	xbin = min(xskip, (u16)3);
 	ybin = min(yskip, (u16)3);
 
-	/* Make sure we don't exceed frame limits */
-	if (rect->left + width > icd->width_max)
-		rect->left = (icd->width_max - width) / 2;
+	dev_dbg(&icd->dev, "xskip %u, width %u/%u, yskip %u, height %u/%u\n",
+		xskip, width, rect->width, yskip, height, rect->height);
 
-	if (rect->top + height > icd->height_max)
-		rect->top = (icd->height_max - height) / 2;
-
-	/* Could just do roundup(rect->left, [xy]bin); but this is cheaper */
+	/* Could just do roundup(rect->left, [xy]bin * 2); but this is cheaper */
 	switch (xbin) {
 	case 2:
-		rect->left = (rect->left + 1) & ~1;
+		left = (left + 3) & ~3;
 		break;
 	case 3:
-		rect->left = roundup(rect->left, 3);
+		left = roundup(left, 6);
 	}
 
 	switch (ybin) {
 	case 2:
-		rect->top = (rect->top + 1) & ~1;
+		top = (top + 3) & ~3;
 		break;
 	case 3:
-		rect->top = roundup(rect->top, 3);
+		top = roundup(top, 6);
 	}
 
+	/* Disable register update, reconfigure atomically */
+	ret = reg_set(icd, MT9T031_OUTPUT_CONTROL, 1);
+	if (ret < 0)
+		return ret;
+
 	/* Blanking and start values - default... */
 	ret = reg_write(icd, MT9T031_HORIZONTAL_BLANKING, hblank);
 	if (ret >= 0)
@@ -270,14 +298,14 @@ static int mt9t031_set_fmt(struct soc_camera_device *icd,
 			ret = reg_write(icd, MT9T031_ROW_ADDRESS_MODE,
 					((ybin - 1) << 4) | (yskip - 1));
 	}
-	dev_dbg(&icd->dev, "new left %u, top %u\n", rect->left, rect->top);
+	dev_dbg(&icd->dev, "new physical left %u, top %u\n", left, top);
 
 	/* The caller provides a supported format, as guaranteed by
 	 * icd->try_fmt_cap(), soc_camera_s_crop() and soc_camera_cropcap() */
 	if (ret >= 0)
-		ret = reg_write(icd, MT9T031_COLUMN_START, rect->left);
+		ret = reg_write(icd, MT9T031_COLUMN_START, left);
 	if (ret >= 0)
-		ret = reg_write(icd, MT9T031_ROW_START, rect->top);
+		ret = reg_write(icd, MT9T031_ROW_START, top);
 	if (ret >= 0)
 		ret = reg_write(icd, MT9T031_WINDOW_WIDTH, width - 1);
 	if (ret >= 0)
@@ -302,6 +330,9 @@ static int mt9t031_set_fmt(struct soc_camera_device *icd,
 		mt9t031->yskip = yskip;
 	}
 
+	/* Re-enable register update, commit all changes */
+	reg_clear(icd, MT9T031_OUTPUT_CONTROL, 1);
+
 	return ret < 0 ? ret : 0;
 }
 
@@ -310,14 +341,14 @@ static int mt9t031_try_fmt(struct soc_camera_device *icd,
 {
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	if (pix->height < icd->height_min)
-		pix->height = icd->height_min;
-	if (pix->height > icd->height_max)
-		pix->height = icd->height_max;
-	if (pix->width < icd->width_min)
-		pix->width = icd->width_min;
-	if (pix->width > icd->width_max)
-		pix->width = icd->width_max;
+	if (pix->height < MT9T031_MIN_HEIGHT)
+		pix->height = MT9T031_MIN_HEIGHT;
+	if (pix->height > MT9T031_MAX_HEIGHT)
+		pix->height = MT9T031_MAX_HEIGHT;
+	if (pix->width < MT9T031_MIN_WIDTH)
+		pix->width = MT9T031_MIN_WIDTH;
+	if (pix->width > MT9T031_MAX_WIDTH)
+		pix->width = MT9T031_MAX_WIDTH;
 
 	pix->width &= ~0x01; /* has to be even */
 	pix->height &= ~0x01; /* has to be even */
@@ -390,6 +421,14 @@ static const struct v4l2_queryctrl mt9t031_controls[] = {
 		.step		= 1,
 		.default_value	= 0,
 	}, {
+		.id		= V4L2_CID_HFLIP,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Flip Horizontally",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+	}, {
 		.id		= V4L2_CID_GAIN,
 		.type		= V4L2_CTRL_TYPE_INTEGER,
 		.name		= "Gain",
@@ -513,21 +552,23 @@ static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_contro
 			if (data < 0)
 				return -EIO;
 		} else {
-			/* Pack it into 1.125..15 variable step, register values 9..67 */
+			/* Pack it into 1.125..128 variable step, register values 9..0x7860 */
 			/* We assume qctrl->maximum - qctrl->default_value - 1 > 0 */
 			unsigned long range = qctrl->maximum - qctrl->default_value - 1;
+			/* calculated gain: map 65..127 to 9..1024 step 0.125 */
 			unsigned long gain = ((ctrl->value - qctrl->default_value - 1) *
-					       111 + range / 2) / range + 9;
+					       1015 + range / 2) / range + 9;
 
-			if (gain <= 32)
+			if (gain <= 32)		/* calculated gain 9..32 -> 9..32 */
 				data = gain;
-			else if (gain <= 64)
+			else if (gain <= 64)	/* calculated gain 33..64 -> 0x51..0x60 */
 				data = ((gain - 32) * 16 + 16) / 32 + 80;
 			else
-				data = ((gain - 64) * 7 + 28) / 56 + 96;
+				/* calculated gain 65..1024 -> (1..120) << 8 + 0x60 */
+				data = (((gain - 64 + 7) * 32) & 0xff00) | 0x60;
 
-			dev_dbg(&icd->dev, "Setting gain from %d to %d\n",
-				 reg_read(icd, MT9T031_GLOBAL_GAIN), data);
+			dev_dbg(&icd->dev, "Setting gain from 0x%x to 0x%x\n",
+				reg_read(icd, MT9T031_GLOBAL_GAIN), data);
 			data = reg_write(icd, MT9T031_GLOBAL_GAIN, data);
 			if (data < 0)
 				return -EIO;
-- 
1.5.4

