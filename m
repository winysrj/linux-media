Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3654 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab3LTJb7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:31:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 02/50] ad9389b: whitespace changes to improve readability
Date: Fri, 20 Dec 2013 10:30:55 +0100
Message-Id: <1387531903-20496-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 116 ++++++++++++++++++++++----------------------
 1 file changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index e7f7171..fa95203 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -150,7 +150,7 @@ static int ad9389b_wr(struct v4l2_subdev *sd, u8 reg, u8 val)
 /* To set specific bits in the register, a clear-mask is given (to be AND-ed),
    and then the value-mask (to be OR-ed). */
 static inline void ad9389b_wr_and_or(struct v4l2_subdev *sd, u8 reg,
-						u8 clr_mask, u8 val_mask)
+				     u8 clr_mask, u8 val_mask)
 {
 	ad9389b_wr(sd, reg, (ad9389b_rd(sd, reg) & clr_mask) | val_mask);
 }
@@ -321,12 +321,12 @@ static int ad9389b_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct ad9389b_state *state = get_ad9389b_state(sd);
 
 	v4l2_dbg(1, debug, sd,
-		"%s: ctrl id: %d, ctrl->val %d\n", __func__, ctrl->id, ctrl->val);
+		 "%s: ctrl id: %d, ctrl->val %d\n", __func__, ctrl->id, ctrl->val);
 
 	if (state->hdmi_mode_ctrl == ctrl) {
 		/* Set HDMI or DVI-D */
 		ad9389b_wr_and_or(sd, 0xaf, 0xfd,
-				ctrl->val == V4L2_DV_TX_MODE_HDMI ? 0x02 : 0x00);
+				  ctrl->val == V4L2_DV_TX_MODE_HDMI ? 0x02 : 0x00);
 		return 0;
 	}
 	if (state->rgb_quantization_range_ctrl == ctrl)
