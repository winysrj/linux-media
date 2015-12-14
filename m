Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:46291 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbbLNOmS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 09:42:18 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH v2 3/3] [media] mt9v032: Add V4L2 controls for AEC and AGC
Date: Mon, 14 Dec 2015 15:41:53 +0100
Message-Id: <1450104113-6392-3-git-send-email-mpa@pengutronix.de>
In-Reply-To: <1450104113-6392-1-git-send-email-mpa@pengutronix.de>
References: <1450104113-6392-1-git-send-email-mpa@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds V4L2 controls for Auto Exposure Control and Auto Gain
Control settings. These settings include low pass filter, update
frequency of these settings and the update interval for those units.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/media/i2c/mt9v032.c | 153 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 152 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index cc16acf001de..6cbc3b87eda9 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -133,9 +133,16 @@
 #define		MT9V032_TEST_PATTERN_GRAY_DIAGONAL	(3 << 11)
 #define		MT9V032_TEST_PATTERN_ENABLE		(1 << 13)
 #define		MT9V032_TEST_PATTERN_FLIP		(1 << 14)
+#define MT9V032_AEGC_DESIRED_BIN			0xa5
+#define MT9V032_AEC_UPDATE_FREQUENCY			0xa6
+#define MT9V032_AEC_LPF					0xa8
+#define MT9V032_AGC_UPDATE_FREQUENCY			0xa9
+#define MT9V032_AGC_LPF					0xaa
 #define MT9V032_AEC_AGC_ENABLE				0xaf
 #define		MT9V032_AEC_ENABLE			(1 << 0)
 #define		MT9V032_AGC_ENABLE			(1 << 1)
