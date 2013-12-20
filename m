Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1975 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab3LTJb7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:31:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 08/50] adv7604: add support for all the digital input ports
Date: Fri, 20 Dec 2013 10:31:01 +0100
Message-Id: <1387531903-20496-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

The adv7604 supports four digital input ports. This patch adds support
for all of them, instead of just port A.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 266 ++++++++++++++++++++++++++------------------
 include/media/adv7604.h     |  20 ++--
 2 files changed, 168 insertions(+), 118 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index a324106b..6372d31 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -53,8 +53,6 @@ MODULE_LICENSE("GPL");
 /* ADV7604 system clock frequency */
 #define ADV7604_fsc (28636360)
 
-#define DIGITAL_INPUT (state->mode == ADV7604_MODE_HDMI)
-
 /*
  **********************************************************************
  *
@@ -67,10 +65,13 @@ struct adv7604_state {
 	struct v4l2_subdev sd;
 	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
-	enum adv7604_mode mode;
+	enum adv7604_input_port selected_input;
 	struct v4l2_dv_timings timings;
-	u8 edid[256];
-	unsigned edid_blocks;
+	struct {
+		u8 edid[256];
+		u32 present;
+		unsigned blocks;
+	} edid;
 	struct v4l2_fract aspect_ratio;
 	u32 rgb_quantization_range;
 	struct workqueue_struct *work_queues;
@@ -516,7 +517,7 @@ static void adv7604_delayed_work_enable_hotplug(struct work_struct *work)
 
 	v4l2_dbg(2, debug, sd, "%s: enable hotplug\n", __func__);
 
-	v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)1);
+	v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&state->edid.present);
 }
 
 static inline int edid_write_block(struct v4l2_subdev *sd,
@@ -529,8 +530,6 @@ static inline int edid_write_block(struct v4l2_subdev *sd,
 
 	v4l2_dbg(2, debug, sd, "%s: write EDID block (%d byte)\n", __func__, len);
 
-	v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)0);
-
 	/* Disables I2C access to internal EDID ram from DDC port */
 	rep_write_and_or(sd, 0x77, 0xf0, 0x0);
 
@@ -541,22 +540,19 @@ static inline int edid_write_block(struct v4l2_subdev *sd,
 		return err;
 
 	/* adv7604 calculates the checksums and enables I2C access to internal
-	   EDID ram from DDC port. */
-	rep_write_and_or(sd, 0x77, 0xf0, 0x1);
+	   EDID RAM from DDC port. */
+	rep_write_and_or(sd, 0x77, 0xf0, state->edid.present);
 
 	for (i = 0; i < 1000; i++) {
-		if (rep_read(sd, 0x7d) & 1)
+		if (rep_read(sd, 0x7d) & state->edid.present)
 			break;
 		mdelay(1);
 	}
 	if (i == 1000) {
-		v4l_err(client, "error enabling edid\n");
+		v4l_err(client, "error enabling edid (0x%x)\n", state->edid.present);
 		return -EIO;
 	}
 
-	/* enable hotplug after 100 ms */
-	queue_delayed_work(state->work_queues,
-			&state->delayed_work_enable_hotplug, HZ / 10);
 	return 0;
 }
 
@@ -574,6 +570,11 @@ static inline int hdmi_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return adv_smbus_write_byte_data(state->i2c_hdmi, reg, val);
 }
 
+static inline int hdmi_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
+{
+	return hdmi_write(sd, reg, (hdmi_read(sd, reg) & mask) | val);
+}
+
 static inline int test_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
@@ -623,6 +624,26 @@ static inline int vdp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 
 /* ----------------------------------------------------------------------- */
 
