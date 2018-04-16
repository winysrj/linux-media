Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53217 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754442AbeDPMh0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 08:37:26 -0400
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
Subject: [PATCH v2 11/12] media: ov5640: Add 60 fps support
Date: Mon, 16 Apr 2018 14:37:00 +0200
Message-Id: <20180416123701.15901-12-maxime.ripard@bootlin.com>
In-Reply-To: <20180416123701.15901-1-maxime.ripard@bootlin.com>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have everything in place to compute the clock rate at runtime,
we can enable the 60fps framerate for the mode we tested it with.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 690ed0238763..c01bbc5f9f34 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -112,6 +112,7 @@ enum ov5640_mode_id {
 enum ov5640_frame_rate {
 	OV5640_15_FPS = 0,
 	OV5640_30_FPS,
+	OV5640_60_FPS,
 	OV5640_NUM_FRAMERATES,
 };
 
@@ -140,6 +141,7 @@ MODULE_PARM_DESC(virtual_channel,
 static const int ov5640_framerates[] = {
 	[OV5640_15_FPS] = 15,
 	[OV5640_30_FPS] = 30,
+	[OV5640_60_FPS] = 60,
 };
 
 /* regulator supplies */
@@ -1398,12 +1400,19 @@ ov5640_find_mode(struct ov5640_dev *sensor, enum ov5640_frame_rate fr,
 				/* try to find another mode */
 				continue;
 
+			/* Only 640x480 can operate at 60fps (for now) */
+			if (fr == OV5640_60_FPS &&
+			    width != 640 && height != 480)
+				/* try to find another mode */
+				continue;
+
 			break;
 		}
 	}
 
+	/* VGA is the only mode that supports all the framerates */
 	if (nearest && i < 0)
-		mode = &ov5640_mode_data[0];
+		mode = &ov5640_mode_data[OV5640_MODE_VGA_640_480];
 
 	return mode;
 }
@@ -1848,12 +1857,13 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
 	int ret;
 
 	minfps = ov5640_framerates[OV5640_15_FPS];
-	maxfps = ov5640_framerates[OV5640_30_FPS];
+	maxfps = ov5640_framerates[OV5640_60_FPS];
 
 	if (fi->numerator == 0) {
 		fi->denominator = maxfps;
 		fi->numerator = 1;
-		return OV5640_30_FPS;
+		ret = OV5640_60_FPS;
+		goto find_mode;
 	}
 
 	fps = DIV_ROUND_CLOSEST(fi->denominator, fi->numerator);
@@ -1865,11 +1875,15 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
 		fi->denominator = minfps;
 	else if (2 * fps >= 2 * minfps + (maxfps - minfps))
 		fi->denominator = maxfps;
+
+	if (fi->denominator == minfps)
+		ret = OV5640_15_FPS;
+	else if (fi->denominator == maxfps)
+		ret = OV5640_60_FPS;
 	else
-		fi->denominator = minfps;
-
-	ret = (fi->denominator == minfps) ? OV5640_15_FPS : OV5640_30_FPS;
+		ret = OV5640_30_FPS;
 
+find_mode:
 	mode = ov5640_find_mode(sensor, ret, width, height, false);
 	return mode ? ret : -EINVAL;
 }
@@ -2458,8 +2472,11 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
 
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