@@ -387,60 +387,60 @@ static int ad9389b_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "chip revision %d\n", state->chip_revision);
 	v4l2_info(sd, "power %s\n", state->power_on ? "on" : "off");
 	v4l2_info(sd, "%s hotplug, %s Rx Sense, %s EDID (%d block(s))\n",
-			(ad9389b_rd(sd, 0x42) & MASK_AD9389B_HPD_DETECT) ?
-							"detected" : "no",
-			(ad9389b_rd(sd, 0x42) & MASK_AD9389B_MSEN_DETECT) ?
-							"detected" : "no",
-			edid->segments ? "found" : "no", edid->blocks);
+		  (ad9389b_rd(sd, 0x42) & MASK_AD9389B_HPD_DETECT) ?
+		  "detected" : "no",
+		  (ad9389b_rd(sd, 0x42) & MASK_AD9389B_MSEN_DETECT) ?
+		  "detected" : "no",
+		  edid->segments ? "found" : "no", edid->blocks);
 	if (state->have_monitor) {
 		v4l2_info(sd, "%s output %s\n",
-				  (ad9389b_rd(sd, 0xaf) & 0x02) ?
-				  "HDMI" : "DVI-D",
-				  (ad9389b_rd(sd, 0xa1) & 0x3c) ?
-				  "disabled" : "enabled");
+			  (ad9389b_rd(sd, 0xaf) & 0x02) ?
+			  "HDMI" : "DVI-D",
+			  (ad9389b_rd(sd, 0xa1) & 0x3c) ?
+			  "disabled" : "enabled");
 	}
 	v4l2_info(sd, "ad9389b: %s\n", (ad9389b_rd(sd, 0xb8) & 0x40) ?
-					"encrypted" : "no encryption");
+		  "encrypted" : "no encryption");
 	v4l2_info(sd, "state: %s, error: %s, detect count: %u, msk/irq: %02x/%02x\n",
-			states[ad9389b_rd(sd, 0xc8) & 0xf],
-			errors[ad9389b_rd(sd, 0xc8) >> 4],
-			state->edid_detect_counter,
-			ad9389b_rd(sd, 0x94), ad9389b_rd(sd, 0x96));
+		  states[ad9389b_rd(sd, 0xc8) & 0xf],
+		  errors[ad9389b_rd(sd, 0xc8) >> 4],
+		  state->edid_detect_counter,
+		  ad9389b_rd(sd, 0x94), ad9389b_rd(sd, 0x96));
 	manual_gear = ad9389b_rd(sd, 0x98) & 0x80;
 	v4l2_info(sd, "ad9389b: RGB quantization: %s range\n",
-			ad9389b_rd(sd, 0x3b) & 0x01 ? "limited" : "full");
+		  ad9389b_rd(sd, 0x3b) & 0x01 ? "limited" : "full");
 	v4l2_info(sd, "ad9389b: %s gear %d\n",
 		  manual_gear ? "manual" : "automatic",
 		  manual_gear ? ((ad9389b_rd(sd, 0x98) & 0x70) >> 4) :
-				((ad9389b_rd(sd, 0x9e) & 0x0e) >> 1));
+		  ((ad9389b_rd(sd, 0x9e) & 0x0e) >> 1));
 	if (state->have_monitor) {
 		if (ad9389b_rd(sd, 0xaf) & 0x02) {
 			/* HDMI only */
 			u8 manual_cts = ad9389b_rd(sd, 0x0a) & 0x80;
 			u32 N = (ad9389b_rd(sd, 0x01) & 0xf) << 16 |
-				 ad9389b_rd(sd, 0x02) << 8 |
-				 ad9389b_rd(sd, 0x03);
+				ad9389b_rd(sd, 0x02) << 8 |
+				ad9389b_rd(sd, 0x03);
 			u8 vic_detect = ad9389b_rd(sd, 0x3e) >> 2;
 			u8 vic_sent = ad9389b_rd(sd, 0x3d) & 0x3f;
 			u32 CTS;
 
 			if (manual_cts)
 				CTS = (ad9389b_rd(sd, 0x07) & 0xf) << 16 |
-				       ad9389b_rd(sd, 0x08) << 8 |
-				       ad9389b_rd(sd, 0x09);
+				      ad9389b_rd(sd, 0x08) << 8 |
+				      ad9389b_rd(sd, 0x09);
 			else
 				CTS = (ad9389b_rd(sd, 0x04) & 0xf) << 16 |
-				       ad9389b_rd(sd, 0x05) << 8 |
-				       ad9389b_rd(sd, 0x06);
+				      ad9389b_rd(sd, 0x05) << 8 |
+				      ad9389b_rd(sd, 0x06);
 			N = (ad9389b_rd(sd, 0x01) & 0xf) << 16 |
-			     ad9389b_rd(sd, 0x02) << 8 |
-			     ad9389b_rd(sd, 0x03);
+			    ad9389b_rd(sd, 0x02) << 8 |
+			    ad9389b_rd(sd, 0x03);
 
 			v4l2_info(sd, "ad9389b: CTS %s mode: N %d, CTS %d\n",
-				manual_cts ? "manual" : "automatic", N, CTS);
+				  manual_cts ? "manual" : "automatic", N, CTS);
 
 			v4l2_info(sd, "ad9389b: VIC: detected %d, sent %d\n",
-				vic_detect, vic_sent);
+				  vic_detect, vic_sent);
 		}
 	}
 	if (state->dv_timings.type == V4L2_DV_BT_656_1120)
@@ -486,7 +486,7 @@ static int ad9389b_s_power(struct v4l2_subdev *sd, int on)
 	}
 	if (i > 1)
 		v4l2_dbg(1, debug, sd,
-			"needed %d retries to powerup the ad9389b\n", i);
+			 "needed %d retries to powerup the ad9389b\n", i);
 
 	/* Select chip: AD9389B */
 	ad9389b_wr_and_or(sd, 0xba, 0xef, 0x10);
