Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-231.synserver.de ([212.40.185.231]:1046 "EHLO
	smtp-out-227.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752339AbbAMMBf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 07:01:35 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 15/16] [media] adv7180: Add free run mode controls
Date: Tue, 13 Jan 2015 13:01:20 +0100
Message-Id: <1421150481-30230-16-git-send-email-lars@metafoo.de>
In-Reply-To: <1421150481-30230-1-git-send-email-lars@metafoo.de>
References: <1421150481-30230-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The adv7180 (and similar) has support for a so called free run mode in which
it will output a predefined test signal. This patch adds support for
configuring the various aspects of the so called free run mode.

The patch adds three new v4l controls:
	* Free Running Mode: Allows to either disable or enable free running
	  mode or set it to automatic. In automatic mode the adv7180 will go to
	  free run mode if no external signal source could be detected
	* Free Running Pattern: Allows to select which pattern will be displayed
	  in free run mode
	* Free Running Color: Allows to select the color of the pattern

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7180.c | 125 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 122 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 82c8296..678d6c9 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -75,6 +75,9 @@
 #define ADV7180_HUE_DEF		0
 #define ADV7180_HUE_MAX		128
 
+#define ADV7180_REG_DEF_VAL_Y		0x000c
+#define ADV7180_REG_DEF_VAL_C		0x000d
+
 #define ADV7180_REG_CTRL		0x000e
 #define ADV7180_CTRL_IRQ_SPACE		0x20
 
@@ -168,6 +171,11 @@
 #define ADV7180_DEFAULT_VPP_I2C_ADDR 0x42
 
 #define V4L2_CID_ADV_FAST_SWITCH	(V4L2_CID_DV_CLASS_BASE + 0x1010)
+#define V4L2_CID_ADV_FREE_RUN_COLOR	(V4L2_CID_DV_CLASS_BASE + 0x1002)
+#define V4L2_CID_ADV_FREE_RUN_MODE	(V4L2_CID_DV_CLASS_BASE + 0x1003)
+#define V4L2_CID_ADV_FREE_RUN_PATTERN	(V4L2_CID_DV_CLASS_BASE + 0x1004)
+
+#define ADV7180_INPUT_DISABLED (~0x00)
 
 struct adv7180_state;
 
@@ -193,6 +201,7 @@ struct adv7180_state {
 	v4l2_std_id		curr_norm;
 	bool			autodetect;
 	bool			powered;
+	bool			force_free_run;
 	u8			input;
 
 	struct i2c_client	*client;
@@ -363,10 +372,13 @@ static int adv7180_s_routing(struct v4l2_subdev *sd, u32 input,
 		goto out;
 	}
 
-	ret = state->chip_info->select_input(state, input);
-
-	if (ret == 0)
+	if (state->force_free_run) {
 		state->input = input;
+	} else {
+		ret = state->chip_info->select_input(state, input);
+		if (ret == 0)
+			state->input = input;
+	}
 out:
 	mutex_unlock(&state->mutex);
 	return ret;
@@ -488,6 +500,7 @@ static int adv7180_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct adv7180_state *state = ctrl_to_adv7180(ctrl);
 	int ret = mutex_lock_interruptible(&state->mutex);
+	int reg_val;
 	int val;
 
 	if (ret)
@@ -526,6 +539,53 @@ static int adv7180_s_ctrl(struct v4l2_ctrl *ctrl)
 			adv7180_write(state, ADV7180_REG_FLCONTROL, 0x00);
 		}
 		break;
+	case V4L2_CID_ADV_FREE_RUN_MODE:
+		switch (ctrl->val) {
+		case 1: /* Enabled */
+			ret = state->chip_info->select_input(state,
+				ADV7180_INPUT_DISABLED);
+			state->force_free_run = true;
+			break;
+		case 0: /* Disabled */
+		case 2: /* Automatic */
+			ret = state->chip_info->select_input(state,
+				state->input);
+			state->force_free_run = false;
+			break;
+		default:
+			break;
+		}
+		reg_val = adv7180_read(state, ADV7180_REG_DEF_VAL_Y);
+		reg_val &= 0xfc;
+		reg_val |= ctrl->val;
+		adv7180_write(state, ADV7180_REG_DEF_VAL_Y, reg_val);
+		break;
+	case V4L2_CID_ADV_FREE_RUN_PATTERN:
+		reg_val = adv7180_read(state, 0x14);
+		reg_val &= 0xf8;
+		reg_val |= ctrl->val;
+		adv7180_write(state, 0x14, reg_val);
+		break;
+	case V4L2_CID_ADV_FREE_RUN_COLOR: {
+		int r = (ctrl->val & 0xff0000) >> 16;
+		int g = (ctrl->val & 0x00ff00) >> 8;
+		int b = (ctrl->val & 0x0000ff);
+		/* RGB -> YCbCr, numerical approximation */
+		int y = ((66 * r + 129 * g + 25 * b + 128) >> 8) + 16;
+		int cb = ((-38 * r - 74 * g + 112 * b + 128) >> 8) + 128;
+		int cr = ((112 * r - 94 * g - 18 * b + 128) >> 8) + 128;
+
+		/* Y is 6-bit, Cb and Cr 4-bit */
+		y >>= 2;
+		cb >>= 4;
+		cr >>= 4;
+
+		reg_val = adv7180_read(state, ADV7180_REG_DEF_VAL_Y);
+		adv7180_write(state, ADV7180_REG_DEF_VAL_Y,
+			(y << 2) | (reg_val & 0x03));
+		adv7180_write(state, ADV7180_REG_DEF_VAL_C, (cr << 4) | cb);
+		break;
+	}
 	default:
 		ret = -EINVAL;
 	}
