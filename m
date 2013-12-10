Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1322 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3LJMLM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 07:11:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/6] ad9389b: remove rx-sense irq dependency
Date: Tue, 10 Dec 2013 13:08:51 +0100
Message-Id: <21b242fb465550a0026f1ed081d29107b76a2bec.1386677238.git.hans.verkuil@cisco.com>
In-Reply-To: <1386677334-20953-1-git-send-email-hverkuil@xs4all.nl>
References: <1386677334-20953-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5857a9bc34d88ef46d61c9d25d11117ac874afc4.1386677238.git.hans.verkuil@cisco.com>
References: <5857a9bc34d88ef46d61c9d25d11117ac874afc4.1386677238.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Removed dependency on rx-sense interrupt, it's a leftover from obsolete
code. Removing this simplifies the code.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 138 +++++++++++++++++++-------------------------
 1 file changed, 58 insertions(+), 80 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index fa95203..cca7758 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -66,11 +66,6 @@ MODULE_LICENSE("GPL");
 **********************************************************************
 */
 
-struct i2c_reg_value {
-	u8 reg;
-	u8 value;
-};
-
 struct ad9389b_state_edid {
 	/* total number of blocks */
 	u32 blocks;
@@ -143,7 +138,7 @@ static int ad9389b_wr(struct v4l2_subdev *sd, u8 reg, u8 val)
 		if (ret == 0)
 			return 0;
 	}
-	v4l2_err(sd, "I2C Write Problem\n");
+	v4l2_err(sd, "%s: failed reg 0x%x, val 0x%x\n", __func__, reg, val);
 	return ret;
 }
 
@@ -392,13 +387,11 @@ static int ad9389b_log_status(struct v4l2_subdev *sd)
 		  (ad9389b_rd(sd, 0x42) & MASK_AD9389B_MSEN_DETECT) ?
 		  "detected" : "no",
 		  edid->segments ? "found" : "no", edid->blocks);
-	if (state->have_monitor) {
-		v4l2_info(sd, "%s output %s\n",
-			  (ad9389b_rd(sd, 0xaf) & 0x02) ?
-			  "HDMI" : "DVI-D",
-			  (ad9389b_rd(sd, 0xa1) & 0x3c) ?
-			  "disabled" : "enabled");
-	}
+	v4l2_info(sd, "%s output %s\n",
+		  (ad9389b_rd(sd, 0xaf) & 0x02) ?
+		  "HDMI" : "DVI-D",
+		  (ad9389b_rd(sd, 0xa1) & 0x3c) ?
+		  "disabled" : "enabled");
 	v4l2_info(sd, "ad9389b: %s\n", (ad9389b_rd(sd, 0xb8) & 0x40) ?
 		  "encrypted" : "no encryption");
 	v4l2_info(sd, "state: %s, error: %s, detect count: %u, msk/irq: %02x/%02x\n",
@@ -413,35 +406,33 @@ static int ad9389b_log_status(struct v4l2_subdev *sd)
 		  manual_gear ? "manual" : "automatic",
 		  manual_gear ? ((ad9389b_rd(sd, 0x98) & 0x70) >> 4) :
 		  ((ad9389b_rd(sd, 0x9e) & 0x0e) >> 1));
