Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:63059 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3DVOGN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 10:06:13 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLN00CYJTUCUVI0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Apr 2013 23:06:12 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 06/12] exynos4-is: Don't overwrite subdevdata in the fimc-is
 sensor driver
Date: Mon, 22 Apr 2013 16:03:41 +0200
Message-id: <1366639427-14253-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
References: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's an I2C client driver and it must not overwrite the struct v4l2_subdev
dev_priv field, which is used by the v4l2 core to store a pointer to
struct i2c_client.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |    8 +-------
 drivers/media/platform/exynos4-is/fimc-is-sensor.h |    6 ++++++
 drivers/media/platform/exynos4-is/fimc-is.c        |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-sensor.c b/drivers/media/platform/exynos4-is/fimc-is-sensor.c
index 035fa14..6647421 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-sensor.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-sensor.c
@@ -40,11 +40,6 @@ static const struct v4l2_mbus_framefmt fimc_is_sensor_formats[] = {
 	}
 };
 
-static struct fimc_is_sensor *sd_to_fimc_is_sensor(struct v4l2_subdev *sd)
-{
-	return container_of(sd, struct fimc_is_sensor, subdev);
-}
-
 static const struct v4l2_mbus_framefmt *find_sensor_format(
 	struct v4l2_mbus_framefmt *mf)
 {
@@ -147,7 +142,7 @@ static const struct v4l2_subdev_internal_ops fimc_is_sensor_sd_internal_ops = {
 
 static int fimc_is_sensor_s_power(struct v4l2_subdev *sd, int on)
 {
-	struct fimc_is_sensor *sensor = v4l2_get_subdevdata(sd);
+	struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
 	int gpio = sensor->gpio_reset;
 	int ret;
 
@@ -252,7 +247,6 @@ static int fimc_is_sensor_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
-	v4l2_set_subdevdata(sd, sensor);
 	pm_runtime_no_callbacks(dev);
 	pm_runtime_enable(dev);
 
diff --git a/drivers/media/platform/exynos4-is/fimc-is-sensor.h b/drivers/media/platform/exynos4-is/fimc-is-sensor.h
index 50b8e4d..6036d49 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-sensor.h
+++ b/drivers/media/platform/exynos4-is/fimc-is-sensor.h
@@ -77,6 +77,12 @@ struct fimc_is_sensor {
 	struct v4l2_mbus_framefmt format;
 };
 
+static inline
+struct fimc_is_sensor *sd_to_fimc_is_sensor(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct fimc_is_sensor, subdev);
+}
+
 int fimc_is_register_sensor_driver(void);
 void fimc_is_unregister_sensor_driver(void);
 
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 3c81c88..c4049d4 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -220,7 +220,7 @@ static int fimc_is_register_subdevs(struct fimc_is *is)
 			if (WARN_ON(is->sensor))
 				continue;
 
-			is->sensor = v4l2_get_subdevdata(sd);
+			is->sensor = sd_to_fimc_is_sensor(sd);
 
 			if (fimc_is_parse_sensor_config(is->sensor, child)) {
 				dev_warn(&is->pdev->dev, "DT parse error: %s\n",
-- 
1.7.9.5

