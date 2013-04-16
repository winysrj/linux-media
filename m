Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:55392 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3DPGOs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 02:14:48 -0400
Received: by mail-da0-f42.google.com with SMTP id n15so94399dad.1
        for <linux-media@vger.kernel.org>; Mon, 15 Apr 2013 23:14:48 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 4/5] [media] exynos4-is: Initialize 'sensor' before using
Date: Tue, 16 Apr 2013 11:32:22 +0530
Message-Id: <1366092143-5482-4-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1366092143-5482-1-git-send-email-sachin.kamat@linaro.org>
References: <1366092143-5482-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing initialization code to the 'sensor' data
structure variable before using it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Only compile tested.
---
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-sensor.c b/drivers/media/platform/exynos4-is/fimc-is-sensor.c
index 02b2719..bda9093 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-sensor.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-sensor.c
@@ -268,7 +268,8 @@ err_gpio:
 
 static int fimc_is_sensor_remove(struct i2c_client *client)
 {
-	struct fimc_is_sensor *sensor;
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
 
 	regulator_bulk_free(SENSOR_NUM_SUPPLIES, sensor->supplies);
 	media_entity_cleanup(&sensor->subdev.entity);
-- 
1.7.9.5

