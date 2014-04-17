Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38906 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbaDQONm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 41/49] adv7604: Replace *_and_or() functions with *_clr_set()
Date: Thu, 17 Apr 2014 16:13:12 +0200
Message-Id: <1397744000-23967-42-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The *_and_or() functions take an 'and' bitmask to be ANDed with the
register value before ORing it with th 'or' bitmask. As the functions
are used to mask and set bits selectively, this requires the caller to
invert the 'and' bitmask and is thus error prone. Replace those
functions with a *_clr_set() variant that takes a mask of bits to be
cleared instead of a mask of bits to be kept.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 86 ++++++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index fc71c17..7a9c17c 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -429,9 +429,9 @@ static inline int io_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return adv_smbus_write_byte_data(state, ADV7604_PAGE_IO, reg, val);
 }
 
-static inline int io_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
+static inline int io_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
 {
-	return io_write(sd, reg, (io_read(sd, reg) & mask) | val);
+	return io_write(sd, reg, (io_read(sd, reg) & ~mask) | val);
 }
 
 static inline int avlink_read(struct v4l2_subdev *sd, u8 reg)
@@ -462,9 +462,9 @@ static inline int cec_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return adv_smbus_write_byte_data(state, ADV7604_PAGE_CEC, reg, val);
 }
 
-static inline int cec_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
+static inline int cec_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
 {
-	return cec_write(sd, reg, (cec_read(sd, reg) & mask) | val);
+	return cec_write(sd, reg, (cec_read(sd, reg) & ~mask) | val);
 }
 
 static inline int infoframe_read(struct v4l2_subdev *sd, u8 reg)
@@ -538,9 +538,9 @@ static inline int rep_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return adv_smbus_write_byte_data(state, ADV7604_PAGE_REP, reg, val);
 }
 
-static inline int rep_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
+static inline int rep_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
 {
-	return rep_write(sd, reg, (rep_read(sd, reg) & mask) | val);
+	return rep_write(sd, reg, (rep_read(sd, reg) & ~mask) | val);
 }
 
 static inline int edid_read(struct v4l2_subdev *sd, u8 reg)
@@ -629,9 +629,9 @@ static inline int hdmi_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return adv_smbus_write_byte_data(state, ADV7604_PAGE_HDMI, reg, val);
 }
 
-static inline int hdmi_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
+static inline int hdmi_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
 {
-	return hdmi_write(sd, reg, (hdmi_read(sd, reg) & mask) | val);
+	return hdmi_write(sd, reg, (hdmi_read(sd, reg) & ~mask) | val);
 }
 
 static inline int test_read(struct v4l2_subdev *sd, u8 reg)
@@ -667,9 +667,9 @@ static inline int cp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return adv_smbus_write_byte_data(state, ADV7604_PAGE_CP, reg, val);
 }
 
