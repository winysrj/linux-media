Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:20731 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753596AbdGCJRN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Jul 2017 05:17:13 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        " H. Nikolaus Schaller" <hns@goldelico.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v2 5/7] [media] ov9650: add multiple variant support
Date: Mon, 3 Jul 2017 11:16:06 +0200
Message-ID: <1499073368-31905-6-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1499073368-31905-1-git-send-email-hugues.fruchet@st.com>
References: <1499073368-31905-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ops support and registers set can now be different
from a variant to another.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov9650.c | 156 ++++++++++++++++++++++++++++-----------------
 1 file changed, 99 insertions(+), 57 deletions(-)

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index db96698..50397e6 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -38,7 +38,7 @@
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
-#define DRIVER_NAME "OV9650"
+#define DRIVER_NAME "ov965x"
 
 /*
  * OV9650/OV9652 register definitions
@@ -239,6 +239,13 @@ struct ov965x_framesize {
 	const struct i2c_rv *regs;
 };
 
+struct ov965x_pixfmt {
+	u32 code;
+	u32 colorspace;
+	/* REG_TSLB value, only bits [3:2] may be set. */
+	u8 tslb_reg;
+};
+
 struct ov965x_interval {
 	struct v4l2_fract interval;
 	/* Maximum resolution for this interval */
@@ -257,6 +264,21 @@ struct ov965x {
 	struct media_pad pad;
 	enum v4l2_mbus_type bus_type;
 	struct gpio_desc *gpios[NUM_GPIOS];
+
+	/* Variant specific regs and ops */
+	const struct i2c_rv *init_regs;
+	const struct ov965x_framesize *framesizes;
+	unsigned int nb_of_framesizes;
+	const struct ov965x_pixfmt *formats;
+	unsigned int nb_of_formats;
+	const struct ov965x_interval *intervals;
+	unsigned int nb_of_intervals;
+	int (*initialize_controls)(struct ov965x *ov965x);
+	int (*set_frame_interval)(struct ov965x *ov965x,
+				  struct v4l2_subdev_frame_interval *fi);
+	void (*update_exposure_ctrl)(struct ov965x *ov965x);
+	int (*set_params)(struct ov965x *ov965x);
+
 	/* External master clock frequency */
 	unsigned long mclk_frequency;
 	struct clk *clk;
@@ -416,13 +438,6 @@ struct ov965x {
 	},
 };
 
-struct ov965x_pixfmt {
-	u32 code;
-	u32 colorspace;
-	/* REG_TSLB value, only bits [3:2] may be set. */
-	u8 tslb_reg;
-};
-
 static const struct ov965x_pixfmt ov965x_formats[] = {
 	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG, 0x00},
 	{ MEDIA_BUS_FMT_YVYU8_2X8, V4L2_COLORSPACE_JPEG, 0x04},
@@ -576,7 +591,7 @@ static int ov965x_s_power(struct v4l2_subdev *sd, int on)
 		__ov965x_set_power(ov965x, on);
 		if (on) {
 			ret = ov965x_write_array(client,
-						 ov965x_init_regs);
+						 ov965x->init_regs);
 			ov965x->apply_frame_fmt = 1;
 			ov965x->ctrls.update = 1;
 		}
@@ -1090,12 +1105,13 @@ static int ov965x_initialize_controls(struct ov965x *ov965x)
 /*
  * V4L2 subdev video and pad level operations
  */
-static void ov965x_get_default_format(struct v4l2_mbus_framefmt *mf)
+static void ov965x_get_default_format(struct ov965x *ov965x,
+				      struct v4l2_mbus_framefmt *mf)
 {
-	mf->width = ov965x_framesizes[0].width;
-	mf->height = ov965x_framesizes[0].height;
-	mf->colorspace = ov965x_formats[0].colorspace;
-	mf->code = ov965x_formats[0].code;
+	mf->width = ov965x->framesizes[0].width;
+	mf->height = ov965x->framesizes[0].height;
+	mf->colorspace = ov965x->formats[0].colorspace;
+	mf->code = ov965x->formats[0].code;
 	mf->field = V4L2_FIELD_NONE;
 }
 
