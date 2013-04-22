Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:59891 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3DVOGA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 10:06:00 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLN006ONTTN4QE0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Apr 2013 23:05:59 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 05/12] exynos4-is: Fix regulator/gpio resource releasing on the
 driver removal
Date: Mon, 22 Apr 2013 16:03:40 +0200
Message-id: <1366639427-14253-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
References: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove regulator_bulk_free() calls as devm_regulator_bulk_get() function
is used to get the regulators so those will be freed automatically while
the driver is removed.
Missing gpio free is fixed by requesting a gpio with the devm_* API.
All that is done now in the I2C client driver remove() callback is the
media entity cleanup call.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |   26 ++++++--------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-sensor.c b/drivers/media/platform/exynos4-is/fimc-is-sensor.c
index 6b3ea54..035fa14 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-sensor.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-sensor.c
@@ -216,7 +216,8 @@ static int fimc_is_sensor_probe(struct i2c_client *client,
 
 	gpio = of_get_gpio_flags(dev->of_node, 0, NULL);
 	if (gpio_is_valid(gpio)) {
-		ret = gpio_request_one(gpio, GPIOF_OUT_INIT_LOW, DRIVER_NAME);
+		ret = devm_gpio_request_one(dev, gpio, GPIOF_OUT_INIT_LOW,
+							DRIVER_NAME);
 		if (ret < 0)
 			return ret;
 	}
@@ -228,13 +229,11 @@ static int fimc_is_sensor_probe(struct i2c_client *client,
 	ret = devm_regulator_bulk_get(&client->dev, SENSOR_NUM_SUPPLIES,
 				      sensor->supplies);
 	if (ret < 0)
-		goto err_gpio;
+		return ret;
 
 	of_id = of_match_node(fimc_is_sensor_of_match, dev->of_node);
-	if (!of_id) {
-		ret = -ENODEV;
-		goto err_reg;
-	}
+	if (!of_id)
+		return -ENODEV;
 
 	sensor->drvdata = of_id->data;
 	sensor->dev = dev;
@@ -251,28 +250,19 @@ static int fimc_is_sensor_probe(struct i2c_client *client,
 	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_init(&sd->entity, 1, &sensor->pad, 0);
 	if (ret < 0)
-		goto err_reg;
+		return ret;
 
 	v4l2_set_subdevdata(sd, sensor);
 	pm_runtime_no_callbacks(dev);
 	pm_runtime_enable(dev);
 
-	return 0;
-err_reg:
-	regulator_bulk_free(SENSOR_NUM_SUPPLIES, sensor->supplies);
-err_gpio:
-	if (gpio_is_valid(sensor->gpio_reset))
-		gpio_free(sensor->gpio_reset);
 	return ret;
 }
 
 static int fimc_is_sensor_remove(struct i2c_client *client)
 {
-	struct fimc_is_sensor *sensor;
-
-	regulator_bulk_free(SENSOR_NUM_SUPPLIES, sensor->supplies);
-	media_entity_cleanup(&sensor->subdev.entity);
-
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	media_entity_cleanup(&sd->entity);
 	return 0;
 }
 
-- 
1.7.9.5

