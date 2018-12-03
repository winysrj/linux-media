Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51418 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725918AbeLCIos (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 03:44:48 -0500
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
Subject: [PATCH v6 10/12] media: ov5640: Make the FPS clamping / rounding more extendable
Date: Mon,  3 Dec 2018 09:44:25 +0100
Message-Id: <7af3d5a7d538d04fab83fa482f9073651d3034c7.1543826654.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
References: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
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
Tested-by: Adam Ford <aford173@gmail.com> #imx6dq
---
 drivers/media/i2c/ov5640.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 6cdf5ee0e4fa..93fa072135ad 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2053,7 +2053,8 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
 {
 	const struct ov5640_mode_info *mode;
 	enum ov5640_frame_rate rate = OV5640_30_FPS;
-	u32 minfps, maxfps, fps;
+	int minfps, maxfps, best_fps, fps;
+	int i;
 
 	minfps = ov5640_framerates[OV5640_15_FPS];
 	maxfps = ov5640_framerates[OV5640_30_FPS];
@@ -2064,19 +2065,21 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
 		return OV5640_30_FPS;
 	}
 
-	fps = DIV_ROUND_CLOSEST(fi->denominator, fi->numerator);
+	fps = clamp_val(DIV_ROUND_CLOSEST(fi->denominator, fi->numerator),
+			minfps, maxfps);
 
-	fi->numerator = 1;
-	if (fps > maxfps)
-		fi->denominator = maxfps;
-	else if (fps < minfps)
-		fi->denominator = minfps;
-	else if (2 * fps >= 2 * minfps + (maxfps - minfps))
-		fi->denominator = maxfps;
-	else
-		fi->denominator = minfps;
+	best_fps = minfps;
+	for (i = 0; i < ARRAY_SIZE(ov5640_framerates); i++) {
+		int curr_fps = ov5640_framerates[i];
 
-	rate = (fi->denominator == minfps) ? OV5640_15_FPS : OV5640_30_FPS;
+		if (abs(curr_fps - fps) < abs(best_fps - fps)) {
+			best_fps = curr_fps;
+			rate = i;
+		}
+	}
+
+	fi->numerator = 1;
+	fi->denominator = best_fps;
 
 	mode = ov5640_find_mode(sensor, rate, width, height, false);
 	return mode ? rate : -EINVAL;
-- 
git-series 0.9.1
