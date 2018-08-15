Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37322 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728885AbeHOQW3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 12:22:29 -0400
Received: by mail-wm0-f66.google.com with SMTP id n11-v6so1354007wmc.2
        for <linux-media@vger.kernel.org>; Wed, 15 Aug 2018 06:30:17 -0700 (PDT)
From: petrcvekcz@gmail.com
To: hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com
Cc: Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org, philipp.zabel@gmail.com
Subject: [PATCH v2 2/4] media: i2c: ov9640: drop soc_camera code and switch to v4l2_async
Date: Wed, 15 Aug 2018 15:30:25 +0200
Message-Id: <e92337feaf8f656fc8f5660cf3bcdfa88cc5629f.1534339750.git.petrcvekcz@gmail.com>
In-Reply-To: <cover.1534339750.git.petrcvekcz@gmail.com>
References: <cover.1534339750.git.petrcvekcz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Petr Cvek <petrcvekcz@gmail.com>

This patch removes the dependency on an obsoleted soc_camera from ov9640
driver and changes the code to be a standalone v4l2 async subdevice.
It also adds GPIO allocations for power and reset signals (as they are not
handled by soc_camera now).

The values for waiting on GPIOs (reset and power) settling down were taken
from the datasheet (> 1 ms after HW/SW reset). The upper limit was chosen
as an arbitrary value. Also one occurrence of mdelay() was changed to
msleep(). The delays were successfully tested on a real hardware.

The patch makes ov9640 sensor again compatible with the pxa_camera driver.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
---
 drivers/media/i2c/ov9640.c | 76 ++++++++++++++++++++++++++------------
 drivers/media/i2c/ov9640.h |  2 +
 2 files changed, 55 insertions(+), 23 deletions(-)

diff --git a/drivers/media/i2c/ov9640.c b/drivers/media/i2c/ov9640.c
index c63948989688..ae55d13233f0 100644
--- a/drivers/media/i2c/ov9640.c
+++ b/drivers/media/i2c/ov9640.c
@@ -9,6 +9,7 @@
  * Kuninori Morimoto <morimoto.kuninori@renesas.com>
  *
  * Based on ov7670 and soc_camera_platform driver,
+ * transition from soc_camera to pxa_camera based on mt9m111
  *
  * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
  * Copyright (C) 2008 Magnus Damm
@@ -27,10 +28,14 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
-#include <media/soc_camera.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
+
+#include <linux/gpio/consumer.h>
 
 #include "ov9640.h"
 
@@ -323,11 +328,23 @@ static int ov9640_set_register(struct v4l2_subdev *sd,
 
 static int ov9640_s_power(struct v4l2_subdev *sd, int on)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct ov9640_priv *priv = to_ov9640_sensor(sd);
-
-	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
+	int ret = 0;
+
+	if (on) {
+		gpiod_set_value(priv->gpio_power, 1);
+		usleep_range(1000, 2000);
+		ret = v4l2_clk_enable(priv->clk);
+		usleep_range(1000, 2000);
+		gpiod_set_value(priv->gpio_reset, 0);
+	} else {
+		gpiod_set_value(priv->gpio_reset, 1);
+		usleep_range(1000, 2000);
+		v4l2_clk_disable(priv->clk);
+		usleep_range(1000, 2000);
+		gpiod_set_value(priv->gpio_power, 0);
+	}
+	return ret;
 }
 
 /* select nearest higher resolution for capture */
@@ -475,7 +492,7 @@ static int ov9640_prog_dflt(struct i2c_client *client)
 	}
 
 	/* wait for the changes to actually happen, 140ms are not enough yet */
-	mdelay(150);
+	msleep(150);
 
 	return 0;
 }
@@ -631,14 +648,10 @@ static const struct v4l2_subdev_core_ops ov9640_core_ops = {
 static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
 		V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -667,18 +680,27 @@ static int ov9640_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov9640_priv *priv;
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	if (!ssdd) {
-		dev_err(&client->dev, "Missing platform_data for driver\n");
-		return -EINVAL;
-	}
-
-	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&client->dev, sizeof(*priv),
+			    GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	priv->gpio_power = devm_gpiod_get(&client->dev, "Camera power",
+					  GPIOD_OUT_LOW);
+	if (IS_ERR_OR_NULL(priv->gpio_power)) {
+		ret = PTR_ERR(priv->gpio_power);
+		return ret;
+	}
+
+	priv->gpio_reset = devm_gpiod_get(&client->dev, "Camera reset",
+					  GPIOD_OUT_HIGH);
+	if (IS_ERR_OR_NULL(priv->gpio_reset)) {
+		ret = PTR_ERR(priv->gpio_reset);
+		return ret;
+	}
+
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov9640_subdev_ops);
 
 	v4l2_ctrl_handler_init(&priv->hdl, 2);
@@ -697,12 +719,20 @@ static int ov9640_probe(struct i2c_client *client,
 	}
 
 	ret = ov9640_video_probe(client);
-	if (ret) {
-		v4l2_clk_put(priv->clk);
-eclkget:
-		v4l2_ctrl_handler_free(&priv->hdl);
-	}
+	if (ret)
+		goto eprobe;
 
+	priv->subdev.dev = &client->dev;
+	ret = v4l2_async_register_subdev(&priv->subdev);
+	if (ret)
+		goto eprobe;
+
+	return 0;
+
+eprobe:
+	v4l2_clk_put(priv->clk);
+eclkget:
+	v4l2_ctrl_handler_free(&priv->hdl);
 	return ret;
 }
 
@@ -712,7 +742,7 @@ static int ov9640_remove(struct i2c_client *client)
 	struct ov9640_priv *priv = to_ov9640_sensor(sd);
 
 	v4l2_clk_put(priv->clk);
-	v4l2_device_unregister_subdev(&priv->subdev);
+	v4l2_async_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
 }
diff --git a/drivers/media/i2c/ov9640.h b/drivers/media/i2c/ov9640.h
index 65d13ff17536..be5e4b29ac69 100644
--- a/drivers/media/i2c/ov9640.h
+++ b/drivers/media/i2c/ov9640.h
@@ -200,6 +200,8 @@ struct ov9640_priv {
 	struct v4l2_subdev		subdev;
 	struct v4l2_ctrl_handler	hdl;
 	struct v4l2_clk			*clk;
+	struct gpio_desc		*gpio_power;
+	struct gpio_desc		*gpio_reset;
 
 	int				model;
 	int				revision;
-- 
2.18.0
