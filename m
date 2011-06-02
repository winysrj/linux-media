Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38826 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1FBPhh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 11:37:37 -0400
From: Johannes Obermaier <johannes.obermaier@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Johannes Obermaier <johannes.obermaier@gmail.com>
Subject: [PATCH 2/2] V4L/DVB: mt9v011: Added exposure for mt9v011
Date: Thu,  2 Jun 2011 17:43:14 +0200
Message-Id: <1307029394-30525-1-git-send-email-johannes.obermaier@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There are problems when you use this camera/sensor in a very bright room or outside. The image is completely white, because it is overexposed. The driver uses a default value which is not suitable for all environments.
This patch makes it possible to adjust the exposure time by youself. I found out by logging the i2c-data, that the windows driver for this sensor is doing this, too.
I tested the camera on a sunny day and after adjusting the exposure time, I was able to see a very good image.

Signed-off-by: Johannes Obermaier <johannes.obermaier@gmail.com>
---
 drivers/media/video/mt9v011.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9v011.c b/drivers/media/video/mt9v011.c
index a6cf05a..fbbd018 100644
--- a/drivers/media/video/mt9v011.c
+++ b/drivers/media/video/mt9v011.c
@@ -59,6 +59,15 @@ static struct v4l2_queryctrl mt9v011_qctrl[] = {
 		.default_value = 0x0020,
 		.flags = 0,
 	}, {
+		.id = V4L2_CID_EXPOSURE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Exposure",
+		.minimum = 0,
+		.maximum = 2047,
+		.step = 1,
+		.default_value = 0x01fc,
+		.flags = 0,
+	}, {
 		.id = V4L2_CID_RED_BALANCE,
 		.type = V4L2_CTRL_TYPE_INTEGER,
 		.name = "Red Balance",
@@ -105,7 +114,7 @@ struct mt9v011 {
 	unsigned hflip:1;
 	unsigned vflip:1;
 
-	u16 global_gain, red_bal, blue_bal;
+	u16 global_gain, exposure, red_bal, blue_bal;
 };
 
 static inline struct mt9v011 *to_mt9v011(struct v4l2_subdev *sd)
@@ -184,6 +193,9 @@ static void set_balance(struct v4l2_subdev *sd)
 {
 	struct mt9v011 *core = to_mt9v011(sd);
 	u16 green1_gain, green2_gain, blue_gain, red_gain;
+	u16 exposure;
+
+	exposure = core->exposure;
 
 	green1_gain = core->global_gain;
 	green2_gain = core->global_gain;
@@ -198,6 +210,7 @@ static void set_balance(struct v4l2_subdev *sd)
 	mt9v011_write(sd, R2E_MT9V011_GREEN_2_GAIN,  green1_gain);
 	mt9v011_write(sd, R2C_MT9V011_BLUE_GAIN, blue_gain);
 	mt9v011_write(sd, R2D_MT9V011_RED_GAIN, red_gain);
+	mt9v011_write(sd, R09_MT9V011_SHUTTER_WIDTH, exposure);
 }
 
 static void calc_fps(struct v4l2_subdev *sd, u32 *numerator, u32 *denominator)
@@ -338,6 +351,9 @@ static int mt9v011_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	case V4L2_CID_GAIN:
 		ctrl->value = core->global_gain;
 		return 0;
+	case V4L2_CID_EXPOSURE:
+		ctrl->value = core->exposure;
+		return 0;
 	case V4L2_CID_RED_BALANCE:
 		ctrl->value = core->red_bal;
 		return 0;
@@ -392,6 +408,9 @@ static int mt9v011_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	case V4L2_CID_GAIN:
 		core->global_gain = ctrl->value;
 		break;
+	case V4L2_CID_EXPOSURE:
+		core->exposure = ctrl->value;
+		break;
 	case V4L2_CID_RED_BALANCE:
 		core->red_bal = ctrl->value;
 		break;
@@ -598,6 +617,7 @@ static int mt9v011_probe(struct i2c_client *c,
 	}
 
 	core->global_gain = 0x0024;
+	core->exposure = 0x01fc;
 	core->width  = 640;
 	core->height = 480;
 	core->xtal = 27000000;	/* Hz */
-- 
1.6.4.2

