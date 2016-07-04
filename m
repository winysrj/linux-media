Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:43815 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932472AbcGDNfG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 09:35:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/7] adv7604/adv7842: fix quantization range handling
Date: Mon,  4 Jul 2016 15:34:48 +0200
Message-Id: <1467639292-1066-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467639292-1066-1-git-send-email-hverkuil@xs4all.nl>
References: <1467639292-1066-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix a number of bugs that appeared when support for mediabus formats was
added:

- Support for V4L2_DV_RGB_RANGE_FULL/LIMITED should only be enabled
  for HDMI RGB formats, not for YCbCr formats. Since, as the name
  says, this setting is for RGB only. So read the InfoFrame to check
  the format.

- the quantization range for the pixelport depends on whether the
  mediabus code is RGB or not: if it is RGB, then produce full range
  RGB values, otherwise produce limited range YCbCr values.

  This means that the op_656_range and alt_data_sat fields of the
  platform data are no longer used and these will be removed in a
  following patch.

- when setting up a new format the RGB quantization range settings
  were never updated. Do so, since this depends on the format.

- fix the log_status output which was confusing and incorrect.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 27 ++++++++++++++++-----------
 drivers/media/i2c/adv7842.c | 26 +++++++++++++++++---------
 2 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 3f1ab49..943706d 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1086,6 +1086,10 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 	struct adv76xx_state *state = to_state(sd);
 	bool rgb_output = io_read(sd, 0x02) & 0x02;
 	bool hdmi_signal = hdmi_read(sd, 0x05) & 0x80;
+	u8 y = HDMI_COLORSPACE_RGB;
+
+	if (hdmi_signal && (io_read(sd, 0x60) & 1))
+		y = infoframe_read(sd, 0x01) >> 5;
 
 	v4l2_dbg(2, debug, sd, "%s: RGB quantization range: %d, RGB out: %d, HDMI: %d\n",
 			__func__, state->rgb_quantization_range,
@@ -1093,6 +1097,7 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 
 	adv76xx_set_gain(sd, true, 0x0, 0x0, 0x0);
 	adv76xx_set_offset(sd, true, 0x0, 0x0, 0x0);
+	io_write_clr_set(sd, 0x02, 0x04, rgb_output ? 0 : 4);
 
 	switch (state->rgb_quantization_range) {
 	case V4L2_DV_RGB_RANGE_AUTO:
@@ -1142,6 +1147,9 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 			break;
 		}
 
+		if (y != HDMI_COLORSPACE_RGB)
+			break;
+
 		/* RGB limited range (16-235) */
 		io_write_clr_set(sd, 0x02, 0xf0, 0x00);
 
@@ -1153,6 +1161,9 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 			break;
 		}
 
+		if (y != HDMI_COLORSPACE_RGB)
+			break;
+
 		/* RGB full range (0-255) */
 		io_write_clr_set(sd, 0x02, 0xf0, 0x10);
 
@@ -1849,6 +1860,7 @@ static void adv76xx_setup_format(struct adv76xx_state *state)
 	io_write_clr_set(sd, 0x04, 0xe0, adv76xx_op_ch_sel(state));
 	io_write_clr_set(sd, 0x05, 0x01,
 			state->format->swap_cb_cr ? ADV76XX_OP_SWAP_CB_CR : 0);
+	set_rgb_quantization_range(sd);
 }
 
 static int adv76xx_get_format(struct v4l2_subdev *sd,
@@ -2323,11 +2335,10 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
 			rgb_quantization_range_txt[state->rgb_quantization_range]);
 	v4l2_info(sd, "Input color space: %s\n",
 			input_color_space_txt[reg_io_0x02 >> 4]);