+#define MT9V034_AEC_MAX_SHUTTER_WIDTH			0xad
+#define MT9V032_AEC_MAX_SHUTTER_WIDTH			0xbd
 #define MT9V032_THERMAL_INFO				0xc1
 
 enum mt9v032_model {
@@ -162,6 +169,8 @@ struct mt9v032_model_data {
 	unsigned int min_shutter;
 	unsigned int max_shutter;
 	unsigned int pclk_reg;
+	unsigned int aec_max_shutter_reg;
+	const struct v4l2_ctrl_config * const aec_max_shutter_v4l2_ctrl;
 };
 
 struct mt9v032_model_info {
@@ -175,6 +184,9 @@ static const struct mt9v032_model_version mt9v032_versions[] = {
 	{ MT9V034_CHIP_ID_REV1, "MT9V024/MT9V034 rev1" },
 };
 
+static const struct v4l2_ctrl_config mt9v032_aec_max_shutter_width;
+static const struct v4l2_ctrl_config mt9v034_aec_max_shutter_width;
+
 static const struct mt9v032_model_data mt9v032_model_data[] = {
 	{
 		/* MT9V022, MT9V032 revisions 1/2/3 */
@@ -185,6 +197,8 @@ static const struct mt9v032_model_data mt9v032_model_data[] = {
 		.min_shutter = MT9V032_TOTAL_SHUTTER_WIDTH_MIN,
 		.max_shutter = MT9V032_TOTAL_SHUTTER_WIDTH_MAX,
 		.pclk_reg = MT9V032_PIXEL_CLOCK,
+		.aec_max_shutter_reg = MT9V032_AEC_MAX_SHUTTER_WIDTH,
+		.aec_max_shutter_v4l2_ctrl = &mt9v032_aec_max_shutter_width,
 	}, {
 		/* MT9V024, MT9V034 */
 		.min_row_time = 690,
@@ -194,6 +208,8 @@ static const struct mt9v032_model_data mt9v032_model_data[] = {
 		.min_shutter = MT9V034_TOTAL_SHUTTER_WIDTH_MIN,
 		.max_shutter = MT9V034_TOTAL_SHUTTER_WIDTH_MAX,
 		.pclk_reg = MT9V034_PIXEL_CLOCK,
+		.aec_max_shutter_reg = MT9V034_AEC_MAX_SHUTTER_WIDTH,
+		.aec_max_shutter_v4l2_ctrl = &mt9v034_aec_max_shutter_width,
 	},
 };
 
@@ -647,6 +663,33 @@ static int mt9v032_set_selection(struct v4l2_subdev *subdev,
  */
 
 #define V4L2_CID_TEST_PATTERN_COLOR	(V4L2_CID_USER_BASE | 0x1001)
+/*
+ * Value between 1 and 64 to set the desired bin. This is effectively a measure
+ * of how bright the image is supposed to be. Both AGC and AEC try to reach
+ * this.
+ */
+#define V4L2_CID_AEGC_DESIRED_BIN		(V4L2_CID_USER_BASE | 0x1002)
+/*
+ * LPF is the low pass filter capability of the chip. Both AEC and AGC have
+ * this setting. This limits the speed in which AGC/AEC adjust their settings.
+ * Possible values are 0-2. 0 means no LPF. For 1 and 2 this equation is used:
+ * 	if |(Calculated new exp - current exp)| > (current exp / 4)
+ * 		next exp = Calculated new exp
+ * 	else
+ * 		next exp = Current exp + ((Calculated new exp - current exp) / 2^LPF)
+ */
+#define V4L2_CID_AEC_LPF		(V4L2_CID_USER_BASE | 0x1003)
+#define V4L2_CID_AGC_LPF		(V4L2_CID_USER_BASE | 0x1004)
+/*
+ * Value between 0 and 15. This is the number of frames being skipped before
+ * updating the auto exposure/gain.
+ */
+#define V4L2_CID_AEC_UPDATE_INTERVAL	(V4L2_CID_USER_BASE | 0x1005)
+#define V4L2_CID_AGC_UPDATE_INTERVAL	(V4L2_CID_USER_BASE | 0x1006)
+/*
+ * Maximum shutter width used for AEC.
+ */
+#define V4L2_CID_AEC_MAX_SHUTTER_WIDTH	(V4L2_CID_USER_BASE | 0x1007)
 
 static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
 {
@@ -716,6 +759,28 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
 			break;
 		}
 		return regmap_write(map, MT9V032_TEST_PATTERN, data);
+
+	case V4L2_CID_AEGC_DESIRED_BIN:
+		return regmap_write(map, MT9V032_AEGC_DESIRED_BIN, ctrl->val);
+
+	case V4L2_CID_AEC_LPF:
+		return regmap_write(map, MT9V032_AEC_LPF, ctrl->val);
+
+	case V4L2_CID_AGC_LPF:
+		return regmap_write(map, MT9V032_AGC_LPF, ctrl->val);
+
+	case V4L2_CID_AEC_UPDATE_INTERVAL:
+		return regmap_write(map, MT9V032_AEC_UPDATE_FREQUENCY,
+				    ctrl->val);
+
+	case V4L2_CID_AGC_UPDATE_INTERVAL:
+		return regmap_write(map, MT9V032_AGC_UPDATE_FREQUENCY,
+				    ctrl->val);
+
+	case V4L2_CID_AEC_MAX_SHUTTER_WIDTH:
+		return regmap_write(map,
+				    mt9v032->model->data->aec_max_shutter_reg,
+				    ctrl->val);
 	}
 
 	return 0;
@@ -745,6 +810,84 @@ static const struct v4l2_ctrl_config mt9v032_test_pattern_color = {
 	.flags		= 0,
 };
 
+static const struct v4l2_ctrl_config mt9v032_aegc_controls[] = {
+	{
+		.ops		= &mt9v032_ctrl_ops,
+		.id		= V4L2_CID_AEGC_DESIRED_BIN,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "aec_agc_desired_bin",
+		.min		= 1,
+		.max		= 64,
+		.step		= 1,
+		.def		= 58,
+		.flags		= 0,
+	}, {
+		.ops		= &mt9v032_ctrl_ops,
+		.id		= V4L2_CID_AEC_LPF,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "aec_lpf",
+		.min		= 0,
+		.max		= 2,
+		.step		= 1,
+		.def		= 0,
+		.flags		= 0,
+	}, {
+		.ops		= &mt9v032_ctrl_ops,
+		.id		= V4L2_CID_AGC_LPF,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "agc_lpf",
+		.min		= 0,
+		.max		= 2,
+		.step		= 1,
+		.def		= 2,
+		.flags		= 0,
+	}, {
+		.ops		= &mt9v032_ctrl_ops,
+		.id		= V4L2_CID_AEC_UPDATE_INTERVAL,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "aec_update_interval",
+		.min		= 0,
+		.max		= 16,
+		.step		= 1,
+		.def		= 2,
+		.flags		= 0,
+	}, {
+		.ops		= &mt9v032_ctrl_ops,
+		.id		= V4L2_CID_AGC_UPDATE_INTERVAL,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "agc_update_interval",
+		.min		= 0,
+		.max		= 16,
+		.step		= 1,
+		.def		= 2,
+		.flags		= 0,
+	}
+};
+
+static const struct v4l2_ctrl_config mt9v032_aec_max_shutter_width = {
+	.ops		= &mt9v032_ctrl_ops,
+	.id		= V4L2_CID_AEC_MAX_SHUTTER_WIDTH,
+	.type		= V4L2_CTRL_TYPE_INTEGER,
+	.name		= "aec_max_shutter_width",
+	.min		= 1,
+	.max		= MT9V032_TOTAL_SHUTTER_WIDTH_MAX,
+	.step		= 1,
+	.def		= MT9V032_TOTAL_SHUTTER_WIDTH_DEF,
+	.flags		= 0,
+};
+
+static const struct v4l2_ctrl_config mt9v034_aec_max_shutter_width = {
+	.ops		= &mt9v032_ctrl_ops,
+	.id		= V4L2_CID_AEC_MAX_SHUTTER_WIDTH,
+	.type		= V4L2_CTRL_TYPE_INTEGER,
+	.name		= "aec_max_shutter_width",
+	.min		= 1,
+	.max		= MT9V034_TOTAL_SHUTTER_WIDTH_MAX,
+	.step		= 1,
+	.def		= MT9V032_TOTAL_SHUTTER_WIDTH_DEF,
+	.flags		= 0,
+};
+
 /* -----------------------------------------------------------------------------
  * V4L2 subdev core operations
  */
@@ -986,7 +1129,8 @@ static int mt9v032_probe(struct i2c_client *client,
 	mt9v032->pdata = pdata;
 	mt9v032->model = (const void *)did->driver_data;
 
-	v4l2_ctrl_handler_init(&mt9v032->ctrls, 10);
+	v4l2_ctrl_handler_init(&mt9v032->ctrls, 11 +
+			       ARRAY_SIZE(mt9v032_aegc_controls));
 
 	v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
 			  V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
@@ -1015,6 +1159,13 @@ static int mt9v032_probe(struct i2c_client *client,
 	mt9v032->test_pattern_color = v4l2_ctrl_new_custom(&mt9v032->ctrls,
 				      &mt9v032_test_pattern_color, NULL);
 
+	v4l2_ctrl_new_custom(&mt9v032->ctrls,
+			     mt9v032->model->data->aec_max_shutter_v4l2_ctrl,
+			     NULL);
+	for (i = 0; i != ARRAY_SIZE(mt9v032_aegc_controls); ++i)
+		v4l2_ctrl_new_custom(&mt9v032->ctrls, &mt9v032_aegc_controls[i],
+				     NULL);
+
 	v4l2_ctrl_cluster(2, &mt9v032->test_pattern);
 
 	mt9v032->pixel_rate =
-- 
2.6.2

