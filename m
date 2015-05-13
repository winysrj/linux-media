Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:60059 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813AbbEMHXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 03:23:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ovebryne@cisco.com, marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCHv2 1/5] adv7842: Make output format configurable through pad format operations
Date: Wed, 13 May 2015 09:22:40 +0200
Message-Id: <1431501764-44250-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1431501764-44250-1-git-send-email-hverkuil@xs4all.nl>
References: <1431501764-44250-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace the dummy video format operations by pad format operations that
configure the output format.

Copied from the adv7604 driver.

Note: while arch/blackfin/mach-bf609/boards/ezkit.c uses adv7842_platform_data
this source has not been updated because it is broken since the very
beginning. It depends on a struct adv7842_output_format that does not
exist.

And besides that gcc has no support for bf609 so nobody can compile it
except by installing a toolchain from ADI.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/i2c/adv7842.c | 269 +++++++++++++++++++++++++++++++++++++++-----
 include/media/adv7842.h     |  89 ++++++---------
 2 files changed, 276 insertions(+), 82 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 86e65a8..dceabc2 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -56,6 +56,28 @@ MODULE_LICENSE("GPL");
 /* ADV7842 system clock frequency */
 #define ADV7842_fsc (28636360)
 
+#define ADV7842_RGB_OUT					(1 << 1)
+
+#define ADV7842_OP_FORMAT_SEL_8BIT			(0 << 0)
+#define ADV7842_OP_FORMAT_SEL_10BIT			(1 << 0)
+#define ADV7842_OP_FORMAT_SEL_12BIT			(2 << 0)
+
+#define ADV7842_OP_MODE_SEL_SDR_422			(0 << 5)
+#define ADV7842_OP_MODE_SEL_DDR_422			(1 << 5)
+#define ADV7842_OP_MODE_SEL_SDR_444			(2 << 5)
+#define ADV7842_OP_MODE_SEL_DDR_444			(3 << 5)
+#define ADV7842_OP_MODE_SEL_SDR_422_2X			(4 << 5)
+#define ADV7842_OP_MODE_SEL_ADI_CM			(5 << 5)
+
+#define ADV7842_OP_CH_SEL_GBR				(0 << 5)
+#define ADV7842_OP_CH_SEL_GRB				(1 << 5)
+#define ADV7842_OP_CH_SEL_BGR				(2 << 5)
+#define ADV7842_OP_CH_SEL_RGB				(3 << 5)
+#define ADV7842_OP_CH_SEL_BRG				(4 << 5)
+#define ADV7842_OP_CH_SEL_RBG				(5 << 5)
+
+#define ADV7842_OP_SWAP_CB_CR				(1 << 0)
+
 /*
 **********************************************************************
 *
@@ -64,6 +86,14 @@ MODULE_LICENSE("GPL");
 **********************************************************************
 */
 
