Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38905 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbaDQONh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 32/49] adv7604: Add adv7611 support
Date: Thu, 17 Apr 2014 16:13:03 +0200
Message-Id: <1397744000-23967-33-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lars-Peter Clausen <lars@metafoo.de>

This patch adds support for the Analog Devices ADV7611 HDMI receiver.
The adv7611 is quite similar to the adv7604. It has only one instead of four
HDMI inputs and no analog frontend though. Also some register bits have been
shuffled around, but large parts of their register maps are compatible.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 719 +++++++++++++++++++++++++++++++-------------
 include/media/adv7604.h     |  10 +
 2 files changed, 528 insertions(+), 201 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index f9503d2..1720daf 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -53,6 +53,43 @@ MODULE_LICENSE("GPL");
 /* ADV7604 system clock frequency */
 #define ADV7604_fsc (28636360)
 
+enum adv7604_type {
+	ADV7604,
+	ADV7611,
+};
+
+struct adv7604_reg_seq {
+	unsigned int reg;
+	u8 val;
+};
+
+struct adv7604_chip_info {
+	enum adv7604_type type;
+
+	bool has_afe;
+	unsigned int max_port;
+	unsigned int num_dv_ports;
+
+	unsigned int edid_enable_reg;
+	unsigned int edid_status_reg;
+	unsigned int lcf_reg;
+
+	unsigned int cable_det_mask;
+	unsigned int tdms_lock_mask;
+	unsigned int fmt_change_digital_mask;
+
+	void (*set_termination)(struct v4l2_subdev *sd, bool enable);
+	void (*setup_irqs)(struct v4l2_subdev *sd);
+	unsigned int (*read_hdmi_pixelclock)(struct v4l2_subdev *sd);
+	unsigned int (*read_cable_det)(struct v4l2_subdev *sd);
+
+	/* 0 = AFE, 1 = HDMI */
+	const struct adv7604_reg_seq *recommended_settings[2];
+	unsigned int num_recommended_settings[2];
+
+	unsigned long page_mask;
+};
+
 /*
  **********************************************************************
  *
@@ -61,6 +98,7 @@ MODULE_LICENSE("GPL");
  **********************************************************************
  */
 struct adv7604_state {
+	const struct adv7604_chip_info *info;
 	struct adv7604_platform_data pdata;
 	struct v4l2_subdev sd;
 	struct media_pad pad;
@@ -101,6 +139,11 @@ struct adv7604_state {
 	struct v4l2_ctrl *rgb_quantization_range_ctrl;
 };
 
+static bool adv7604_has_afe(struct adv7604_state *state)
+{
+	return state->info->has_afe;
+}
+
 /* Supported CEA and DMT timings */
 static const struct v4l2_dv_timings adv7604_timings[] = {
 	V4L2_DV_BT_CEA_720X480P59_94,
@@ -611,6 +654,121 @@ static inline int vdp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return adv_smbus_write_byte_data(state->i2c_vdp, reg, val);
 }
 
+enum {
+	ADV7604_PAGE_IO,
+	ADV7604_PAGE_AVLINK,
+	ADV7604_PAGE_CEC,
+	ADV7604_PAGE_INFOFRAME,
+	ADV7604_PAGE_ESDP,
+	ADV7604_PAGE_DPP,
+	ADV7604_PAGE_AFE,
+	ADV7604_PAGE_REP,
+	ADV7604_PAGE_EDID,
+	ADV7604_PAGE_HDMI,
+	ADV7604_PAGE_TEST,
+	ADV7604_PAGE_CP,
+	ADV7604_PAGE_VDP,
+	ADV7604_PAGE_TERM,
+};
+
+#define ADV7604_REG(page, offset)	(((page) << 8) | (offset))
+#define ADV7604_REG_SEQ_TERM		0xffff
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int adv7604_read_reg(struct v4l2_subdev *sd, unsigned int reg)
+{
+	struct adv7604_state *state = to_state(sd);
+	unsigned int page = reg >> 8;
+
+	if (!(BIT(page) & state->info->page_mask))
+		return -EINVAL;
+
+	reg &= 0xff;
+
+	switch (page) {
+	case ADV7604_PAGE_IO:
+		return io_read(sd, reg);
+	case ADV7604_PAGE_AVLINK:
+		return avlink_read(sd, reg);
+	case ADV7604_PAGE_CEC:
+		return cec_read(sd, reg);
+	case ADV7604_PAGE_INFOFRAME:
+		return infoframe_read(sd, reg);
+	case ADV7604_PAGE_ESDP:
+		return esdp_read(sd, reg);
+	case ADV7604_PAGE_DPP:
+		return dpp_read(sd, reg);
+	case ADV7604_PAGE_AFE:
+		return afe_read(sd, reg);
+	case ADV7604_PAGE_REP:
+		return rep_read(sd, reg);
+	case ADV7604_PAGE_EDID:
+		return edid_read(sd, reg);
+	case ADV7604_PAGE_HDMI:
+		return hdmi_read(sd, reg);
+	case ADV7604_PAGE_TEST:
+		return test_read(sd, reg);
+	case ADV7604_PAGE_CP:
+		return cp_read(sd, reg);
+	case ADV7604_PAGE_VDP:
+		return vdp_read(sd, reg);
+	}
+
+	return -EINVAL;
+}
+#endif
+
+static int adv7604_write_reg(struct v4l2_subdev *sd, unsigned int reg, u8 val)
+{
+	struct adv7604_state *state = to_state(sd);
+	unsigned int page = reg >> 8;
+
+	if (!(BIT(page) & state->info->page_mask))
+		return -EINVAL;
+
+	reg &= 0xff;
+
+	switch (page) {
+	case ADV7604_PAGE_IO:
+		return io_write(sd, reg, val);
+	case ADV7604_PAGE_AVLINK:
+		return avlink_write(sd, reg, val);
+	case ADV7604_PAGE_CEC:
+		return cec_write(sd, reg, val);
+	case ADV7604_PAGE_INFOFRAME:
+		return infoframe_write(sd, reg, val);
+	case ADV7604_PAGE_ESDP:
+		return esdp_write(sd, reg, val);
+	case ADV7604_PAGE_DPP:
+		return dpp_write(sd, reg, val);
+	case ADV7604_PAGE_AFE:
+		return afe_write(sd, reg, val);
+	case ADV7604_PAGE_REP:
+		return rep_write(sd, reg, val);
+	case ADV7604_PAGE_EDID:
+		return edid_write(sd, reg, val);
+	case ADV7604_PAGE_HDMI:
+		return hdmi_write(sd, reg, val);
+	case ADV7604_PAGE_TEST:
+		return test_write(sd, reg, val);
+	case ADV7604_PAGE_CP:
+		return cp_write(sd, reg, val);
+	case ADV7604_PAGE_VDP:
+		return vdp_write(sd, reg, val);
+	}
+
+	return -EINVAL;
+}
+
+static void adv7604_write_reg_seq(struct v4l2_subdev *sd,
+				  const struct adv7604_reg_seq *reg_seq)
+{
+	unsigned int i;
+
+	for (i = 0; reg_seq[i].reg != ADV7604_REG_SEQ_TERM; i++)
+		adv7604_write_reg(sd, reg_seq[i].reg, reg_seq[i].val);
+}
+
 /* ----------------------------------------------------------------------- */
 
 static inline bool is_analog_input(struct v4l2_subdev *sd)
@@ -654,119 +812,61 @@ static void adv7604_inv_register(struct v4l2_subdev *sd)
 static int adv7604_g_register(struct v4l2_subdev *sd,
 					struct v4l2_dbg_register *reg)
 {
-	reg->size = 1;
-	switch (reg->reg >> 8) {
-	case 0:
-		reg->val = io_read(sd, reg->reg & 0xff);
-		break;
-	case 1:
-		reg->val = avlink_read(sd, reg->reg & 0xff);
-		break;
-	case 2:
-		reg->val = cec_read(sd, reg->reg & 0xff);
-		break;
-	case 3:
-		reg->val = infoframe_read(sd, reg->reg & 0xff);
-		break;
-	case 4:
-		reg->val = esdp_read(sd, reg->reg & 0xff);
-		break;
-	case 5:
-		reg->val = dpp_read(sd, reg->reg & 0xff);
-		break;
-	case 6:
-		reg->val = afe_read(sd, reg->reg & 0xff);
-		break;
-	case 7:
-		reg->val = rep_read(sd, reg->reg & 0xff);
-		break;
-	case 8:
-		reg->val = edid_read(sd, reg->reg & 0xff);
-		break;
-	case 9:
-		reg->val = hdmi_read(sd, reg->reg & 0xff);
-		break;
-	case 0xa:
-		reg->val = test_read(sd, reg->reg & 0xff);
-		break;
-	case 0xb:
-		reg->val = cp_read(sd, reg->reg & 0xff);
-		break;
-	case 0xc:
-		reg->val = vdp_read(sd, reg->reg & 0xff);
-		break;
-	default:
+	int ret;
+
+	ret = adv7604_read_reg(sd, reg->reg);
+	if (ret < 0) {
 		v4l2_info(sd, "Register %03llx not supported\n", reg->reg);
 		adv7604_inv_register(sd);
-		break;
+		return ret;
 	}
+
+	reg->size = 1;
+	reg->val = ret;
+
 	return 0;
 }
 
 static int adv7604_s_register(struct v4l2_subdev *sd,
 					const struct v4l2_dbg_register *reg)
 {
-	u8 val = reg->val & 0xff;
+	int ret;
 
-	switch (reg->reg >> 8) {
-	case 0:
-		io_write(sd, reg->reg & 0xff, val);
-		break;
-	case 1:
-		avlink_write(sd, reg->reg & 0xff, val);
-		break;
-	case 2:
-		cec_write(sd, reg->reg & 0xff, val);
-		break;
-	case 3:
-		infoframe_write(sd, reg->reg & 0xff, val);
-		break;
-	case 4:
-		esdp_write(sd, reg->reg & 0xff, val);
-		break;
-	case 5:
-		dpp_write(sd, reg->reg & 0xff, val);
-		break;
-	case 6:
-		afe_write(sd, reg->reg & 0xff, val);
-		break;
-	case 7:
-		rep_write(sd, reg->reg & 0xff, val);
-		break;
-	case 8:
-		edid_write(sd, reg->reg & 0xff, val);
-		break;
-	case 9:
-		hdmi_write(sd, reg->reg & 0xff, val);
-		break;
-	case 0xa:
-		test_write(sd, reg->reg & 0xff, val);
-		break;
-	case 0xb:
-		cp_write(sd, reg->reg & 0xff, val);
-		break;
-	case 0xc:
-		vdp_write(sd, reg->reg & 0xff, val);
-		break;
-	default:
+	ret = adv7604_write_reg(sd, reg->reg, reg->val);
+	if (ret < 0) {
 		v4l2_info(sd, "Register %03llx not supported\n", reg->reg);
 		adv7604_inv_register(sd);
-		break;
+		return ret;
 	}
+
 	return 0;
 }
 #endif
 
+static unsigned int adv7604_read_cable_det(struct v4l2_subdev *sd)
+{
+	u8 value = io_read(sd, 0x6f);
+
+	return ((value & 0x10) >> 4)
+	     | ((value & 0x08) >> 2)
+	     | ((value & 0x04) << 0)
+	     | ((value & 0x02) << 2);
+}
+
+static unsigned int adv7611_read_cable_det(struct v4l2_subdev *sd)
+{
+	u8 value = io_read(sd, 0x6f);
+
+	return value & 1;
+}
+
 static int adv7604_s_detect_tx_5v_ctrl(struct v4l2_subdev *sd)
 {
 	struct adv7604_state *state = to_state(sd);
-	u8 reg_io_6f = io_read(sd, 0x6f);
+	const struct adv7604_chip_info *info = state->info;
 
 	return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl,
-			((reg_io_6f & 0x10) >> 4) |
-			((reg_io_6f & 0x08) >> 2) |
-			(reg_io_6f & 0x04) |
-			((reg_io_6f & 0x02) << 2));
+				info->read_cable_det(sd));
 }
 
 static int find_and_set_predefined_video_timings(struct v4l2_subdev *sd,
@@ -797,9 +897,11 @@ static int configure_predefined_video_timings(struct v4l2_subdev *sd,
 
 	v4l2_dbg(1, debug, sd, "%s", __func__);
 
-	/* reset to default values */
-	io_write(sd, 0x16, 0x43);
-	io_write(sd, 0x17, 0x5a);
+	if (adv7604_has_afe(state)) {
+		/* reset to default values */
+		io_write(sd, 0x16, 0x43);
+		io_write(sd, 0x17, 0x5a);
+	}
 	/* disable embedded syncs for auto graphics mode */
 	cp_write_and_or(sd, 0x81, 0xef, 0x00);
 	cp_write(sd, 0x8f, 0x00);
@@ -1061,6 +1163,8 @@ static int adv7604_s_ctrl(struct v4l2_ctrl *ctrl)
 		set_rgb_quantization_range(sd);
 		return 0;
 	case V4L2_CID_ADV_RX_ANALOG_SAMPLING_PHASE:
+		if (!adv7604_has_afe(state))
+			return -EINVAL;
 		/* Set the analog sampling phase. This is needed to find the
 		   best sampling phase for analog video: an application or
 		   driver has to try a number of phases and analyze the picture
@@ -1098,7 +1202,10 @@ static inline bool no_signal_tmds(struct v4l2_subdev *sd)
 
 static inline bool no_lock_tmds(struct v4l2_subdev *sd)
 {
-	return (io_read(sd, 0x6a) & 0xe0) != 0xe0;
+	struct adv7604_state *state = to_state(sd);
+	const struct adv7604_chip_info *info = state->info;
+
+	return (io_read(sd, 0x6a) & info->tdms_lock_mask) != info->tdms_lock_mask;
 }
 
 static inline bool is_hdmi(struct v4l2_subdev *sd)
@@ -1108,6 +1215,15 @@ static inline bool is_hdmi(struct v4l2_subdev *sd)
 
 static inline bool no_lock_sspd(struct v4l2_subdev *sd)
 {
+	struct adv7604_state *state = to_state(sd);
+
+	/*
+	 * Chips without a AFE don't expose registers for the SSPD, so just assume
+	 * that we have a lock.
+	 */
+	if (adv7604_has_afe(state))
+		return false;
+
 	/* TODO channel 2 */
 	return ((cp_read(sd, 0xb5) & 0xd0) != 0xd0);
 }
@@ -1137,6 +1253,11 @@ static inline bool no_signal(struct v4l2_subdev *sd)
 
 static inline bool no_lock_cp(struct v4l2_subdev *sd)
 {
+	struct adv7604_state *state = to_state(sd);
+
+	if (!adv7604_has_afe(state))
+		return false;
+
 	/* CP has detected a non standard number of lines on the incoming
 	   video compared to what it is configured to receive by s_dv_timings */
 	return io_read(sd, 0x12) & 0x01;
@@ -1205,8 +1326,11 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
 	return -1;
 }
 
+
 static int read_stdi(struct v4l2_subdev *sd, struct stdi_readback *stdi)
 {
+	struct adv7604_state *state = to_state(sd);
+	const struct adv7604_chip_info *info = state->info;
 	u8 polarity;
 
 	if (no_lock_stdi(sd) || no_lock_sspd(sd)) {
@@ -1216,20 +1340,26 @@ static int read_stdi(struct v4l2_subdev *sd, struct stdi_readback *stdi)
 
 	/* read STDI */
 	stdi->bl = cp_read16(sd, 0xb1, 0x3fff);
-	stdi->lcf = cp_read16(sd, 0xb3, 0x7ff);
+	stdi->lcf = cp_read16(sd, info->lcf_reg, 0x7ff);
 	stdi->lcvs = cp_read(sd, 0xb3) >> 3;
 	stdi->interlaced = io_read(sd, 0x12) & 0x10;
 
-	/* read SSPD */
-	polarity = cp_read(sd, 0xb5);
-	if ((polarity & 0x03) == 0x01) {
-		stdi->hs_pol = polarity & 0x10
-			     ? (polarity & 0x08 ? '+' : '-') : 'x';
-		stdi->vs_pol = polarity & 0x40
-			     ? (polarity & 0x20 ? '+' : '-') : 'x';
+	if (adv7604_has_afe(state)) {
+		/* read SSPD */
+		polarity = cp_read(sd, 0xb5);
+		if ((polarity & 0x03) == 0x01) {
+			stdi->hs_pol = polarity & 0x10
+				     ? (polarity & 0x08 ? '+' : '-') : 'x';
+			stdi->vs_pol = polarity & 0x40
+				     ? (polarity & 0x20 ? '+' : '-') : 'x';
+		} else {
+			stdi->hs_pol = 'x';
+			stdi->vs_pol = 'x';
+		}
 	} else {
-		stdi->hs_pol = 'x';
-		stdi->vs_pol = 'x';
+		polarity = hdmi_read(sd, 0x05);
+		stdi->hs_pol = polarity & 0x20 ? '+' : '-';
+		stdi->vs_pol = polarity & 0x10 ? '+' : '-';
 	}
 
 	if (no_lock_stdi(sd) || no_lock_sspd(sd)) {
@@ -1297,10 +1427,43 @@ static void adv7604_fill_optional_dv_timings_fields(struct v4l2_subdev *sd,
 	}
 }
 
+static unsigned int adv7604_read_hdmi_pixelclock(struct v4l2_subdev *sd)
+{
+	unsigned int freq;
+	int a, b;
+
+	a = hdmi_read(sd, 0x06);
+	b = hdmi_read(sd, 0x3b);
+	if (a < 0 || b < 0)
+		return 0;
+	freq =  a * 1000000 + ((b & 0x30) >> 4) * 250000;
+
+	if (is_hdmi(sd)) {
+		/* adjust for deep color mode */
+		unsigned bits_per_channel = ((hdmi_read(sd, 0x0b) & 0x60) >> 4) + 8;
+
+		freq = freq * 8 / bits_per_channel;
+	}
+
+	return freq;
+}
+
+static unsigned int adv7611_read_hdmi_pixelclock(struct v4l2_subdev *sd)
+{
+	int a, b;
+
+	a = hdmi_read(sd, 0x51);
+	b = hdmi_read(sd, 0x52);
+	if (a < 0 || b < 0)
+		return 0;
+	return ((a << 1) | (b >> 7)) * 1000000 + (b & 0x7f) * 1000000 / 128;
+}
+
 static int adv7604_query_dv_timings(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings *timings)
 {
 	struct adv7604_state *state = to_state(sd);
+	const struct adv7604_chip_info *info = state->info;
 	struct v4l2_bt_timings *bt = &timings->bt;
 	struct stdi_readback stdi;
 
@@ -1324,21 +1487,12 @@ static int adv7604_query_dv_timings(struct v4l2_subdev *sd,
 		V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
 
 	if (is_digital_input(sd)) {
-		uint32_t freq;
-
 		timings->type = V4L2_DV_BT_656_1120;
 
+		/* FIXME: All masks are incorrect for ADV7611 */
 		bt->width = hdmi_read16(sd, 0x07, 0xfff);
 		bt->height = hdmi_read16(sd, 0x09, 0xfff);
-		freq = (hdmi_read(sd, 0x06) * 1000000) +
-			((hdmi_read(sd, 0x3b) & 0x30) >> 4) * 250000;
-		if (is_hdmi(sd)) {
-			/* adjust for deep color mode */
-			unsigned bits_per_channel = ((hdmi_read(sd, 0x0b) & 0x60) >> 4) + 8;
-
-			freq = freq * 8 / bits_per_channel;
-		}
-		bt->pixelclock = freq;
+		bt->pixelclock = info->read_hdmi_pixelclock(sd);
 		bt->hfrontporch = hdmi_read16(sd, 0x20, 0x3ff);
 		bt->hsync = hdmi_read16(sd, 0x22, 0x3ff);
 		bt->hbackporch = hdmi_read16(sd, 0x24, 0x3ff);
@@ -1444,7 +1598,7 @@ static int adv7604_s_dv_timings(struct v4l2_subdev *sd,
 
 	state->timings = *timings;
 
-	cp_write(sd, 0x91, bt->interlaced ? 0x50 : 0x10);
+	cp_write_and_or(sd, 0x91, 0xbf, bt->interlaced ? 0x40 : 0x00);
 
 	/* Use prim_mode and vid_std when available */
 	err = configure_predefined_video_timings(sd, timings);
@@ -1471,6 +1625,16 @@ static int adv7604_g_dv_timings(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static void adv7604_set_termination(struct v4l2_subdev *sd, bool enable)
+{
+	hdmi_write(sd, 0x01, enable ? 0x00 : 0x78);
+}
+
+static void adv7611_set_termination(struct v4l2_subdev *sd, bool enable)
+{
+	hdmi_write(sd, 0x83, enable ? 0xfe : 0xff);
+}
+
 static void enable_input(struct v4l2_subdev *sd)
 {
 	struct adv7604_state *state = to_state(sd);
@@ -1479,7 +1643,7 @@ static void enable_input(struct v4l2_subdev *sd)
 		io_write(sd, 0x15, 0xb0);   /* Disable Tristate of Pins (no audio) */
 	} else if (is_digital_input(sd)) {
 		hdmi_write_and_or(sd, 0x00, 0xfc, state->selected_input);
-		hdmi_write(sd, 0x01, 0x00); /* Enable HDMI clock terminators */
+		state->info->set_termination(sd, true);
 		io_write(sd, 0x15, 0xa0);   /* Disable Tristate of Pins */
 		hdmi_write_and_or(sd, 0x1a, 0xef, 0x00); /* Unmute audio */
 	} else {
@@ -1490,67 +1654,36 @@ static void enable_input(struct v4l2_subdev *sd)
 
 static void disable_input(struct v4l2_subdev *sd)
 {
+	struct adv7604_state *state = to_state(sd);
+
 	hdmi_write_and_or(sd, 0x1a, 0xef, 0x10); /* Mute audio */
 	msleep(16); /* 512 samples with >= 32 kHz sample rate [REF_03, c. 7.16.10] */
 	io_write(sd, 0x15, 0xbe);   /* Tristate all outputs from video core */
-	hdmi_write(sd, 0x01, 0x78); /* Disable HDMI clock terminators */
+	state->info->set_termination(sd, false);
 }
 
 static void select_input(struct v4l2_subdev *sd)
 {
 	struct adv7604_state *state = to_state(sd);
+	const struct adv7604_chip_info *info = state->info;
 
 	if (is_analog_input(sd)) {
-		/* reset ADI recommended settings for HDMI: */
-		/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 4. */
-		hdmi_write(sd, 0x0d, 0x04); /* HDMI filter optimization */
-		hdmi_write(sd, 0x3d, 0x00); /* DDC bus active pull-up control */
-		hdmi_write(sd, 0x3e, 0x74); /* TMDS PLL optimization */
-		hdmi_write(sd, 0x4e, 0x3b); /* TMDS PLL optimization */
-		hdmi_write(sd, 0x57, 0x74); /* TMDS PLL optimization */
-		hdmi_write(sd, 0x58, 0x63); /* TMDS PLL optimization */
-		hdmi_write(sd, 0x8d, 0x18); /* equaliser */
-		hdmi_write(sd, 0x8e, 0x34); /* equaliser */
-		hdmi_write(sd, 0x93, 0x88); /* equaliser */
-		hdmi_write(sd, 0x94, 0x2e); /* equaliser */
-		hdmi_write(sd, 0x96, 0x00); /* enable automatic EQ changing */
+		adv7604_write_reg_seq(sd, info->recommended_settings[0]);
 
 		afe_write(sd, 0x00, 0x08); /* power up ADC */
 		afe_write(sd, 0x01, 0x06); /* power up Analog Front End */
 		afe_write(sd, 0xc8, 0x00); /* phase control */
-
-		/* set ADI recommended settings for digitizer */
-		/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 17. */
-		afe_write(sd, 0x12, 0x7b); /* ADC noise shaping filter controls */
-		afe_write(sd, 0x0c, 0x1f); /* CP core gain controls */
-		cp_write(sd, 0x3e, 0x04); /* CP core pre-gain control */
-		cp_write(sd, 0xc3, 0x39); /* CP coast control. Graphics mode */
-		cp_write(sd, 0x40, 0x5c); /* CP core pre-gain control. Graphics mode */
 	} else if (is_digital_input(sd)) {
 		hdmi_write(sd, 0x00, state->selected_input & 0x03);
 
-		/* set ADI recommended settings for HDMI: */
-		/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 4. */
-		hdmi_write(sd, 0x0d, 0x84); /* HDMI filter optimization */
-		hdmi_write(sd, 0x3d, 0x10); /* DDC bus active pull-up control */
-		hdmi_write(sd, 0x3e, 0x39); /* TMDS PLL optimization */
-		hdmi_write(sd, 0x4e, 0x3b); /* TMDS PLL optimization */
-		hdmi_write(sd, 0x57, 0xb6); /* TMDS PLL optimization */
-		hdmi_write(sd, 0x58, 0x03); /* TMDS PLL optimization */
-		hdmi_write(sd, 0x8d, 0x18); /* equaliser */
-		hdmi_write(sd, 0x8e, 0x34); /* equaliser */
-		hdmi_write(sd, 0x93, 0x8b); /* equaliser */
-		hdmi_write(sd, 0x94, 0x2d); /* equaliser */
-		hdmi_write(sd, 0x96, 0x01); /* enable automatic EQ changing */
-
-		afe_write(sd, 0x00, 0xff); /* power down ADC */
-		afe_write(sd, 0x01, 0xfe); /* power down Analog Front End */
-		afe_write(sd, 0xc8, 0x40); /* phase control */
-
-		/* reset ADI recommended settings for digitizer */
-		/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 17. */
-		afe_write(sd, 0x12, 0xfb); /* ADC noise shaping filter controls */
-		afe_write(sd, 0x0c, 0x0d); /* CP core gain controls */
+		adv7604_write_reg_seq(sd, info->recommended_settings[1]);
+
+		if (adv7604_has_afe(state)) {
+			afe_write(sd, 0x00, 0xff); /* power down ADC */
+			afe_write(sd, 0x01, 0xfe); /* power down Analog Front End */
+			afe_write(sd, 0xc8, 0x40); /* phase control */
+		}
+
 		cp_write(sd, 0x3e, 0x00); /* CP core pre-gain control */
 		cp_write(sd, 0xc3, 0x39); /* CP coast control. Graphics mode */
 		cp_write(sd, 0x40, 0x80); /* CP core pre-gain control. Graphics mode */
@@ -1571,6 +1704,9 @@ static int adv7604_s_routing(struct v4l2_subdev *sd,
 	if (input == state->selected_input)
 		return 0;
 
+	if (input > state->info->max_port)
+		return -EINVAL;
+
 	state->selected_input = input;
 
 	disable_input(sd);
@@ -1610,6 +1746,8 @@ static int adv7604_g_mbus_fmt(struct v4l2_subdev *sd,
 
 static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 {
+	struct adv7604_state *state = to_state(sd);
+	const struct adv7604_chip_info *info = state->info;
 	const u8 irq_reg_0x43 = io_read(sd, 0x43);
 	const u8 irq_reg_0x6b = io_read(sd, 0x6b);
 	const u8 irq_reg_0x70 = io_read(sd, 0x70);
@@ -1628,7 +1766,9 @@ static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 
 	/* format change */
 	fmt_change = irq_reg_0x43 & 0x98;
-	fmt_change_digital = is_digital_input(sd) ? (irq_reg_0x6b & 0xc0) : 0;
+	fmt_change_digital = is_digital_input(sd)
+			   ? irq_reg_0x6b & info->fmt_change_digital_mask
+			   : 0;
 
 	if (fmt_change || fmt_change_digital) {
 		v4l2_dbg(1, debug, sd,
@@ -1650,7 +1790,7 @@ static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	}
 
 	/* tx 5v detect */
-	tx_5v = io_read(sd, 0x70) & 0x1e;
+	tx_5v = io_read(sd, 0x70) & info->cable_det_mask;
 	if (tx_5v) {
 		v4l2_dbg(1, debug, sd, "%s: tx_5v: 0x%x\n", __func__, tx_5v);
 		io_write(sd, 0x71, tx_5v);
@@ -1732,6 +1872,7 @@ static int get_edid_spa_location(const u8 *edid)
 static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 {
 	struct adv7604_state *state = to_state(sd);
+	const struct adv7604_chip_info *info = state->info;
 	int spa_loc;
 	int tmp = 0;
 	int err;
@@ -1745,7 +1886,7 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		/* Disable hotplug and I2C access to EDID RAM from DDC port */
 		state->edid.present &= ~(1 << edid->pad);
 		v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&state->edid.present);
-		rep_write_and_or(sd, 0x77, 0xf0, state->edid.present);
+		rep_write_and_or(sd, info->edid_enable_reg, 0xf0, state->edid.present);
 
 		/* Fall back to a 16:9 aspect ratio */
 		state->aspect_ratio.numerator = 16;
@@ -1769,7 +1910,7 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 	/* Disable hotplug and I2C access to EDID RAM from DDC port */
 	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
 	v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&tmp);
-	rep_write_and_or(sd, 0x77, 0xf0, 0x00);
+	rep_write_and_or(sd, info->edid_enable_reg, 0xf0, 0x00);
 
 	spa_loc = get_edid_spa_location(edid->edid);
 	if (spa_loc < 0)
@@ -1795,8 +1936,14 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 	default:
 		return -EINVAL;
 	}
-	rep_write(sd, 0x76, spa_loc & 0xff);
-	rep_write_and_or(sd, 0x77, 0xbf, (spa_loc >> 2) & 0x40);
+
+	if (info->type == ADV7604) {
+		rep_write(sd, 0x76, spa_loc & 0xff);
+		rep_write_and_or(sd, 0x77, 0xbf, (spa_loc & 0x100) >> 2);
+	} else {
+		/* FIXME: Where is the SPA location LSB register ? */
+		rep_write_and_or(sd, 0x71, 0xfe, (spa_loc & 0x100) >> 8);
+	}
 
 	edid->edid[spa_loc] = state->spa_port_a[0];
 	edid->edid[spa_loc + 1] = state->spa_port_a[1];
@@ -1815,10 +1962,10 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 
 	/* adv7604 calculates the checksums and enables I2C access to internal
 	   EDID RAM from DDC port. */
-	rep_write_and_or(sd, 0x77, 0xf0, state->edid.present);
+	rep_write_and_or(sd, info->edid_enable_reg, 0xf0, state->edid.present);
 
 	for (i = 0; i < 1000; i++) {
-		if (rep_read(sd, 0x7d) & state->edid.present)
+		if (rep_read(sd, info->edid_status_reg) & state->edid.present)
 			break;
 		mdelay(1);
 	}
@@ -1881,6 +2028,7 @@ static void print_avi_infoframe(struct v4l2_subdev *sd)
 static int adv7604_log_status(struct v4l2_subdev *sd)
 {
 	struct adv7604_state *state = to_state(sd);
+	const struct adv7604_chip_info *info = state->info;
 	struct v4l2_dv_timings timings;
 	struct stdi_readback stdi;
 	u8 reg_io_0x02 = io_read(sd, 0x02);
@@ -1915,7 +2063,7 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 
 	v4l2_info(sd, "-----Chip status-----\n");
 	v4l2_info(sd, "Chip power: %s\n", no_power(sd) ? "off" : "on");
-	edid_enabled = rep_read(sd, 0x7d);
+	edid_enabled = rep_read(sd, info->edid_status_reg);
 	v4l2_info(sd, "EDID enabled port A: %s, B: %s, C: %s, D: %s\n",
 			((edid_enabled & 0x01) ? "Yes" : "No"),
 			((edid_enabled & 0x02) ? "Yes" : "No"),
@@ -1925,12 +2073,12 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 			"enabled" : "disabled");
 
 	v4l2_info(sd, "-----Signal status-----\n");
-	cable_det = io_read(sd, 0x6f);
+	cable_det = info->read_cable_det(sd);
 	v4l2_info(sd, "Cable detected (+5V power) port A: %s, B: %s, C: %s, D: %s\n",
-			((cable_det & 0x10) ? "Yes" : "No"),
-			((cable_det & 0x08) ? "Yes" : "No"),
+			((cable_det & 0x01) ? "Yes" : "No"),
+			((cable_det & 0x02) ? "Yes" : "No"),
 			((cable_det & 0x04) ? "Yes" : "No"),
-			((cable_det & 0x02) ? "Yes" : "No"));
+			((cable_det & 0x08) ? "Yes" : "No"));
 	v4l2_info(sd, "TMDS signal detected: %s\n",
 			no_signal_tmds(sd) ? "false" : "true");
 	v4l2_info(sd, "TMDS signal locked: %s\n",
@@ -2103,6 +2251,7 @@ static const struct v4l2_ctrl_config adv7604_ctrl_free_run_color = {
 static int adv7604_core_init(struct v4l2_subdev *sd)
 {
 	struct adv7604_state *state = to_state(sd);
+	const struct adv7604_chip_info *info = state->info;
 	struct adv7604_platform_data *pdata = &state->pdata;
 
 	hdmi_write(sd, 0x48,
@@ -2156,19 +2305,31 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 	/* TODO from platform data */
 	afe_write(sd, 0xb5, 0x01);  /* Setting MCLK to 256Fs */
 
-	afe_write(sd, 0x02, pdata->ain_sel); /* Select analog input muxing mode */
-	io_write_and_or(sd, 0x30, ~(1 << 4), pdata->output_bus_lsb_to_msb << 4);
+	if (adv7604_has_afe(state)) {
+		afe_write(sd, 0x02, pdata->ain_sel); /* Select analog input muxing mode */
+		io_write_and_or(sd, 0x30, ~(1 << 4), pdata->output_bus_lsb_to_msb << 4);
+	}
 
 	/* interrupts */
-	io_write(sd, 0x40, 0xc2); /* Configure INT1 */
-	io_write(sd, 0x41, 0xd7); /* STDI irq for any change, disable INT2 */
+	io_write(sd, 0x40, 0xc0 | pdata->int1_config); /* Configure INT1 */
 	io_write(sd, 0x46, 0x98); /* Enable SSPD, STDI and CP unlocked interrupts */
-	io_write(sd, 0x6e, 0xc1); /* Enable V_LOCKED, DE_REGEN_LCK, HDMI_MODE interrupts */
-	io_write(sd, 0x73, 0x1e); /* Enable CABLE_DET_A_ST (+5v) interrupts */
+	io_write(sd, 0x6e, info->fmt_change_digital_mask); /* Enable V_LOCKED and DE_REGEN_LCK interrupts */
+	io_write(sd, 0x73, info->cable_det_mask); /* Enable cable detection (+5v) interrupts */
+	info->setup_irqs(sd);
 
 	return v4l2_ctrl_handler_setup(sd->ctrl_handler);
 }
 
+static void adv7604_setup_irqs(struct v4l2_subdev *sd)
+{
+	io_write(sd, 0x41, 0xd7); /* STDI irq for any change, disable INT2 */
+}
+
+static void adv7611_setup_irqs(struct v4l2_subdev *sd)
+{
+	io_write(sd, 0x41, 0xd0); /* STDI irq for any change, disable INT2 */
+}
+
 static void adv7604_unregister_clients(struct adv7604_state *state)
 {
 	if (state->i2c_avlink)
@@ -2207,6 +2368,130 @@ static struct i2c_client *adv7604_dummy_client(struct v4l2_subdev *sd,
 	return i2c_new_dummy(client->adapter, io_read(sd, io_reg) >> 1);
 }
 
+static const struct adv7604_reg_seq adv7604_recommended_settings_afe[] = {
+	/* reset ADI recommended settings for HDMI: */
+	/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 4. */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x0d), 0x04 }, /* HDMI filter optimization */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x0d), 0x04 }, /* HDMI filter optimization */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x3d), 0x00 }, /* DDC bus active pull-up control */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x3e), 0x74 }, /* TMDS PLL optimization */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x4e), 0x3b }, /* TMDS PLL optimization */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x57), 0x74 }, /* TMDS PLL optimization */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x58), 0x63 }, /* TMDS PLL optimization */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x8d), 0x18 }, /* equaliser */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x8e), 0x34 }, /* equaliser */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x93), 0x88 }, /* equaliser */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x94), 0x2e }, /* equaliser */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x96), 0x00 }, /* enable automatic EQ changing */
+
+	/* set ADI recommended settings for digitizer */
+	/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 17. */
+	{ ADV7604_REG(ADV7604_PAGE_AFE, 0x12), 0x7b }, /* ADC noise shaping filter controls */
+	{ ADV7604_REG(ADV7604_PAGE_AFE, 0x0c), 0x1f }, /* CP core gain controls */
+	{ ADV7604_REG(ADV7604_PAGE_CP, 0x3e), 0x04 }, /* CP core pre-gain control */
+	{ ADV7604_REG(ADV7604_PAGE_CP, 0xc3), 0x39 }, /* CP coast control. Graphics mode */
+	{ ADV7604_REG(ADV7604_PAGE_CP, 0x40), 0x5c }, /* CP core pre-gain control. Graphics mode */
+
+	{ ADV7604_REG_SEQ_TERM, 0 },
+};
+
+static const struct adv7604_reg_seq adv7604_recommended_settings_hdmi[] = {
+	/* set ADI recommended settings for HDMI: */
+	/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 4. */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x0d), 0x84 }, /* HDMI filter optimization */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x3d), 0x10 }, /* DDC bus active pull-up control */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x3e), 0x39 }, /* TMDS PLL optimization */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x4e), 0x3b }, /* TMDS PLL optimization */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x57), 0xb6 }, /* TMDS PLL optimization */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x58), 0x03 }, /* TMDS PLL optimization */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x8d), 0x18 }, /* equaliser */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x8e), 0x34 }, /* equaliser */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x93), 0x8b }, /* equaliser */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x94), 0x2d }, /* equaliser */
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x96), 0x01 }, /* enable automatic EQ changing */
+
+	/* reset ADI recommended settings for digitizer */
+	/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 17. */
+	{ ADV7604_REG(ADV7604_PAGE_AFE, 0x12), 0xfb }, /* ADC noise shaping filter controls */
+	{ ADV7604_REG(ADV7604_PAGE_AFE, 0x0c), 0x0d }, /* CP core gain controls */
+
+	{ ADV7604_REG_SEQ_TERM, 0 },
+};
+
+static const struct adv7604_reg_seq adv7611_recommended_settings_hdmi[] = {
+	{ ADV7604_REG(ADV7604_PAGE_CP, 0x6c), 0x00 },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x6f), 0x0c },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x87), 0x70 },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x57), 0xda },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x58), 0x01 },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x03), 0x98 },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x4c), 0x44 },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x8d), 0x04 },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x8e), 0x1e },
+
+	{ ADV7604_REG_SEQ_TERM, 0 },
+};
+
+static const struct adv7604_chip_info adv7604_chip_info[] = {
+	[ADV7604] = {
+		.type = ADV7604,
+		.has_afe = true,
+		.max_port = ADV7604_INPUT_VGA_COMP,
+		.num_dv_ports = 4,
+		.edid_enable_reg = 0x77,
+		.edid_status_reg = 0x7d,
+		.lcf_reg = 0xb3,
+		.tdms_lock_mask = 0xe0,
+		.cable_det_mask = 0x1e,
+		.fmt_change_digital_mask = 0xc1,
+		.set_termination = adv7604_set_termination,
+		.setup_irqs = adv7604_setup_irqs,
+		.read_hdmi_pixelclock = adv7604_read_hdmi_pixelclock,
+		.read_cable_det = adv7604_read_cable_det,
+		.recommended_settings = {
+		    [0] = adv7604_recommended_settings_afe,
+		    [1] = adv7604_recommended_settings_hdmi,
+		},
+		.num_recommended_settings = {
+		    [0] = ARRAY_SIZE(adv7604_recommended_settings_afe),
+		    [1] = ARRAY_SIZE(adv7604_recommended_settings_hdmi),
+		},
+		.page_mask = BIT(ADV7604_PAGE_IO) | BIT(ADV7604_PAGE_AVLINK) |
+			BIT(ADV7604_PAGE_CEC) | BIT(ADV7604_PAGE_INFOFRAME) |
+			BIT(ADV7604_PAGE_ESDP) | BIT(ADV7604_PAGE_DPP) |
+			BIT(ADV7604_PAGE_AFE) | BIT(ADV7604_PAGE_REP) |
+			BIT(ADV7604_PAGE_EDID) | BIT(ADV7604_PAGE_HDMI) |
+			BIT(ADV7604_PAGE_TEST) | BIT(ADV7604_PAGE_CP) |
+			BIT(ADV7604_PAGE_VDP),
+	},
+	[ADV7611] = {
+		.type = ADV7611,
+		.has_afe = false,
+		.max_port = ADV7604_INPUT_HDMI_PORT_A,
+		.num_dv_ports = 1,
+		.edid_enable_reg = 0x74,
+		.edid_status_reg = 0x76,
+		.lcf_reg = 0xa3,
+		.tdms_lock_mask = 0x43,
+		.cable_det_mask = 0x01,
+		.fmt_change_digital_mask = 0x03,
+		.set_termination = adv7611_set_termination,
+		.setup_irqs = adv7611_setup_irqs,
+		.read_hdmi_pixelclock = adv7611_read_hdmi_pixelclock,
+		.read_cable_det = adv7611_read_cable_det,
+		.recommended_settings = {
+		    [1] = adv7611_recommended_settings_hdmi,
+		},
+		.num_recommended_settings = {
+		    [1] = ARRAY_SIZE(adv7611_recommended_settings_hdmi),
+		},
+		.page_mask = BIT(ADV7604_PAGE_IO) | BIT(ADV7604_PAGE_CEC) |
+			BIT(ADV7604_PAGE_INFOFRAME) | BIT(ADV7604_PAGE_AFE) |
+			BIT(ADV7604_PAGE_REP) |  BIT(ADV7604_PAGE_EDID) |
+			BIT(ADV7604_PAGE_HDMI) | BIT(ADV7604_PAGE_CP),
+	},
+};
+
 static int adv7604_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