-static inline int cp_write_and_or(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
+static inline int cp_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
 {
-	return cp_write(sd, reg, (cp_read(sd, reg) & mask) | val);
+	return cp_write(sd, reg, (cp_read(sd, reg) & ~mask) | val);
 }
 
 static inline int vdp_read(struct v4l2_subdev *sd, u8 reg)
@@ -947,7 +947,7 @@ static int configure_predefined_video_timings(struct v4l2_subdev *sd,
 		io_write(sd, 0x17, 0x5a);
 	}
 	/* disable embedded syncs for auto graphics mode */
-	cp_write_and_or(sd, 0x81, 0xef, 0x00);
+	cp_write_clr_set(sd, 0x81, 0x10, 0x00);
 	cp_write(sd, 0x8f, 0x00);
 	cp_write(sd, 0x90, 0x00);
 	cp_write(sd, 0xa2, 0x00);
@@ -1005,7 +1005,7 @@ static void configure_custom_video_timings(struct v4l2_subdev *sd,
 		io_write(sd, 0x00, 0x07); /* video std */
 		io_write(sd, 0x01, 0x02); /* prim mode */
 		/* enable embedded syncs for auto graphics mode */
-		cp_write_and_or(sd, 0x81, 0xef, 0x10);
+		cp_write_clr_set(sd, 0x81, 0x10, 0x10);
 
 		/* Should only be set in auto-graphics mode [REF_02, p. 91-92] */
 		/* setup PLL_DIV_MAN_EN and PLL_DIV_RATIO */
@@ -1115,21 +1115,21 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 		if (state->selected_input == ADV7604_PAD_VGA_RGB) {
 			/* Receiving analog RGB signal
 			 * Set RGB full range (0-255) */
-			io_write_and_or(sd, 0x02, 0x0f, 0x10);
+			io_write_clr_set(sd, 0x02, 0xf0, 0x10);
 			break;
 		}
 
 		if (state->selected_input == ADV7604_PAD_VGA_COMP) {
 			/* Receiving analog YPbPr signal
 			 * Set automode */
-			io_write_and_or(sd, 0x02, 0x0f, 0xf0);
+			io_write_clr_set(sd, 0x02, 0xf0, 0xf0);
 			break;
 		}
 
 		if (hdmi_signal) {
 			/* Receiving HDMI signal
 			 * Set automode */
-			io_write_and_or(sd, 0x02, 0x0f, 0xf0);
+			io_write_clr_set(sd, 0x02, 0xf0, 0xf0);
 			break;
 		}
 
@@ -1138,10 +1138,10 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 		 * input format (CE/IT) in automatic mode */
 		if (state->timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
 			/* RGB limited range (16-235) */
-			io_write_and_or(sd, 0x02, 0x0f, 0x00);
+			io_write_clr_set(sd, 0x02, 0xf0, 0x00);
 		} else {
 			/* RGB full range (0-255) */
-			io_write_and_or(sd, 0x02, 0x0f, 0x10);
+			io_write_clr_set(sd, 0x02, 0xf0, 0x10);
 
 			if (is_digital_input(sd) && rgb_output) {
 				adv7604_set_offset(sd, false, 0x40, 0x40, 0x40);
@@ -1154,23 +1154,23 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 	case V4L2_DV_RGB_RANGE_LIMITED:
 		if (state->selected_input == ADV7604_PAD_VGA_COMP) {
 			/* YCrCb limited range (16-235) */
-			io_write_and_or(sd, 0x02, 0x0f, 0x20);
+			io_write_clr_set(sd, 0x02, 0xf0, 0x20);
 			break;
 		}
 
 		/* RGB limited range (16-235) */
-		io_write_and_or(sd, 0x02, 0x0f, 0x00);
+		io_write_clr_set(sd, 0x02, 0xf0, 0x00);
 
 		break;
 	case V4L2_DV_RGB_RANGE_FULL:
 		if (state->selected_input == ADV7604_PAD_VGA_COMP) {
 			/* YCrCb full range (0-255) */
-			io_write_and_or(sd, 0x02, 0x0f, 0x60);
+			io_write_clr_set(sd, 0x02, 0xf0, 0x60);
 			break;
 		}
 
 		/* RGB full range (0-255) */
-		io_write_and_or(sd, 0x02, 0x0f, 0x10);
+		io_write_clr_set(sd, 0x02, 0xf0, 0x10);
 
 		if (is_analog_input(sd) || hdmi_signal)
 			break;
@@ -1222,7 +1222,7 @@ static int adv7604_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_ADV_RX_FREE_RUN_COLOR_MANUAL:
 		/* Use the default blue color for free running mode,
 		   or supply your own. */
-		cp_write_and_or(sd, 0xbf, ~0x04, (ctrl->val << 2));
+		cp_write_clr_set(sd, 0xbf, 0x04, ctrl->val << 2);
 		return 0;
 	case V4L2_CID_ADV_RX_FREE_RUN_COLOR:
 		cp_write(sd, 0xc0, (ctrl->val & 0xff0000) >> 16);
@@ -1605,11 +1605,11 @@ static int adv7604_query_dv_timings(struct v4l2_subdev *sd,
 				v4l2_dbg(1, debug, sd, "%s: restart STDI\n", __func__);
 				/* TODO restart STDI for Sync Channel 2 */
 				/* enter one-shot mode */
-				cp_write_and_or(sd, 0x86, 0xf9, 0x00);
+				cp_write_clr_set(sd, 0x86, 0x06, 0x00);
 				/* trigger STDI restart */
-				cp_write_and_or(sd, 0x86, 0xf9, 0x04);
+				cp_write_clr_set(sd, 0x86, 0x06, 0x04);
 				/* reset to continuous mode */
-				cp_write_and_or(sd, 0x86, 0xf9, 0x02);
+				cp_write_clr_set(sd, 0x86, 0x06, 0x02);
 				state->restart_stdi_once = false;
 				return -ENOLINK;
 			}
@@ -1668,7 +1668,7 @@ static int adv7604_s_dv_timings(struct v4l2_subdev *sd,
 
 	state->timings = *timings;
 
-	cp_write_and_or(sd, 0x91, 0xbf, bt->interlaced ? 0x40 : 0x00);
+	cp_write_clr_set(sd, 0x91, 0x40, bt->interlaced ? 0x40 : 0x00);
 
 	/* Use prim_mode and vid_std when available */
 	err = configure_predefined_video_timings(sd, timings);
@@ -1712,10 +1712,10 @@ static void enable_input(struct v4l2_subdev *sd)
 	if (is_analog_input(sd)) {
 		io_write(sd, 0x15, 0xb0);   /* Disable Tristate of Pins (no audio) */
 	} else if (is_digital_input(sd)) {
-		hdmi_write_and_or(sd, 0x00, 0xfc, state->selected_input);
+		hdmi_write_clr_set(sd, 0x00, 0x03, state->selected_input);
 		state->info->set_termination(sd, true);
 		io_write(sd, 0x15, 0xa0);   /* Disable Tristate of Pins */
-		hdmi_write_and_or(sd, 0x1a, 0xef, 0x00); /* Unmute audio */
+		hdmi_write_clr_set(sd, 0x1a, 0x10, 0x00); /* Unmute audio */
 	} else {
 		v4l2_dbg(2, debug, sd, "%s: Unknown port %d selected\n",
 				__func__, state->selected_input);
@@ -1726,7 +1726,7 @@ static void disable_input(struct v4l2_subdev *sd)
 {
 	struct adv7604_state *state = to_state(sd);
 
-	hdmi_write_and_or(sd, 0x1a, 0xef, 0x10); /* Mute audio */
+	hdmi_write_clr_set(sd, 0x1a, 0x10, 0x10); /* Mute audio */
 	msleep(16); /* 512 samples with >= 32 kHz sample rate [REF_03, c. 7.16.10] */
 	io_write(sd, 0x15, 0xbe);   /* Tristate all outputs from video core */
 	state->info->set_termination(sd, false);
@@ -1857,12 +1857,12 @@ static void adv7604_setup_format(struct adv7604_state *state)
 {
 	struct v4l2_subdev *sd = &state->sd;
 
-	io_write_and_or(sd, 0x02, 0xfd,
+	io_write_clr_set(sd, 0x02, 0x02,
 			state->format->rgb_out ? ADV7604_RGB_OUT : 0);
 	io_write(sd, 0x03, state->format->op_format_sel |
 		 state->pdata.op_format_mode_sel);
-	io_write_and_or(sd, 0x04, 0x1f, adv7604_op_ch_sel(state));
-	io_write_and_or(sd, 0x05, 0xfe,
+	io_write_clr_set(sd, 0x04, 0xe0, adv7604_op_ch_sel(state));
+	io_write_clr_set(sd, 0x05, 0x01,
 			state->format->swap_cb_cr ? ADV7604_OP_SWAP_CB_CR : 0);
 }
 
@@ -2059,7 +2059,7 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		/* Disable hotplug and I2C access to EDID RAM from DDC port */
 		state->edid.present &= ~(1 << edid->pad);
 		v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&state->edid.present);
-		rep_write_and_or(sd, info->edid_enable_reg, 0xf0, state->edid.present);
+		rep_write_clr_set(sd, info->edid_enable_reg, 0x0f, state->edid.present);
 
 		/* Fall back to a 16:9 aspect ratio */
 		state->aspect_ratio.numerator = 16;
@@ -2083,7 +2083,7 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 	/* Disable hotplug and I2C access to EDID RAM from DDC port */
 	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
 	v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&tmp);
-	rep_write_and_or(sd, info->edid_enable_reg, 0xf0, 0x00);
+	rep_write_clr_set(sd, info->edid_enable_reg, 0x0f, 0x00);
 
 	spa_loc = get_edid_spa_location(edid->edid);
 	if (spa_loc < 0)
@@ -2112,10 +2112,10 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 
 	if (info->type == ADV7604) {
 		rep_write(sd, 0x76, spa_loc & 0xff);
-		rep_write_and_or(sd, 0x77, 0xbf, (spa_loc & 0x100) >> 2);
+		rep_write_clr_set(sd, 0x77, 0x40, (spa_loc & 0x100) >> 2);
 	} else {
 		/* FIXME: Where is the SPA location LSB register ? */
-		rep_write_and_or(sd, 0x71, 0xfe, (spa_loc & 0x100) >> 8);
+		rep_write_clr_set(sd, 0x71, 0x01, (spa_loc & 0x100) >> 8);
 	}
 
 	edid->edid[spa_loc] = state->spa_port_a[0];
@@ -2135,7 +2135,7 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 
 	/* adv7604 calculates the checksums and enables I2C access to internal
 	   EDID RAM from DDC port. */
-	rep_write_and_or(sd, info->edid_enable_reg, 0xf0, state->edid.present);
+	rep_write_clr_set(sd, info->edid_enable_reg, 0x0f, state->edid.present);
 
 	for (i = 0; i < 1000; i++) {
 		if (rep_read(sd, info->edid_status_reg) & state->edid.present)
@@ -2431,11 +2431,11 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 	cp_write(sd, 0xcf, 0x01);   /* Power down macrovision */
 
 	/* video format */
-	io_write_and_or(sd, 0x02, 0xf0,
+	io_write_clr_set(sd, 0x02, 0x0f,
 			pdata->alt_gamma << 3 |
 			pdata->op_656_range << 2 |
 			pdata->alt_data_sat << 0);
-	io_write_and_or(sd, 0x05, 0xf1, pdata->blank_data << 3 |
+	io_write_clr_set(sd, 0x05, 0x0e, pdata->blank_data << 3 |
 			pdata->insert_av_codes << 2 |
 			pdata->replicate_av_codes << 1);
 	adv7604_setup_format(state);
@@ -2460,16 +2460,16 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 				     for digital formats */
 
 	/* HDMI audio */
-	hdmi_write_and_or(sd, 0x15, 0xfc, 0x03); /* Mute on FIFO over-/underflow [REF_01, c. 1.2.18] */
-	hdmi_write_and_or(sd, 0x1a, 0xf1, 0x08); /* Wait 1 s before unmute */
-	hdmi_write_and_or(sd, 0x68, 0xf9, 0x06); /* FIFO reset on over-/underflow [REF_01, c. 1.2.19] */
+	hdmi_write_clr_set(sd, 0x15, 0x03, 0x03); /* Mute on FIFO over-/underflow [REF_01, c. 1.2.18] */
+	hdmi_write_clr_set(sd, 0x1a, 0x0e, 0x08); /* Wait 1 s before unmute */
+	hdmi_write_clr_set(sd, 0x68, 0x06, 0x06); /* FIFO reset on over-/underflow [REF_01, c. 1.2.19] */
 
 	/* TODO from platform data */
 	afe_write(sd, 0xb5, 0x01);  /* Setting MCLK to 256Fs */
 
 	if (adv7604_has_afe(state)) {
 		afe_write(sd, 0x02, pdata->ain_sel); /* Select analog input muxing mode */
-		io_write_and_or(sd, 0x30, ~(1 << 4), pdata->output_bus_lsb_to_msb << 4);
+		io_write_clr_set(sd, 0x30, 1 << 4, pdata->output_bus_lsb_to_msb << 4);
 	}
 
 	/* interrupts */
-- 
1.8.3.2

