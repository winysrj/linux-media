Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:59785 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932377AbeEWKFr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 06:05:47 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v3 7/7] media: imx274: add SELECTION support for cropping
Date: Wed, 23 May 2018 12:05:20 +0200
Message-Id: <1527069921-21084-8-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1527069921-21084-1-git-send-email-luca@lucaceresoli.net>
References: <1527069921-21084-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently this driver does not support cropping. The supported modes
are the following, all capturing the entire area:

 - 3840x2160, 1:1 binning (native sensor resolution)
 - 1920x1080, 2:1 binning
 - 1280x720,  3:1 binning

The set_fmt callback chooses among these 3 configurations the one that
matches the requested format.

Adding support to VIDIOC_SUBDEV_G_SELECTION and
VIDIOC_SUBDEV_S_SELECTION involved a complete rewrite of set_fmt,
which now chooses the most appropriate binning based on the ratio
between the previously-set cropping size and the format size being
requested.

Also change the names in enum imx274_mode from being resolution-based
to being binning-based (e.g. from IMX274_MODE_1920X1080 to
IMX274_MODE_BINNING_2_1). Without cropping, the two naming are
equivalent. With cropping, the resolution could be different,
e.g. using 2:1 binning mode to crop 1200x960 and output a 600x480
format. Using binning in the names avoids any misunderstanding.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>

---
Changed v2 -> v3:
 - Remove hard-coded HMAX reg setting from all modes, not only the
   first one. HMAX is always computed and set in s_stream now.
 - Reword commit log message.

Changed v1 -> v2:
 - add "media: " prefix to commit message