+struct adv7842_format_info {
+	u32 code;
+	u8 op_ch_sel;
+	bool rgb_out;
+	bool swap_cb_cr;
+	u8 op_format_sel;
+};
+
 struct adv7842_state {
 	struct adv7842_platform_data pdata;
 	struct v4l2_subdev sd;
@@ -72,6 +102,9 @@ struct adv7842_state {
 	enum adv7842_mode mode;
 	struct v4l2_dv_timings timings;
 	enum adv7842_vid_std_select vid_std_select;
+
+	const struct adv7842_format_info *format;
+
 	v4l2_std_id norm;
 	struct {
 		u8 edid[256];
@@ -221,11 +254,21 @@ static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
 	return &container_of(ctrl->handler, struct adv7842_state, hdl)->sd;
 }
 
+static inline unsigned hblanking(const struct v4l2_bt_timings *t)
+{
+	return V4L2_DV_BT_BLANKING_WIDTH(t);
+}
+
 static inline unsigned htotal(const struct v4l2_bt_timings *t)
 {
 	return V4L2_DV_BT_FRAME_WIDTH(t);
 }
 
+static inline unsigned vblanking(const struct v4l2_bt_timings *t)
+{
+	return V4L2_DV_BT_BLANKING_HEIGHT(t);
+}
+
 static inline unsigned vtotal(const struct v4l2_bt_timings *t)
 {
 	return V4L2_DV_BT_FRAME_HEIGHT(t);
@@ -335,6 +378,12 @@ static inline int io_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 va
 	return io_write(sd, reg, (io_read(sd, reg) & mask) | val);
 }
 
+static inline int io_write_clr_set(struct v4l2_subdev *sd,
+				   u8 reg, u8 mask, u8 val)
+{
+	return io_write(sd, reg, (io_read(sd, reg) & ~mask) | val);
+}
+
 static inline int avlink_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7842_state *state = to_state(sd);
@@ -535,6 +584,64 @@ static void main_reset(struct v4l2_subdev *sd)
 	mdelay(5);
 }
 
+/* -----------------------------------------------------------------------------
+ * Format helpers
+ */
+
+static const struct adv7842_format_info adv7842_formats[] = {
+	{ MEDIA_BUS_FMT_RGB888_1X24, ADV7842_OP_CH_SEL_RGB, true, false,
+	  ADV7842_OP_MODE_SEL_SDR_444 | ADV7842_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, ADV7842_OP_CH_SEL_RGB, false, false,
+	  ADV7842_OP_MODE_SEL_SDR_422 | ADV7842_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, ADV7842_OP_CH_SEL_RGB, false, true,
+	  ADV7842_OP_MODE_SEL_SDR_422 | ADV7842_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YUYV10_2X10, ADV7842_OP_CH_SEL_RGB, false, false,
+	  ADV7842_OP_MODE_SEL_SDR_422 | ADV7842_OP_FORMAT_SEL_10BIT },
+	{ MEDIA_BUS_FMT_YVYU10_2X10, ADV7842_OP_CH_SEL_RGB, false, true,
+	  ADV7842_OP_MODE_SEL_SDR_422 | ADV7842_OP_FORMAT_SEL_10BIT },
+	{ MEDIA_BUS_FMT_YUYV12_2X12, ADV7842_OP_CH_SEL_RGB, false, false,
+	  ADV7842_OP_MODE_SEL_SDR_422 | ADV7842_OP_FORMAT_SEL_12BIT },
+	{ MEDIA_BUS_FMT_YVYU12_2X12, ADV7842_OP_CH_SEL_RGB, false, true,
+	  ADV7842_OP_MODE_SEL_SDR_422 | ADV7842_OP_FORMAT_SEL_12BIT },
+	{ MEDIA_BUS_FMT_UYVY8_1X16, ADV7842_OP_CH_SEL_RBG, false, false,
+	  ADV7842_OP_MODE_SEL_SDR_422_2X | ADV7842_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_VYUY8_1X16, ADV7842_OP_CH_SEL_RBG, false, true,
+	  ADV7842_OP_MODE_SEL_SDR_422_2X | ADV7842_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YUYV8_1X16, ADV7842_OP_CH_SEL_RGB, false, false,
+	  ADV7842_OP_MODE_SEL_SDR_422_2X | ADV7842_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YVYU8_1X16, ADV7842_OP_CH_SEL_RGB, false, true,
+	  ADV7842_OP_MODE_SEL_SDR_422_2X | ADV7842_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_UYVY10_1X20, ADV7842_OP_CH_SEL_RBG, false, false,
+	  ADV7842_OP_MODE_SEL_SDR_422_2X | ADV7842_OP_FORMAT_SEL_10BIT },
+	{ MEDIA_BUS_FMT_VYUY10_1X20, ADV7842_OP_CH_SEL_RBG, false, true,
+	  ADV7842_OP_MODE_SEL_SDR_422_2X | ADV7842_OP_FORMAT_SEL_10BIT },
+	{ MEDIA_BUS_FMT_YUYV10_1X20, ADV7842_OP_CH_SEL_RGB, false, false,
+	  ADV7842_OP_MODE_SEL_SDR_422_2X | ADV7842_OP_FORMAT_SEL_10BIT },
+	{ MEDIA_BUS_FMT_YVYU10_1X20, ADV7842_OP_CH_SEL_RGB, false, true,
+	  ADV7842_OP_MODE_SEL_SDR_422_2X | ADV7842_OP_FORMAT_SEL_10BIT },
+	{ MEDIA_BUS_FMT_UYVY12_1X24, ADV7842_OP_CH_SEL_RBG, false, false,
+	  ADV7842_OP_MODE_SEL_SDR_422_2X | ADV7842_OP_FORMAT_SEL_12BIT },
+	{ MEDIA_BUS_FMT_VYUY12_1X24, ADV7842_OP_CH_SEL_RBG, false, true,
+	  ADV7842_OP_MODE_SEL_SDR_422_2X | ADV7842_OP_FORMAT_SEL_12BIT },
+	{ MEDIA_BUS_FMT_YUYV12_1X24, ADV7842_OP_CH_SEL_RGB, false, false,
+	  ADV7842_OP_MODE_SEL_SDR_422_2X | ADV7842_OP_FORMAT_SEL_12BIT },
+	{ MEDIA_BUS_FMT_YVYU12_1X24, ADV7842_OP_CH_SEL_RGB, false, true,
+	  ADV7842_OP_MODE_SEL_SDR_422_2X | ADV7842_OP_FORMAT_SEL_12BIT },
+};
+
+static const struct adv7842_format_info *
+adv7842_format_info(struct adv7842_state *state, u32 code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(adv7842_formats); ++i) {
+		if (adv7842_formats[i].code == code)
+			return &adv7842_formats[i];
+	}
+
+	return NULL;
+}
+
 /* ----------------------------------------------------------------------- */
 
 static inline bool is_analog_input(struct v4l2_subdev *sd)
