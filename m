Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:57458 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932894AbeFKLgP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 07:36:15 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/8] media: imx274: consolidate per-mode data in imx274_frmfmt
Date: Mon, 11 Jun 2018 13:35:33 +0200
Message-Id: <1528716939-17015-3-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1528716939-17015-1-git-send-email-luca@lucaceresoli.net>
References: <1528716939-17015-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Data about the implemented readout modes is partially stored in
imx274_formats[], the rest is scattered in several arrays. The latter
are then accessed using the mode index, e.g.:

  min_frame_len[priv->mode_index]

Consolidate all these data in imx274_formats[], and store a pointer to
the selected mode (i.e. imx274_formats[priv->mode_index]) in the main
device struct. This way code to use these data becomes more readable,
e.g.:

  priv->mode->min_frame_len

This removes lots of scaffolding code and keeps data about each mode
in a unique place.

Also remove a parameter to imx274_mode_regs() that is now unused.

While this adds the mode pointer to the device struct, it does not
remove the mode_index from it because mode_index is still used in two
dev_dbg() calls.  This will be handled in a follow-up commit.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>

---
Changed v3 -> v4: nothing

Changed v2 -> v3: nothing

Changed v1 -> v2:
 - add "media: " prefix to commit message
---
 drivers/media/i2c/imx274.c | 139 +++++++++++++++++++++------------------------
 1 file changed, 66 insertions(+), 73 deletions(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 8a8a11b8d75d..2ec31ae4e60d 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -147,10 +147,28 @@ enum imx274_mode {
 };
 
 /*
- * imx274 format related structure
+ * Parameters for each imx274 readout mode.
+ *
+ * These are the values to configure the sensor in one of the
+ * implemented modes.
+ *
+ * @size: recommended recording pixels
+ * @init_regs: registers to initialize the mode
+ * @min_frame_len: Minimum frame length for each mode (see "Frame Rate
+ *                 Adjustment (CSI-2)" in the datasheet)
+ * @min_SHR: Minimum SHR register value (see "Shutter Setting (CSI-2)" in the
+ *           datasheet)
+ * @max_fps: Maximum frames per second
+ * @nocpiop: Number of clocks per internal offset period (see "Integration Time
+ *           in Each Readout Drive Mode (CSI-2)" in the datasheet)
  */
 struct imx274_frmfmt {
 	struct v4l2_frmsize_discrete size;
+	const struct reg_8 *init_regs;
+	int min_frame_len;
+	int min_SHR;
+	int max_fps;
+	int nocpiop;
 };
 
 /*
@@ -476,58 +494,35 @@ static const struct reg_8 imx274_tp_regs[] = {
 	{IMX274_TABLE_END, 0x00}
 };
 
-static const struct reg_8 *mode_table[] = {
-	[IMX274_MODE_3840X2160]		= imx274_mode1_3840x2160_raw10,
-	[IMX274_MODE_1920X1080]		= imx274_mode3_1920x1080_raw10,
-	[IMX274_MODE_1280X720]		= imx274_mode5_1280x720_raw10,
-};
-
-/*
- * imx274 format related structure
- */
+/* nocpiop happens to be the same number for the implemented modes */
 static const struct imx274_frmfmt imx274_formats[] = {
-	{ {3840, 2160} },
-	{ {1920, 1080} },
-	{ {1280,  720} },
-};
-
-/*
- * minimal frame length for each mode
- * refer to datasheet section "Frame Rate Adjustment (CSI-2)"
- */
-static const int min_frame_len[] = {
-	4550, /* mode 1, 4K */
-	2310, /* mode 3, 1080p */
-	2310 /* mode 5, 720p */
-};
-
-/*
- * minimal numbers of SHR register
- * refer to datasheet table "Shutter Setting (CSI-2)"
- */
-static const int min_SHR[] = {
-	12, /* mode 1, 4K */
-	8, /* mode 3, 1080p */
-	8 /* mode 5, 720p */
-};
-
-static const int max_frame_rate[] = {
-	60, /* mode 1 , 4K */
-	120, /* mode 3, 1080p */
-	120 /* mode 5, 720p */
-};
-
-/*
- * Number of clocks per internal offset period
- * a constant based on mode
- * refer to section "Integration Time in Each Readout Drive Mode (CSI-2)"
- * in the datasheet
- * for the implemented 3 modes, it happens to be the same number
- */
-static const int nocpiop[] = {
-	112, /* mode 1 , 4K */
-	112, /* mode 3, 1080p */
-	112 /* mode 5, 720p */
+	{
+		/* mode 1, 4K */
+		.size = {3840, 2160},
+		.init_regs = imx274_mode1_3840x2160_raw10,
+		.min_frame_len = 4550,
+		.min_SHR = 12,
+		.max_fps = 60,
+		.nocpiop = 112,
+	},
+	{
+		/* mode 3, 1080p */
+		.size = {1920, 1080},
+		.init_regs = imx274_mode3_1920x1080_raw10,
+		.min_frame_len = 2310,
+		.min_SHR = 8,
+		.max_fps = 120,
+		.nocpiop = 112,
+	},
+	{
+		/* mode 5, 720p */
+		.size = {1280, 720},
+		.init_regs = imx274_mode5_1280x720_raw10,
+		.min_frame_len = 2310,
+		.min_SHR = 8,
+		.max_fps = 120,
+		.nocpiop = 112,
+	},
 };
 
 /*
@@ -557,6 +552,8 @@ struct imx274_ctrls {
  * @regmap: Pointer to regmap structure
  * @reset_gpio: Pointer to reset gpio
  * @lock: Mutex structure
+ * @mode: Parameters for the selected readout mode
+ *        (points to imx274_formats[mode_index])
  * @mode_index: Resolution mode index
  */
 struct stimx274 {
@@ -569,6 +566,7 @@ struct stimx274 {
 	struct regmap *regmap;
 	struct gpio_desc *reset_gpio;
 	struct mutex lock; /* mutex lock for operations */
+	const struct imx274_frmfmt *mode;
 	u32 mode_index;
 };
 
@@ -704,18 +702,12 @@ static int imx274_write_table(struct stimx274 *priv, const struct reg_8 table[])
 }
 
 /*
- * imx274_mode_regs - Function for set mode registers per mode index
+ * Set mode registers to start stream.
  * @priv: Pointer to device structure
- * @mode: Mode index value
- *
- * This is used to start steam per mode index.
- * mode = 0, start stream for sensor Mode 1: 4K/raw10
- * mode = 1, start stream for sensor Mode 3: 1080p/raw10
- * mode = 2, start stream for sensor Mode 5: 720p/raw10
  *
  * Return: 0 on success, errors otherwise
  */
-static int imx274_mode_regs(struct stimx274 *priv, int mode)
+static int imx274_mode_regs(struct stimx274 *priv)
 {
 	int err = 0;
 
@@ -727,7 +719,7 @@ static int imx274_mode_regs(struct stimx274 *priv, int mode)
 	if (err)
 		return err;
 
-	err = imx274_write_table(priv, mode_table[mode]);
+	err = imx274_write_table(priv, priv->mode->init_regs);
 
 	return err;
 }
@@ -889,6 +881,7 @@ static int imx274_set_fmt(struct v4l2_subdev *sd,
 	}
 
 	imx274->mode_index = index;
+	imx274->mode = &imx274_formats[index];
 
 	if (fmt->width > IMX274_MAX_WIDTH)
 		fmt->width = IMX274_MAX_WIDTH;
@@ -1042,7 +1035,7 @@ static int imx274_s_stream(struct v4l2_subdev *sd, int on)
 
 	if (on) {
 		/* load mode registers */
-		ret = imx274_mode_regs(imx274, imx274->mode_index);
+		ret = imx274_mode_regs(imx274);
 		if (ret)
 			goto fail;
 
@@ -1146,14 +1139,14 @@ static int imx274_clamp_coarse_time(struct stimx274 *priv, u32 *val,
 	if (err)
 		return err;
 
-	if (*frame_length < min_frame_len[priv->mode_index])
-		*frame_length = min_frame_len[priv->mode_index];
+	if (*frame_length < priv->mode->min_frame_len)
+		*frame_length =  priv->mode->min_frame_len;
 
 	*val = *frame_length - *val; /* convert to raw shr */
 	if (*val > *frame_length - IMX274_SHR_LIMIT_CONST)
 		*val = *frame_length - IMX274_SHR_LIMIT_CONST;
-	else if (*val < min_SHR[priv->mode_index])
-		*val = min_SHR[priv->mode_index];
+	else if (*val < priv->mode->min_SHR)
+		*val = priv->mode->min_SHR;
 
 	return 0;
 }
@@ -1365,7 +1358,7 @@ static int imx274_set_exposure(struct stimx274 *priv, int val)
 	}
 
 	coarse_time = (IMX274_PIXCLK_CONST1 / IMX274_PIXCLK_CONST2 * val
-			- nocpiop[priv->mode_index]) / hmax;
+			- priv->mode->nocpiop) / hmax;
 
 	/* step 2: convert exposure_time into SHR value */
 
