Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37298 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752423AbcLLPzY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 10:55:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/15] ov7670: add devicetree support
Date: Mon, 12 Dec 2016 16:55:10 +0100
Message-Id: <20161212155520.41375-6-hverkuil@xs4all.nl>
In-Reply-To: <20161212155520.41375-1-hverkuil@xs4all.nl>
References: <20161212155520.41375-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add DT support. Use it to get the reset and pwdn pins (if there are any).
Tested with one sensor requiring reset/pwdn and one sensor that doesn't
have reset/pwdn pins.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov7670.c | 40 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index d2c0e23..1b06778 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -17,6 +17,8 @@
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
+#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-mediabus.h>
@@ -232,6 +234,8 @@ struct ov7670_info {
 	};
 	struct ov7670_format_struct *fmt;  /* Current format */
 	struct clk *clk;
+	struct gpio_desc *resetb_gpio;
+	struct gpio_desc *pwdn_gpio;
 	int min_width;			/* Filter out smaller sizes */
 	int min_height;			/* Filter out smaller sizes */
 	int clock_speed;		/* External clock speed (MHz) */
@@ -594,8 +598,6 @@ static int ov7670_init(struct v4l2_subdev *sd, u32 val)
 	return ov7670_write_array(sd, ov7670_default_regs);
 }
 
-
-
 static int ov7670_detect(struct v4l2_subdev *sd)
 {
 	unsigned char v;
@@ -1552,6 +1554,29 @@ static const struct ov7670_devtype ov7670_devdata[] = {
 	},
 };
 
+static int ov7670_init_gpio(struct i2c_client *client, struct ov7670_info *info)
+{
+	/* Request the power down GPIO asserted */
+	info->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "pwdn",
+			GPIOD_OUT_LOW);
+	if (IS_ERR(info->pwdn_gpio)) {
+		dev_info(&client->dev, "can't get %s GPIO\n", "pwdn");
+		return PTR_ERR(info->pwdn_gpio);
+	}
+
+	/* Request the reset GPIO deasserted */
+	info->resetb_gpio = devm_gpiod_get_optional(&client->dev, "resetb",
+			GPIOD_OUT_LOW);
+	if (IS_ERR(info->resetb_gpio)) {
+		dev_info(&client->dev, "can't get %s GPIO\n", "resetb");
+		return PTR_ERR(info->resetb_gpio);
+	}
+
+	usleep_range(3000, 5000);
+
+	return 0;
+}
+
 static int ov7670_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -1597,7 +1622,7 @@ static int ov7670_probe(struct i2c_client *client,
 		return -EPROBE_DEFER;
 	clk_prepare_enable(info->clk);
 
-	ret = ov7670_probe_dt(client, info);
+	ret = ov7670_init_gpio(client, info);
 	if (ret)
 		goto clk_put;
 
@@ -1716,9 +1741,18 @@ static const struct i2c_device_id ov7670_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ov7670_id);
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id ov7670_of_match[] = {
+	{ .compatible = "ovti,ov7670", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, ov7670_of_match);
+#endif
+
 static struct i2c_driver ov7670_driver = {
 	.driver = {
 		.name	= "ov7670",
+		.of_match_table = of_match_ptr(ov7670_of_match),
 	},
 	.probe		= ov7670_probe,
 	.remove		= ov7670_remove,
-- 
2.10.2

