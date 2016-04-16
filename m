Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34933 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbcDPIMi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Apr 2016 04:12:38 -0400
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi, mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [PATCH] [media] smiapp: provide g_skip_top_lines method in sensor ops
Date: Sat, 16 Apr 2016 11:12:20 +0300
Message-Id: <1460794340-490-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some sensors (like the one in Nokia N900) provide metadata in the first
couple of lines. Make that information information available to the
pipeline.

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 12 ++++++++++++
 drivers/media/i2c/smiapp/smiapp.h      |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index a215efe..3dfe387 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -188,6 +188,8 @@ static int smiapp_read_frame_fmt(struct smiapp_sensor *sensor)
 		embedded_end = 0;
 	}
 
+	sensor->image_start = image_start;
+
 	dev_dbg(&client->dev, "embedded data from lines %d to %d\n",
 		embedded_start, embedded_end);
 	dev_dbg(&client->dev, "image data starts at line %d\n", image_start);
@@ -2280,6 +2282,15 @@ static int smiapp_get_skip_frames(struct v4l2_subdev *subdev, u32 *frames)
 	return 0;
 }
 
+static int smiapp_get_skip_top_lines(struct v4l2_subdev *subdev, u32 *lines)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+
+	*lines = sensor->image_start;
+
+	return 0;
+}
+
 /* -----------------------------------------------------------------------------
  * sysfs attributes
  */
@@ -2890,6 +2901,7 @@ static const struct v4l2_subdev_pad_ops smiapp_pad_ops = {
 
 static const struct v4l2_subdev_sensor_ops smiapp_sensor_ops = {
 	.g_skip_frames = smiapp_get_skip_frames,
+	.g_skip_top_lines = smiapp_get_skip_top_lines,
 };
 
 static const struct v4l2_subdev_ops smiapp_ops = {
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index f6af0cc..c8b4ca0 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -217,6 +217,7 @@ struct smiapp_sensor {
 
 	u8 hvflip_inv_mask; /* H/VFLIP inversion due to sensor orientation */
 	u8 frame_skip;
+	u32 image_start;	/* Offset to first line after metadata lines */
 
 	int power_count;
 
-- 
1.9.1

