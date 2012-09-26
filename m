Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57306 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab2IZJsS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 05:48:18 -0400
Received: by wibhq12 with SMTP id hq12so4654977wib.1
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 02:48:17 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, mchehab@infradead.org, hverkuil@xs4all.nl,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 3/5] media: ov7670: calculate framerate properly for ov7675.
Date: Wed, 26 Sep 2012 11:47:55 +0200
Message-Id: <1348652877-25816-4-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the datasheet ov7675 uses a formula to achieve
the desired framerate that is different from the operations
done in the current code.

In fact, this formula should apply to ov7670 too. This would
mean that current code is wrong but, in order to preserve
compatibility, the new formula will be used for ov7675 only.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/i2c/ov7670.c |  122 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 105 insertions(+), 17 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 627fe5f..175fbfc 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -47,6 +47,8 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
  */
 #define OV7670_I2C_ADDR 0x42
 
+#define PLL_FACTOR	4
+
 /* Registers */
 #define REG_GAIN	0x00	/* Gain lower 8 bits (rest in vref) */
 #define REG_BLUE	0x01	/* blue gain */
@@ -164,6 +166,12 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
 #define REG_GFIX	0x69	/* Fix gain control */
 
+#define REG_DBLV	0x6b	/* PLL control an debugging */
+#define   DBLV_BYPASS	  0x00	  /* Bypass PLL */
+#define   DBLV_X4	  0x01	  /* clock x4 */
+#define   DBLV_X6	  0x10	  /* clock x6 */
+#define   DBLV_X8	  0x11	  /* clock x8 */
+
 #define REG_REG76	0x76	/* OV's name */
 #define   R76_BLKPCOR	  0x80	  /* Black pixel correction enable */
 #define   R76_WHTPCOR	  0x40	  /* White pixel correction enable */
@@ -765,6 +773,67 @@ static struct ov7670_win_size ov7670_win_sizes[2][4] = {
 	}
 };
 
+static void ov7670_get_framerate(struct v4l2_subdev *sd,
+				 struct v4l2_fract *tpf)
+{
+	struct ov7670_info *info = to_state(sd);
+	u32 clkrc = info->clkrc;
+	u32 pll_factor = PLL_FACTOR;
+
+	clkrc++;
+	if (info->fmt->mbus_code == V4L2_MBUS_FMT_SBGGR8_1X8)
+		clkrc = (clkrc >> 1);
+
+	tpf->numerator = 1;
+	tpf->denominator = (5 * pll_factor * info->clock_speed) /
+			(4 * clkrc);
+}
+
+static int ov7670_set_framerate(struct v4l2_subdev *sd,
+				 struct v4l2_fract *tpf)
+{
+	struct ov7670_info *info = to_state(sd);
+	u32 clkrc;
+	u32 pll_factor = PLL_FACTOR;
+	int ret;
+
+	/*
+	 * The formula is fps = 5/4*pixclk for YUV/RGB and
+	 * fps = 5/2*pixclk for RAW.
+	 *
+	 * pixclk = clock_speed / (clkrc + 1) * PLLfactor
+	 *
+	 */
+	if (tpf->numerator == 0 || tpf->denominator == 0) {
+		clkrc = 0;
+	} else {
+		clkrc = (5 * pll_factor * info->clock_speed * tpf->numerator) /
+			(4 * tpf->denominator);
+		if (info->fmt->mbus_code == V4L2_MBUS_FMT_SBGGR8_1X8)
+			clkrc = (clkrc << 1);
+		clkrc--;
+	}
+
+	/*
+	 * The datasheet claims that clkrc = 0 will divide the input clock by 1
+	 * but we've checked with an oscilloscope that it divides by 2 instead.
+	 * So, if clkrc = 0 just bypass the divider.
+	 */
+	if (clkrc <= 0)
+		clkrc = CLK_EXT;
+	else if (clkrc > CLK_SCALE)
+		clkrc = CLK_SCALE;
+	info->clkrc = clkrc;
+
+	/* Recalculate frame rate */
+	ov7670_get_framerate(sd, tpf);
+
+	ret = ov7670_write(sd, REG_CLKRC, info->clkrc);
+	if (ret < 0)
+		return ret;
+	return ov7670_write(sd, REG_DBLV, DBLV_X4);
+}
+
 /*
  * Store a set of start/stop values into the camera.
  */
