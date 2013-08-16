Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:39325 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab3HPJVc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Aug 2013 05:21:32 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: s.nawrocki@samsung.com, hverkuil@xs4all.nl, swarren@wwwdotorg.org,
	mark.rutland@arm.com, a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v6 12/13] V4L: s5k6a3: Change sensor min/max resolutions
Date: Fri, 16 Aug 2013 14:50:44 +0530
Message-Id: <1376644845-10422-13-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1376644845-10422-1-git-send-email-arun.kk@samsung.com>
References: <1376644845-10422-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

s5k6a3 sensor has actual pixel resolution of 1408x1402 against
the active resolution 1392x1392. The real resolution is needed
when raw sensor SRGB data is dumped to memory by fimc-lite.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/s5k6a3.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
index ccbb4fc..34c3165 100644
--- a/drivers/media/i2c/s5k6a3.c
+++ b/drivers/media/i2c/s5k6a3.c
@@ -25,10 +25,12 @@
 #include <media/v4l2-async.h>
 #include <media/v4l2-subdev.h>
 
-#define S5K6A3_SENSOR_MAX_WIDTH		1392
-#define S5K6A3_SENSOR_MAX_HEIGHT	1392
-#define S5K6A3_SENSOR_MIN_WIDTH		32
-#define S5K6A3_SENSOR_MIN_HEIGHT	32
+#define S5K6A3_SENSOR_MAX_WIDTH		1408
+#define S5K6A3_SENSOR_MAX_HEIGHT	1402
+#define S5K6A3_SENSOR_ACTIVE_WIDTH	1392
+#define S5K6A3_SENSOR_ACTIVE_HEIGHT	1392
+#define S5K6A3_SENSOR_MIN_WIDTH		(32 + 16)
+#define S5K6A3_SENSOR_MIN_HEIGHT	(32 + 10)
 
 #define S5K6A3_DEF_PIX_WIDTH		1296
 #define S5K6A3_DEF_PIX_HEIGHT		732
@@ -107,10 +109,11 @@ static void s5k6a3_try_format(struct v4l2_mbus_framefmt *mf)
 
 	fmt = find_sensor_format(mf);
 	mf->code = fmt->code;
-	v4l_bound_align_image(&mf->width, S5K6A3_SENSOR_MIN_WIDTH,
-			      S5K6A3_SENSOR_MAX_WIDTH, 0,
-			      &mf->height, S5K6A3_SENSOR_MIN_HEIGHT,
-			      S5K6A3_SENSOR_MAX_HEIGHT, 0, 0);
+	v4l_bound_align_image(&mf->width,
+			S5K6A3_SENSOR_MIN_WIDTH, S5K6A3_SENSOR_MAX_WIDTH, 0,
+			&mf->height,
+			S5K6A3_SENSOR_MIN_HEIGHT, S5K6A3_SENSOR_MAX_HEIGHT, 0,
+			0);
 }
 
 static struct v4l2_mbus_framefmt *__s5k6a3_get_format(
-- 
1.7.9.5

