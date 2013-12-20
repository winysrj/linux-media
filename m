Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2037 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab3LTJcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [REVIEW PATCH 31/50] adv7842: support YCrCb analog input, receive CEA formats as RGB on VGA input
Date: Fri, 20 Dec 2013 10:31:24 +0100
Message-Id: <1387531903-20496-32-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Added support for YCrCb analog input.

If input is ADV7842_MODE_RGB and RGB quantization range is set to
V4L2_DV_RGB_RANGE_AUTO, then video with CEA timings will be received
as RGB. For ADV7842_MODE_COMP, automatic CSC mode will be selected.

See table 48 on page 281 in "ADV7842 Hardware Manual, Rev. 0, January 2011"
for details.

Make sure that when switching inputs the RGB quantization range is
updated as well.

Also updated the platform_data in ezkit to ensure that what was the old
default value is now explicitly specified, so the behavior for that board
is unchanged.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
---
 arch/blackfin/mach-bf609/boards/ezkit.c |  1 -
 drivers/media/i2c/adv7842.c             | 94 +++++++++++++++++++++++----------
 include/media/adv7842.h                 |  3 --
 3 files changed, 65 insertions(+), 33 deletions(-)

diff --git a/arch/blackfin/mach-bf609/boards/ezkit.c b/arch/blackfin/mach-bf609/boards/ezkit.c
index 82beedd..28bdd8b 100644
--- a/arch/blackfin/mach-bf609/boards/ezkit.c
+++ b/arch/blackfin/mach-bf609/boards/ezkit.c
@@ -1025,7 +1025,6 @@ static struct adv7842_platform_data adv7842_data = {
 	.ain_sel = ADV7842_AIN10_11_12_NC_SYNC_4_1,
 	.prim_mode = ADV7842_PRIM_MODE_SDP,
 	.vid_std_select = ADV7842_SDP_VID_STD_CVBS_SD_4x1,
-	.inp_color_space = ADV7842_INP_COLOR_SPACE_AUTO,
 	.i2c_sdp_io = 0x40,
 	.i2c_sdp = 0x41,
 	.i2c_cp = 0x42,
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 05d65a8..23f3c1f 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1034,34 +1034,60 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 {
 	struct adv7842_state *state = to_state(sd);
 
+	v4l2_dbg(2, debug, sd, "%s: rgb_quantization_range = %d\n",
+		       __func__, state->rgb_quantization_range);
+
 	switch (state->rgb_quantization_range) {
 	case V4L2_DV_RGB_RANGE_AUTO:
-		/* automatic */
-		if (is_digital_input(sd) && !(hdmi_read(sd, 0x05) & 0x80)) {
-			/* receiving DVI-D signal */
-
-			/* ADV7842 selects RGB limited range regardless of
-			   input format (CE/IT) in automatic mode */
-			if (state->timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
-				/* RGB limited range (16-235) */
-				io_write_and_or(sd, 0x02, 0x0f, 0x00);
-
-			} else {
-				/* RGB full range (0-255) */
-				io_write_and_or(sd, 0x02, 0x0f, 0x10);
-			}
-		} else {
-			/* receiving HDMI or analog signal, set automode */
+		if (state->mode == ADV7842_MODE_RGB) {
+			/* Receiving analog RGB signal
+			 * Set RGB full range (0-255) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x10);
+			break;
+		}
+
+		if (state->mode == ADV7842_MODE_COMP) {
+			/* Receiving analog YPbPr signal
+			 * Set automode */
+			io_write_and_or(sd, 0x02, 0x0f, 0xf0);
+			break;
+		}
+
+		if (hdmi_read(sd, 0x05) & 0x80) {
+			/* Receiving HDMI signal
+			 * Set automode */
 			io_write_and_or(sd, 0x02, 0x0f, 0xf0);
+			break;
+		}
+
+		/* Receiving DVI-D signal
+		 * ADV7842 selects RGB limited range regardless of
+		 * input format (CE/IT) in automatic mode */
+		if (state->timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
+			/* RGB limited range (16-235) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x00);
+		} else {
+			/* RGB full range (0-255) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x10);
 		}
 		break;
 	case V4L2_DV_RGB_RANGE_LIMITED:
-		/* RGB limited range (16-235) */
-		io_write_and_or(sd, 0x02, 0x0f, 0x00);
+		if (state->mode == ADV7842_MODE_COMP) {
+			/* YCrCb limited range (16-235) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x20);
+		} else {
+			/* RGB limited range (16-235) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x00);
+		}
 		break;
 	case V4L2_DV_RGB_RANGE_FULL:
-		/* RGB full range (0-255) */
-		io_write_and_or(sd, 0x02, 0x0f, 0x10);
+		if (state->mode == ADV7842_MODE_COMP) {
+			/* YCrCb full range (0-255) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x60);
+		} else {
+			/* RGB full range (0-255) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x10);
+		}
 		break;
 	}
 }
@@ -1299,7 +1325,7 @@ static int adv7842_dv_timings_cap(struct v4l2_subdev *sd,
 }
 
 /* Fill the optional fields .standards and .flags in struct v4l2_dv_timings
-   if the format is listed in adv7604_timings[] */
+   if the format is listed in adv7842_timings[] */
 static void adv7842_fill_optional_dv_timings_fields(struct v4l2_subdev *sd,
 		struct v4l2_dv_timings *timings)
 {
@@ -1442,6 +1468,8 @@ static int adv7842_g_dv_timings(struct v4l2_subdev *sd,
 static void enable_input(struct v4l2_subdev *sd)
 {
 	struct adv7842_state *state = to_state(sd);
+
+	set_rgb_quantization_range(sd);
 	switch (state->mode) {
 	case ADV7842_MODE_SDP:
 	case ADV7842_MODE_COMP:
@@ -1586,6 +1614,13 @@ static void select_input(struct v4l2_subdev *sd,
 
 		afe_write(sd, 0x00, 0x00); /* power up ADC */
 		afe_write(sd, 0xc8, 0x00); /* phase control */
+		if (state->mode == ADV7842_MODE_COMP) {
+			/* force to YCrCb */
+			io_write_and_or(sd, 0x02, 0x0f, 0x60);
+		} else {
+			/* force to RGB */
+			io_write_and_or(sd, 0x02, 0x0f, 0x10);
+		}
 
 		/* set ADI recommended settings for digitizer */
 		/* "ADV7842 Register Settings Recommendations
@@ -1681,19 +1716,19 @@ static int adv7842_s_routing(struct v4l2_subdev *sd,
 
 	switch (input) {
 	case ADV7842_SELECT_HDMI_PORT_A:
-		/* TODO select HDMI_COMP or HDMI_GR */
 		state->mode = ADV7842_MODE_HDMI;
 		state->vid_std_select = ADV7842_HDMI_COMP_VID_STD_HD_1250P;
 		state->hdmi_port_a = true;
 		break;
 	case ADV7842_SELECT_HDMI_PORT_B:
-		/* TODO select HDMI_COMP or HDMI_GR */
 		state->mode = ADV7842_MODE_HDMI;
 		state->vid_std_select = ADV7842_HDMI_COMP_VID_STD_HD_1250P;
 		state->hdmi_port_a = false;
 		break;
 	case ADV7842_SELECT_VGA_COMP:
-		v4l2_info(sd, "%s: VGA component: todo\n", __func__);
+		state->mode = ADV7842_MODE_COMP;
+		state->vid_std_select = ADV7842_RGB_VID_STD_AUTO_GRAPH_MODE;
+		break;
 	case ADV7842_SELECT_VGA_RGB:
 		state->mode = ADV7842_MODE_RGB;
 		state->vid_std_select = ADV7842_RGB_VID_STD_AUTO_GRAPH_MODE;
@@ -2112,7 +2147,7 @@ static int adv7842_cp_log_status(struct v4l2_subdev *sd)
 	static const char * const input_color_space_txt[16] = {
 		"RGB limited range (16-235)", "RGB full range (0-255)",
 		"YCbCr Bt.601 (16-235)", "YCbCr Bt.709 (16-235)",
-		"XvYCC Bt.601", "XvYCC Bt.709",
+		"xvYCC Bt.601", "xvYCC Bt.709",
 		"YCbCr Bt.601 (0-255)", "YCbCr Bt.709 (0-255)",
 		"invalid", "invalid", "invalid", "invalid", "invalid",
 		"invalid", "invalid", "automatic"
@@ -2341,9 +2376,10 @@ static int adv7842_g_std(struct v4l2_subdev *sd, v4l2_std_id *norm)
 
 /* ----------------------------------------------------------------------- */
 
-static int adv7842_core_init(struct v4l2_subdev *sd,
-		const struct adv7842_platform_data *pdata)
+static int adv7842_core_init(struct v4l2_subdev *sd)
 {
+	struct adv7842_state *state = to_state(sd);
+	struct adv7842_platform_data *pdata = &state->pdata;
 	hdmi_write(sd, 0x48,
 		   (pdata->disable_pwrdnb ? 0x80 : 0) |
 		   (pdata->disable_cable_det_rst ? 0x40 : 0));
@@ -2356,7 +2392,7 @@ static int adv7842_core_init(struct v4l2_subdev *sd,
 
 	/* video format */
 	io_write(sd, 0x02,
-		 pdata->inp_color_space << 4 |
+		 0xf0 |
 		 pdata->alt_gamma << 3 |
 		 pdata->op_656_range << 2 |
 		 pdata->rgb_out << 1 |
@@ -2570,7 +2606,7 @@ static int adv7842_command_ram_test(struct v4l2_subdev *sd)
 	adv7842_rewrite_i2c_addresses(sd, pdata);
 
 	/* and re-init chip and state */
-	adv7842_core_init(sd, pdata);
+	adv7842_core_init(sd);
 
 	disable_input(sd);
 
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index c023f88..f4e9d0d 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -163,9 +163,6 @@ struct adv7842_platform_data {
 	/* Video standard */
 	enum adv7842_vid_std_select vid_std_select;
 
-	/* Input Color Space */
-	enum adv7842_inp_color_space inp_color_space;
-
 	/* Select output format */
 	enum adv7842_op_format_sel op_format_sel;
 
-- 
1.8.4.4