-	if (state->have_monitor) {
-		if (ad9389b_rd(sd, 0xaf) & 0x02) {
-			/* HDMI only */
-			u8 manual_cts = ad9389b_rd(sd, 0x0a) & 0x80;
-			u32 N = (ad9389b_rd(sd, 0x01) & 0xf) << 16 |
-				ad9389b_rd(sd, 0x02) << 8 |
-				ad9389b_rd(sd, 0x03);
-			u8 vic_detect = ad9389b_rd(sd, 0x3e) >> 2;
-			u8 vic_sent = ad9389b_rd(sd, 0x3d) & 0x3f;
-			u32 CTS;
-
-			if (manual_cts)
-				CTS = (ad9389b_rd(sd, 0x07) & 0xf) << 16 |
-				      ad9389b_rd(sd, 0x08) << 8 |
-				      ad9389b_rd(sd, 0x09);
-			else
-				CTS = (ad9389b_rd(sd, 0x04) & 0xf) << 16 |
-				      ad9389b_rd(sd, 0x05) << 8 |
-				      ad9389b_rd(sd, 0x06);
-			N = (ad9389b_rd(sd, 0x01) & 0xf) << 16 |
-			    ad9389b_rd(sd, 0x02) << 8 |
-			    ad9389b_rd(sd, 0x03);
-
-			v4l2_info(sd, "ad9389b: CTS %s mode: N %d, CTS %d\n",
-				  manual_cts ? "manual" : "automatic", N, CTS);
-
-			v4l2_info(sd, "ad9389b: VIC: detected %d, sent %d\n",
-				  vic_detect, vic_sent);
-		}
+	if (ad9389b_rd(sd, 0xaf) & 0x02) {
+		/* HDMI only */
+		u8 manual_cts = ad9389b_rd(sd, 0x0a) & 0x80;
+		u32 N = (ad9389b_rd(sd, 0x01) & 0xf) << 16 |
+			ad9389b_rd(sd, 0x02) << 8 |
+			ad9389b_rd(sd, 0x03);
+		u8 vic_detect = ad9389b_rd(sd, 0x3e) >> 2;
+		u8 vic_sent = ad9389b_rd(sd, 0x3d) & 0x3f;
+		u32 CTS;
+
+		if (manual_cts)
+			CTS = (ad9389b_rd(sd, 0x07) & 0xf) << 16 |
+			      ad9389b_rd(sd, 0x08) << 8 |
+			      ad9389b_rd(sd, 0x09);
+		else
+			CTS = (ad9389b_rd(sd, 0x04) & 0xf) << 16 |
+			      ad9389b_rd(sd, 0x05) << 8 |
+			      ad9389b_rd(sd, 0x06);
+		N = (ad9389b_rd(sd, 0x01) & 0xf) << 16 |
+		    ad9389b_rd(sd, 0x02) << 8 |
+		    ad9389b_rd(sd, 0x03);
+
+		v4l2_info(sd, "ad9389b: CTS %s mode: N %d, CTS %d\n",
+			  manual_cts ? "manual" : "automatic", N, CTS);
+
+		v4l2_info(sd, "ad9389b: VIC: detected %d, sent %d\n",
+			  vic_detect, vic_sent);
 	}
 	if (state->dv_timings.type == V4L2_DV_BT_656_1120)
 		v4l2_print_dv_timings(sd->name, "timings: ",
@@ -556,14 +547,16 @@ static int ad9389b_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	irq_status = ad9389b_rd(sd, 0x96);
 	/* clear detected interrupts */
 	ad9389b_wr(sd, 0x96, irq_status);
+	/* enable interrupts */
+	ad9389b_set_isr(sd, true);
 
-	if (irq_status & (MASK_AD9389B_HPD_INT | MASK_AD9389B_MSEN_INT))
+	v4l2_dbg(1, debug, sd, "%s: irq_status 0x%x\n", __func__, irq_status);
+
+	if (irq_status & (MASK_AD9389B_HPD_INT))
 		ad9389b_check_monitor_present_status(sd);
 	if (irq_status & MASK_AD9389B_EDID_RDY_INT)
 		ad9389b_check_edid_status(sd);
 
-	/* enable interrupts */
-	ad9389b_set_isr(sd, true);
 	*handled = true;
 	return 0;
 }
@@ -612,8 +605,6 @@ static const struct v4l2_subdev_pad_ops ad9389b_pad_ops = {
 /* Enable/disable ad9389b output */
 static int ad9389b_s_stream(struct v4l2_subdev *sd, int enable)
 {
-	struct ad9389b_state *state = get_ad9389b_state(sd);
-
 	v4l2_dbg(1, debug, sd, "%s: %sable\n", __func__, (enable ? "en" : "dis"));
 
 	ad9389b_wr_and_or(sd, 0xa1, ~0x3c, (enable ? 0 : 0x3c));
@@ -621,7 +612,6 @@ static int ad9389b_s_stream(struct v4l2_subdev *sd, int enable)
 		ad9389b_check_monitor_present_status(sd);
 	} else {
 		ad9389b_s_power(sd, 0);
-		state->have_monitor = false;
 	}
 	return 0;
 }
@@ -845,7 +835,6 @@ static void ad9389b_edid_handler(struct work_struct *work)
 		if (state->edid.read_retries) {
 			state->edid.read_retries--;
 			v4l2_dbg(1, debug, sd, "%s: edid read failed\n", __func__);
-			state->have_monitor = false;
 			ad9389b_s_power(sd, false);
 			ad9389b_s_power(sd, true);
 			queue_delayed_work(state->work_queue,
@@ -922,42 +911,28 @@ static void ad9389b_check_monitor_present_status(struct v4l2_subdev *sd)
 	u8 status = ad9389b_rd(sd, 0x42);
 
 	v4l2_dbg(1, debug, sd, "%s: status: 0x%x%s%s\n",
-			 __func__,
-			 status,
-			 status & MASK_AD9389B_HPD_DETECT ? ", hotplug" : "",
-			 status & MASK_AD9389B_MSEN_DETECT ? ", rx-sense" : "");
+		 __func__,
+		 status,
+		 status & MASK_AD9389B_HPD_DETECT ? ", hotplug" : "",
+		 status & MASK_AD9389B_MSEN_DETECT ? ", rx-sense" : "");
 
-	if ((status & MASK_AD9389B_HPD_DETECT) &&
-	    ((status & MASK_AD9389B_MSEN_DETECT) || state->edid.segments)) {
-		v4l2_dbg(1, debug, sd,
-				"%s: hotplug and (rx-sense or edid)\n", __func__);
-		if (!state->have_monitor) {
-			v4l2_dbg(1, debug, sd, "%s: monitor detected\n", __func__);
-			state->have_monitor = true;
-			ad9389b_set_isr(sd, true);
-			if (!ad9389b_s_power(sd, true)) {
-				v4l2_dbg(1, debug, sd,
-					"%s: monitor detected, powerup failed\n", __func__);
-				return;
-			}
-			ad9389b_setup(sd);
-			ad9389b_notify_monitor_detect(sd);
-			state->edid.read_retries = EDID_MAX_RETRIES;
-			queue_delayed_work(state->work_queue,
-					&state->edid_handler, EDID_DELAY);
-		}
-	} else if (status & MASK_AD9389B_HPD_DETECT) {
+	if (status & MASK_AD9389B_HPD_DETECT) {
 		v4l2_dbg(1, debug, sd, "%s: hotplug detected\n", __func__);
+		state->have_monitor = true;
+		if (!ad9389b_s_power(sd, true)) {
+			v4l2_dbg(1, debug, sd,
+				 "%s: monitor detected, powerup failed\n", __func__);
+			return;
+		}
+		ad9389b_setup(sd);
+		ad9389b_notify_monitor_detect(sd);
 		state->edid.read_retries = EDID_MAX_RETRIES;
 		queue_delayed_work(state->work_queue,
-				&state->edid_handler, EDID_DELAY);
+				   &state->edid_handler, EDID_DELAY);
 	} else if (!(status & MASK_AD9389B_HPD_DETECT)) {
 		v4l2_dbg(1, debug, sd, "%s: hotplug not detected\n", __func__);
-		if (state->have_monitor) {
-			v4l2_dbg(1, debug, sd, "%s: monitor not detected\n", __func__);
-			state->have_monitor = false;
-			ad9389b_notify_monitor_detect(sd);
-		}
+		state->have_monitor = false;
+		ad9389b_notify_monitor_detect(sd);
 		ad9389b_s_power(sd, false);
 		memset(&state->edid, 0, sizeof(struct ad9389b_state_edid));
 	}
@@ -966,6 +941,10 @@ static void ad9389b_check_monitor_present_status(struct v4l2_subdev *sd)
 	v4l2_ctrl_s_ctrl(state->hotplug_ctrl, ad9389b_have_hotplug(sd) ? 0x1 : 0x0);
 	v4l2_ctrl_s_ctrl(state->rx_sense_ctrl, ad9389b_have_rx_sense(sd) ? 0x1 : 0x0);
 	v4l2_ctrl_s_ctrl(state->have_edid0_ctrl, state->edid.segments ? 0x1 : 0x0);
+
+	/* update with setting from ctrls */
+	ad9389b_s_ctrl(state->rgb_quantization_range_ctrl);
+	ad9389b_s_ctrl(state->hdmi_mode_ctrl);
 }
 
 static bool edid_block_verify_crc(u8 *edid_block)
@@ -1042,7 +1021,6 @@ static bool ad9389b_check_edid_status(struct v4l2_subdev *sd)
 	    !edid_verify_header(sd, segment)) {
 		/* edid crc error, force reread of edid segment */
 		v4l2_err(sd, "%s: edid crc or header error\n", __func__);
-		state->have_monitor = false;
 		ad9389b_s_power(sd, false);
 		ad9389b_s_power(sd, true);
 		return false;
-- 
1.8.4.rc3

