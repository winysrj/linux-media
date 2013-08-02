Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53300 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3HBPDm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 11:03:42 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: s.nawrocki@samsung.com, hverkuil@xs4all.nl, a.hajda@samsung.com,
	sachin.kamat@linaro.org, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC v3 12/13] V4L: s5k6a3: Change sensor min/max resolutions
Date: Fri,  2 Aug 2013 20:32:41 +0530
Message-Id: <1375455762-22071-13-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1375455762-22071-1-git-send-email-arun.kk@samsung.com>
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

s5k6a3 sensor has actual pixel resolution of 1408x1402 against
the active resolution 1392x1392. The real resolution is needed
when raw sensor SRGB data is dumped to memory by fimc-lite.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/i2c/s5k6a3.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
index ccbb4fc..d81638d 100644
--- a/drivers/media/i2c/s5k6a3.c
+++ b/drivers/media/i2c/s5k6a3.c
@@ -30,6 +30,9 @@
 #define S5K6A3_SENSOR_MIN_WIDTH		32
 #define S5K6A3_SENSOR_MIN_HEIGHT	32
 
+#define S5K6A3_WIDTH_PADDING		16
+#define S5K6A3_HEIGHT_PADDING		10
+
 #define S5K6A3_DEF_PIX_WIDTH		1296
 #define S5K6A3_DEF_PIX_HEIGHT		732
 
@@ -107,10 +110,13 @@ static void s5k6a3_try_format(struct v4l2_mbus_framefmt *mf)
 
 	fmt = find_sensor_format(mf);
 	mf->code = fmt->code;
-	v4l_bound_align_image(&mf->width, S5K6A3_SENSOR_MIN_WIDTH,
-			      S5K6A3_SENSOR_MAX_WIDTH, 0,
-			      &mf->height, S5K6A3_SENSOR_MIN_HEIGHT,
-			      S5K6A3_SENSOR_MAX_HEIGHT, 0, 0);
+	v4l_bound_align_image(&mf->width,
+			S5K6A3_SENSOR_MIN_WIDTH + S5K6A3_WIDTH_PADDING,
+			S5K6A3_SENSOR_MAX_WIDTH + S5K6A3_WIDTH_PADDING, 0,
+			&mf->height,
+			S5K6A3_SENSOR_MIN_HEIGHT + S5K6A3_HEIGHT_PADDING,
+			S5K6A3_SENSOR_MAX_HEIGHT + S5K6A3_HEIGHT_PADDING, 0,
+			0);
 }
 
 static struct v4l2_mbus_framefmt *__s5k6a3_get_format(
-- 
1.7.9.5

