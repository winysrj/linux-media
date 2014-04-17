Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38905 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaDQONk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 35/49] adv7604: Make output format configurable through pad format operations
Date: Thu, 17 Apr 2014 16:13:06 +0200
Message-Id: <1397744000-23967-36-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the dummy video format operations by pad format operations that
configure the output format.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 280 ++++++++++++++++++++++++++++++++++++++++----
 include/media/adv7604.h     |  56 ++++-----
 2 files changed, 275 insertions(+), 61 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 79fb34d..59f7bf0 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -53,6 +53,28 @@ MODULE_LICENSE("GPL");
 /* ADV7604 system clock frequency */
 #define ADV7604_fsc (28636360)
 
+#define ADV7604_RGB_OUT					(1 << 1)
+
+#define ADV7604_OP_FORMAT_SEL_8BIT			(0 << 0)
+#define ADV7604_OP_FORMAT_SEL_10BIT			(1 << 0)
+#define ADV7604_OP_FORMAT_SEL_12BIT			(2 << 0)
+
+#define ADV7604_OP_MODE_SEL_SDR_422			(0 << 5)
+#define ADV7604_OP_MODE_SEL_DDR_422			(1 << 5)
+#define ADV7604_OP_MODE_SEL_SDR_444			(2 << 5)
+#define ADV7604_OP_MODE_SEL_DDR_444			(3 << 5)
+#define ADV7604_OP_MODE_SEL_SDR_422_2X			(4 << 5)
+#define ADV7604_OP_MODE_SEL_ADI_CM			(5 << 5)
+
+#define ADV7604_OP_CH_SEL_GBR				(0 << 5)
+#define ADV7604_OP_CH_SEL_GRB				(1 << 5)
+#define ADV7604_OP_CH_SEL_BGR				(2 << 5)
+#define ADV7604_OP_CH_SEL_RGB				(3 << 5)
+#define ADV7604_OP_CH_SEL_BRG				(4 << 5)
+#define ADV7604_OP_CH_SEL_RBG				(5 << 5)
+
+#define ADV7604_OP_SWAP_CB_CR				(1 << 0)
+
 enum adv7604_type {
 	ADV7604,
 	ADV7611,
@@ -63,6 +85,14 @@ struct adv7604_reg_seq {
 	u8 val;
 };
 
+struct adv7604_format_info {
+	enum v4l2_mbus_pixelcode code;
+	u8 op_ch_sel;
+	bool rgb_out;
+	bool swap_cb_cr;
+	u8 op_format_sel;
+};
+
 struct adv7604_chip_info {
 	enum adv7604_type type;
 
@@ -78,6 +108,9 @@ struct adv7604_chip_info {
 	unsigned int tdms_lock_mask;
 	unsigned int fmt_change_digital_mask;
 
+	const struct adv7604_format_info *formats;
+	unsigned int nformats;
+
 	void (*set_termination)(struct v4l2_subdev *sd, bool enable);
 	void (*setup_irqs)(struct v4l2_subdev *sd);
 	unsigned int (*read_hdmi_pixelclock)(struct v4l2_subdev *sd);
@@ -101,12 +134,18 @@ struct adv7604_chip_info {
 struct adv7604_state {
 	const struct adv7604_chip_info *info;
 	struct adv7604_platform_data pdata;
+
 	struct v4l2_subdev sd;
 	struct media_pad pads[ADV7604_PAD_MAX];
 	unsigned int source_pad;
+
 	struct v4l2_ctrl_handler hdl;
+
 	enum adv7604_pad selected_input;
+
 	struct v4l2_dv_timings timings;
+	const struct adv7604_format_info *format;
+
 	struct {
 		u8 edid[256];
 		u32 present;
@@ -771,6 +810,93 @@ static void adv7604_write_reg_seq(struct v4l2_subdev *sd,
 		adv7604_write_reg(sd, reg_seq[i].reg, reg_seq[i].val);
 }
 
+/* -----------------------------------------------------------------------------
+ * Format helpers
+ */
+
+static const struct adv7604_format_info adv7604_formats[] = {
+	{ V4L2_MBUS_FMT_RGB888_1X24, ADV7604_OP_CH_SEL_RGB, true, false,
+	  ADV7604_OP_MODE_SEL_SDR_444 | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ V4L2_MBUS_FMT_YUYV8_2X8, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ V4L2_MBUS_FMT_YVYU8_2X8, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ V4L2_MBUS_FMT_YUYV10_2X10, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_10BIT },
+	{ V4L2_MBUS_FMT_YVYU10_2X10, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_10BIT },
+	{ V4L2_MBUS_FMT_YUYV12_2X12, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
+	{ V4L2_MBUS_FMT_YVYU12_2X12, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
+	{ V4L2_MBUS_FMT_UYVY8_1X16, ADV7604_OP_CH_SEL_RBG, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ V4L2_MBUS_FMT_VYUY8_1X16, ADV7604_OP_CH_SEL_RBG, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ V4L2_MBUS_FMT_YUYV8_1X16, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ V4L2_MBUS_FMT_YVYU8_1X16, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ V4L2_MBUS_FMT_UYVY10_1X20, ADV7604_OP_CH_SEL_RBG, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
+	{ V4L2_MBUS_FMT_VYUY10_1X20, ADV7604_OP_CH_SEL_RBG, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
+	{ V4L2_MBUS_FMT_YUYV10_1X20, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
+	{ V4L2_MBUS_FMT_YVYU10_1X20, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
+	{ V4L2_MBUS_FMT_UYVY12_1X24, ADV7604_OP_CH_SEL_RBG, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
+	{ V4L2_MBUS_FMT_VYUY12_1X24, ADV7604_OP_CH_SEL_RBG, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
+	{ V4L2_MBUS_FMT_YUYV12_1X24, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
+	{ V4L2_MBUS_FMT_YVYU12_1X24, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
+};
+
+static const struct adv7604_format_info adv7611_formats[] = {
+	{ V4L2_MBUS_FMT_RGB888_1X24, ADV7604_OP_CH_SEL_RGB, true, false,
+	  ADV7604_OP_MODE_SEL_SDR_444 | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ V4L2_MBUS_FMT_YUYV8_2X8, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ V4L2_MBUS_FMT_YVYU8_2X8, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ V4L2_MBUS_FMT_YUYV12_2X12, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
+	{ V4L2_MBUS_FMT_YVYU12_2X12, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
+	{ V4L2_MBUS_FMT_UYVY8_1X16, ADV7604_OP_CH_SEL_RBG, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ V4L2_MBUS_FMT_VYUY8_1X16, ADV7604_OP_CH_SEL_RBG, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ V4L2_MBUS_FMT_YUYV8_1X16, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ V4L2_MBUS_FMT_YVYU8_1X16, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ V4L2_MBUS_FMT_UYVY12_1X24, ADV7604_OP_CH_SEL_RBG, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
+	{ V4L2_MBUS_FMT_VYUY12_1X24, ADV7604_OP_CH_SEL_RBG, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
+	{ V4L2_MBUS_FMT_YUYV12_1X24, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
+	{ V4L2_MBUS_FMT_YVYU12_1X24, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
+};
+
+static const struct adv7604_format_info *
+adv7604_format_info(struct adv7604_state *state, enum v4l2_mbus_pixelcode code)
+{
+	unsigned int i;
+
+	for (i = 0; i < state->info->nformats; ++i) {
+		if (state->info->formats[i].code == code)
+			return &state->info->formats[i];
+	}
+
+	return NULL;
+}
+
 /* ----------------------------------------------------------------------- */
 
 static inline bool is_analog_input(struct v4l2_subdev *sd)
@@ -1720,29 +1846,132 @@ static int adv7604_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7604_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
-			     enum v4l2_mbus_pixelcode *code)
+static int adv7604_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (index)
+	struct adv7604_state *state = to_state(sd);
+
+	if (code->index >= state->info->nformats)
 		return -EINVAL;
-	/* Good enough for now */
-	*code = V4L2_MBUS_FMT_FIXED;
+
+	code->code = state->info->formats[code->index].code;
+
 	return 0;
 }
 
-static int adv7604_g_mbus_fmt(struct v4l2_subdev *sd,
-		struct v4l2_mbus_framefmt *fmt)
+static void adv7604_fill_format(struct adv7604_state *state,
+				struct v4l2_mbus_framefmt *format)
 {
-	struct adv7604_state *state = to_state(sd);
+	memset(format, 0, sizeof(*format));
 
-	fmt->width = state->timings.bt.width;
-	fmt->height = state->timings.bt.height;
-	fmt->code = V4L2_MBUS_FMT_FIXED;
-	fmt->field = V4L2_FIELD_NONE;
-	if (state->timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
-		fmt->colorspace = (state->timings.bt.height <= 576) ?
+	format->width = state->timings.bt.width;
+	format->height = state->timings.bt.height;
+	format->field = V4L2_FIELD_NONE;
+
+	if (state->timings.bt.standards & V4L2_DV_BT_STD_CEA861)
+		format->colorspace = (state->timings.bt.height <= 576) ?
 			V4L2_COLORSPACE_SMPTE170M : V4L2_COLORSPACE_REC709;
+}
+
+/*
+ * Compute the op_ch_sel value required to obtain on the bus the component order
+ * corresponding to the selected format taking into account bus reordering
+ * applied by the board at the output of the device.
+ *
+ * The following table gives the op_ch_value from the format component order
+ * (expressed as op_ch_sel value in column) and the bus reordering (expressed as
+ * adv7604_bus_order value in row).
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
+static unsigned int adv7604_op_ch_sel(struct adv7604_state *state)
+{
+#define _SEL(a,b,c,d,e,f)	{ \
+	ADV7604_OP_CH_SEL_##a, ADV7604_OP_CH_SEL_##b, ADV7604_OP_CH_SEL_##c, \
+	ADV7604_OP_CH_SEL_##d, ADV7604_OP_CH_SEL_##e, ADV7604_OP_CH_SEL_##f }
+#define _BUS(x)			[ADV7604_BUS_ORDER_##x]
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
+static void adv7604_setup_format(struct adv7604_state *state)
+{
+	struct v4l2_subdev *sd = &state->sd;
+
+	io_write_and_or(sd, 0x02, 0xfd,
+			state->format->rgb_out ? ADV7604_RGB_OUT : 0);
+	io_write(sd, 0x03, state->format->op_format_sel |
+		 state->pdata.op_format_mode_sel);
+	io_write_and_or(sd, 0x04, 0x1f, adv7604_op_ch_sel(state));
+	io_write_and_or(sd, 0x05, 0xfe,
+			state->format->swap_cb_cr ? ADV7604_OP_SWAP_CB_CR : 0);
+}
+
+static int adv7604_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_format *format)
+{
+	struct adv7604_state *state = to_state(sd);
+
+	if (format->pad != state->source_pad)
+		return -EINVAL;
+
+	adv7604_fill_format(state, &format->format);
+
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		struct v4l2_mbus_framefmt *fmt;
+
+		fmt = v4l2_subdev_get_try_format(fh, format->pad);
+		format->format.code = fmt->code;
+	} else {
+		format->format.code = state->format->code;
 	}
+
+	return 0;
+}
+
+static int adv7604_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_format *format)
+{
+	struct adv7604_state *state = to_state(sd);
+	const struct adv7604_format_info *info;
+
+	if (format->pad != state->source_pad)
+		return -EINVAL;
+
+	info = adv7604_format_info(state, format->format.code);
+	if (info == NULL)
+		info = adv7604_format_info(state, V4L2_MBUS_FMT_YUYV8_2X8);
+
+	adv7604_fill_format(state, &format->format);
+	format->format.code = info->code;
+
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		struct v4l2_mbus_framefmt *fmt;
+
+		fmt = v4l2_subdev_get_try_format(fh, format->pad);
+		fmt->code = format->format.code;
+	} else {
+		state->format = info;
+		adv7604_setup_format(state);
+	}
+
 	return 0;
 }
 
@@ -2189,13 +2418,12 @@ static const struct v4l2_subdev_video_ops adv7604_video_ops = {
 	.query_dv_timings = adv7604_query_dv_timings,
 	.enum_dv_timings = adv7604_enum_dv_timings,
 	.dv_timings_cap = adv7604_dv_timings_cap,
-	.enum_mbus_fmt = adv7604_enum_mbus_fmt,
-	.g_mbus_fmt = adv7604_g_mbus_fmt,
-	.try_mbus_fmt = adv7604_g_mbus_fmt,
-	.s_mbus_fmt = adv7604_g_mbus_fmt,
 };
 
 static const struct v4l2_subdev_pad_ops adv7604_pad_ops = {
+	.enum_mbus_code = adv7604_enum_mbus_code,
+	.get_fmt = adv7604_get_format,
+	.set_fmt = adv7604_set_format,
 	.get_edid = adv7604_get_edid,
 	.set_edid = adv7604_set_edid,
 };
@@ -2264,14 +2492,11 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 	io_write_and_or(sd, 0x02, 0xf0,
 			pdata->alt_gamma << 3 |
 			pdata->op_656_range << 2 |
-			pdata->rgb_out << 1 |
 			pdata->alt_data_sat << 0);
-	io_write(sd, 0x03, pdata->op_format_sel);
-	io_write_and_or(sd, 0x04, 0x1f, pdata->op_ch_sel << 5);
-	io_write_and_or(sd, 0x05, 0xf0, pdata->blank_data << 3 |
-					pdata->insert_av_codes << 2 |
-					pdata->replicate_av_codes << 1 |
-					pdata->invert_cbcr << 0);
+	io_write_and_or(sd, 0x05, 0xf1, pdata->blank_data << 3 |
+			pdata->insert_av_codes << 2 |
+			pdata->replicate_av_codes << 1);
+	adv7604_setup_format(state);
 
 	cp_write(sd, 0x69, 0x30);   /* Enable CP CSC */
 
@@ -2439,6 +2664,8 @@ static const struct adv7604_chip_info adv7604_chip_info[] = {
 		.tdms_lock_mask = 0xe0,
 		.cable_det_mask = 0x1e,
 		.fmt_change_digital_mask = 0xc1,
+		.formats = adv7604_formats,
+		.nformats = ARRAY_SIZE(adv7604_formats),
 		.set_termination = adv7604_set_termination,
 		.setup_irqs = adv7604_setup_irqs,
 		.read_hdmi_pixelclock = adv7604_read_hdmi_pixelclock,
@@ -2470,6 +2697,8 @@ static const struct adv7604_chip_info adv7604_chip_info[] = {
 		.tdms_lock_mask = 0x43,
 		.cable_det_mask = 0x01,
 		.fmt_change_digital_mask = 0x03,
+		.formats = adv7611_formats,
+		.nformats = ARRAY_SIZE(adv7611_formats),
 		.set_termination = adv7611_set_termination,
 		.setup_irqs = adv7611_setup_irqs,
 		.read_hdmi_pixelclock = adv7611_read_hdmi_pixelclock,
@@ -2525,6 +2754,7 @@ static int adv7604_probe(struct i2c_client *client,
 	}
 	state->pdata = *pdata;
 	state->timings = cea640x480;
+	state->format = adv7604_format_info(state, V4L2_MBUS_FMT_YUYV8_2X8);
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7604_ops);
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index 6186771..d8b2cb8 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -32,14 +32,18 @@ enum adv7604_ain_sel {
 	ADV7604_AIN9_4_5_6_SYNC_2_1 = 4,
 };
 
-/* Bus rotation and reordering (IO register 0x04, [7:5]) */
-enum adv7604_op_ch_sel {
-	ADV7604_OP_CH_SEL_GBR = 0,
-	ADV7604_OP_CH_SEL_GRB = 1,
-	ADV7604_OP_CH_SEL_BGR = 2,
-	ADV7604_OP_CH_SEL_RGB = 3,
-	ADV7604_OP_CH_SEL_BRG = 4,
-	ADV7604_OP_CH_SEL_RBG = 5,
+/*
+ * Bus rotation and reordering. This is used to specify component reordering on
+ * the board and describes the components order on the bus when the ADV7604
+ * outputs RGB.
+ */
+enum adv7604_bus_order {
+	ADV7604_BUS_ORDER_RGB,		/* No operation	*/
+	ADV7604_BUS_ORDER_GRB,		/* Swap 1-2	*/
+	ADV7604_BUS_ORDER_RBG,		/* Swap 2-3	*/
+	ADV7604_BUS_ORDER_BGR,		/* Swap 1-3	*/
+	ADV7604_BUS_ORDER_BRG,		/* Rotate right	*/
+	ADV7604_BUS_ORDER_GBR,		/* Rotate left	*/
 };
 
 /* Input Color Space (IO register 0x02, [7:4]) */
@@ -55,29 +59,11 @@ enum adv7604_inp_color_space {
 	ADV7604_INP_COLOR_SPACE_AUTO = 0xf,
 };
 
-/* Select output format (IO register 0x03, [7:0]) */
-enum adv7604_op_format_sel {
-	ADV7604_OP_FORMAT_SEL_SDR_ITU656_8 = 0x00,
-	ADV7604_OP_FORMAT_SEL_SDR_ITU656_10 = 0x01,
-	ADV7604_OP_FORMAT_SEL_SDR_ITU656_12_MODE0 = 0x02,
-	ADV7604_OP_FORMAT_SEL_SDR_ITU656_12_MODE1 = 0x06,
-	ADV7604_OP_FORMAT_SEL_SDR_ITU656_12_MODE2 = 0x0a,
-	ADV7604_OP_FORMAT_SEL_DDR_422_8 = 0x20,
-	ADV7604_OP_FORMAT_SEL_DDR_422_10 = 0x21,
-	ADV7604_OP_FORMAT_SEL_DDR_422_12_MODE0 = 0x22,
-	ADV7604_OP_FORMAT_SEL_DDR_422_12_MODE1 = 0x23,
-	ADV7604_OP_FORMAT_SEL_DDR_422_12_MODE2 = 0x24,
-	ADV7604_OP_FORMAT_SEL_SDR_444_24 = 0x40,
-	ADV7604_OP_FORMAT_SEL_SDR_444_30 = 0x41,
-	ADV7604_OP_FORMAT_SEL_SDR_444_36_MODE0 = 0x42,
-	ADV7604_OP_FORMAT_SEL_DDR_444_24 = 0x60,
-	ADV7604_OP_FORMAT_SEL_DDR_444_30 = 0x61,
-	ADV7604_OP_FORMAT_SEL_DDR_444_36 = 0x62,
-	ADV7604_OP_FORMAT_SEL_SDR_ITU656_16 = 0x80,
-	ADV7604_OP_FORMAT_SEL_SDR_ITU656_20 = 0x81,
-	ADV7604_OP_FORMAT_SEL_SDR_ITU656_24_MODE0 = 0x82,
-	ADV7604_OP_FORMAT_SEL_SDR_ITU656_24_MODE1 = 0x86,
-	ADV7604_OP_FORMAT_SEL_SDR_ITU656_24_MODE2 = 0x8a,
+/* Select output format (IO register 0x03, [4:2]) */
+enum adv7604_op_format_mode_sel {
+	ADV7604_OP_FORMAT_MODE0 = 0x00,
+	ADV7604_OP_FORMAT_MODE1 = 0x04,
+	ADV7604_OP_FORMAT_MODE2 = 0x08,
 };
 
 enum adv7604_drive_strength {
@@ -105,10 +91,10 @@ struct adv7604_platform_data {
 	enum adv7604_ain_sel ain_sel;
 
 	/* Bus rotation and reordering */
-	enum adv7604_op_ch_sel op_ch_sel;
+	enum adv7604_bus_order bus_order;
 
-	/* Select output format */
-	enum adv7604_op_format_sel op_format_sel;
+	/* Select output format mode */
+	enum adv7604_op_format_mode_sel op_format_mode_sel;
 
 	/* Configuration of the INT1 pin */
 	enum adv7604_int1_config int1_config;
@@ -116,14 +102,12 @@ struct adv7604_platform_data {
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
 
 	/* IO register 0x06 */
 	unsigned inv_vs_pol:1;
-- 
1.8.3.2