@@ -1375,7 +1368,7 @@ static int imx274_set_exposure(struct stimx274 *priv, int val)
 		goto fail;
 
 	priv->ctrls.exposure->val =
-			(coarse_time * hmax + nocpiop[priv->mode_index])
+			(coarse_time * hmax + priv->mode->nocpiop)
 			/ (IMX274_PIXCLK_CONST1 / IMX274_PIXCLK_CONST2);
 
 	dev_dbg(&priv->client->dev,
@@ -1529,10 +1522,9 @@ static int imx274_set_frame_interval(struct stimx274 *priv,
 				/ frame_interval.numerator);
 
 	/* boundary check */
-	if (req_frame_rate > max_frame_rate[priv->mode_index]) {
+	if (req_frame_rate > priv->mode->max_fps) {
 		frame_interval.numerator = 1;
-		frame_interval.denominator =
-					max_frame_rate[priv->mode_index];
+		frame_interval.denominator = priv->mode->max_fps;
 	} else if (req_frame_rate < IMX274_MIN_FRAME_RATE) {
 		frame_interval.numerator = 1;
 		frame_interval.denominator = IMX274_MIN_FRAME_RATE;
@@ -1634,8 +1626,9 @@ static int imx274_probe(struct i2c_client *client,
 
 	/* initialize format */
 	imx274->mode_index = IMX274_MODE_3840X2160;
-	imx274->format.width = imx274_formats[0].size.width;
-	imx274->format.height = imx274_formats[0].size.height;
+	imx274->mode = &imx274_formats[imx274->mode_index];
+	imx274->format.width = imx274->mode->size.width;
+	imx274->format.height = imx274->mode->size.height;
 	imx274->format.field = V4L2_FIELD_NONE;
 	imx274->format.code = MEDIA_BUS_FMT_SRGGB10_1X10;
 	imx274->format.colorspace = V4L2_COLORSPACE_SRGB;
-- 
2.7.4
