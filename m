Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:46708 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728357AbeJKQrz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 12:47:55 -0400
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
Subject: [PATCH v4 09/12] media: ov5640: Make the FPS clamping / rounding more extendable
Date: Thu, 11 Oct 2018 11:21:04 +0200
Message-Id: <20181011092107.30715-10-maxime.ripard@bootlin.com>
In-Reply-To: <20181011092107.30715-1-maxime.ripard@bootlin.com>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current code uses an algorithm to clamp the FPS values and round them
to the closest supported one that isn't really allows to be extended to
more than two values.

Rework it a bit to make it much easier to extend the amount of FPS options
we support.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index d7a1e1928baf..b2206fa71b0d 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1976,7 +1976,8 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
 {
 	const struct ov5640_mode_info *mode;
 	enum ov5640_frame_rate rate = OV5640_30_FPS;
-	u32 minfps, maxfps, fps;
+	int minfps, maxfps, best_fps, fps;
+	int i;
 
 	minfps = ov5640_framerates[OV5640_15_FPS];
 	maxfps = ov5640_framerates[OV5640_30_FPS];
@@ -1987,19 +1988,21 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
 		return OV5640_30_FPS;
 	}
 
-	fps = DIV_ROUND_CLOSEST(fi->denominator, fi->numerator);
+	fps = clamp_val(DIV_ROUND_CLOSEST(fi->denominator, fi->numerator),
+			minfps, maxfps);
+
+	best_fps = minfps;
+	for (i = 0; i < ARRAY_SIZE(ov5640_framerates); i++) {
+		int curr_fps = ov5640_framerates[i];
+
+		if (abs(curr_fps - fps) < abs(best_fps - fps)) {
+			best_fps = curr_fps;
+			rate = i;
+		}
+	}
 
 	fi->numerator = 1;
-	if (fps > maxfps)
-		fi->denominator = maxfps;
-	else if (fps < minfps)
-		fi->denominator = minfps;
-	else if (2 * fps >= 2 * minfps + (maxfps - minfps))
-		fi->denominator = maxfps;
-	else
-		fi->denominator = minfps;
-
-	rate = (fi->denominator == minfps) ? OV5640_15_FPS : OV5640_30_FPS;
+	fi->denominator = best_fps;
 
 	mode = ov5640_find_mode(sensor, rate, width, height, false);
 	return mode ? rate : -EINVAL;
-- 
2.19.1
