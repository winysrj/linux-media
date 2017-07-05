Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:45673 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbdGEIpJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 04:45:09 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hansverk@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 2/3] [media] ov5645: Add control to export pixel clock frequency
Date: Wed,  5 Jul 2017 11:44:48 +0300
Message-Id: <1499244289-7791-2-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1499244289-7791-1-git-send-email-todor.tomov@linaro.org>
References: <1499244289-7791-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add suport for standard V4L2_CID_PIXEL_RATE control. The pixel clock
frequency value is specific for each sensor mode so the sensor mode
structure is extended to add this. The control is read-only and its
value is updated when the sensor mode is changed - on set_format.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/i2c/ov5645.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
index bb3dd0d..4583f66 100644
--- a/drivers/media/i2c/ov5645.c
+++ b/drivers/media/i2c/ov5645.c
@@ -80,6 +80,7 @@ struct ov5645_mode_info {
 	u32 height;
 	const struct reg_value *data;
 	u32 data_size;
+	u32 pixel_clock;
 };
 
 struct ov5645 {
@@ -99,6 +100,7 @@ struct ov5645 {
 	const struct ov5645_mode_info *current_mode;
 
 	struct v4l2_ctrl_handler ctrls;
+	struct v4l2_ctrl *pixel_clock;
 
 	/* Cached register values */
 	u8 aec_pk_manual;
@@ -510,19 +512,22 @@ static inline struct ov5645 *to_ov5645(struct v4l2_subdev *sd)
 		.width = 1280,
 		.height = 960,
 		.data = ov5645_setting_sxga,
-		.data_size = ARRAY_SIZE(ov5645_setting_sxga)
+		.data_size = ARRAY_SIZE(ov5645_setting_sxga),
+		.pixel_clock = 111440000
 	},
 	{
 		.width = 1920,
 		.height = 1080,
 		.data = ov5645_setting_1080p,
-		.data_size = ARRAY_SIZE(ov5645_setting_1080p)
+		.data_size = ARRAY_SIZE(ov5645_setting_1080p),
+		.pixel_clock = 167160000
 	},
 	{
 		.width = 2592,
 		.height = 1944,
 		.data = ov5645_setting_full,
-		.data_size = ARRAY_SIZE(ov5645_setting_full)
+		.data_size = ARRAY_SIZE(ov5645_setting_full),
+		.pixel_clock = 167160000
 	},
 };
 
@@ -969,6 +974,7 @@ static int ov5645_set_format(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *__format;
 	struct v4l2_rect *__crop;
 	const struct ov5645_mode_info *new_mode;
+	int ret;
 
 	__crop = __ov5645_get_pad_crop(ov5645, cfg, format->pad,
 			format->which);
@@ -978,8 +984,14 @@ static int ov5645_set_format(struct v4l2_subdev *sd,
 	__crop->width = new_mode->width;
 	__crop->height = new_mode->height;
 
-	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		ret = v4l2_ctrl_s_ctrl_int64(ov5645->pixel_clock,
+					     new_mode->pixel_clock);
+		if (ret < 0)
+			return ret;
+
 		ov5645->current_mode = new_mode;
+	}
 
 	__format = __ov5645_get_pad_format(ov5645, cfg, format->pad,
 			format->which);
@@ -1197,7 +1209,7 @@ static int ov5645_probe(struct i2c_client *client,
 
 	mutex_init(&ov5645->power_lock);
 
-	v4l2_ctrl_handler_init(&ov5645->ctrls, 7);
+	v4l2_ctrl_handler_init(&ov5645->ctrls, 8);
 	v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
 			  V4L2_CID_SATURATION, -4, 4, 1, 0);
 	v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
@@ -1215,6 +1227,10 @@ static int ov5645_probe(struct i2c_client *client,
 				     V4L2_CID_TEST_PATTERN,
 				     ARRAY_SIZE(ov5645_test_pattern_menu) - 1,
 				     0, 0, ov5645_test_pattern_menu);
+	ov5645->pixel_clock = v4l2_ctrl_new_std(&ov5645->ctrls,
+						&ov5645_ctrl_ops,
+						V4L2_CID_PIXEL_RATE,
+						1, INT_MAX, 1, 1);
 
 	ov5645->sd.ctrl_handler = &ov5645->ctrls;
 
-- 
1.9.1
