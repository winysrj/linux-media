Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:34023 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425809AbeCBOfX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 09:35:23 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 02/12] media: ov5640: Add light frequency control
Date: Fri,  2 Mar 2018 15:34:50 +0100
Message-Id: <20180302143500.32650-3-maxime.ripard@bootlin.com>
In-Reply-To: <20180302143500.32650-1-maxime.ripard@bootlin.com>
References: <20180302143500.32650-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mylène Josserand <mylene.josserand@bootlin.com>

Add the light frequency control to be able to set the frequency
to manual (50Hz or 60Hz) or auto.

Signed-off-by: Mylène Josserand <mylene.josserand@bootlin.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index f5e867d47ab8..e6a23eb55c1d 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -186,6 +186,7 @@ struct ov5640_ctrls {
 	};
 	struct v4l2_ctrl *auto_focus;
 	struct v4l2_ctrl *brightness;
+	struct v4l2_ctrl *light_freq;
 	struct v4l2_ctrl *saturation;
 	struct v4l2_ctrl *contrast;
 	struct v4l2_ctrl *hue;
@@ -2102,6 +2103,21 @@ static int ov5640_set_ctrl_focus(struct ov5640_dev *sensor, int value)
 			      BIT(1), value ? BIT(1) : 0);
 }
 
+static int ov5640_set_ctl_light_freq(struct ov5640_dev *sensor, int value)
+{
+	int ret;
+
+	ret = ov5640_mod_reg(sensor, OV5640_REG_HZ5060_CTRL01, BIT(7),
+			     (value == V4L2_CID_POWER_LINE_FREQUENCY_AUTO) ?
+			     0: BIT(7));
+	if (ret)
+		return ret;
+
+	return ov5640_mod_reg(sensor, OV5640_REG_HZ5060_CTRL00, BIT(2),
+			      (value == V4L2_CID_POWER_LINE_FREQUENCY_50HZ) ?
+			      BIT(2): 0);
+}
+
 static int ov5640_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = ctrl_to_sd(ctrl);
@@ -2173,6 +2189,9 @@ static int ov5640_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_FOCUS_AUTO:
 		ret = ov5640_set_ctrl_focus(sensor, ctrl->val);
 		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+		ret = ov5640_set_ctl_light_freq(sensor, ctrl->val);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -2237,6 +2256,11 @@ static int ov5640_init_controls(struct ov5640_dev *sensor)
 
 	ctrls->auto_focus = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FOCUS_AUTO,
 					      0, 1, 1, 0);
+	ctrls->light_freq =
+		v4l2_ctrl_new_std_menu(hdl, ops,
+				       V4L2_CID_POWER_LINE_FREQUENCY,
+				       V4L2_CID_POWER_LINE_FREQUENCY_AUTO, 0,
+				       V4L2_CID_POWER_LINE_FREQUENCY_50HZ);
 
 	if (hdl->error) {
 		ret = hdl->error;
-- 
2.14.3
