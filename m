Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45297 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbeJYE4V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Oct 2018 00:56:21 -0400
Received: by mail-pg1-f196.google.com with SMTP id s3-v6so2852249pga.12
        for <linux-media@vger.kernel.org>; Wed, 24 Oct 2018 13:26:49 -0700 (PDT)
From: Tim Harvey <tharvey@gateworks.com>
To: Lars-Peter Clausen <lars@metafoo.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] media: adv7180: add g_skip_frames support
Date: Wed, 24 Oct 2018 13:25:51 -0700
Message-Id: <1540412751-19194-1-git-send-email-tharvey@gateworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The adv7180 produces 1 to 2 frames of garbage before proper sync is
established. This allows V4L2 drivers and apps to skip those.

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/media/i2c/adv7180.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 99697ba..6f3dc88 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -180,6 +180,9 @@
 
 #define V4L2_CID_ADV_FAST_SWITCH	(V4L2_CID_USER_ADV7180_BASE + 0x00)
 
+/* Initial number of frames to skip to avoid possible garbage */
+#define ADV7180_NUM_OF_SKIP_FRAMES       2
+
 struct adv7180_state;
 
 #define ADV7180_FLAG_RESET_POWERED	BIT(0)
@@ -769,6 +772,13 @@ static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int adv7180_get_skip_frames(struct v4l2_subdev *sd, u32 *frames)
+{
+	*frames = ADV7180_NUM_OF_SKIP_FRAMES;
+
+	return 0;
+}
+
 static int adv7180_g_pixelaspect(struct v4l2_subdev *sd, struct v4l2_fract *aspect)
 {
 	struct adv7180_state *state = to_state(sd);
@@ -849,10 +859,15 @@ static const struct v4l2_subdev_pad_ops adv7180_pad_ops = {
 	.get_fmt = adv7180_get_pad_format,
 };
 
+static const struct v4l2_subdev_sensor_ops adv7180_sensor_ops = {
+	.g_skip_frames = adv7180_get_skip_frames,
+};
+
 static const struct v4l2_subdev_ops adv7180_ops = {
 	.core = &adv7180_core_ops,
 	.video = &adv7180_video_ops,
 	.pad = &adv7180_pad_ops,
+	.sensor = &adv7180_sensor_ops,
 };
 
 static irqreturn_t adv7180_irq(int irq, void *devid)
-- 
2.7.4