@@ -599,7 +599,7 @@ static int ad9389b_get_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
 	if (edid->blocks + edid->start_block >= state->edid.segments * 2)
 		edid->blocks = state->edid.segments * 2 - edid->start_block;
 	memcpy(edid->edid, &state->edid.data[edid->start_block * 128],
-				128 * edid->blocks);
+	       128 * edid->blocks);
 	return 0;
 }
 
@@ -686,14 +686,14 @@ static int ad9389b_g_dv_timings(struct v4l2_subdev *sd,
 }
 
 static int ad9389b_enum_dv_timings(struct v4l2_subdev *sd,
-			struct v4l2_enum_dv_timings *timings)
+				   struct v4l2_enum_dv_timings *timings)
 {
 	return v4l2_enum_dv_timings_cap(timings, &ad9389b_timings_cap,
 			NULL, NULL);
 }
 
 static int ad9389b_dv_timings_cap(struct v4l2_subdev *sd,
-			struct v4l2_dv_timings_cap *cap)
+				  struct v4l2_dv_timings_cap *cap)
 {
 	*cap = ad9389b_timings_cap;
 	return 0;
@@ -724,15 +724,15 @@ static int ad9389b_s_clock_freq(struct v4l2_subdev *sd, u32 freq)
 	u32 N;
 
 	switch (freq) {
-	case 32000: N = 4096; break;
-	case 44100: N = 6272; break;
-	case 48000: N = 6144; break;
-	case 88200: N = 12544; break;
-	case 96000: N = 12288; break;
+	case 32000:  N = 4096;  break;
+	case 44100:  N = 6272;  break;
+	case 48000:  N = 6144;  break;
+	case 88200:  N = 12544; break;
+	case 96000:  N = 12288; break;
 	case 176400: N = 25088; break;
 	case 192000: N = 24576; break;
 	default:
-		return -EINVAL;
+	     return -EINVAL;
 	}
 
 	/* Set N (used with CTS to regenerate the audio clock) */
@@ -748,15 +748,15 @@ static int ad9389b_s_i2s_clock_freq(struct v4l2_subdev *sd, u32 freq)
 	u32 i2s_sf;
 
 	switch (freq) {
-	case 32000: i2s_sf = 0x30; break;
-	case 44100: i2s_sf = 0x00; break;
-	case 48000: i2s_sf = 0x20; break;
-	case 88200: i2s_sf = 0x80; break;
-	case 96000: i2s_sf = 0xa0; break;
+	case 32000:  i2s_sf = 0x30; break;
+	case 44100:  i2s_sf = 0x00; break;
+	case 48000:  i2s_sf = 0x20; break;
+	case 88200:  i2s_sf = 0x80; break;
+	case 96000:  i2s_sf = 0xa0; break;
 	case 176400: i2s_sf = 0xc0; break;
 	case 192000: i2s_sf = 0xe0; break;
 	default:
-		return -EINVAL;
+	     return -EINVAL;
 	}
 
 	/* Set sampling frequency for I2S audio to 48 kHz */
@@ -800,7 +800,7 @@ static const struct v4l2_subdev_ops ad9389b_ops = {
 
 /* ----------------------------------------------------------------------- */
 static void ad9389b_dbg_dump_edid(int lvl, int debug, struct v4l2_subdev *sd,
-							int segment, u8 *buf)
+				  int segment, u8 *buf)
 {
 	int i, j;
 
@@ -826,8 +826,8 @@ static void ad9389b_dbg_dump_edid(int lvl, int debug, struct v4l2_subdev *sd,
 static void ad9389b_edid_handler(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
-	struct ad9389b_state *state = container_of(dwork,
-			struct ad9389b_state, edid_handler);
+	struct ad9389b_state *state =
+		container_of(dwork, struct ad9389b_state, edid_handler);
 	struct v4l2_subdev *sd = &state->sd;
 	struct ad9389b_edid_detect ed;
 
@@ -849,7 +849,7 @@ static void ad9389b_edid_handler(struct work_struct *work)
 			ad9389b_s_power(sd, false);
 			ad9389b_s_power(sd, true);
 			queue_delayed_work(state->work_queue,
-					&state->edid_handler, EDID_DELAY);
+					   &state->edid_handler, EDID_DELAY);
 			return;
 		}
 	}
@@ -1019,7 +1019,7 @@ static bool ad9389b_check_edid_status(struct v4l2_subdev *sd)
 	u8 edidRdy = ad9389b_rd(sd, 0xc5);
 
 	v4l2_dbg(1, debug, sd, "%s: edid ready (retries: %d)\n",
-			 __func__, EDID_MAX_RETRIES - state->edid.read_retries);
+		 __func__, EDID_MAX_RETRIES - state->edid.read_retries);
 
 	if (!(edidRdy & MASK_AD9389B_EDID_RDY))
 		return false;
