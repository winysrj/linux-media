Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1026 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab2JQJSk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 05:18:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <mats.randgaard@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH for v3.7 2/4] adv7604: Replace prim_mode by mode
Date: Wed, 17 Oct 2012 11:18:31 +0200
Message-Id: <de0a665e2f74c0fd2ff87ffa6f8994249d7501a4.1350465202.git.hans.verkuil@cisco.com>
In-Reply-To: <1350465513-7304-1-git-send-email-hverkuil@xs4all.nl>
References: <1350465513-7304-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c970cc0b7e589a05fbf258792412e5564f648f79.1350465202.git.hans.verkuil@cisco.com>
References: <c970cc0b7e589a05fbf258792412e5564f648f79.1350465202.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Changes the way the primary mode is handled:

- Remove it from platform_data since it doesn't belong there.
- Add a new mode enum for use with s_routing.
- Collapse the two HDMI modes into one HDMI mode: when setting up the
  timings manually we do not need to select HDMI_COMP mode. That's only
  needed when selecting a preset.

This patch prepares for the next step where we switch to using the presets
where available.

Signed-off-by: Mats Randgaard <mats.randgaard@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c |   78 ++++++++++++++++---------------------------
 include/media/adv7604.h     |   21 ++++++------
 2 files changed, 39 insertions(+), 60 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 75a8395..74a18c0 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -53,8 +53,7 @@ MODULE_LICENSE("GPL");
 /* ADV7604 system clock frequency */
 #define ADV7604_fsc (28636360)
 
-#define DIGITAL_INPUT ((state->prim_mode == ADV7604_PRIM_MODE_HDMI_COMP) || \
-			(state->prim_mode == ADV7604_PRIM_MODE_HDMI_GR))
+#define DIGITAL_INPUT (state->mode == ADV7604_MODE_HDMI)
 
 /*
  **********************************************************************
@@ -68,7 +67,7 @@ struct adv7604_state {
 	struct v4l2_subdev sd;
 	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
-	enum adv7604_prim_mode prim_mode;
+	enum adv7604_mode mode;
 	struct v4l2_dv_timings timings;
 	u8 edid[256];
 	unsigned edid_blocks;
@@ -738,12 +737,7 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 	switch (state->rgb_quantization_range) {
 	case V4L2_DV_RGB_RANGE_AUTO:
 		/* automatic */
-		if ((hdmi_read(sd, 0x05) & 0x80) ||
-				(state->prim_mode == ADV7604_PRIM_MODE_COMP) ||
-				(state->prim_mode == ADV7604_PRIM_MODE_RGB)) {
-			/* receiving HDMI or analog signal */
-			io_write_and_or(sd, 0x02, 0x0f, 0xf0);
-		} else {
+		if (DIGITAL_INPUT && !(hdmi_read(sd, 0x05) & 0x80)) {
 			/* receiving DVI-D signal */
 
 			/* ADV7604 selects RGB limited range regardless of
@@ -756,6 +750,9 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 				/* RGB full range (0-255) */
 				io_write_and_or(sd, 0x02, 0x0f, 0x10);
 			}
+		} else {
+			/* receiving HDMI or analog signal, set automode */
+			io_write_and_or(sd, 0x02, 0x0f, 0xf0);
 		}
 		break;
 	case V4L2_DV_RGB_RANGE_LIMITED:
