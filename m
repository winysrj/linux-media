Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:60036 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932792AbeFRIHQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 04:07:16 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 2/2] media: ov5645: Report number of skip frames
Date: Mon, 18 Jun 2018 11:06:59 +0300
Message-Id: <1529309219-27404-2-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1529309219-27404-1-git-send-email-todor.tomov@linaro.org>
References: <1529309219-27404-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The OV5645 supports automatic exposure (AE) and automatic white
balance (AWB). When streaming is started it takes up to 5 frames
until the AE and AWB converge and output a frame with good quality.

Implement g_skip_frames to report number of frames to be skipped
when streaming is started.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/i2c/ov5645.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
index 1722cda..00bc3c0 100644
--- a/drivers/media/i2c/ov5645.c
+++ b/drivers/media/i2c/ov5645.c
@@ -70,6 +70,9 @@
 #define OV5645_SDE_SAT_U		0x5583
 #define OV5645_SDE_SAT_V		0x5584
 
+/* Number of frames needed for AE and AWB to converge */
+#define OV5645_NUM_OF_SKIP_FRAMES 5
+
 struct reg_value {
 	u16 reg;
 	u8 val;
@@ -1071,6 +1074,13 @@ static int ov5645_s_stream(struct v4l2_subdev *subdev, int enable)
 	return 0;
 }
 
+static int ov5645_get_skip_frames(struct v4l2_subdev *sd, u32 *frames)
+{
+	*frames = OV5645_NUM_OF_SKIP_FRAMES;
+
+	return 0;
+}
+
 static const struct v4l2_subdev_core_ops ov5645_core_ops = {
 	.s_power = ov5645_s_power,
 };
@@ -1088,10 +1098,15 @@ static const struct v4l2_subdev_pad_ops ov5645_subdev_pad_ops = {
 	.get_selection = ov5645_get_selection,
 };
 
+static const struct v4l2_subdev_sensor_ops ov5645_sensor_ops = {
+	.g_skip_frames = ov5645_get_skip_frames,
+};
+
 static const struct v4l2_subdev_ops ov5645_subdev_ops = {
 	.core = &ov5645_core_ops,
 	.video = &ov5645_video_ops,
 	.pad = &ov5645_subdev_pad_ops,
+	.sensor = &ov5645_sensor_ops,
 };
 
 static int ov5645_probe(struct i2c_client *client,
-- 
2.7.4
