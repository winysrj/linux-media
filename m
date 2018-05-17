Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43902 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751665AbeEQIyN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:54:13 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v3 11/12] media: ov5640: Add 60 fps support
Date: Thu, 17 May 2018 10:54:04 +0200
Message-Id: <20180517085405.10104-12-maxime.ripard@bootlin.com>
In-Reply-To: <20180517085405.10104-1-maxime.ripard@bootlin.com>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have everything in place to compute the clock rate at runtime,
we can enable the 60fps framerate for the mode we tested it with.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 0f6c39080d69..a8852ded60b6 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -109,6 +109,7 @@ enum ov5640_mode_id {
 enum ov5640_frame_rate {
 	OV5640_15_FPS = 0,
 	OV5640_30_FPS,
+	OV5640_60_FPS,
 	OV5640_NUM_FRAMERATES,
 };
 
@@ -137,6 +138,7 @@ MODULE_PARM_DESC(virtual_channel,
 static const int ov5640_framerates[] = {
 	[OV5640_15_FPS] = 15,
 	[OV5640_30_FPS] = 30,
+	[OV5640_60_FPS] = 60,
 };
 
 /* regulator supplies */
@@ -1439,12 +1441,23 @@ ov5640_find_mode(struct ov5640_dev *sensor, enum ov5640_frame_rate fr,
 				/* try to find another mode */
 				continue;
 
+			/* Only 640x480 can operate at 60fps (for now) */
+			if (fr == OV5640_60_FPS &&
+			    !(width == 640 && height == 480))
+				/* try to find another mode */
+				continue;
+
 			break;
 		}
 	}
 
-	if (nearest && i < 0)
-		mode = &ov5640_mode_data[0];
+	/* VGA is the only mode that supports all the framerates */
+	if (i < 0) {
+		if (!nearest)
+			return NULL;
+
+		mode = &ov5640_mode_data[OV5640_MODE_VGA_640_480];
+	}
 
 	return mode;
 }
@@ -1894,12 +1907,13 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
 	int i;
 
 	minfps = ov5640_framerates[OV5640_15_FPS];
-	maxfps = ov5640_framerates[OV5640_30_FPS];
+	maxfps = ov5640_framerates[OV5640_60_FPS];
 
 	if (fi->numerator == 0) {
 		fi->denominator = maxfps;
 		fi->numerator = 1;
-		return OV5640_30_FPS;
+		rate = OV5640_60_FPS;
+		goto find_mode;
 	}
 
 	fps = clamp_val(DIV_ROUND_CLOSEST(fi->denominator, fi->numerator),
@@ -1918,6 +1932,7 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
 	fi->numerator = 1;
 	fi->denominator = best_fps;
 
+find_mode:
 	mode = ov5640_find_mode(sensor, rate, width, height, false);
 	return mode ? rate : -EINVAL;
 }
@@ -2495,8 +2510,11 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
 
 	frame_rate = ov5640_try_frame_interval(sensor, &fi->interval,
 					       mode->hact, mode->vact);
-	if (frame_rate < 0)
-		frame_rate = OV5640_15_FPS;
+	if (frame_rate < 0) {
+		/* Always return a valid frame interval value */
+		fi->interval = sensor->frame_interval;
+		goto out;
+	}
 
 	sensor->current_fr = frame_rate;
 	sensor->frame_interval = fi->interval;
-- 
2.17.0