@@ -1032,14 +1032,14 @@ static bool ad9389b_check_edid_status(struct v4l2_subdev *sd)
 	v4l2_dbg(1, debug, sd, "%s: got segment %d\n", __func__, segment);
 	ad9389b_edid_rd(sd, 256, &state->edid.data[segment * 256]);
 	ad9389b_dbg_dump_edid(2, debug, sd, segment,
-			&state->edid.data[segment * 256]);
+			      &state->edid.data[segment * 256]);
 	if (segment == 0) {
 		state->edid.blocks = state->edid.data[0x7e] + 1;
 		v4l2_dbg(1, debug, sd, "%s: %d blocks in total\n",
-				__func__, state->edid.blocks);
+			 __func__, state->edid.blocks);
 	}
 	if (!edid_verify_crc(sd, segment) ||
-			!edid_verify_header(sd, segment)) {
+	    !edid_verify_header(sd, segment)) {
 		/* edid crc error, force reread of edid segment */
 		v4l2_err(sd, "%s: edid crc or header error\n", __func__);
 		state->have_monitor = false;
@@ -1052,12 +1052,12 @@ static bool ad9389b_check_edid_status(struct v4l2_subdev *sd)
 	if (((state->edid.data[0x7e] >> 1) + 1) > state->edid.segments) {
 		/* Request next EDID segment */
 		v4l2_dbg(1, debug, sd, "%s: request segment %d\n",
-				__func__, state->edid.segments);
+			 __func__, state->edid.segments);
 		ad9389b_wr(sd, 0xc9, 0xf);
 		ad9389b_wr(sd, 0xc4, state->edid.segments);
 		state->edid.read_retries = EDID_MAX_RETRIES;
 		queue_delayed_work(state->work_queue,
-				&state->edid_handler, EDID_DELAY);
+				   &state->edid_handler, EDID_DELAY);
 		return false;
 	}
 
@@ -1101,7 +1101,7 @@ static int ad9389b_probe(struct i2c_client *client, const struct i2c_device_id *
 		return -EIO;
 
 	v4l_dbg(1, debug, client, "detecting ad9389b client on address 0x%x\n",
-			client->addr << 1);
+		client->addr << 1);
 
 	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (!state)
@@ -1160,7 +1160,7 @@ static int ad9389b_probe(struct i2c_client *client, const struct i2c_device_id *
 		goto err_entity;
 	}
 	v4l2_dbg(1, debug, sd, "reg 0x41 0x%x, chip version (reg 0x00) 0x%x\n",
-			ad9389b_rd(sd, 0x41), state->chip_revision);
+		 ad9389b_rd(sd, 0x41), state->chip_revision);
 
 	state->edid_i2c_client = i2c_new_dummy(client->adapter, (0x7e>>1));
 	if (state->edid_i2c_client == NULL) {
@@ -1183,7 +1183,7 @@ static int ad9389b_probe(struct i2c_client *client, const struct i2c_device_id *
 	ad9389b_set_isr(sd, true);
 
 	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
-			  client->addr << 1, client->adapter->name);
+		  client->addr << 1, client->adapter->name);
 	return 0;
 
 err_unreg:
-- 
1.8.4.4