@@ -1440,6 +1547,8 @@ static int adv7842_query_dv_timings(struct v4l2_subdev *sd,
 	}
 	bt->interlaced = stdi.interlaced ?
 		V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
+	bt->standards = V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
+			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT;
 
 	if (is_digital_input(sd)) {
 		uint32_t freq;
@@ -1478,6 +1587,10 @@ static int adv7842_query_dv_timings(struct v4l2_subdev *sd,
 					hdmi_read(sd, 0x31)) / 2;
 			bt->il_vbackporch = ((hdmi_read(sd, 0x34) & 0x1f) * 256 +
 					hdmi_read(sd, 0x35)) / 2;
+		} else {
+			bt->il_vfrontporch = 0;
+			bt->il_vsync = 0;
+			bt->il_vbackporch = 0;
 		}
 		adv7842_fill_optional_dv_timings_fields(sd, timings);
 	} else {
@@ -1871,47 +1984,145 @@ static int adv7842_enum_mbus_code(struct v4l2_subdev *sd,
 		struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (code->pad || code->index)
+	if (code->index >= ARRAY_SIZE(adv7842_formats))
 		return -EINVAL;
-	/* Good enough for now */
-	code->code = MEDIA_BUS_FMT_FIXED;
+	code->code = adv7842_formats[code->index].code;
 	return 0;
 }
 
-static int adv7842_fill_fmt(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_format *format)
+static void adv7842_fill_format(struct adv7842_state *state,
+				struct v4l2_mbus_framefmt *format)
+{
+	memset(format, 0, sizeof(*format));
+
+	format->width = state->timings.bt.width;
+	format->height = state->timings.bt.height;
+	format->field = V4L2_FIELD_NONE;
+	format->colorspace = V4L2_COLORSPACE_SRGB;
+
+	if (state->timings.bt.flags & V4L2_DV_FL_IS_CE_VIDEO)
+		format->colorspace = (state->timings.bt.height <= 576) ?
+			V4L2_COLORSPACE_SMPTE170M : V4L2_COLORSPACE_REC709;
+}
+
+/*
+ * Compute the op_ch_sel value required to obtain on the bus the component order
+ * corresponding to the selected format taking into account bus reordering
+ * applied by the board at the output of the device.
+ *
+ * The following table gives the op_ch_value from the format component order
+ * (expressed as op_ch_sel value in column) and the bus reordering (expressed as
+ * adv7842_bus_order value in row).
+ *
+ *           |	GBR(0)	GRB(1)	BGR(2)	RGB(3)	BRG(4)	RBG(5)
+ * ----------+-------------------------------------------------
+ * RGB (NOP) |	GBR	GRB	BGR	RGB	BRG	RBG
+ * GRB (1-2) |	BGR	RGB	GBR	GRB	RBG	BRG
+ * RBG (2-3) |	GRB	GBR	BRG	RBG	BGR	RGB
+ * BGR (1-3) |	RBG	BRG	RGB	BGR	GRB	GBR
+ * BRG (ROR) |	BRG	RBG	GRB	GBR	RGB	BGR
+ * GBR (ROL) |	RGB	BGR	RBG	BRG	GBR	GRB
+ */
+static unsigned int adv7842_op_ch_sel(struct adv7842_state *state)
+{
+#define _SEL(a, b, c, d, e, f)	{ \
+	ADV7842_OP_CH_SEL_##a, ADV7842_OP_CH_SEL_##b, ADV7842_OP_CH_SEL_##c, \
+	ADV7842_OP_CH_SEL_##d, ADV7842_OP_CH_SEL_##e, ADV7842_OP_CH_SEL_##f }
+#define _BUS(x)			[ADV7842_BUS_ORDER_##x]
+
+	static const unsigned int op_ch_sel[6][6] = {
+		_BUS(RGB) /* NOP */ = _SEL(GBR, GRB, BGR, RGB, BRG, RBG),
+		_BUS(GRB) /* 1-2 */ = _SEL(BGR, RGB, GBR, GRB, RBG, BRG),
+		_BUS(RBG) /* 2-3 */ = _SEL(GRB, GBR, BRG, RBG, BGR, RGB),
+		_BUS(BGR) /* 1-3 */ = _SEL(RBG, BRG, RGB, BGR, GRB, GBR),
+		_BUS(BRG) /* ROR */ = _SEL(BRG, RBG, GRB, GBR, RGB, BGR),
+		_BUS(GBR) /* ROL */ = _SEL(RGB, BGR, RBG, BRG, GBR, GRB),
+	};
+
+	return op_ch_sel[state->pdata.bus_order][state->format->op_ch_sel >> 5];
+}
+
+static void adv7842_setup_format(struct adv7842_state *state)
+{
+	struct v4l2_subdev *sd = &state->sd;
+
+	io_write_clr_set(sd, 0x02, 0x02,
+			state->format->rgb_out ? ADV7842_RGB_OUT : 0);
+	io_write(sd, 0x03, state->format->op_format_sel |
+		 state->pdata.op_format_mode_sel);
+	io_write_clr_set(sd, 0x04, 0xe0, adv7842_op_ch_sel(state));
+	io_write_clr_set(sd, 0x05, 0x01,
+			state->format->swap_cb_cr ? ADV7842_OP_SWAP_CB_CR : 0);
+}
+
+static int adv7842_get_format(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *cfg,
+			      struct v4l2_subdev_format *format)
 {
-	struct v4l2_mbus_framefmt *fmt = &format->format;
 	struct adv7842_state *state = to_state(sd);
 
-	if (format->pad)
+	if (format->pad != ADV7842_PAD_SOURCE)
 		return -EINVAL;
 
-	fmt->width = state->timings.bt.width;
-	fmt->height = state->timings.bt.height;
-	fmt->code = MEDIA_BUS_FMT_FIXED;
-	fmt->field = V4L2_FIELD_NONE;
-
 	if (state->mode == ADV7842_MODE_SDP) {
 		/* SPD block */
-		if (!(sdp_read(sd, 0x5A) & 0x01))
+		if (!(sdp_read(sd, 0x5a) & 0x01))
 			return -EINVAL;
-		fmt->width = 720;
+		format->format.code = MEDIA_BUS_FMT_YUYV8_2X8;
+		format->format.width = 720;
 		/* valid signal */
 		if (state->norm & V4L2_STD_525_60)
-			fmt->height = 480;
+			format->format.height = 480;
 		else
-			fmt->height = 576;
-		fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
+			format->format.height = 576;
+		format->format.colorspace = V4L2_COLORSPACE_SMPTE170M;
 		return 0;
 	}
 
-	fmt->colorspace = V4L2_COLORSPACE_SRGB;
-	if (state->timings.bt.flags & V4L2_DV_FL_IS_CE_VIDEO) {
-		fmt->colorspace = (state->timings.bt.height <= 576) ?
-			V4L2_COLORSPACE_SMPTE170M : V4L2_COLORSPACE_REC709;
+	adv7842_fill_format(state, &format->format);
+
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		struct v4l2_mbus_framefmt *fmt;
+
+		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
+		format->format.code = fmt->code;
+	} else {
+		format->format.code = state->format->code;
 	}
+
+	return 0;
+}
+
+static int adv7842_set_format(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *cfg,
+			      struct v4l2_subdev_format *format)
+{
+	struct adv7842_state *state = to_state(sd);
+	const struct adv7842_format_info *info;
+
+	if (format->pad != ADV7842_PAD_SOURCE)
+		return -EINVAL;
+
+	if (state->mode == ADV7842_MODE_SDP)
+		return adv7842_get_format(sd, cfg, format);
+
+	info = adv7842_format_info(state, format->format.code);
+	if (info == NULL)
+		info = adv7842_format_info(state, MEDIA_BUS_FMT_YUYV8_2X8);
+
+	adv7842_fill_format(state, &format->format);
+	format->format.code = info->code;
+
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		struct v4l2_mbus_framefmt *fmt;
+
+		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
+		fmt->code = format->format.code;
+	} else {
+		state->format = info;
+		adv7842_setup_format(state);
+	}
+
 	return 0;
 }
 
