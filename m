Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51463 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbeLCIot (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 03:44:49 -0500
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
        Jacopo Mondi <jacopo@jmondi.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v6 11/12] media: ov5640: Add 60 fps support
Date: Mon,  3 Dec 2018 09:44:26 +0100
Message-Id: <a8de32518b433f62064447236fcb7fe9b6c2af7d.1543826654.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
References: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have everything in place to compute the clock rate at runtime,
we can enable the 60fps framerate for the mode we tested it with.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Tested-by: Adam Ford <aford173@gmail.com> #imx6dq
---
 drivers/media/i2c/ov5640.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 93fa072135ad..6391ea4f712c 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -111,6 +111,7 @@ enum ov5640_mode_id {
 enum ov5640_frame_rate {
 	OV5640_15_FPS = 0,
 	OV5640_30_FPS,
+	OV5640_60_FPS,
 	OV5640_NUM_FRAMERATES,
 };
 
@@ -139,6 +140,7 @@ MODULE_PARM_DESC(virtual_channel,
 static const int ov5640_framerates[] = {
 	[OV5640_15_FPS] = 15,
 	[OV5640_30_FPS] = 30,
+	[OV5640_60_FPS] = 60,
 };
 
 /* regulator supplies */
@@ -1562,6 +1564,11 @@ ov5640_find_mode(struct ov5640_dev *sensor, enum ov5640_frame_rate fr,
 	    (!nearest && (mode->hact != width || mode->vact != height)))
 		return NULL;
 
+	/* Only 640x480 can operate at 60fps (for now) */
+	if (fr == OV5640_60_FPS &&
+	    !(mode->hact == 640 && mode->vact == 480))
+		return NULL;
+
 	return mode;
 }
 
@@ -2057,12 +2064,13 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
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
@@ -2081,6 +2089,7 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
 	fi->numerator = 1;
 	fi->denominator = best_fps;
 
+find_mode:
 	mode = ov5640_find_mode(sensor, rate, width, height, false);
 	return mode ? rate : -EINVAL;
 }
@@ -2699,8 +2708,11 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
 
 	frame_rate = ov5640_try_frame_interval(sensor, &fi->interval,
 					       mode->hact, mode->vact);
-	if (frame_rate < 0)
-		frame_rate = OV5640_15_FPS;
+	if (frame_rate < 0) {
+		/* Always return a valid frame interval value */
+		fi->interval = sensor->frame_interval;
+		goto out;
+	}
 
 	mode = ov5640_find_mode(sensor, frame_rate, mode->hact,
 				mode->vact, true);
-- 
git-series 0.9.1