@@ -1203,24 +1200,25 @@ static int adv7604_g_dv_timings(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static void enable_input(struct v4l2_subdev *sd, enum adv7604_prim_mode prim_mode)
+static void enable_input(struct v4l2_subdev *sd)
 {
-	switch (prim_mode) {
-	case ADV7604_PRIM_MODE_COMP:
-	case ADV7604_PRIM_MODE_RGB:
+	struct adv7604_state *state = to_state(sd);
+
+	switch (state->mode) {
+	case ADV7604_MODE_COMP:
+	case ADV7604_MODE_GR:
 		/* enable */
 		io_write(sd, 0x15, 0xb0);   /* Disable Tristate of Pins (no audio) */
 		break;
-	case ADV7604_PRIM_MODE_HDMI_COMP:
-	case ADV7604_PRIM_MODE_HDMI_GR:
+	case ADV7604_MODE_HDMI:
 		/* enable */
 		hdmi_write(sd, 0x1a, 0x0a); /* Unmute audio */
 		hdmi_write(sd, 0x01, 0x00); /* Enable HDMI clock terminators */
 		io_write(sd, 0x15, 0xa0);   /* Disable Tristate of Pins */
 		break;
 	default:
-		v4l2_err(sd, "%s: reserved primary mode 0x%0x\n",
-				__func__, prim_mode);
+		v4l2_dbg(2, debug, sd, "%s: Unknown mode %d\n",
+				__func__, state->mode);
 		break;
 	}
 }
@@ -1233,11 +1231,13 @@ static void disable_input(struct v4l2_subdev *sd)
 	hdmi_write(sd, 0x01, 0x78); /* Disable HDMI clock terminators */
 }
 
-static void select_input(struct v4l2_subdev *sd, enum adv7604_prim_mode prim_mode)
+static void select_input(struct v4l2_subdev *sd)
 {
-	switch (prim_mode) {
-	case ADV7604_PRIM_MODE_COMP:
-	case ADV7604_PRIM_MODE_RGB:
+	struct adv7604_state *state = to_state(sd);
+
+	switch (state->mode) {
+	case ADV7604_MODE_COMP:
+	case ADV7604_MODE_GR:
 		/* set mode and select free run resolution */
 		io_write(sd, 0x00, 0x07); /* video std */
 		io_write(sd, 0x01, 0x02); /* prim mode */
@@ -1271,13 +1271,10 @@ static void select_input(struct v4l2_subdev *sd, enum adv7604_prim_mode prim_mod
 		cp_write(sd, 0x40, 0x5c); /* CP core pre-gain control. Graphics mode */
 		break;
 
-	case ADV7604_PRIM_MODE_HDMI_COMP:
-	case ADV7604_PRIM_MODE_HDMI_GR:
+	case ADV7604_MODE_HDMI:
 		/* set mode and select free run resolution */
-		/* video std */
-		io_write(sd, 0x00,
-			(prim_mode == ADV7604_PRIM_MODE_HDMI_GR) ? 0x02 : 0x1e);
-		io_write(sd, 0x01, prim_mode); /* prim mode */
+		io_write(sd, 0x00, 0x02); /* video std */
+		io_write(sd, 0x01, 0x06); /* prim mode */
 		/* disable embedded syncs for auto graphics mode */
 		cp_write_and_or(sd, 0x81, 0xef, 0x00);
 
@@ -1309,7 +1306,8 @@ static void select_input(struct v4l2_subdev *sd, enum adv7604_prim_mode prim_mod
 
 		break;
 	default:
-		v4l2_err(sd, "%s: reserved primary mode 0x%0x\n", __func__, prim_mode);
+		v4l2_dbg(2, debug, sd, "%s: Unknown mode %d\n",
+				__func__, state->mode);
 		break;
 	}
 }
@@ -1321,26 +1319,13 @@ static int adv7604_s_routing(struct v4l2_subdev *sd,
 
 	v4l2_dbg(2, debug, sd, "%s: input %d", __func__, input);
 
-	switch (input) {
-	case 0:
-		/* TODO select HDMI_COMP or HDMI_GR */
-		state->prim_mode = ADV7604_PRIM_MODE_HDMI_COMP;
-		break;
-	case 1:
-		state->prim_mode = ADV7604_PRIM_MODE_RGB;
-		break;
-	case 2:
-		state->prim_mode = ADV7604_PRIM_MODE_COMP;
-		break;
-	default:
-		return -EINVAL;
-	}
+	state->mode = input;
 
 	disable_input(sd);
 
-	select_input(sd, state->prim_mode);
+	select_input(sd);
 
-	enable_input(sd, state->prim_mode);
+	enable_input(sd);
 
 	return 0;
 }
@@ -1724,11 +1709,6 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 	afe_write(sd, 0x02, pdata->ain_sel); /* Select analog input muxing mode */
 	io_write_and_or(sd, 0x30, ~(1 << 4), pdata->output_bus_lsb_to_msb << 4);
 
-	state->prim_mode = pdata->prim_mode;
-	select_input(sd, pdata->prim_mode);
-
-	enable_input(sd, pdata->prim_mode);
-
 	/* interrupts */
 	io_write(sd, 0x40, 0xc2); /* Configure INT1 */
 	io_write(sd, 0x41, 0xd7); /* STDI irq for any change, disable INT2 */
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index 171b957..dc004bc 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -40,14 +40,6 @@ enum adv7604_op_ch_sel {
 	ADV7604_OP_CH_SEL_RBG = 5,
 };
 
-/* Primary mode (IO register 0x01, [3:0]) */
-enum adv7604_prim_mode {
-	ADV7604_PRIM_MODE_COMP = 1,
-	ADV7604_PRIM_MODE_RGB = 2,
-	ADV7604_PRIM_MODE_HDMI_COMP = 5,
-	ADV7604_PRIM_MODE_HDMI_GR = 6,
-};
-
 /* Input Color Space (IO register 0x02, [7:4]) */
 enum adv7604_inp_color_space {
 	ADV7604_INP_COLOR_SPACE_LIM_RGB = 0,
@@ -103,9 +95,6 @@ struct adv7604_platform_data {
 	/* Bus rotation and reordering */
 	enum adv7604_op_ch_sel op_ch_sel;
 
-	/* Primary mode */
-	enum adv7604_prim_mode prim_mode;
-
 	/* Select output format */
 	enum adv7604_op_format_sel op_format_sel;
 
@@ -142,6 +131,16 @@ struct adv7604_platform_data {
 	u8 i2c_vdp;
 };
 
+/*
+ * Mode of operation.
+ * This is used as the input argument of the s_routing video op.
+ */
+enum adv7604_mode {
+	ADV7604_MODE_COMP,
+	ADV7604_MODE_GR,
+	ADV7604_MODE_HDMI,
+};
+
 #define V4L2_CID_ADV_RX_ANALOG_SAMPLING_PHASE	(V4L2_CID_DV_CLASS_BASE + 0x1000)
 #define V4L2_CID_ADV_RX_FREE_RUN_COLOR_MANUAL	(V4L2_CID_DV_CLASS_BASE + 0x1001)
 #define V4L2_CID_ADV_RX_FREE_RUN_COLOR		(V4L2_CID_DV_CLASS_BASE + 0x1002)
-- 
1.7.10.4

