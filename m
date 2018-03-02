Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:34011 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1424981AbeCBOfO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 09:35:14 -0500
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
Subject: [PATCH 01/12] media: ov5640: Add auto-focus feature
Date: Fri,  2 Mar 2018 15:34:49 +0100
Message-Id: <20180302143500.32650-2-maxime.ripard@bootlin.com>
In-Reply-To: <20180302143500.32650-1-maxime.ripard@bootlin.com>
References: <20180302143500.32650-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mylène Josserand <mylene.josserand@bootlin.com>

Add the auto-focus ENABLE/DISABLE feature as V4L2 control.
Disabled by default.

Signed-off-by: Mylène Josserand <mylene.josserand@bootlin.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index e2dd352224c7..f5e867d47ab8 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -80,8 +80,9 @@
 #define OV5640_REG_POLARITY_CTRL00	0x4740
 #define OV5640_REG_MIPI_CTRL00		0x4800
 #define OV5640_REG_DEBUG_MODE		0x4814
-#define OV5640_REG_ISP_FORMAT_MUX_CTRL	0x501f
+#define OV5640_REG_ISP_CTRL03		0x5003
 #define OV5640_REG_PRE_ISP_TEST_SET1	0x503d
+#define OV5640_REG_ISP_FORMAT_MUX_CTRL	0x501f
 #define OV5640_REG_SDE_CTRL0		0x5580
 #define OV5640_REG_SDE_CTRL1		0x5581
 #define OV5640_REG_SDE_CTRL3		0x5583
@@ -183,6 +184,7 @@ struct ov5640_ctrls {
 		struct v4l2_ctrl *auto_gain;
 		struct v4l2_ctrl *gain;
 	};
+	struct v4l2_ctrl *auto_focus;
 	struct v4l2_ctrl *brightness;
 	struct v4l2_ctrl *saturation;
 	struct v4l2_ctrl *contrast;
@@ -2094,6 +2096,12 @@ static int ov5640_set_ctrl_test_pattern(struct ov5640_dev *sensor, int value)
 			      0xa4, value ? 0xa4 : 0);
 }
 
+static int ov5640_set_ctrl_focus(struct ov5640_dev *sensor, int value)
+{
+	return ov5640_mod_reg(sensor, OV5640_REG_ISP_CTRL03,
+			      BIT(1), value ? BIT(1) : 0);
+}
+
 static int ov5640_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = ctrl_to_sd(ctrl);
@@ -2162,6 +2170,9 @@ static int ov5640_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_TEST_PATTERN:
 		ret = ov5640_set_ctrl_test_pattern(sensor, ctrl->val);
 		break;
+	case V4L2_CID_FOCUS_AUTO:
+		ret = ov5640_set_ctrl_focus(sensor, ctrl->val);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -2224,6 +2235,9 @@ static int ov5640_init_controls(struct ov5640_dev *sensor)
 					     ARRAY_SIZE(test_pattern_menu) - 1,
 					     0, 0, test_pattern_menu);
 
+	ctrls->auto_focus = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FOCUS_AUTO,
+					      0, 1, 1, 0);
+
 	if (hdl->error) {
 		ret = hdl->error;
 		goto free_ctrls;
-- 
2.14.3
