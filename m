Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58556 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab3EHNq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 09:46:56 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.146.12])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5BC7635A6A
	for <linux-media@vger.kernel.org>; Wed,  8 May 2013 15:46:25 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH RESEND 8/9] s5c73m3: Convert to devm_gpio_request_one()
Date: Wed,  8 May 2013 15:46:33 +0200
Message-Id: <1368020794-21264-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the devm_gpio_request_one() managed function to simplify cleanup
code paths.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c | 79 +++++++++++---------------------
 1 file changed, 28 insertions(+), 51 deletions(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index cb52438..d3e867a 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1511,59 +1511,40 @@ static const struct v4l2_subdev_ops oif_subdev_ops = {
 	.video	= &s5c73m3_oif_video_ops,
 };
 
-static int s5c73m3_configure_gpio(int nr, int val, const char *name)
-{
-	unsigned long flags = val ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
-	int ret;
-
-	if (!gpio_is_valid(nr))
-		return 0;
-	ret = gpio_request_one(nr, flags, name);
-	if (!ret)
-		gpio_export(nr, 0);
-	return ret;
-}
-
-static int s5c73m3_free_gpios(struct s5c73m3 *state)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(state->gpio); i++) {
-		if (!gpio_is_valid(state->gpio[i].gpio))
-			continue;
-		gpio_free(state->gpio[i].gpio);
-		state->gpio[i].gpio = -EINVAL;
-	}
-	return 0;
-}
-
 static int s5c73m3_configure_gpios(struct s5c73m3 *state,
 				   const struct s5c73m3_platform_data *pdata)
 {
-	const struct s5c73m3_gpio *gpio = &pdata->gpio_stby;
+	struct device *dev = &state->i2c_client->dev;
+	const struct s5c73m3_gpio *gpio;
+	unsigned long flags;
 	int ret;
 
 	state->gpio[STBY].gpio = -EINVAL;
 	state->gpio[RST].gpio  = -EINVAL;
 
-	ret = s5c73m3_configure_gpio(gpio->gpio, gpio->level, "S5C73M3_STBY");
-	if (ret) {
-		s5c73m3_free_gpios(state);
-		return ret;
+	gpio = &pdata->gpio_stby;
+	if (gpio_is_valid(gpio->gpio)) {
+		flags = (gpio->level ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW)
+		      | GPIOF_EXPORT;
+		ret = devm_gpio_request_one(dev, gpio->gpio, flags,
+					    "S5C73M3_STBY");
+		if (ret < 0)
+			return ret;
+
+		state->gpio[STBY] = *gpio;
 	}
-	state->gpio[STBY] = *gpio;
-	if (gpio_is_valid(gpio->gpio))
-		gpio_set_value(gpio->gpio, 0);
 
 	gpio = &pdata->gpio_reset;
-	ret = s5c73m3_configure_gpio(gpio->gpio, gpio->level, "S5C73M3_RST");
-	if (ret) {
-		s5c73m3_free_gpios(state);
-		return ret;
+	if (gpio_is_valid(gpio->gpio)) {
+		flags = (gpio->level ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW)
+		      | GPIOF_EXPORT;
+		ret = devm_gpio_request_one(dev, gpio->gpio, flags,
+					    "S5C73M3_RST");
+		if (ret < 0)
+			return ret;
+
+		state->gpio[RST] = *gpio;
 	}
-	state->gpio[RST] = *gpio;
-	if (gpio_is_valid(gpio->gpio))
-		gpio_set_value(gpio->gpio, 0);
 
 	return 0;
 }
@@ -1626,10 +1607,11 @@ static int s5c73m3_probe(struct i2c_client *client,
 
 	state->mclk_frequency = pdata->mclk_frequency;
 	state->bus_type = pdata->bus_type;
+	state->i2c_client = client;
 
 	ret = s5c73m3_configure_gpios(state, pdata);
 	if (ret)
-		goto out_err1;
+		goto out_err;
 
 	for (i = 0; i < S5C73M3_MAX_SUPPLIES; i++)
 		state->supplies[i].supply = s5c73m3_supply_names[i];
@@ -1638,12 +1620,12 @@ static int s5c73m3_probe(struct i2c_client *client,
 			       state->supplies);
 	if (ret) {
 		dev_err(dev, "failed to get regulators\n");
-		goto out_err2;
+		goto out_err;
 	}
 
 	ret = s5c73m3_init_controls(state);
 	if (ret)
-		goto out_err2;
+		goto out_err;
 
 	state->sensor_pix_size[RES_ISP] = &s5c73m3_isp_resolutions[1];
 	state->sensor_pix_size[RES_JPEG] = &s5c73m3_jpeg_resolutions[1];
@@ -1659,16 +1641,12 @@ static int s5c73m3_probe(struct i2c_client *client,
 
 	ret = s5c73m3_register_spi_driver(state);
 	if (ret < 0)
-		goto out_err2;
-
-	state->i2c_client = client;
+		goto out_err;
 
 	v4l2_info(sd, "%s: completed succesfully\n", __func__);
 	return 0;
 
-out_err2:
-	s5c73m3_free_gpios(state);
-out_err1:
+out_err:
 	media_entity_cleanup(&sd->entity);
 	return ret;
 }
@@ -1688,7 +1666,6 @@ static int s5c73m3_remove(struct i2c_client *client)
 	media_entity_cleanup(&sensor_sd->entity);
 
 	s5c73m3_unregister_spi_driver(state);
-	s5c73m3_free_gpios(state);
 
 	return 0;
 }
-- 
1.8.1.5