@@ -2551,14 +2762,11 @@ static int adv7842_core_init(struct v4l2_subdev *sd)
 		 0xf0 |
 		 pdata->alt_gamma << 3 |
 		 pdata->op_656_range << 2 |
-		 pdata->rgb_out << 1 |
 		 pdata->alt_data_sat << 0);
-	io_write(sd, 0x03, pdata->op_format_sel);
-	io_write_and_or(sd, 0x04, 0x1f, pdata->op_ch_sel << 5);
 	io_write_and_or(sd, 0x05, 0xf0, pdata->blank_data << 3 |
 			pdata->insert_av_codes << 2 |
-			pdata->replicate_av_codes << 1 |
-			pdata->invert_cbcr << 0);
+			pdata->replicate_av_codes << 1);
+	adv7842_setup_format(state);
 
 	/* HDMI audio */
 	hdmi_write_and_or(sd, 0x1a, 0xf1, 0x08); /* Wait 1 s before unmute */
@@ -2818,13 +3026,13 @@ static const struct v4l2_subdev_video_ops adv7842_video_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops adv7842_pad_ops = {
+	.enum_mbus_code = adv7842_enum_mbus_code,
+	.get_fmt = adv7842_get_format,
+	.set_fmt = adv7842_set_format,
 	.get_edid = adv7842_get_edid,
 	.set_edid = adv7842_set_edid,
 	.enum_dv_timings = adv7842_enum_dv_timings,
 	.dv_timings_cap = adv7842_dv_timings_cap,
-	.enum_mbus_code = adv7842_enum_mbus_code,
-	.get_fmt = adv7842_fill_fmt,
-	.set_fmt = adv7842_fill_fmt,
 };
 
 static const struct v4l2_subdev_ops adv7842_ops = {
@@ -2991,6 +3199,7 @@ static int adv7842_probe(struct i2c_client *client,
 	/* platform data */
 	state->pdata = *pdata;
 	state->timings = cea640x480;
+	state->format = adv7842_format_info(state, MEDIA_BUS_FMT_YUYV8_2X8);
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7842_ops);
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index 924cbb8..64a66d0 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -30,14 +30,38 @@ enum adv7842_ain_sel {
 	ADV7842_AIN9_4_5_6_SYNC_2_1 = 4,
 };
 
-/* Bus rotation and reordering (IO register 0x04, [7:5]) */
-enum adv7842_op_ch_sel {
-	ADV7842_OP_CH_SEL_GBR = 0,
-	ADV7842_OP_CH_SEL_GRB = 1,
-	ADV7842_OP_CH_SEL_BGR = 2,
-	ADV7842_OP_CH_SEL_RGB = 3,
-	ADV7842_OP_CH_SEL_BRG = 4,
-	ADV7842_OP_CH_SEL_RBG = 5,
+/*
+ * Bus rotation and reordering. This is used to specify component reordering on
+ * the board and describes the components order on the bus when the ADV7842
+ * outputs RGB.
+ */
+enum adv7842_bus_order {
+	ADV7842_BUS_ORDER_RGB,		/* No operation	*/
+	ADV7842_BUS_ORDER_GRB,		/* Swap 1-2	*/
+	ADV7842_BUS_ORDER_RBG,		/* Swap 2-3	*/
+	ADV7842_BUS_ORDER_BGR,		/* Swap 1-3	*/
+	ADV7842_BUS_ORDER_BRG,		/* Rotate right	*/
+	ADV7842_BUS_ORDER_GBR,		/* Rotate left	*/
+};
+
+/* Input Color Space (IO register 0x02, [7:4]) */
+enum adv7842_inp_color_space {
+	ADV7842_INP_COLOR_SPACE_LIM_RGB = 0,
+	ADV7842_INP_COLOR_SPACE_FULL_RGB = 1,
+	ADV7842_INP_COLOR_SPACE_LIM_YCbCr_601 = 2,
+	ADV7842_INP_COLOR_SPACE_LIM_YCbCr_709 = 3,
+	ADV7842_INP_COLOR_SPACE_XVYCC_601 = 4,
+	ADV7842_INP_COLOR_SPACE_XVYCC_709 = 5,
+	ADV7842_INP_COLOR_SPACE_FULL_YCbCr_601 = 6,
+	ADV7842_INP_COLOR_SPACE_FULL_YCbCr_709 = 7,
+	ADV7842_INP_COLOR_SPACE_AUTO = 0xf,
+};
+
+/* Select output format (IO register 0x03, [4:2]) */
+enum adv7842_op_format_mode_sel {
+	ADV7842_OP_FORMAT_MODE0 = 0x00,
+	ADV7842_OP_FORMAT_MODE1 = 0x04,
+	ADV7842_OP_FORMAT_MODE2 = 0x08,
 };
 
 /* Mode of operation */
@@ -61,44 +85,6 @@ enum adv7842_vid_std_select {
 	ADV7842_HDMI_COMP_VID_STD_HD_1250P = 0x1e,
 };
 
-/* Input Color Space (IO register 0x02, [7:4]) */
-enum adv7842_inp_color_space {
-	ADV7842_INP_COLOR_SPACE_LIM_RGB = 0,
-	ADV7842_INP_COLOR_SPACE_FULL_RGB = 1,
-	ADV7842_INP_COLOR_SPACE_LIM_YCbCr_601 = 2,
-	ADV7842_INP_COLOR_SPACE_LIM_YCbCr_709 = 3,
-	ADV7842_INP_COLOR_SPACE_XVYCC_601 = 4,
-	ADV7842_INP_COLOR_SPACE_XVYCC_709 = 5,
-	ADV7842_INP_COLOR_SPACE_FULL_YCbCr_601 = 6,
-	ADV7842_INP_COLOR_SPACE_FULL_YCbCr_709 = 7,
-	ADV7842_INP_COLOR_SPACE_AUTO = 0xf,
-};
-
-/* Select output format (IO register 0x03, [7:0]) */
-enum adv7842_op_format_sel {
-	ADV7842_OP_FORMAT_SEL_SDR_ITU656_8 = 0x00,
-	ADV7842_OP_FORMAT_SEL_SDR_ITU656_10 = 0x01,
-	ADV7842_OP_FORMAT_SEL_SDR_ITU656_12_MODE0 = 0x02,
-	ADV7842_OP_FORMAT_SEL_SDR_ITU656_12_MODE1 = 0x06,
-	ADV7842_OP_FORMAT_SEL_SDR_ITU656_12_MODE2 = 0x0a,
-	ADV7842_OP_FORMAT_SEL_DDR_422_8 = 0x20,
-	ADV7842_OP_FORMAT_SEL_DDR_422_10 = 0x21,
-	ADV7842_OP_FORMAT_SEL_DDR_422_12_MODE0 = 0x22,
-	ADV7842_OP_FORMAT_SEL_DDR_422_12_MODE1 = 0x23,
-	ADV7842_OP_FORMAT_SEL_DDR_422_12_MODE2 = 0x24,
-	ADV7842_OP_FORMAT_SEL_SDR_444_24 = 0x40,
-	ADV7842_OP_FORMAT_SEL_SDR_444_30 = 0x41,
-	ADV7842_OP_FORMAT_SEL_SDR_444_36_MODE0 = 0x42,
-	ADV7842_OP_FORMAT_SEL_DDR_444_24 = 0x60,
-	ADV7842_OP_FORMAT_SEL_DDR_444_30 = 0x61,
-	ADV7842_OP_FORMAT_SEL_DDR_444_36 = 0x62,
-	ADV7842_OP_FORMAT_SEL_SDR_ITU656_16 = 0x80,
-	ADV7842_OP_FORMAT_SEL_SDR_ITU656_20 = 0x81,
-	ADV7842_OP_FORMAT_SEL_SDR_ITU656_24_MODE0 = 0x82,
-	ADV7842_OP_FORMAT_SEL_SDR_ITU656_24_MODE1 = 0x86,
-	ADV7842_OP_FORMAT_SEL_SDR_ITU656_24_MODE2 = 0x8a,
-};
-
 enum adv7842_select_input {
 	ADV7842_SELECT_HDMI_PORT_A,
 	ADV7842_SELECT_HDMI_PORT_B,
@@ -163,7 +149,10 @@ struct adv7842_platform_data {
 	enum adv7842_ain_sel ain_sel;
 
 	/* Bus rotation and reordering */
-	enum adv7842_op_ch_sel op_ch_sel;
+	enum adv7842_bus_order bus_order;
+
+	/* Select output format mode */
+	enum adv7842_op_format_mode_sel op_format_mode_sel;
 
 	/* Default mode */
 	enum adv7842_mode mode;
@@ -174,20 +163,15 @@ struct adv7842_platform_data {
 	/* Video standard */
 	enum adv7842_vid_std_select vid_std_select;
 
-	/* Select output format */
-	enum adv7842_op_format_sel op_format_sel;
-
 	/* IO register 0x02 */
 	unsigned alt_gamma:1;
 	unsigned op_656_range:1;
-	unsigned rgb_out:1;
 	unsigned alt_data_sat:1;
 
 	/* IO register 0x05 */
 	unsigned blank_data:1;
 	unsigned insert_av_codes:1;
 	unsigned replicate_av_codes:1;
-	unsigned invert_cbcr:1;
 
 	/* IO register 0x30 */
 	unsigned output_bus_lsb_to_msb:1;
@@ -256,5 +240,6 @@ struct adv7842_platform_data {
 #define ADV7842_EDID_PORT_A   0
 #define ADV7842_EDID_PORT_B   1
 #define ADV7842_EDID_PORT_VGA 2
+#define ADV7842_PAD_SOURCE    3
 
 #endif
-- 
2.1.4

