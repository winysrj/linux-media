Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:41020 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbaAXORd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 09:17:33 -0500
From: Martin Bugge <marbugge@cisco.com>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/4] [media] adv7842: adjust gain and offset for DVI-D signals
Date: Fri, 24 Jan 2014 14:50:03 +0100
Message-Id: <1390571406-11215-2-git-send-email-marbugge@cisco.com>
In-Reply-To: <1390571406-11215-1-git-send-email-marbugge@cisco.com>
References: <1390571406-11215-1-git-send-email-marbugge@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the input signal is DVI-D and quantization range is RGB full range,
gain and offset must be adjusted to get the right range on the output.
Copied and adopted from adv7604.

Cc: Mats Randgaard <matrandg@cisco.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Martin Bugge <marbugge@cisco.com>
---
 drivers/media/i2c/adv7842.c | 109 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 99 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 1effc21..f7a4d79 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -546,6 +546,14 @@ static void main_reset(struct v4l2_subdev *sd)
 
 /* ----------------------------------------------------------------------- */
 
+static inline bool is_analog_input(struct v4l2_subdev *sd)
+{
+	struct adv7842_state *state = to_state(sd);
+
+	return ((state->mode == ADV7842_MODE_RGB) ||
+		(state->mode == ADV7842_MODE_COMP));
+}
+
 static inline bool is_digital_input(struct v4l2_subdev *sd)
 {
 	struct adv7842_state *state = to_state(sd);
@@ -1027,12 +1035,72 @@ static void configure_custom_video_timings(struct v4l2_subdev *sd,
 	cp_write(sd, 0xac, (height & 0x0f) << 4);
 }
 
+static void adv7842_set_offset(struct v4l2_subdev *sd, bool auto_offset, u16 offset_a, u16 offset_b, u16 offset_c)
+{
+	struct adv7842_state *state = to_state(sd);
+	u8 offset_buf[4];
+
+	if (auto_offset) {
+		offset_a = 0x3ff;
+		offset_b = 0x3ff;
+		offset_c = 0x3ff;
+	}
+
+	v4l2_dbg(2, debug, sd, "%s: %s offset: a = 0x%x, b = 0x%x, c = 0x%x\n",
+		 __func__, auto_offset ? "Auto" : "Manual",
+		 offset_a, offset_b, offset_c);
+
+	offset_buf[0]= (cp_read(sd, 0x77) & 0xc0) | ((offset_a & 0x3f0) >> 4);
+	offset_buf[1] = ((offset_a & 0x00f) << 4) | ((offset_b & 0x3c0) >> 6);
+	offset_buf[2] = ((offset_b & 0x03f) << 2) | ((offset_c & 0x300) >> 8);
+	offset_buf[3] = offset_c & 0x0ff;
+
+	/* Registers must be written in this order with no i2c access in between */
+	if (adv_smbus_write_i2c_block_data(state->i2c_cp, 0x77, 4, offset_buf))
+		v4l2_err(sd, "%s: i2c error writing to CP reg 0x77, 0x78, 0x79, 0x7a\n", __func__);
+}
+
+static void adv7842_set_gain(struct v4l2_subdev *sd, bool auto_gain, u16 gain_a, u16 gain_b, u16 gain_c)
+{
+	struct adv7842_state *state = to_state(sd);
+	u8 gain_buf[4];
+	u8 gain_man = 1;
+	u8 agc_mode_man = 1;
+
+	if (auto_gain) {
+		gain_man = 0;
+		agc_mode_man = 0;
+		gain_a = 0x100;
+		gain_b = 0x100;
+		gain_c = 0x100;
+	}
+
+	v4l2_dbg(2, debug, sd, "%s: %s gain: a = 0x%x, b = 0x%x, c = 0x%x\n",
+		 __func__, auto_gain ? "Auto" : "Manual",
+		 gain_a, gain_b, gain_c);
+
+	gain_buf[0] = ((gain_man << 7) | (agc_mode_man << 6) | ((gain_a & 0x3f0) >> 4));
+	gain_buf[1] = (((gain_a & 0x00f) << 4) | ((gain_b & 0x3c0) >> 6));
+	gain_buf[2] = (((gain_b & 0x03f) << 2) | ((gain_c & 0x300) >> 8));
+	gain_buf[3] = ((gain_c & 0x0ff));
+
+	/* Registers must be written in this order with no i2c access in between */
+	if (adv_smbus_write_i2c_block_data(state->i2c_cp, 0x73, 4, gain_buf))
+		v4l2_err(sd, "%s: i2c error writing to CP reg 0x73, 0x74, 0x75, 0x76\n", __func__);
+}
+
 static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 {
 	struct adv7842_state *state = to_state(sd);
+	bool rgb_output = io_read(sd, 0x02) & 0x02;
+	bool hdmi_signal = hdmi_read(sd, 0x05) & 0x80;
+
+	v4l2_dbg(2, debug, sd, "%s: RGB quantization range: %d, RGB out: %d, HDMI: %d\n",
+			__func__, state->rgb_quantization_range,
+			rgb_output, hdmi_signal);
 
-	v4l2_dbg(2, debug, sd, "%s: rgb_quantization_range = %d\n",
-		       __func__, state->rgb_quantization_range);
+	adv7842_set_gain(sd, true, 0x0, 0x0, 0x0);
+	adv7842_set_offset(sd, true, 0x0, 0x0, 0x0);
 
 	switch (state->rgb_quantization_range) {
 	case V4L2_DV_RGB_RANGE_AUTO:
@@ -1050,7 +1118,7 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 			break;
 		}
 
-		if (hdmi_read(sd, 0x05) & 0x80) {
+		if (hdmi_signal) {
 			/* Receiving HDMI signal
 			 * Set automode */
 			io_write_and_or(sd, 0x02, 0x0f, 0xf0);
@@ -1066,24 +1134,45 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 		} else {
 			/* RGB full range (0-255) */
 			io_write_and_or(sd, 0x02, 0x0f, 0x10);
+
+			if (is_digital_input(sd) && rgb_output) {
+				adv7842_set_offset(sd, false, 0x40, 0x40, 0x40);
+			} else {
+				adv7842_set_gain(sd, false, 0xe0, 0xe0, 0xe0);
+				adv7842_set_offset(sd, false, 0x70, 0x70, 0x70);
+			}
 		}
 		break;
 	case V4L2_DV_RGB_RANGE_LIMITED:
 		if (state->mode == ADV7842_MODE_COMP) {
 			/* YCrCb limited range (16-235) */
 			io_write_and_or(sd, 0x02, 0x0f, 0x20);
-		} else {
-			/* RGB limited range (16-235) */
-			io_write_and_or(sd, 0x02, 0x0f, 0x00);
+			break;
 		}
+
+		/* RGB limited range (16-235) */
+		io_write_and_or(sd, 0x02, 0x0f, 0x00);
+
 		break;
 	case V4L2_DV_RGB_RANGE_FULL:
 		if (state->mode == ADV7842_MODE_COMP) {
 			/* YCrCb full range (0-255) */
 			io_write_and_or(sd, 0x02, 0x0f, 0x60);
+			break;
+		}
+
+		/* RGB full range (0-255) */
+		io_write_and_or(sd, 0x02, 0x0f, 0x10);
+
+		if (is_analog_input(sd) || hdmi_signal)
+			break;
+
+		/* Adjust gain/offset for DVI-D signals only */
+		if (rgb_output) {
+			adv7842_set_offset(sd, false, 0x40, 0x40, 0x40);
 		} else {
-			/* RGB full range (0-255) */
-			io_write_and_or(sd, 0x02, 0x0f, 0x10);
+			adv7842_set_gain(sd, false, 0xe0, 0xe0, 0xe0);
+			adv7842_set_offset(sd, false, 0x70, 0x70, 0x70);
 		}
 		break;
 	}
@@ -1717,8 +1806,8 @@ static void select_input(struct v4l2_subdev *sd,
 		 * (rev. 2.5, June 2010)" p. 17. */
 		afe_write(sd, 0x12, 0xfb); /* ADC noise shaping filter controls */
 		afe_write(sd, 0x0c, 0x0d); /* CP core gain controls */
-		cp_write(sd, 0x3e, 0x80); /* CP core pre-gain control,
-					     enable color control */
+		cp_write(sd, 0x3e, 0x00); /* CP core pre-gain control */
+
 		/* CP coast control */
 		cp_write(sd, 0xc3, 0x33); /* Component mode */
 
-- 
1.8.1.4