@@ -2216,6 +2501,7 @@ static int adv7604_probe(struct i2c_client *client,
 	struct adv7604_platform_data *pdata = client->dev.platform_data;
 	struct v4l2_ctrl_handler *hdl;
 	struct v4l2_subdev *sd;
+	u16 val;
 	int err;
 
 	/* Check if the adapter supports the needed features */
@@ -2230,6 +2516,8 @@ static int adv7604_probe(struct i2c_client *client,
 		return -ENOMEM;
 	}
 
+	state->info = &adv7604_chip_info[id->driver_data];
+
 	/* initialize variables */
 	state->restart_stdi_once = true;
 	state->selected_input = ~0;
@@ -2244,18 +2532,36 @@ static int adv7604_probe(struct i2c_client *client,
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7604_ops);
+	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
+		id->name, i2c_adapter_id(client->adapter),
+		client->addr);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
-	/* i2c access to adv7604? */
-	if (adv_smbus_read_byte_data_check(client, 0xfb, false) != 0x68) {
-		v4l2_info(sd, "not an adv7604 on address 0x%x\n",
-				client->addr << 1);
-		return -ENODEV;
+	/*
+	 * Verify that the chip is present. On ADV7604 the RD_INFO register only
+	 * identifies the revision, while on ADV7611 it identifies the model as
+	 * well. Use the HDMI slave address on ADV7604 and RD_INFO on ADV7611.
+	 */
+	if (state->info->type == ADV7604) {
+		val = adv_smbus_read_byte_data_check(client, 0xfb, false);
+		if (val != 0x68) {
+			v4l2_info(sd, "not an adv7604 on address 0x%x\n",
+					client->addr << 1);
+			return -ENODEV;
+		}
+	} else {
+		val = (adv_smbus_read_byte_data_check(client, 0xea, false) << 8)
+		    | (adv_smbus_read_byte_data_check(client, 0xeb, false) << 0);
+		if (val != 0x2051) {
+			v4l2_info(sd, "not an adv7611 on address 0x%x\n",
+					client->addr << 1);
+			return -ENODEV;
+		}
 	}
 
 	/* control handlers */
 	hdl = &state->hdl;
-	v4l2_ctrl_handler_init(hdl, 9);
+	v4l2_ctrl_handler_init(hdl, adv7604_has_afe(state) ? 9 : 8);
 
 	v4l2_ctrl_new_std(hdl, &adv7604_ctrl_ops,
 			V4L2_CID_BRIGHTNESS, -128, 127, 1, 0);
@@ -2268,15 +2574,17 @@ static int adv7604_probe(struct i2c_client *client,
 
 	/* private controls */
 	state->detect_tx_5v_ctrl = v4l2_ctrl_new_std(hdl, NULL,
-			V4L2_CID_DV_RX_POWER_PRESENT, 0, 0x0f, 0, 0);
+			V4L2_CID_DV_RX_POWER_PRESENT, 0,
+			(1 << state->info->num_dv_ports) - 1, 0, 0);
 	state->rgb_quantization_range_ctrl =
 		v4l2_ctrl_new_std_menu(hdl, &adv7604_ctrl_ops,
 			V4L2_CID_DV_RX_RGB_RANGE, V4L2_DV_RGB_RANGE_FULL,
 			0, V4L2_DV_RGB_RANGE_AUTO);
 
 	/* custom controls */
-	state->analog_sampling_phase_ctrl =
-		v4l2_ctrl_new_custom(hdl, &adv7604_ctrl_analog_sampling_phase, NULL);
+	if (adv7604_has_afe(state))
+		state->analog_sampling_phase_ctrl =
+			v4l2_ctrl_new_custom(hdl, &adv7604_ctrl_analog_sampling_phase, NULL);
 	state->free_run_color_manual_ctrl =
 		v4l2_ctrl_new_custom(hdl, &adv7604_ctrl_free_run_color_manual, NULL);
 	state->free_run_color_ctrl =
@@ -2289,7 +2597,8 @@ static int adv7604_probe(struct i2c_client *client,
 	}
 	state->detect_tx_5v_ctrl->is_private = true;
 	state->rgb_quantization_range_ctrl->is_private = true;
-	state->analog_sampling_phase_ctrl->is_private = true;
+	if (adv7604_has_afe(state))
+		state->analog_sampling_phase_ctrl->is_private = true;
 	state->free_run_color_manual_ctrl->is_private = true;
 	state->free_run_color_ctrl->is_private = true;
 
@@ -2298,27 +2607,34 @@ static int adv7604_probe(struct i2c_client *client,
 		goto err_hdl;
 	}
 
-	state->i2c_avlink = adv7604_dummy_client(sd, pdata->i2c_avlink, 0xf3);
 	state->i2c_cec = adv7604_dummy_client(sd, pdata->i2c_cec, 0xf4);
 	state->i2c_infoframe = adv7604_dummy_client(sd, pdata->i2c_infoframe, 0xf5);
-	state->i2c_esdp = adv7604_dummy_client(sd, pdata->i2c_esdp, 0xf6);
-	state->i2c_dpp = adv7604_dummy_client(sd, pdata->i2c_dpp, 0xf7);
 	state->i2c_afe = adv7604_dummy_client(sd, pdata->i2c_afe, 0xf8);
 	state->i2c_repeater = adv7604_dummy_client(sd, pdata->i2c_repeater, 0xf9);
 	state->i2c_edid = adv7604_dummy_client(sd, pdata->i2c_edid, 0xfa);
 	state->i2c_hdmi = adv7604_dummy_client(sd, pdata->i2c_hdmi, 0xfb);
-	state->i2c_test = adv7604_dummy_client(sd, pdata->i2c_test, 0xfc);
 	state->i2c_cp = adv7604_dummy_client(sd, pdata->i2c_cp, 0xfd);
-	state->i2c_vdp = adv7604_dummy_client(sd, pdata->i2c_vdp, 0xfe);
-	if (!state->i2c_avlink || !state->i2c_cec || !state->i2c_infoframe ||
-	    !state->i2c_esdp || !state->i2c_dpp || !state->i2c_afe ||
+	if (!state->i2c_cec || !state->i2c_infoframe || !state->i2c_afe ||
 	    !state->i2c_repeater || !state->i2c_edid || !state->i2c_hdmi ||
-	    !state->i2c_test || !state->i2c_cp || !state->i2c_vdp) {
+	    !state->i2c_cp) {
 		err = -ENOMEM;
-		v4l2_err(sd, "failed to create all i2c clients\n");
+		v4l2_err(sd, "failed to create digital i2c clients\n");
 		goto err_i2c;
 	}
 
+	if (adv7604_has_afe(state)) {
+		state->i2c_avlink = adv7604_dummy_client(sd, pdata->i2c_avlink, 0xf3);
+		state->i2c_esdp = adv7604_dummy_client(sd, pdata->i2c_esdp, 0xf6);
+		state->i2c_dpp = adv7604_dummy_client(sd, pdata->i2c_dpp, 0xf7);
+		state->i2c_test = adv7604_dummy_client(sd, pdata->i2c_test, 0xfc);
+		state->i2c_vdp = adv7604_dummy_client(sd, pdata->i2c_vdp, 0xfe);
+		if (!state->i2c_avlink || !state->i2c_esdp || !state->i2c_dpp ||
+		    !state->i2c_test || !state->i2c_vdp) {
+			err = -ENOMEM;
+			v4l2_err(sd, "failed to create analog i2c clients\n");
+			goto err_i2c;
+		}
+	}
 	/* work queues */
 	state->work_queues = create_singlethread_workqueue(client->name);
 	if (!state->work_queues) {
@@ -2379,7 +2695,8 @@ static int adv7604_remove(struct i2c_client *client)
 /* ----------------------------------------------------------------------- */
 
 static struct i2c_device_id adv7604_id[] = {
-	{ "adv7604", 0 },
+	{ "adv7604", ADV7604 },
+	{ "adv7611", ADV7611 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, adv7604_id);
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index c6b3937..b2500bae 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -86,6 +86,13 @@ enum adv7604_drive_strength {
 	ADV7604_DR_STR_HIGH = 3,
 };
 
+enum adv7604_int1_config {
+	ADV7604_INT1_CONFIG_OPEN_DRAIN,
+	ADV7604_INT1_CONFIG_ACTIVE_LOW,
+	ADV7604_INT1_CONFIG_ACTIVE_HIGH,
+	ADV7604_INT1_CONFIG_DISABLED,
+};
+
 /* Platform dependent definition */
 struct adv7604_platform_data {
 	/* DIS_PWRDNB: 1 if the PWRDNB pin is unused and unconnected */
@@ -103,6 +110,9 @@ struct adv7604_platform_data {
 	/* Select output format */
 	enum adv7604_op_format_sel op_format_sel;
 
+	/* Configuration of the INT1 pin */
+	enum adv7604_int1_config int1_config;
+
 	/* IO register 0x02 */
 	unsigned alt_gamma:1;
 	unsigned op_656_range:1;
-- 
1.8.3.2