---
 drivers/media/i2c/imx274.c | 272 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 192 insertions(+), 80 deletions(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index e5ba19b97083..f5819ce99e98 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -19,6 +19,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/kernel.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
@@ -74,7 +75,7 @@
  */
 #define IMX274_MIN_EXPOSURE_TIME		(4 * 260 / 72)
 
-#define IMX274_DEFAULT_MODE			IMX274_MODE_3840X2160
+#define IMX274_DEFAULT_MODE			IMX274_MODE_BINNING_OFF
 #define IMX274_MAX_WIDTH			(3840)
 #define IMX274_MAX_HEIGHT			(2160)
 #define IMX274_MAX_FRAME_RATE			(120)
@@ -111,6 +112,20 @@
 #define IMX274_SHR_REG_LSB			0x300C /* SHR */
 #define IMX274_SVR_REG_MSB			0x300F /* SVR */
 #define IMX274_SVR_REG_LSB			0x300E /* SVR */
+#define IMX274_HTRIM_EN_REG			0x3037
+#define IMX274_HTRIM_START_REG_LSB		0x3038
+#define IMX274_HTRIM_START_REG_MSB		0x3039
+#define IMX274_HTRIM_END_REG_LSB		0x303A
+#define IMX274_HTRIM_END_REG_MSB		0x303B
+#define IMX274_VWIDCUTEN_REG			0x30DD
+#define IMX274_VWIDCUT_REG_LSB			0x30DE
+#define IMX274_VWIDCUT_REG_MSB			0x30DF
+#define IMX274_VWINPOS_REG_LSB			0x30E0
+#define IMX274_VWINPOS_REG_MSB			0x30E1
+#define IMX274_WRITE_VSIZE_REG_LSB		0x3130
+#define IMX274_WRITE_VSIZE_REG_MSB		0x3131
+#define IMX274_Y_OUT_SIZE_REG_LSB		0x3132
+#define IMX274_Y_OUT_SIZE_REG_MSB		0x3133
 #define IMX274_VMAX_REG_1			0x30FA /* VMAX, MSB */
 #define IMX274_VMAX_REG_2			0x30F9 /* VMAX */
 #define IMX274_VMAX_REG_3			0x30F8 /* VMAX, LSB */
@@ -141,9 +156,9 @@ static const struct regmap_config imx274_regmap_config = {
 };
 
 enum imx274_mode {
-	IMX274_MODE_3840X2160,
-	IMX274_MODE_1920X1080,
-	IMX274_MODE_1280X720,
+	IMX274_MODE_BINNING_OFF,
+	IMX274_MODE_BINNING_2_1,
+	IMX274_MODE_BINNING_3_1,
 };
 
 /*
@@ -215,31 +230,14 @@ static const struct reg_8 imx274_mode1_3840x2160_raw10[] = {
 	{0x3004, 0x01},
 	{0x3005, 0x01},
 	{0x3006, 0x00},
-	{0x3007, 0x02},
+	{0x3007, 0xa2},
 
 	{0x3018, 0xA2}, /* output XVS, HVS */
 
 	{0x306B, 0x05},
 	{0x30E2, 0x01},
-	{0x30F6, 0x07}, /* HMAX, 263 */
-	{0x30F7, 0x01}, /* HMAX */
-
-	{0x30dd, 0x01}, /* crop to 2160 */
-	{0x30de, 0x06},
-	{0x30df, 0x00},
-	{0x30e0, 0x12},
-	{0x30e1, 0x00},
-	{0x3037, 0x01}, /* to crop to 3840 */
-	{0x3038, 0x0c},
-	{0x3039, 0x00},
-	{0x303a, 0x0c},
-	{0x303b, 0x0f},
 
 	{0x30EE, 0x01},
-	{0x3130, 0x86},
-	{0x3131, 0x08},
-	{0x3132, 0x7E},
-	{0x3133, 0x08},
 	{0x3342, 0x0A},
 	{0x3343, 0x00},
 	{0x3344, 0x16},
@@ -273,32 +271,14 @@ static const struct reg_8 imx274_mode3_1920x1080_raw10[] = {
 	{0x3004, 0x02},
 	{0x3005, 0x21},
 	{0x3006, 0x00},
-	{0x3007, 0x11},
+	{0x3007, 0xb1},
 
 	{0x3018, 0xA2}, /* output XVS, HVS */
 
 	{0x306B, 0x05},
 	{0x30E2, 0x02},
 
-	{0x30F6, 0x04}, /* HMAX, 260 */
-	{0x30F7, 0x01}, /* HMAX */
-
-	{0x30dd, 0x01}, /* to crop to 1920x1080 */
-	{0x30de, 0x05},
-	{0x30df, 0x00},
-	{0x30e0, 0x04},
-	{0x30e1, 0x00},
-	{0x3037, 0x01},
-	{0x3038, 0x0c},
-	{0x3039, 0x00},
-	{0x303a, 0x0c},
-	{0x303b, 0x0f},
-
 	{0x30EE, 0x01},
-	{0x3130, 0x4E},
-	{0x3131, 0x04},
-	{0x3132, 0x46},
-	{0x3133, 0x04},
 	{0x3342, 0x0A},
 	{0x3343, 0x00},
 	{0x3344, 0x1A},
@@ -331,31 +311,14 @@ static const struct reg_8 imx274_mode5_1280x720_raw10[] = {
 	{0x3004, 0x03},
 	{0x3005, 0x31},
 	{0x3006, 0x00},
-	{0x3007, 0x09},
+	{0x3007, 0xa9},
 
 	{0x3018, 0xA2}, /* output XVS, HVS */
 
 	{0x306B, 0x05},
 	{0x30E2, 0x03},
 
-	{0x30F6, 0x04}, /* HMAX, 260 */
-	{0x30F7, 0x01}, /* HMAX */
-
-	{0x30DD, 0x01},
-	{0x30DE, 0x07},
-	{0x30DF, 0x00},
-	{0x40E0, 0x04},
-	{0x30E1, 0x00},
-	{0x3030, 0xD4},
-	{0x3031, 0x02},
-	{0x3032, 0xD0},
-	{0x3033, 0x02},
-
 	{0x30EE, 0x01},
-	{0x3130, 0xE2},
-	{0x3131, 0x02},
-	{0x3132, 0xDE},
-	{0x3133, 0x02},
 	{0x3342, 0x0A},
 	{0x3343, 0x00},
 	{0x3344, 0x1B},
@@ -561,6 +524,7 @@ struct stimx274 {
 	struct imx274_ctrls ctrls;
 	struct v4l2_mbus_framefmt format;
 	struct v4l2_fract frame_interval;
+	struct v4l2_rect crop;
 	struct regmap *regmap;
 	struct gpio_desc *reset_gpio;
 	struct mutex lock; /* mutex lock for operations */
@@ -901,36 +865,30 @@ static int imx274_set_fmt(struct v4l2_subdev *sd,
 {
 	struct v4l2_mbus_framefmt *fmt = &format->format;
 	struct stimx274 *imx274 = to_imx274(sd);
-	struct i2c_client *client = imx274->client;
-	int index;
+	struct device *dev = &imx274->client->dev;
+	unsigned int ratio; /* Binning ratio */
 
-	dev_dbg(&client->dev,
-		"%s: width = %d height = %d code = %d\n",
-		__func__, fmt->width, fmt->height, fmt->code);
+	dev_dbg(dev, "%s: request of  %dx%d (%s)\n",
+		__func__, fmt->width, fmt->height,
+		V4L2_SUBDEV_FORMAT_ACTIVE ? "ACTIVE" : "TRY");
 
 	mutex_lock(&imx274->lock);
 
-	for (index = 0; index < ARRAY_SIZE(imx274_formats); index++) {
-		if (imx274_formats[index].size.width == fmt->width &&
-		    imx274_formats[index].size.height == fmt->height)
+	/* Find ratio (maximize output resolution). Fallback to 1:1. */
+	for (ratio = 3; ratio > 1; ratio--)
+		if (fmt->width <= DIV_ROUND_UP(imx274->crop.width, ratio) &&
+		    fmt->height <= DIV_ROUND_UP(imx274->crop.height, ratio))
 			break;
-	}
-
-	if (index >= ARRAY_SIZE(imx274_formats)) {
-		/* default to first format */
-		index = 0;
-	}
 
-	imx274->mode = &imx274_formats[index];
+	imx274->mode = &imx274_formats[ratio - 1];
 
-	if (fmt->width > IMX274_MAX_WIDTH)
-		fmt->width = IMX274_MAX_WIDTH;
-	if (fmt->height > IMX274_MAX_HEIGHT)
-		fmt->height = IMX274_MAX_HEIGHT;
-	fmt->width = fmt->width & (~IMX274_MASK_LSB_2_BITS);
-	fmt->height = fmt->height & (~IMX274_MASK_LSB_2_BITS);
+	fmt->width = imx274->crop.width / ratio;
+	fmt->height = imx274->crop.height / ratio;
 	fmt->field = V4L2_FIELD_NONE;
 
+	dev_dbg(dev, "%s: adjusted to %dx%d (%d:1 binning)\n",
+		__func__, fmt->width, fmt->height, ratio);
+
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
 		cfg->try_fmt = *fmt;
 	else
@@ -940,6 +898,152 @@ static int imx274_set_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int imx274_get_selection(struct v4l2_subdev *sd,
+				struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_selection *sel)
+{
+	struct stimx274 *imx274 = to_imx274(sd);
+
+	if (sel->pad != 0)
+		return -EINVAL;
+
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = IMX274_MAX_WIDTH;
+		sel->r.height = IMX274_MAX_HEIGHT;
+		return 0;
+	case V4L2_SEL_TGT_CROP:
+		if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+			mutex_lock(&imx274->lock);
+			sel->r = imx274->crop;
+			mutex_unlock(&imx274->lock);
+		} else {
+			sel->r = cfg->try_crop;
+		}
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int imx274_set_selection(struct v4l2_subdev *sd,
+				struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_selection *sel)
+{
+	struct stimx274 *imx274 = to_imx274(sd);
+	struct device *dev = &imx274->client->dev;
+	struct v4l2_mbus_framefmt *tgt_fmt;
+	struct v4l2_rect *tgt_crop;
+	struct v4l2_rect new_crop;
+
+	/*
+	 * h_step could be 12 or 24 depending on the binning. But we
+	 * won't know the binning until we choose the mode later in
+	 * imx274_set_fmt(). Thus let's be safe and use the most
+	 * conservative value in all cases.
+	 */
+	const int h_step = 24;
+
+	dev_dbg(dev, "%s: request of  (%d,%d)%dx%d (%s)\n", __func__,
+		sel->r.left, sel->r.top, sel->r.width, sel->r.height,
+		V4L2_SUBDEV_FORMAT_ACTIVE ? "ACTIVE" : "TRY");
+
+	if (sel->target != V4L2_SEL_TGT_CROP || sel->pad != 0)
+		return -EINVAL;
+
+	new_crop.width = rounddown(min_t(u32, sel->r.width, IMX274_MAX_WIDTH),
+				   h_step);
+
+	/* Constraint: HTRIMMING_END - HTRIMMING_START >= 144 */
+	if (new_crop.width < 144)
+		new_crop.width = 144;
+
+	new_crop.left = min_t(u32, roundup(sel->r.left, h_step),
+			      IMX274_MAX_WIDTH - new_crop.width);
+
+	new_crop.height =
+		ALIGN(min_t(u32, sel->r.height, IMX274_MAX_HEIGHT), 2);
+
+	new_crop.top = min_t(u32, ALIGN(sel->r.top, 2),
+			     IMX274_MAX_HEIGHT - new_crop.height);
+
+	dev_dbg(dev, "%s: adjusted to (%d,%d)%dx%d", __func__,
+		new_crop.left, new_crop.top, new_crop.width, new_crop.height);
+
+	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
+		tgt_crop = &cfg->try_crop;
+		tgt_fmt = &cfg->try_fmt;
+	} else {
+		tgt_crop = &imx274->crop;
+		tgt_fmt = &imx274->format;
+	}
+
+	mutex_lock(&imx274->lock);
+
+	if (new_crop.width != tgt_crop->width ||
+	    new_crop.height != tgt_crop->height) {
+		/* crop size changed, reset the output image size */
+		tgt_fmt->width = new_crop.width;
+		tgt_fmt->height = new_crop.height;
+		if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+			imx274->mode = &imx274_formats[IMX274_MODE_BINNING_OFF];
+	}
+
+	*tgt_crop = new_crop;
+
+	mutex_unlock(&imx274->lock);
+
+	sel->r = new_crop;
+
+	return 0;
+}
+
+static int imx274_set_trimming(struct stimx274 *imx274)
+{
+	u32 h_start;
+	u32 h_end;
+	u32 hmax;
+	u32 v_cut;
+	s32 v_pos;
+	u32 write_v_size;
+	u32 y_out_size;
+	struct reg_8 regs[17];
+
+	h_start = imx274->crop.left + 12;
+	h_end = h_start + imx274->crop.width;
+
+	/* Use the minimum allowed value of HMAX */
+	/* Note: except in mode 1, (width / 16 + 23) is always < hmax_min */
+	/* Note: 260 is the minimum HMAX in all implemented modes */
+	hmax = max_t(u32, 260, (imx274->crop.width) / 16 + 23);
+
+	/* invert v_pos if VFLIP */
+	v_pos = imx274->ctrls.vflip->cur.val ?
+		(-imx274->crop.top / 2) : (imx274->crop.top / 2);
+	v_cut = (IMX274_MAX_HEIGHT - imx274->crop.height) / 2;
+	write_v_size = imx274->crop.height + 22;
+	y_out_size   = imx274->crop.height + 14;
+
+	prepare_reg(&regs[0],  IMX274_HMAX_REG_LSB,        hmax,         16);
+	prepare_reg(&regs[2],  IMX274_HTRIM_EN_REG,        1,             1);
+	prepare_reg(&regs[3],  IMX274_HTRIM_START_REG_LSB, h_start,      13);
+	prepare_reg(&regs[5],  IMX274_HTRIM_END_REG_LSB,   h_end,        13);
+
+	prepare_reg(&regs[7],  IMX274_VWIDCUTEN_REG,       1,             1);
+	prepare_reg(&regs[8],  IMX274_VWIDCUT_REG_LSB,     v_cut,        11);
+	prepare_reg(&regs[10], IMX274_VWINPOS_REG_LSB,     v_pos,        12);
+	prepare_reg(&regs[12], IMX274_WRITE_VSIZE_REG_LSB, write_v_size, 13);
+	prepare_reg(&regs[14], IMX274_Y_OUT_SIZE_REG_LSB,  y_out_size,   13);
+
+	regs[16].addr = IMX274_TABLE_END;
+
+	return imx274_write_table(imx274, regs);
+}
+
 /**
  * imx274_g_frame_interval - Get the frame interval
  * @sd: Pointer to V4L2 Sub device structure
@@ -1080,6 +1184,10 @@ static int imx274_s_stream(struct v4l2_subdev *sd, int on)
 		if (ret)
 			goto fail;
 
+		ret = imx274_set_trimming(imx274);
+		if (ret)
+			goto fail;
+
 		/*
 		 * update frame rate & expsoure. if the last mode is different,
 		 * HMAX could be changed. As the result, frame rate & exposure
@@ -1589,6 +1697,8 @@ static int imx274_set_frame_interval(struct stimx274 *priv,
 static const struct v4l2_subdev_pad_ops imx274_pad_ops = {
 	.get_fmt = imx274_get_fmt,
 	.set_fmt = imx274_set_fmt,
+	.get_selection = imx274_get_selection,
+	.set_selection = imx274_set_selection,
 };
 
 static const struct v4l2_subdev_video_ops imx274_video_ops = {
@@ -1641,6 +1751,8 @@ static int imx274_probe(struct i2c_client *client,
 	imx274->format.colorspace = V4L2_COLORSPACE_SRGB;
 	imx274->frame_interval.numerator = 1;
 	imx274->frame_interval.denominator = IMX274_DEF_FRAME_RATE;
+	imx274->crop.width = imx274->mode->size.width;
+	imx274->crop.height = imx274->mode->size.height;
 
 	/* initialize regmap */
 	imx274->regmap = devm_regmap_init_i2c(client, &imx274_regmap_config);
-- 
2.7.4