@@ -1103,10 +1119,12 @@ static int ov965x_enum_mbus_code(struct v4l2_subdev *sd,
 				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (code->index >= ARRAY_SIZE(ov965x_formats))
+	struct ov965x *ov965x = to_ov965x(sd);
+
+	if (code->index >= ov965x->nb_of_formats)
 		return -EINVAL;
 
-	code->code = ov965x_formats[code->index].code;
+	code->code = ov965x->formats[code->index].code;
 	return 0;
 }
 
@@ -1114,22 +1132,22 @@ static int ov965x_enum_frame_sizes(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
-	int i = ARRAY_SIZE(ov965x_formats);
+	struct ov965x *ov965x = to_ov965x(sd);
+	int i = ov965x->nb_of_formats;
 
-	if (fse->index >= ARRAY_SIZE(ov965x_framesizes))
+	if (fse->index >= ov965x->nb_of_framesizes)
 		return -EINVAL;
 
 	while (--i)
-		if (fse->code == ov965x_formats[i].code)
+		if (fse->code == ov965x->formats[i].code)
 			break;
 
-	fse->code = ov965x_formats[i].code;
+	fse->code = ov965x->formats[i].code;
 
-	fse->min_width  = ov965x_framesizes[fse->index].width;
+	fse->min_width  = ov965x->framesizes[fse->index].width;
 	fse->max_width  = fse->min_width;
-	fse->max_height = ov965x_framesizes[fse->index].height;
+	fse->max_height = ov965x->framesizes[fse->index].height;
 	fse->min_height = fse->max_height;
-
 	return 0;
 }
 
