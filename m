Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:33993 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1424937AbeCBOfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 09:35:13 -0500
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
Subject: [PATCH 11/12] media: ov5640: Add 60 fps support
Date: Fri,  2 Mar 2018 15:34:59 +0100
Message-Id: <20180302143500.32650-12-maxime.ripard@bootlin.com>
In-Reply-To: <20180302143500.32650-1-maxime.ripard@bootlin.com>
References: <20180302143500.32650-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have everything in place to compute the clock rate at runtime,
we can enable the 60fps framerate for the mode we tested it with.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 5510a19281a4..03838f42fb82 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -111,6 +111,7 @@ enum ov5640_mode_id {
 enum ov5640_frame_rate {
 	OV5640_15_FPS = 0,
 	OV5640_30_FPS,
+	OV5640_60_FPS,
 	OV5640_NUM_FRAMERATES,
 };
 
@@ -144,6 +145,7 @@ MODULE_PARM_DESC(virtual_channel,
 static const int ov5640_framerates[] = {
 	[OV5640_15_FPS] = 15,
 	[OV5640_30_FPS] = 30,
+	[OV5640_60_FPS] = 60,
 };
 
 /* regulator supplies */
@@ -1447,6 +1449,11 @@ ov5640_find_mode(struct ov5640_dev *sensor, enum ov5640_frame_rate fr,
 	    fr != OV5640_15_FPS)
 		return NULL;
 
+	/* Only 640x480 can operate at 60fps (for now) */
+	if (fr == OV5640_60_FPS &&
+	    width != 640 && height != 480)
+		return NULL;
+
 	return mode;
 }
 
@@ -1875,12 +1882,12 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
 	int ret;
 
 	minfps = ov5640_framerates[OV5640_15_FPS];
-	maxfps = ov5640_framerates[OV5640_30_FPS];
+	maxfps = ov5640_framerates[OV5640_60_FPS];
 
 	if (fi->numerator == 0) {
 		fi->denominator = maxfps;
 		fi->numerator = 1;
-		return OV5640_30_FPS;
+		return OV5640_60_FPS;
 	}
 
 	fps = DIV_ROUND_CLOSEST(fi->denominator, fi->numerator);
@@ -1892,10 +1899,13 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
 		fi->denominator = minfps;
 	else if (2 * fps >= 2 * minfps + (maxfps - minfps))
 		fi->denominator = maxfps;
-	else
-		fi->denominator = minfps;
 
-	ret = (fi->denominator == minfps) ? OV5640_15_FPS : OV5640_30_FPS;
+	if (fi->denominator == minfps)
+		ret = OV5640_15_FPS;
+	else if (fi->denominator == maxfps)
+		ret = OV5640_60_FPS;
+	else
+		ret = OV5640_30_FPS;
 
 	mode = ov5640_find_mode(sensor, ret, width, height, false);
 	return mode ? ret : -EINVAL;
-- 
2.14.3
