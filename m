Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46548 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab3ILMIW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 08:08:22 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: s.nawrocki@samsung.com, hverkuil@xs4all.nl, swarren@wwwdotorg.org,
	mark.rutland@arm.com, Pawel.Moll@arm.com, galak@codeaurora.org,
	a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v8 11/12] V4L: s5k6a3: Change sensor min/max resolutions
Date: Thu, 12 Sep 2013 17:37:48 +0530
Message-Id: <1378987669-10870-12-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1378987669-10870-1-git-send-email-arun.kk@samsung.com>
References: <1378987669-10870-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

s5k6a3 sensor has actual pixel resolution of 1408x1402 against
the active resolution 1392x1392. The real resolution is needed
when raw sensor SRGB data is dumped to memory by fimc-lite.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/s5k6a3.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
index ccbb4fc..e70e217 100644
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
-- 
1.7.9.5