@@ -548,6 +608,53 @@ static const struct v4l2_ctrl_config adv7180_ctrl_fast_switch = {
 	.step = 1,
 };
 
+static const char * const adv7180_free_run_pattern_strings[] = {
+	"Solid",
+	"Bars",
+	"Luma Ramp",
+	"Reserved",
+	"Reserved",
+	"Boundary Box",
+};
+
+static const char * const adv7180_free_run_mode_strings[] = {
+	"Disabled",
+	"Enabled",
+	"Automatic",
+};
+
+static const struct v4l2_ctrl_config adv7180_ctrl_free_run_color = {
+	.ops = &adv7180_ctrl_ops,
+	.id = V4L2_CID_ADV_FREE_RUN_COLOR,
+	.name = "Free Running Color",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = 0xffffff,
+	.step = 0x1,
+};
+
+static const struct v4l2_ctrl_config adv7180_ctrl_free_run_mode = {
+	.ops = &adv7180_ctrl_ops,
+	.id = V4L2_CID_ADV_FREE_RUN_MODE,
+	.name = "Free Running Mode",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.min = 0,
+	.max = ARRAY_SIZE(adv7180_free_run_mode_strings) - 1,
+	.def = 2,
+	.qmenu = adv7180_free_run_mode_strings,
+};
+
+static const struct v4l2_ctrl_config adv7180_ctrl_free_run_pattern = {
+	.ops = &adv7180_ctrl_ops,
+	.id = V4L2_CID_ADV_FREE_RUN_PATTERN,
+	.name = "Free Running Pattern",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.min = 0,
+	.max = ARRAY_SIZE(adv7180_free_run_pattern_strings) - 1,
+	.menu_skip_mask = 0x18, /* 0x3 and 0x4 are reserved */
+	.qmenu = adv7180_free_run_pattern_strings,
+};
+
 static int adv7180_init_controls(struct adv7180_state *state)
 {
 	v4l2_ctrl_handler_init(&state->ctrl_hdl, 4);
@@ -565,6 +672,12 @@ static int adv7180_init_controls(struct adv7180_state *state)
 			  V4L2_CID_HUE, ADV7180_HUE_MIN,
 			  ADV7180_HUE_MAX, 1, ADV7180_HUE_DEF);
 	v4l2_ctrl_new_custom(&state->ctrl_hdl, &adv7180_ctrl_fast_switch, NULL);
+	v4l2_ctrl_new_custom(&state->ctrl_hdl, &adv7180_ctrl_free_run_color,
+		NULL);
+	v4l2_ctrl_new_custom(&state->ctrl_hdl, &adv7180_ctrl_free_run_mode,
+		NULL);
+	v4l2_ctrl_new_custom(&state->ctrl_hdl, &adv7180_ctrl_free_run_pattern,
+		NULL);
 
 	state->sd.ctrl_handler = &state->ctrl_hdl;
 	if (state->ctrl_hdl.error) {
@@ -784,6 +897,9 @@ static int adv7180_select_input(struct adv7180_state *state, unsigned int input)
 {
 	int ret;
 
+	if (input == ADV7180_INPUT_DISABLED)
+		input = 0x00;
+
 	ret = adv7180_read(state, ADV7180_REG_INPUT_CONTROL);
 	if (ret < 0)
 		return ret;
@@ -893,6 +1009,9 @@ static int adv7182_select_input(struct adv7180_state *state, unsigned int input)
 	unsigned int i;
 	int ret;
 
+	if (input == ADV7180_INPUT_DISABLED)
+		return adv7180_write(state, ADV7180_REG_INPUT_CONTROL, 0xff);
+
 	ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL, input);
 	if (ret)
 		return ret;
-- 
1.8.0

