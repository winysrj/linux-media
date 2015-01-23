Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-190.synserver.de ([212.40.185.190]:1094 "EHLO
	smtp-out-190.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbbAWPwu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 10:52:50 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?=
	<richard.rojfors@mocean-labs.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 14/15] [media] adv7180: Add fast switch support
Date: Fri, 23 Jan 2015 16:52:33 +0100
Message-Id: <1422028354-31891-15-git-send-email-lars@metafoo.de>
In-Reply-To: <1422028354-31891-1-git-send-email-lars@metafoo.de>
References: <1422028354-31891-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In fast switch mode the adv7180 (and similar) can lock onto a new signal
faster when switching between different inputs. As a downside though it is
no longer able to auto-detect the incoming format.

The fast switch mode is exposed as a boolean v4l control that allows
userspace applications to either enable or disable fast switch mode.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
--
Changes since v1:
	* Reserve private control range and use it for the fast switch control
	* Changed control name from "Fast switch" to "Fast Switch"
---
 drivers/media/i2c/adv7180.c        | 29 +++++++++++++++++++++++++++++
 include/uapi/linux/v4l2-controls.h |  4 ++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 4d789c7..ee73b29 100644
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
 
+#define V4L2_CID_ADV_FAST_SWITCH	(V4L2_CID_USER_ADV7180_BASE + 0x00)
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
+	.name = "Fast Switching",
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
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 661f119..9f6e108 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -170,6 +170,10 @@ enum v4l2_colorfx {
  * We reserve 16 controls for this driver. */
 #define V4L2_CID_USER_SAA7134_BASE		(V4L2_CID_USER_BASE + 0x1060)
 
+/* The base for the adv7180 driver controls.
+ * We reserve 16 controls for this driver. */
+#define V4L2_CID_USER_ADV7180_BASE		(V4L2_CID_USER_BASE + 0x1070)
+
 /* MPEG-class control IDs */
 /* The MPEG controls are applicable to all codec controls
  * and the 'MPEG' part of the define is historical */
-- 
1.8.0

