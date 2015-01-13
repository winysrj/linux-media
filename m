Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-231.synserver.de ([212.40.185.231]:1035 "EHLO
	smtp-out-227.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752352AbbAMMBe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 07:01:34 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 14/16] [media] adv7180: Add fast switch support
Date: Tue, 13 Jan 2015 13:01:19 +0100
Message-Id: <1421150481-30230-15-git-send-email-lars@metafoo.de>
In-Reply-To: <1421150481-30230-1-git-send-email-lars@metafoo.de>
References: <1421150481-30230-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In fast switch mode the adv7180 (and similar) can lock onto a new signal
faster when switching between different inputs. As a downside though it is
no longer able to auto-detect the incoming format.

The fast switch mode is exposed as a boolean v4l control that allows
userspace applications to either enable or disable fast switch mode.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7180.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 4d789c7..82c8296 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -127,6 +127,9 @@
 #define ADV7180_REG_VPP_SLAVE_ADDR	0xFD
 #define ADV7180_REG_CSI_SLAVE_ADDR	0xFE
 
+#define ADV7180_REG_FLCONTROL 0x40e0
+#define ADV7180_FLCONTROL_FL_ENABLE 0x1
+
 #define ADV7180_CSI_REG_PWRDN	0x00
 #define ADV7180_CSI_PWRDN	0x80
 
@@ -164,6 +167,8 @@
 #define ADV7180_DEFAULT_CSI_I2C_ADDR 0x44
 #define ADV7180_DEFAULT_VPP_I2C_ADDR 0x42
 
+#define V4L2_CID_ADV_FAST_SWITCH	(V4L2_CID_DV_CLASS_BASE + 0x1010)
+
 struct adv7180_state;
 
 #define ADV7180_FLAG_RESET_POWERED	BIT(0)
@@ -509,6 +514,18 @@ static int adv7180_s_ctrl(struct v4l2_ctrl *ctrl)
 			break;
 		ret = adv7180_write(state, ADV7180_REG_SD_SAT_CR, val);
 		break;
+	case V4L2_CID_ADV_FAST_SWITCH:
+		if (ctrl->val) {
+			/* ADI required write */
+			adv7180_write(state, 0x80d9, 0x44);
+			adv7180_write(state, ADV7180_REG_FLCONTROL,
+				ADV7180_FLCONTROL_FL_ENABLE);
+		} else {
+			/* ADI required write */
+			adv7180_write(state, 0x80d9, 0xc4);
+			adv7180_write(state, ADV7180_REG_FLCONTROL, 0x00);
+		}
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -521,6 +538,16 @@ static const struct v4l2_ctrl_ops adv7180_ctrl_ops = {
 	.s_ctrl = adv7180_s_ctrl,
 };
 
+static const struct v4l2_ctrl_config adv7180_ctrl_fast_switch = {
+	.ops = &adv7180_ctrl_ops,
+	.id = V4L2_CID_ADV_FAST_SWITCH,
+	.name = "Fast switching",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.min = 0,
+	.max = 1,
+	.step = 1,
+};
+
 static int adv7180_init_controls(struct adv7180_state *state)
 {
 	v4l2_ctrl_handler_init(&state->ctrl_hdl, 4);
@@ -537,6 +564,8 @@ static int adv7180_init_controls(struct adv7180_state *state)
 	v4l2_ctrl_new_std(&state->ctrl_hdl, &adv7180_ctrl_ops,
 			  V4L2_CID_HUE, ADV7180_HUE_MIN,
 			  ADV7180_HUE_MAX, 1, ADV7180_HUE_DEF);
+	v4l2_ctrl_new_custom(&state->ctrl_hdl, &adv7180_ctrl_fast_switch, NULL);
+
 	state->sd.ctrl_handler = &state->ctrl_hdl;
 	if (state->ctrl_hdl.error) {
 		int err = state->ctrl_hdl.error;
-- 
1.8.0