+static inline bool is_analog_input(struct v4l2_subdev *sd)
+{
+	struct adv7604_state *state = to_state(sd);
+
+	return state->selected_input == ADV7604_INPUT_VGA_RGB ||
+	       state->selected_input == ADV7604_INPUT_VGA_COMP;
+}
+
+static inline bool is_digital_input(struct v4l2_subdev *sd)
+{
+	struct adv7604_state *state = to_state(sd);
+
+	return state->selected_input == ADV7604_INPUT_HDMI_PORT_A ||
+	       state->selected_input == ADV7604_INPUT_HDMI_PORT_B ||
+	       state->selected_input == ADV7604_INPUT_HDMI_PORT_C ||
+	       state->selected_input == ADV7604_INPUT_HDMI_PORT_D;
+}
+
+/* ----------------------------------------------------------------------- */
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static void adv7604_inv_register(struct v4l2_subdev *sd)
 {
@@ -748,10 +769,13 @@ static int adv7604_s_register(struct v4l2_subdev *sd,
 static int adv7604_s_detect_tx_5v_ctrl(struct v4l2_subdev *sd)
 {
 	struct adv7604_state *state = to_state(sd);
+	u8 reg_io_6f = io_read(sd, 0x6f);
 
-	/* port A only */
 	return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl,
-				((io_read(sd, 0x6f) & 0x10) >> 4));
+			((reg_io_6f & 0x10) >> 4) |
+			((reg_io_6f & 0x08) >> 2) |
+			(reg_io_6f & 0x04) |
+			((reg_io_6f & 0x02) << 2));
 }
 
 static int find_and_set_predefined_video_timings(struct v4l2_subdev *sd,
@@ -759,12 +783,11 @@ static int find_and_set_predefined_video_timings(struct v4l2_subdev *sd,
 		const struct adv7604_video_standards *predef_vid_timings,
 		const struct v4l2_dv_timings *timings)
 {
-	struct adv7604_state *state = to_state(sd);
 	int i;
 
 	for (i = 0; predef_vid_timings[i].timings.bt.width; i++) {
 		if (!v4l2_match_dv_timings(timings, &predef_vid_timings[i].timings,
-					DIGITAL_INPUT ? 250000 : 1000000))
+					is_digital_input(sd) ? 250000 : 1000000))
 			continue;
 		io_write(sd, 0x00, predef_vid_timings[i].vid_std); /* video std */
 		io_write(sd, 0x01, (predef_vid_timings[i].v_freq << 4) +
@@ -799,27 +822,22 @@ static int configure_predefined_video_timings(struct v4l2_subdev *sd,
 	cp_write(sd, 0xab, 0x00);
 	cp_write(sd, 0xac, 0x00);
 
-	switch (state->mode) {
-	case ADV7604_MODE_COMP:
-	case ADV7604_MODE_GR:
+	if (is_analog_input(sd)) {
 		err = find_and_set_predefined_video_timings(sd,
 				0x01, adv7604_prim_mode_comp, timings);
 		if (err)
 			err = find_and_set_predefined_video_timings(sd,
 					0x02, adv7604_prim_mode_gr, timings);
-		break;
-	case ADV7604_MODE_HDMI:
+	} else if (is_digital_input(sd)) {
 		err = find_and_set_predefined_video_timings(sd,
 				0x05, adv7604_prim_mode_hdmi_comp, timings);
 		if (err)
 			err = find_and_set_predefined_video_timings(sd,
 					0x06, adv7604_prim_mode_hdmi_gr, timings);
-		break;
-	default:
-		v4l2_dbg(2, debug, sd, "%s: Unknown mode %d\n",
-				__func__, state->mode);
+	} else {
+		v4l2_dbg(2, debug, sd, "%s: Unknown port %d selected\n",
+				__func__, state->selected_input);
 		err = -1;
-		break;
 	}
 
 
@@ -846,9 +864,7 @@ static void configure_custom_video_timings(struct v4l2_subdev *sd,
 
 	v4l2_dbg(2, debug, sd, "%s\n", __func__);
 
-	switch (state->mode) {
-	case ADV7604_MODE_COMP:
-	case ADV7604_MODE_GR:
+	if (is_analog_input(sd)) {
 		/* auto graphics */
 		io_write(sd, 0x00, 0x07); /* video std */
 		io_write(sd, 0x01, 0x02); /* prim mode */
@@ -858,33 +874,28 @@ static void configure_custom_video_timings(struct v4l2_subdev *sd,
 		/* Should only be set in auto-graphics mode [REF_02, p. 91-92] */
 		/* setup PLL_DIV_MAN_EN and PLL_DIV_RATIO */
 		/* IO-map reg. 0x16 and 0x17 should be written in sequence */
-		if (adv_smbus_write_i2c_block_data(client, 0x16, 2, pll)) {
+		if (adv_smbus_write_i2c_block_data(client, 0x16, 2, pll))
 			v4l2_err(sd, "writing to reg 0x16 and 0x17 failed\n");
-			break;
-		}
 
 		/* active video - horizontal timing */
 		cp_write(sd, 0xa2, (cp_start_sav >> 4) & 0xff);
 		cp_write(sd, 0xa3, ((cp_start_sav & 0x0f) << 4) |
-					((cp_start_eav >> 8) & 0x0f));
+				   ((cp_start_eav >> 8) & 0x0f));
 		cp_write(sd, 0xa4, cp_start_eav & 0xff);
 
 		/* active video - vertical timing */
 		cp_write(sd, 0xa5, (cp_start_vbi >> 4) & 0xff);
 		cp_write(sd, 0xa6, ((cp_start_vbi & 0xf) << 4) |
-					((cp_end_vbi >> 8) & 0xf));
+				   ((cp_end_vbi >> 8) & 0xf));
 		cp_write(sd, 0xa7, cp_end_vbi & 0xff);
-		break;
-	case ADV7604_MODE_HDMI:
+	} else if (is_digital_input(sd)) {
 		/* set default prim_mode/vid_std for HDMI
 		   according to [REF_03, c. 4.2] */
 		io_write(sd, 0x00, 0x02); /* video std */
 		io_write(sd, 0x01, 0x06); /* prim mode */
-		break;
-	default:
-		v4l2_dbg(2, debug, sd, "%s: Unknown mode %d\n",
-				__func__, state->mode);
-		break;
+	} else {
+		v4l2_dbg(2, debug, sd, "%s: Unknown port %d selected\n",
+				__func__, state->selected_input);
 	}
 
 	cp_write(sd, 0x8f, (ch1_fr_ll >> 8) & 0x7);
@@ -900,7 +911,7 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 	switch (state->rgb_quantization_range) {
 	case V4L2_DV_RGB_RANGE_AUTO:
 		/* automatic */
-		if (DIGITAL_INPUT && !(hdmi_read(sd, 0x05) & 0x80)) {
+		if (is_digital_input(sd) && !(hdmi_read(sd, 0x05) & 0x80)) {
 			/* receiving DVI-D signal */
 
 			/* ADV7604 selects RGB limited range regardless of
@@ -983,8 +994,9 @@ static inline bool no_power(struct v4l2_subdev *sd)
 
 static inline bool no_signal_tmds(struct v4l2_subdev *sd)
 {
-	/* TODO port B, C and D */
-	return !(io_read(sd, 0x6a) & 0x10);
+	struct adv7604_state *state = to_state(sd);
+
+	return !(io_read(sd, 0x6a) & (0x10 >> state->selected_input));
 }
 
 static inline bool no_lock_tmds(struct v4l2_subdev *sd)
@@ -1011,7 +1023,6 @@ static inline bool no_lock_stdi(struct v4l2_subdev *sd)
 
 static inline bool no_signal(struct v4l2_subdev *sd)
 {
-	struct adv7604_state *state = to_state(sd);
 	bool ret;
 
 	ret = no_power(sd);
@@ -1019,7 +1030,7 @@ static inline bool no_signal(struct v4l2_subdev *sd)
 	ret |= no_lock_stdi(sd);
 	ret |= no_lock_sspd(sd);
 
-	if (DIGITAL_INPUT) {
+	if (is_digital_input(sd)) {
 		ret |= no_lock_tmds(sd);
 		ret |= no_signal_tmds(sd);
 	}
@@ -1036,13 +1047,11 @@ static inline bool no_lock_cp(struct v4l2_subdev *sd)
 
 static int adv7604_g_input_status(struct v4l2_subdev *sd, u32 *status)
 {
-	struct adv7604_state *state = to_state(sd);
-
 	*status = 0;
 	*status |= no_power(sd) ? V4L2_IN_ST_NO_POWER : 0;
 	*status |= no_signal(sd) ? V4L2_IN_ST_NO_SIGNAL : 0;
 	if (no_lock_cp(sd))
-		*status |= DIGITAL_INPUT ? V4L2_IN_ST_NO_SYNC : V4L2_IN_ST_NO_H_LOCK;
+		*status |= is_digital_input(sd) ? V4L2_IN_ST_NO_SYNC : V4L2_IN_ST_NO_H_LOCK;
 
 	v4l2_dbg(1, debug, sd, "%s: status = 0x%x\n", __func__, *status);
 
@@ -1157,13 +1166,11 @@ static int adv7604_enum_dv_timings(struct v4l2_subdev *sd,
 static int adv7604_dv_timings_cap(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings_cap *cap)
 {
-	struct adv7604_state *state = to_state(sd);
-
 	cap->type = V4L2_DV_BT_656_1120;
 	cap->bt.max_width = 1920;
 	cap->bt.max_height = 1200;
 	cap->bt.min_pixelclock = 25000000;
-	if (DIGITAL_INPUT)
+	if (is_digital_input(sd))
 		cap->bt.max_pixelclock = 225000000;
 	else
 		cap->bt.max_pixelclock = 170000000;
@@ -1179,12 +1186,11 @@ static int adv7604_dv_timings_cap(struct v4l2_subdev *sd,
 static void adv7604_fill_optional_dv_timings_fields(struct v4l2_subdev *sd,
 		struct v4l2_dv_timings *timings)
 {
-	struct adv7604_state *state = to_state(sd);
 	int i;
 
 	for (i = 0; adv7604_timings[i].bt.width; i++) {
 		if (v4l2_match_dv_timings(timings, &adv7604_timings[i],
-					DIGITAL_INPUT ? 250000 : 1000000)) {
+					is_digital_input(sd) ? 250000 : 1000000)) {
 			*timings = adv7604_timings[i];
 			break;
 		}
@@ -1216,7 +1222,7 @@ static int adv7604_query_dv_timings(struct v4l2_subdev *sd,
 	bt->interlaced = stdi.interlaced ?
 		V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
 
-	if (DIGITAL_INPUT) {
+	if (is_digital_input(sd)) {
 		uint32_t freq;
 
 		timings->type = V4L2_DV_BT_656_1120;
@@ -1305,8 +1311,8 @@ found:
 		return -ENOLINK;
 	}
 
-	if ((!DIGITAL_INPUT && bt->pixelclock > 170000000) ||
-			(DIGITAL_INPUT && bt->pixelclock > 225000000)) {
+	if ((is_analog_input(sd) && bt->pixelclock > 170000000) ||
+			(is_digital_input(sd) && bt->pixelclock > 225000000)) {
 		v4l2_dbg(1, debug, sd, "%s: pixelclock out of range %d\n",
 				__func__, (u32)bt->pixelclock);
 		return -ERANGE;
@@ -1331,8 +1337,8 @@ static int adv7604_s_dv_timings(struct v4l2_subdev *sd,
 
 	bt = &timings->bt;
 
-	if ((!DIGITAL_INPUT && bt->pixelclock > 170000000) ||
-			(DIGITAL_INPUT && bt->pixelclock > 225000000)) {
+	if ((is_analog_input(sd) && bt->pixelclock > 170000000) ||
+			(is_digital_input(sd) && bt->pixelclock > 225000000)) {
 		v4l2_dbg(1, debug, sd, "%s: pixelclock out of range %d\n",
 				__func__, (u32)bt->pixelclock);
 		return -ERANGE;
@@ -1374,22 +1380,18 @@ static void enable_input(struct v4l2_subdev *sd)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	switch (state->mode) {
-	case ADV7604_MODE_COMP:
-	case ADV7604_MODE_GR:
+	if (is_analog_input(sd)) {
 		/* enable */
 		io_write(sd, 0x15, 0xb0);   /* Disable Tristate of Pins (no audio) */
-		break;
-	case ADV7604_MODE_HDMI:
+	} else if (is_digital_input(sd)) {
 		/* enable */
+		hdmi_write_and_or(sd, 0x00, 0xfc, state->selected_input);
 		hdmi_write(sd, 0x1a, 0x0a); /* Unmute audio */
 		hdmi_write(sd, 0x01, 0x00); /* Enable HDMI clock terminators */
 		io_write(sd, 0x15, 0xa0);   /* Disable Tristate of Pins */
-		break;
-	default:
-		v4l2_dbg(2, debug, sd, "%s: Unknown mode %d\n",
-				__func__, state->mode);
-		break;
+	} else {
+		v4l2_dbg(2, debug, sd, "%s: Unknown port %d selected\n",
+				__func__, state->selected_input);
 	}
 }
 
@@ -1405,9 +1407,7 @@ static void select_input(struct v4l2_subdev *sd)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	switch (state->mode) {
-	case ADV7604_MODE_COMP:
-	case ADV7604_MODE_GR:
+	if (is_analog_input(sd)) {
 		/* reset ADI recommended settings for HDMI: */
 		/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 4. */
 		hdmi_write(sd, 0x0d, 0x04); /* HDMI filter optimization */
@@ -1433,9 +1433,9 @@ static void select_input(struct v4l2_subdev *sd)
 		cp_write(sd, 0x3e, 0x04); /* CP core pre-gain control */
 		cp_write(sd, 0xc3, 0x39); /* CP coast control. Graphics mode */
 		cp_write(sd, 0x40, 0x5c); /* CP core pre-gain control. Graphics mode */
-		break;
+	} else if (is_digital_input(sd)) {
+		hdmi_write(sd, 0x00, state->selected_input & 0x03);
 
-	case ADV7604_MODE_HDMI:
 		/* set ADI recommended settings for HDMI: */
 		/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 4. */
 		hdmi_write(sd, 0x0d, 0x84); /* HDMI filter optimization */
@@ -1461,12 +1461,9 @@ static void select_input(struct v4l2_subdev *sd)
 		cp_write(sd, 0x3e, 0x00); /* CP core pre-gain control */
 		cp_write(sd, 0xc3, 0x39); /* CP coast control. Graphics mode */
 		cp_write(sd, 0x40, 0x80); /* CP core pre-gain control. Graphics mode */
-
-		break;
-	default:
-		v4l2_dbg(2, debug, sd, "%s: Unknown mode %d\n",
-				__func__, state->mode);
-		break;
+	} else {
+		v4l2_dbg(2, debug, sd, "%s: Unknown port %d selected\n",
+				__func__, state->selected_input);
 	}
 }
 
@@ -1477,7 +1474,7 @@ static int adv7604_s_routing(struct v4l2_subdev *sd,
 
 	v4l2_dbg(2, debug, sd, "%s: input %d", __func__, input);
 
-	state->mode = input;
+	state->selected_input = input;
 
 	disable_input(sd);
 
@@ -1524,7 +1521,7 @@ static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	fmt_change = io_read(sd, 0x43) & 0x98;
 	if (fmt_change)
 		io_write(sd, 0x44, fmt_change);
-	fmt_change_digital = DIGITAL_INPUT ? (io_read(sd, 0x6b) & 0xc0) : 0;
+	fmt_change_digital = is_digital_input(sd) ? (io_read(sd, 0x6b) & 0xc0) : 0;
 	if (fmt_change_digital)
 		io_write(sd, 0x6c, fmt_change_digital);
 	if (fmt_change || fmt_change_digital) {
@@ -1545,7 +1542,7 @@ static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 			*handled = true;
 	}
 	/* tx 5v detect */
-	tx_5v = io_read(sd, 0x70) & 0x10;
+	tx_5v = io_read(sd, 0x70) & 0x1e;
 	if (tx_5v) {
 		v4l2_dbg(1, debug, sd, "%s: tx_5v: 0x%x\n", __func__, tx_5v);
 		io_write(sd, 0x71, tx_5v);
@@ -1559,19 +1556,41 @@ static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 static int adv7604_get_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid)
 {
 	struct adv7604_state *state = to_state(sd);
+	u8 *data = NULL;
 
-	if (edid->pad != 0)
+	if (edid->pad > ADV7604_EDID_PORT_D)
 		return -EINVAL;
 	if (edid->blocks == 0)
 		return -EINVAL;
-	if (edid->start_block >= state->edid_blocks)
+	if (edid->blocks > 2)
 		return -EINVAL;
-	if (edid->start_block + edid->blocks > state->edid_blocks)
-		edid->blocks = state->edid_blocks - edid->start_block;
+	if (edid->start_block > 1)
+		return -EINVAL;
+	if (edid->start_block == 1)
+		edid->blocks = 1;
 	if (!edid->edid)
 		return -EINVAL;
-	memcpy(edid->edid + edid->start_block * 128,
-	       state->edid + edid->start_block * 128,
+
+	if (edid->blocks > state->edid.blocks)
+		edid->blocks = state->edid.blocks;
+
+	switch (edid->pad) {
+	case ADV7604_EDID_PORT_A:
+	case ADV7604_EDID_PORT_B:
+	case ADV7604_EDID_PORT_C:
+	case ADV7604_EDID_PORT_D:
+		if (state->edid.present & (1 << edid->pad))
+			data = state->edid.edid;
+		break;
+	default:
+		return -EINVAL;
+		break;
+	}
+	if (!data)
+		return -ENODATA;
+
+	memcpy(edid->edid,
+	       data + edid->start_block * 128,
 	       edid->blocks * 128);
 	return 0;
 }
@@ -1581,33 +1600,50 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
 	struct adv7604_state *state = to_state(sd);
 	int err;
 
-	if (edid->pad != 0)
+	if (edid->pad > ADV7604_EDID_PORT_D)
 		return -EINVAL;
 	if (edid->start_block != 0)
 		return -EINVAL;
 	if (edid->blocks == 0) {
 		/* Pull down the hotplug pin */
-		v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)0);
+		state->edid.present &= ~(1 << edid->pad);
+		v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&state->edid.present);
 		/* Disables I2C access to internal EDID ram from DDC port */
 		rep_write_and_or(sd, 0x77, 0xf0, 0x0);
-		state->edid_blocks = 0;
+		state->edid.blocks = 0;
 		/* Fall back to a 16:9 aspect ratio */
 		state->aspect_ratio.numerator = 16;
 		state->aspect_ratio.denominator = 9;
+		v4l2_dbg(2, debug, sd, "%s: clear edid\n", __func__);
 		return 0;
 	}
-	if (edid->blocks > 2)
+	if (edid->blocks > 2) {
+		edid->blocks = 2;
 		return -E2BIG;
+	}
 	if (!edid->edid)
 		return -EINVAL;
-	memcpy(state->edid, edid->edid, 128 * edid->blocks);
-	state->edid_blocks = edid->blocks;
+
+	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
+	state->edid.present &= ~(1 << edid->pad);
+	v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&state->edid.present);
+
+	memcpy(state->edid.edid, edid->edid, 128 * edid->blocks);
+	state->edid.blocks = edid->blocks;
 	state->aspect_ratio = v4l2_calc_aspect_ratio(edid->edid[0x15],
 			edid->edid[0x16]);
-	err = edid_write_block(sd, 128 * edid->blocks, state->edid);
-	if (err < 0)
+	state->edid.present |= edid->pad;
+
+	err = edid_write_block(sd, 128 * edid->blocks, state->edid.edid);
+	if (err < 0) {
 		v4l2_err(sd, "error %d writing edid\n", err);
-	return err;
+		return err;
+	}
+
+	/* enable hotplug after 100 ms */
+	queue_delayed_work(state->work_queues,
+			&state->delayed_work_enable_hotplug, HZ / 10);
+	return 0;
 }
 
 /*********** avi info frame CEA-861-E **************/
@@ -1690,15 +1726,21 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "-----Chip status-----\n");
 	v4l2_info(sd, "Chip power: %s\n", no_power(sd) ? "off" : "on");
 	v4l2_info(sd, "Connector type: %s\n", state->connector_hdmi ?
-			"HDMI" : (DIGITAL_INPUT ? "DVI-D" : "DVI-A"));
-	v4l2_info(sd, "EDID: %s\n", ((rep_read(sd, 0x7d) & 0x01) &&
-			(rep_read(sd, 0x77) & 0x01)) ? "enabled" : "disabled ");
+			"HDMI" : (is_digital_input(sd) ? "DVI-D" : "DVI-A"));
+	v4l2_info(sd, "EDID enabled port A: %s, B: %s, C: %s, D: %s\n",
+			((rep_read(sd, 0x7d) & 0x01) ? "Yes" : "No"),
+			((rep_read(sd, 0x7d) & 0x02) ? "Yes" : "No"),
+			((rep_read(sd, 0x7d) & 0x04) ? "Yes" : "No"),
+			((rep_read(sd, 0x7d) & 0x08) ? "Yes" : "No"));
 	v4l2_info(sd, "CEC: %s\n", !!(cec_read(sd, 0x2a) & 0x01) ?
 			"enabled" : "disabled");
 
 	v4l2_info(sd, "-----Signal status-----\n");
-	v4l2_info(sd, "Cable detected (+5V power): %s\n",
-			(io_read(sd, 0x6f) & 0x10) ? "true" : "false");
+	v4l2_info(sd, "Cable detected (+5V power) port A: %s, B: %s, C: %s, D: %s\n",
+			((io_read(sd, 0x6f) & 0x10) ? "Yes" : "No"),
+			((io_read(sd, 0x6f) & 0x08) ? "Yes" : "No"),
+			((io_read(sd, 0x6f) & 0x04) ? "Yes" : "No"),
+			((io_read(sd, 0x6f) & 0x02) ? "Yes" : "No"));
 	v4l2_info(sd, "TMDS signal detected: %s\n",
 			no_signal_tmds(sd) ? "false" : "true");
 	v4l2_info(sd, "TMDS signal locked: %s\n",
@@ -1744,11 +1786,14 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "Color space conversion: %s\n",
 			csc_coeff_sel_rb[cp_read(sd, 0xfc) >> 4]);
 
-	if (!DIGITAL_INPUT)
+	if (!is_digital_input(sd))
 		return 0;
 
 	v4l2_info(sd, "-----%s status-----\n", is_hdmi(sd) ? "HDMI" : "DVI-D");
-	v4l2_info(sd, "HDCP encrypted content: %s\n", (hdmi_read(sd, 0x05) & 0x40) ? "true" : "false");
+	v4l2_info(sd, "Digital video port selected: %c\n",
+			(hdmi_read(sd, 0x00) & 0x03) + 'A');
+	v4l2_info(sd, "HDCP encrypted content: %s\n",
+			(hdmi_read(sd, 0x05) & 0x40) ? "true" : "false");
 	v4l2_info(sd, "HDCP keys read: %s%s\n",
 			(hdmi_read(sd, 0x04) & 0x20) ? "yes" : "no",
 			(hdmi_read(sd, 0x04) & 0x10) ? "ERROR" : "");
@@ -1906,6 +1951,7 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 				      ADI recommended setting [REF_01, c. 2.3.3] */
 	cp_write(sd, 0xc9, 0x2d); /* use prim_mode and vid_std as free run resolution
 				     for digital formats */
+	rep_write(sd, 0x76, 0xc0); /* SPA location for port B, C and D */
 
 	/* TODO from platform data */
 	afe_write(sd, 0xb5, 0x01);  /* Setting MCLK to 256Fs */
@@ -1918,7 +1964,7 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 	io_write(sd, 0x41, 0xd7); /* STDI irq for any change, disable INT2 */
 	io_write(sd, 0x46, 0x98); /* Enable SSPD, STDI and CP unlocked interrupts */
 	io_write(sd, 0x6e, 0xc0); /* Enable V_LOCKED and DE_REGEN_LCK interrupts */
-	io_write(sd, 0x73, 0x10); /* Enable CABLE_DET_A_ST (+5v) interrupt */
+	io_write(sd, 0x73, 0x1e); /* Enable CABLE_DET_A_ST (+5v) interrupts */
 
 	return v4l2_ctrl_handler_setup(sd->ctrl_handler);
 }
@@ -2020,7 +2066,7 @@ static int adv7604_probe(struct i2c_client *client,
 
 	/* private controls */
 	state->detect_tx_5v_ctrl = v4l2_ctrl_new_std(hdl, NULL,
-			V4L2_CID_DV_RX_POWER_PRESENT, 0, 1, 0, 0);
+			V4L2_CID_DV_RX_POWER_PRESENT, 0, 0x0f, 0, 0);
 	state->rgb_quantization_range_ctrl =
 		v4l2_ctrl_new_std_menu(hdl, &adv7604_ctrl_ops,
 			V4L2_CID_DV_RX_RGB_RANGE, V4L2_DV_RGB_RANGE_FULL,
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index dc004bc..0c96e16 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -131,16 +131,20 @@ struct adv7604_platform_data {
 	u8 i2c_vdp;
 };
 
-/*
- * Mode of operation.
- * This is used as the input argument of the s_routing video op.
- */
-enum adv7604_mode {
-	ADV7604_MODE_COMP,
-	ADV7604_MODE_GR,
-	ADV7604_MODE_HDMI,
+enum adv7604_input_port {
+	ADV7604_INPUT_HDMI_PORT_A,
+	ADV7604_INPUT_HDMI_PORT_B,
+	ADV7604_INPUT_HDMI_PORT_C,
+	ADV7604_INPUT_HDMI_PORT_D,
+	ADV7604_INPUT_VGA_RGB,
+	ADV7604_INPUT_VGA_COMP,
 };
 
+#define ADV7604_EDID_PORT_A 0
+#define ADV7604_EDID_PORT_B 1
+#define ADV7604_EDID_PORT_C 2
+#define ADV7604_EDID_PORT_D 3
+
 #define V4L2_CID_ADV_RX_ANALOG_SAMPLING_PHASE	(V4L2_CID_DV_CLASS_BASE + 0x1000)
 #define V4L2_CID_ADV_RX_FREE_RUN_COLOR_MANUAL	(V4L2_CID_DV_CLASS_BASE + 0x1001)
 #define V4L2_CID_ADV_RX_FREE_RUN_COLOR		(V4L2_CID_DV_CLASS_BASE + 0x1002)
-- 
1.8.4.4