@@ -1138,6 +1156,9 @@ static int ov965x_g_frame_interval(struct v4l2_subdev *sd,
 {
 	struct ov965x *ov965x = to_ov965x(sd);
 
+	if (!ov965x->fiv)
+		return 0;
+
 	mutex_lock(&ov965x->lock);
 	fi->interval = ov965x->fiv->interval;
 	mutex_unlock(&ov965x->lock);
@@ -1146,13 +1167,15 @@ static int ov965x_g_frame_interval(struct v4l2_subdev *sd,
 }
 
 static int __ov965x_set_frame_interval(struct ov965x *ov965x,
-				       struct v4l2_subdev_frame_interval *fi)
+				     struct v4l2_subdev_frame_interval *fi)
 {
 	struct v4l2_mbus_framefmt *mbus_fmt = &ov965x->format;
-	const struct ov965x_interval *fiv = &ov965x_intervals[0];
+	const struct ov965x_interval *fiv = ov965x->intervals;
 	u64 req_int, err, min_err = ~0ULL;
 	unsigned int i;
 
+	if (!fiv)
+		return 0;
 
 	if (fi->interval.denominator == 0)
 		return -EINVAL;
@@ -1160,8 +1183,8 @@ static int __ov965x_set_frame_interval(struct ov965x *ov965x,
 	req_int = (u64)(fi->interval.numerator * 10000) /
 		fi->interval.denominator;
 
-	for (i = 0; i < ARRAY_SIZE(ov965x_intervals); i++) {
-		const struct ov965x_interval *iv = &ov965x_intervals[i];
+	for (i = 0; i < ov965x->nb_of_intervals; i++) {
+		const struct ov965x_interval *iv = ov965x->intervals;
 
 		if (mbus_fmt->width != iv->size.width ||
 		    mbus_fmt->height != iv->size.height)
@@ -1185,13 +1208,15 @@ static int ov965x_s_frame_interval(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_frame_interval *fi)
 {
 	struct ov965x *ov965x = to_ov965x(sd);
-	int ret;
+	int ret = 0;
 
 	v4l2_dbg(1, debug, sd, "Setting %d/%d frame interval\n",
 		 fi->interval.numerator, fi->interval.denominator);
 
 	mutex_lock(&ov965x->lock);
-	ret = __ov965x_set_frame_interval(ov965x, fi);
+	if (ov965x->set_frame_interval)
+		ret = ov965x->set_frame_interval(ov965x, fi);
+
 	ov965x->apply_frame_fmt = 1;
 	mutex_unlock(&ov965x->lock);
 	return ret;
@@ -1216,12 +1241,13 @@ static int ov965x_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config
 	return 0;
 }
 
-static void __ov965x_try_frame_size(struct v4l2_mbus_framefmt *mf,
+static void __ov965x_try_frame_size(struct ov965x *ov965x,
+				    struct v4l2_mbus_framefmt *mf,
 				    const struct ov965x_framesize **size)
 {
-	const struct ov965x_framesize *fsize = &ov965x_framesizes[0],
+	const struct ov965x_framesize *fsize = &ov965x->framesizes[0],
 		*match = NULL;
-	int i = ARRAY_SIZE(ov965x_framesizes);
+	int i = ov965x->nb_of_framesizes;
 	unsigned int min_err = UINT_MAX;
 
 	while (i--) {
@@ -1234,7 +1260,7 @@ static void __ov965x_try_frame_size(struct v4l2_mbus_framefmt *mf,
 		fsize++;
 	}
 	if (!match)
-		match = &ov965x_framesizes[0];
+		match = &ov965x->framesizes[0];
 	mf->width  = match->width;
 	mf->height = match->height;
 	if (size)
@@ -1244,20 +1270,20 @@ static void __ov965x_try_frame_size(struct v4l2_mbus_framefmt *mf,
 static int ov965x_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
-	unsigned int index = ARRAY_SIZE(ov965x_formats);
-	struct v4l2_mbus_framefmt *mf = &fmt->format;
 	struct ov965x *ov965x = to_ov965x(sd);
+	unsigned int index = ov965x->nb_of_formats;
+	struct v4l2_mbus_framefmt *mf = &fmt->format;
 	const struct ov965x_framesize *size = NULL;
 	int ret = 0;
 
-	__ov965x_try_frame_size(mf, &size);
+	__ov965x_try_frame_size(ov965x, mf, &size);
 
 	while (--index)
-		if (ov965x_formats[index].code == mf->code)
+		if (ov965x->formats[index].code == mf->code)
 			break;
 
 	mf->colorspace	= V4L2_COLORSPACE_JPEG;
-	mf->code	= ov965x_formats[index].code;
+	mf->code	= ov965x->formats[index].code;
 	mf->field	= V4L2_FIELD_NONE;
 
 	mutex_lock(&ov965x->lock);
@@ -1273,7 +1299,7 @@ static int ov965x_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config
 		} else {
 			ov965x->frame_size = size;
 			ov965x->format = fmt->format;
-			ov965x->tslb_reg = ov965x_formats[index].tslb_reg;
+			ov965x->tslb_reg = ov965x->formats[index].tslb_reg;
 			ov965x->apply_frame_fmt = 1;
 		}
 	}
@@ -1283,12 +1309,14 @@ static int ov965x_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config
 			.interval = { 0, 1 }
 		};
 		/* Reset to minimum possible frame interval */
-		__ov965x_set_frame_interval(ov965x, &fiv);
+		if (ov965x->set_frame_interval)
+			ret = ov965x->set_frame_interval(ov965x, &fiv);
 	}
 	mutex_unlock(&ov965x->lock);
 
 	if (!ret)
-		ov965x_update_exposure_ctrl(ov965x);
+		if (ov965x->update_exposure_ctrl)
+			ov965x->update_exposure_ctrl(ov965x);
 
 	return ret;
 }
@@ -1363,7 +1391,8 @@ static int ov965x_s_stream(struct v4l2_subdev *sd, int on)
 	mutex_lock(&ov965x->lock);
 	if (ov965x->streaming == !on) {
 		if (on)
-			ret = __ov965x_set_params(ov965x);
+			if (ov965x->set_params)
+				ret = ov965x->set_params(ov965x);
 
 		if (!ret && ctrls->update) {
 			/*
@@ -1396,8 +1425,9 @@ static int ov965x_s_stream(struct v4l2_subdev *sd, int on)
 static int ov965x_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(sd, fh->pad, 0);
+	struct ov965x *ov965x = to_ov965x(sd);
 
-	ov965x_get_default_format(mf);
+	ov965x_get_default_format(ov965x, mf);
 	return 0;
 }
 
@@ -1516,8 +1546,6 @@ static int ov965x_probe(struct i2c_client *client,
 	ov965x = devm_kzalloc(&client->dev, sizeof(*ov965x), GFP_KERNEL);
 	if (!ov965x)
 		return -ENOMEM;
-
-	mutex_init(&ov965x->lock);
 	ov965x->client = client;
 	mutex_init(&ov965x->lock);
 
@@ -1557,38 +1585,52 @@ static int ov965x_probe(struct i2c_client *client,
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
 		     V4L2_SUBDEV_FL_HAS_EVENTS;
 
-	ret = ov965x_configure_gpios(ov965x, pdata);
-	if (ret < 0)
-		return ret;
-
 	ov965x->pad.flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	ret = media_entity_pads_init(&sd->entity, 1, &ov965x->pad);
 	if (ret < 0)
 		return ret;
 
-	ret = ov965x_initialize_controls(ov965x);
+	ret = ov965x_detect_sensor(sd);
 	if (ret < 0)
 		goto err_me;
 
-	ov965x_get_default_format(&ov965x->format);
-	ov965x->frame_size = &ov965x_framesizes[0];
+	ov965x->init_regs = ov965x_init_regs;
+	ov965x->initialize_controls = ov965x_initialize_controls;
+	ov965x->framesizes = ov965x_framesizes;
+	ov965x->nb_of_framesizes = ARRAY_SIZE(ov965x_framesizes);
+	ov965x->formats = ov965x_formats;
+	ov965x->nb_of_formats = ARRAY_SIZE(ov965x_formats);
+	ov965x->intervals = ov965x_intervals;
+	ov965x->nb_of_intervals = ARRAY_SIZE(ov965x_intervals);
 	ov965x->fiv = &ov965x_intervals[0];
+	ov965x->set_frame_interval = __ov965x_set_frame_interval;
+	ov965x->update_exposure_ctrl = ov965x_update_exposure_ctrl;
+	ov965x->set_params = __ov965x_set_params;
 
-	ret = ov965x_detect_sensor(sd);
-	if (ret < 0)
-		goto err_ctrls;
+	ov965x->frame_size = &ov965x->framesizes[0];
+	ov965x_get_default_format(ov965x, &ov965x->format);
+
+	if (ov965x->initialize_controls) {
+		ret = ov965x->initialize_controls(ov965x);
+		if (ret < 0)
+			goto err_ctrls;
+	}
 
 	/* Update exposure time min/max to match frame format */
-	ov965x_update_exposure_ctrl(ov965x);
+	if (ov965x->update_exposure_ctrl)
+		ov965x->update_exposure_ctrl(ov965x);
 
 	ret = v4l2_async_register_subdev(sd);
 	if (ret < 0)
 		goto err_ctrls;
 
+	dev_info(&client->dev, "%s driver probed\n", sd->name);
 	return 0;
+
 err_ctrls:
-	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	if (sd->ctrl_handler)
+		v4l2_ctrl_handler_free(sd->ctrl_handler);
 err_me:
 	media_entity_cleanup(&sd->entity);
 	return ret;
-- 
1.9.1
