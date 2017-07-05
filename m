Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:45675 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751444AbdGEIpK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 04:45:10 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hansverk@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 3/3] [media] ov5645: Add control to export CSI2 link frequency
Date: Wed,  5 Jul 2017 11:44:49 +0300
Message-Id: <1499244289-7791-3-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1499244289-7791-1-git-send-email-todor.tomov@linaro.org>
References: <1499244289-7791-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add suport for standard integer menu V4L2_CID_LINK_FREQ control.
The CSI2 link frequency value is specific for each sensor mode so the
sensor mode structure is extended to add this. The control is made
read-only and its value is updated when the sensor mode is changed -
on set_format.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/i2c/ov5645.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
index 4583f66..85622e4 100644
--- a/drivers/media/i2c/ov5645.c
+++ b/drivers/media/i2c/ov5645.c
@@ -81,6 +81,7 @@ struct ov5645_mode_info {
 	const struct reg_value *data;
 	u32 data_size;
 	u32 pixel_clock;
+	u32 link_freq;
 };
 
 struct ov5645 {
@@ -101,6 +102,7 @@ struct ov5645 {
 
 	struct v4l2_ctrl_handler ctrls;
 	struct v4l2_ctrl *pixel_clock;
+	struct v4l2_ctrl *link_freq;
 
 	/* Cached register values */
 	u8 aec_pk_manual;
@@ -507,27 +509,35 @@ static inline struct ov5645 *to_ov5645(struct v4l2_subdev *sd)
 	{ 0x4202, 0x00 }
 };
 
+static const s64 link_freq[] = {
+	222880000,
+	334320000
+};
+
 static const struct ov5645_mode_info ov5645_mode_info_data[] = {
 	{
 		.width = 1280,
 		.height = 960,
 		.data = ov5645_setting_sxga,
 		.data_size = ARRAY_SIZE(ov5645_setting_sxga),
-		.pixel_clock = 111440000
+		.pixel_clock = 111440000,
+		.link_freq = 0 /* an index in link_freq[] */
 	},
 	{
 		.width = 1920,
 		.height = 1080,
 		.data = ov5645_setting_1080p,
 		.data_size = ARRAY_SIZE(ov5645_setting_1080p),
-		.pixel_clock = 167160000
+		.pixel_clock = 167160000,
+		.link_freq = 1 /* an index in link_freq[] */
 	},
 	{
 		.width = 2592,
 		.height = 1944,
 		.data = ov5645_setting_full,
 		.data_size = ARRAY_SIZE(ov5645_setting_full),
-		.pixel_clock = 167160000
+		.pixel_clock = 167160000,
+		.link_freq = 1 /* an index in link_freq[] */
 	},
 };
 
@@ -990,6 +1000,11 @@ static int ov5645_set_format(struct v4l2_subdev *sd,
 		if (ret < 0)
 			return ret;
 
+		ret = v4l2_ctrl_s_ctrl(ov5645->link_freq,
+				       new_mode->link_freq);
+		if (ret < 0)
+			return ret;
+
 		ov5645->current_mode = new_mode;
 	}
 
@@ -1209,7 +1224,7 @@ static int ov5645_probe(struct i2c_client *client,
 
 	mutex_init(&ov5645->power_lock);
 
-	v4l2_ctrl_handler_init(&ov5645->ctrls, 8);
+	v4l2_ctrl_handler_init(&ov5645->ctrls, 9);
 	v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
 			  V4L2_CID_SATURATION, -4, 4, 1, 0);
 	v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
@@ -1231,6 +1246,13 @@ static int ov5645_probe(struct i2c_client *client,
 						&ov5645_ctrl_ops,
 						V4L2_CID_PIXEL_RATE,
 						1, INT_MAX, 1, 1);
+	ov5645->link_freq = v4l2_ctrl_new_int_menu(&ov5645->ctrls,
+						   &ov5645_ctrl_ops,
+						   V4L2_CID_LINK_FREQ,
+						   ARRAY_SIZE(link_freq) - 1,
+						   0, link_freq);
+	if(ov5645->link_freq)
+		ov5645->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	ov5645->sd.ctrl_handler = &ov5645->ctrls;
 
-- 
1.9.1