-	v4l2_info(sd, "Output color space: %s %s, saturator %s, alt-gamma %s\n",
+	v4l2_info(sd, "Output color space: %s %s, alt-gamma %s\n",
 			(reg_io_0x02 & 0x02) ? "RGB" : "YCbCr",
-			(reg_io_0x02 & 0x04) ? "(16-235)" : "(0-255)",
 			(((reg_io_0x02 >> 2) & 0x01) ^ (reg_io_0x02 & 0x01)) ?
-				"enabled" : "disabled",
+				"(16-235)" : "(0-255)",
 			(reg_io_0x02 & 0x08) ? "enabled" : "disabled");
 	v4l2_info(sd, "Color space conversion: %s\n",
 			csc_coeff_sel_rb[cp_read(sd, info->cp_csc) >> 4]);
@@ -2492,10 +2503,7 @@ static int adv76xx_core_init(struct v4l2_subdev *sd)
 	cp_write(sd, 0xcf, 0x01);   /* Power down macrovision */
 
 	/* video format */
-	io_write_clr_set(sd, 0x02, 0x0f,
-			pdata->alt_gamma << 3 |
-			pdata->op_656_range << 2 |
-			pdata->alt_data_sat << 0);
+	io_write_clr_set(sd, 0x02, 0x0f, pdata->alt_gamma << 3);
 	io_write_clr_set(sd, 0x05, 0x0e, pdata->blank_data << 3 |
 			pdata->insert_av_codes << 2 |
 			pdata->replicate_av_codes << 1);
@@ -2845,10 +2853,8 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 	if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
 		state->pdata.inv_llc_pol = 1;
 
-	if (bus_cfg.bus_type == V4L2_MBUS_BT656) {
+	if (bus_cfg.bus_type == V4L2_MBUS_BT656)
 		state->pdata.insert_av_codes = 1;
-		state->pdata.op_656_range = 1;
-	}
 
 	/* Disable the interrupt for now as no DT-based board uses it. */
 	state->pdata.int1_config = ADV76XX_INT1_CONFIG_DISABLED;
@@ -2871,7 +2877,6 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 	state->pdata.disable_pwrdnb = 0;
 	state->pdata.disable_cable_det_rst = 0;
 	state->pdata.blank_data = 1;
-	state->pdata.alt_data_sat = 1;
 	state->pdata.op_format_mode_sel = ADV7604_OP_FORMAT_MODE0;
 	state->pdata.bus_order = ADV7604_BUS_ORDER_RGB;
 
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 8081ef7..5b3ab35 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1198,6 +1198,10 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 	struct adv7842_state *state = to_state(sd);
 	bool rgb_output = io_read(sd, 0x02) & 0x02;
 	bool hdmi_signal = hdmi_read(sd, 0x05) & 0x80;
+	u8 y = HDMI_COLORSPACE_RGB;
+
+	if (hdmi_signal && (io_read(sd, 0x60) & 1))
+		y = infoframe_read(sd, 0x01) >> 5;
 
 	v4l2_dbg(2, debug, sd, "%s: RGB quantization range: %d, RGB out: %d, HDMI: %d\n",
 			__func__, state->rgb_quantization_range,
@@ -1205,6 +1209,7 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 
 	adv7842_set_gain(sd, true, 0x0, 0x0, 0x0);
 	adv7842_set_offset(sd, true, 0x0, 0x0, 0x0);
+	io_write_clr_set(sd, 0x02, 0x04, rgb_output ? 0 : 4);
 
 	switch (state->rgb_quantization_range) {
 	case V4L2_DV_RGB_RANGE_AUTO:
@@ -1254,6 +1259,9 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 			break;
 		}
 
+		if (y != HDMI_COLORSPACE_RGB)
+			break;
+
 		/* RGB limited range (16-235) */
 		io_write_and_or(sd, 0x02, 0x0f, 0x00);
 
@@ -1265,6 +1273,9 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 			break;
 		}
 
+		if (y != HDMI_COLORSPACE_RGB)
+			break;
+
 		/* RGB full range (0-255) */
 		io_write_and_or(sd, 0x02, 0x0f, 0x10);
 
@@ -2072,6 +2083,7 @@ static void adv7842_setup_format(struct adv7842_state *state)
 	io_write_clr_set(sd, 0x04, 0xe0, adv7842_op_ch_sel(state));
 	io_write_clr_set(sd, 0x05, 0x01,
 			state->format->swap_cb_cr ? ADV7842_OP_SWAP_CB_CR : 0);
+	set_rgb_quantization_range(sd);
 }
 
 static int adv7842_get_format(struct v4l2_subdev *sd,
@@ -2572,11 +2584,11 @@ static int adv7842_cp_log_status(struct v4l2_subdev *sd)
 		  rgb_quantization_range_txt[state->rgb_quantization_range]);
 	v4l2_info(sd, "Input color space: %s\n",
 		  input_color_space_txt[reg_io_0x02 >> 4]);
-	v4l2_info(sd, "Output color space: %s %s, saturator %s\n",
+	v4l2_info(sd, "Output color space: %s %s, alt-gamma %s\n",
 		  (reg_io_0x02 & 0x02) ? "RGB" : "YCbCr",
-		  (reg_io_0x02 & 0x04) ? "(16-235)" : "(0-255)",
-		  ((reg_io_0x02 & 0x04) ^ (reg_io_0x02 & 0x01)) ?
-					"enabled" : "disabled");
+		  (((reg_io_0x02 >> 2) & 0x01) ^ (reg_io_0x02 & 0x01)) ?
+			"(16-235)" : "(0-255)",
+		  (reg_io_0x02 & 0x08) ? "enabled" : "disabled");
 	v4l2_info(sd, "Color space conversion: %s\n",
 		  csc_coeff_sel_rb[cp_read(sd, 0xf4) >> 4]);
 
@@ -2780,11 +2792,7 @@ static int adv7842_core_init(struct v4l2_subdev *sd)
 	io_write(sd, 0x15, 0x80);   /* Power up pads */
 
 	/* video format */
-	io_write(sd, 0x02,
-		 0xf0 |
-		 pdata->alt_gamma << 3 |
-		 pdata->op_656_range << 2 |
-		 pdata->alt_data_sat << 0);
+	io_write(sd, 0x02, 0xf0 | pdata->alt_gamma << 3);
 	io_write_and_or(sd, 0x05, 0xf0, pdata->blank_data << 3 |
 			pdata->insert_av_codes << 2 |
 			pdata->replicate_av_codes << 1);
-- 
2.8.1

