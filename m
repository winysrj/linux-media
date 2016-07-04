Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:46705 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305AbcGDIco (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:32:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 9/9] v4l2-subdev: rename cropcap to g_pixelaspect
Date: Mon,  4 Jul 2016 10:32:22 +0200
Message-Id: <1467621142-8064-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621142-8064-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621142-8064-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The old cropcap video op is now only used to pass the pixelaspect
ratio, so rename it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7180.c                 | 12 ++++++------
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  2 +-
 include/media/v4l2-subdev.h                 |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index b77b0a4..38f4fc3 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -725,16 +725,16 @@ static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7180_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *cropcap)
+static int adv7180_g_pixelaspect(struct v4l2_subdev *sd, struct v4l2_fract *aspect)
 {
 	struct adv7180_state *state = to_state(sd);
 
 	if (state->curr_norm & V4L2_STD_525_60) {
-		cropcap->pixelaspect.numerator = 11;
-		cropcap->pixelaspect.denominator = 10;
+		aspect->numerator = 11;
+		aspect->denominator = 10;
 	} else {
-		cropcap->pixelaspect.numerator = 54;
-		cropcap->pixelaspect.denominator = 59;
+		aspect->numerator = 54;
+		aspect->denominator = 59;
 	}
 
 	return 0;
@@ -787,7 +787,7 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.g_input_status = adv7180_g_input_status,
 	.s_routing = adv7180_s_routing,
 	.g_mbus_config = adv7180_g_mbus_config,
-	.cropcap = adv7180_cropcap,
+	.g_pixelaspect = adv7180_g_pixelaspect,
 	.g_tvnorms = adv7180_g_tvnorms,
 	.s_stream = adv7180_s_stream,
 };
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 10a5c10..b685996 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -381,7 +381,7 @@ static int rvin_cropcap(struct file *file, void *priv,
 	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	return v4l2_subdev_call(sd, video, cropcap, crop);
+	return v4l2_subdev_call(sd, video, g_pixelaspect, &crop->pixelaspect);
 }
 
 static int rvin_enum_input(struct file *file, void *priv,
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 5f79e3c..7f00016 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -359,7 +359,7 @@ struct v4l2_mbus_frame_desc {
  * @s_stream: used to notify the driver that a video stream will start or has
  *	stopped.
  *
- * @cropcap: callback for VIDIOC_CROPCAP ioctl handler code.
+ * @g_pixelaspect: callback to return the pixelaspect ratio.
  *
  * @g_parm: callback for VIDIOC_G_PARM ioctl handler code.
  *
@@ -399,7 +399,7 @@ struct v4l2_subdev_video_ops {
 	int (*g_tvnorms_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
 	int (*g_input_status)(struct v4l2_subdev *sd, u32 *status);
 	int (*s_stream)(struct v4l2_subdev *sd, int enable);
-	int (*cropcap)(struct v4l2_subdev *sd, struct v4l2_cropcap *cc);
+	int (*g_pixelaspect)(struct v4l2_subdev *sd, struct v4l2_fract *aspect);
 	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*g_frame_interval)(struct v4l2_subdev *sd,
-- 
2.8.1