@@ -939,10 +1008,15 @@ static int ov7670_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
 
 	memset(cp, 0, sizeof(struct v4l2_captureparm));
 	cp->capability = V4L2_CAP_TIMEPERFRAME;
-	cp->timeperframe.numerator = 1;
-	cp->timeperframe.denominator = info->clock_speed;
-	if ((info->clkrc & CLK_EXT) == 0 && (info->clkrc & CLK_SCALE) > 1)
-		cp->timeperframe.denominator /= (info->clkrc & CLK_SCALE);
+	if (info->model == MODEL_OV7670) {
+		/* legacy */
+		cp->timeperframe.numerator = 1;
+		cp->timeperframe.denominator = info->clock_speed;
+		if ((info->clkrc & CLK_EXT) == 0 && (info->clkrc & CLK_SCALE) > 1)
+			cp->timeperframe.denominator /= (info->clkrc & CLK_SCALE);
+	} else {
+		ov7670_get_framerate(sd, &cp->timeperframe);
+	}
 	return 0;
 }
 
@@ -958,18 +1032,23 @@ static int ov7670_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
 	if (cp->extendedmode != 0)
 		return -EINVAL;
 
-	if (tpf->numerator == 0 || tpf->denominator == 0)
-		div = 1;  /* Reset to full rate */
-	else
-		div = (tpf->numerator * info->clock_speed) / tpf->denominator;
-	if (div == 0)
-		div = 1;
-	else if (div > CLK_SCALE)
-		div = CLK_SCALE;
-	info->clkrc = (info->clkrc & 0x80) | div;
-	tpf->numerator = 1;
-	tpf->denominator = info->clock_speed / div;
-	return ov7670_write(sd, REG_CLKRC, info->clkrc);
+	if (info->model == MODEL_OV7670) {
+		/* legacy */
+		if (tpf->numerator == 0 || tpf->denominator == 0)
+			div = 1;  /* Reset to full rate */
+		else
+			div = (tpf->numerator * info->clock_speed) / tpf->denominator;
+		if (div == 0)
+			div = 1;
+		else if (div > CLK_SCALE)
+			div = CLK_SCALE;
+		info->clkrc = (info->clkrc & 0x80) | div;
+		tpf->numerator = 1;
+		tpf->denominator = info->clock_speed / div;
+		return ov7670_write(sd, REG_CLKRC, info->clkrc);
+	} else {
+		return ov7670_set_framerate(sd, tpf);
+	}
 }
 
 
@@ -1585,6 +1664,7 @@ static const struct v4l2_subdev_ops ov7670_ops = {
 static int ov7670_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
+	struct v4l2_fract tpf;
 	struct v4l2_subdev *sd;
 	struct ov7670_info *info;
 	int ret;
@@ -1626,7 +1706,15 @@ static int ov7670_probe(struct i2c_client *client,
 	info->model = id->driver_data;
 	info->fmt = &ov7670_formats[0];
 	info->sat = 128;	/* Review this */
-	info->clkrc = info->clock_speed / 30;
+	/* Set default frame rate to 30 fps */
+	if (info->model == MODEL_OV7670) {
+		/* legacy */
+		info->clkrc = info->clock_speed / 30;
+	} else {
+		tpf.numerator = 1;
+		tpf.denominator = 30;
+		ov7670_set_framerate(sd, &tpf);
+	}
 	return 0;
 }
 
-- 
1.7.9.5

