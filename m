Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58557 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab3EHNq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 09:46:56 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.146.12])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8738835A6B
	for <linux-media@vger.kernel.org>; Wed,  8 May 2013 15:46:25 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH RESEND 9/9] s5k6aa: Convert to devm_gpio_request_one()
Date: Wed,  8 May 2013 15:46:34 +0200
Message-Id: <1368020794-21264-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the devm_gpio_request_one() managed function to simplify cleanup
code paths.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/s5k6aa.c | 73 +++++++++++++++++-----------------------------
 1 file changed, 26 insertions(+), 47 deletions(-)

diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index bdf5e3d..789c02a 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -1491,58 +1491,41 @@ static const struct v4l2_subdev_ops s5k6aa_subdev_ops = {
 /*
  * GPIO setup
  */
-static int s5k6aa_configure_gpio(int nr, int val, const char *name)
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
-static void s5k6aa_free_gpios(struct s5k6aa *s5k6aa)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(s5k6aa->gpio); i++) {
-		if (!gpio_is_valid(s5k6aa->gpio[i].gpio))
-			continue;
-		gpio_free(s5k6aa->gpio[i].gpio);
-		s5k6aa->gpio[i].gpio = -EINVAL;
-	}
-}
 
 static int s5k6aa_configure_gpios(struct s5k6aa *s5k6aa,
 				  const struct s5k6aa_platform_data *pdata)
 {
-	const struct s5k6aa_gpio *gpio = &pdata->gpio_stby;
+	struct i2c_client *client = v4l2_get_subdevdata(&s5k6aa->sd);
+	const struct s5k6aa_gpio *gpio;
+	unsigned long flags;
 	int ret;
 
 	s5k6aa->gpio[STBY].gpio = -EINVAL;
 	s5k6aa->gpio[RST].gpio  = -EINVAL;
 
-	ret = s5k6aa_configure_gpio(gpio->gpio, gpio->level, "S5K6AA_STBY");
-	if (ret) {
-		s5k6aa_free_gpios(s5k6aa);
-		return ret;
+	gpio = &pdata->gpio_stby;
+	if (gpio_is_valid(gpio->gpio)) {
+		flags = (gpio->level ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW)
+		      | GPIOF_EXPORT;
+		ret = devm_gpio_request_one(&client->dev, gpio->gpio, flags,
+					    "S5K6AA_STBY");
+		if (ret < 0)
+			return ret;
+
+		s5k6aa->gpio[STBY] = *gpio;
 	}
-	s5k6aa->gpio[STBY] = *gpio;
-	if (gpio_is_valid(gpio->gpio))
-		gpio_set_value(gpio->gpio, 0);
 
 	gpio = &pdata->gpio_reset;
-	ret = s5k6aa_configure_gpio(gpio->gpio, gpio->level, "S5K6AA_RST");
-	if (ret) {
-		s5k6aa_free_gpios(s5k6aa);
-		return ret;
+	if (gpio_is_valid(gpio->gpio)) {
+		flags = (gpio->level ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW)
+		      | GPIOF_EXPORT;
+		ret = devm_gpio_request_one(&client->dev, gpio->gpio, flags,
+					    "S5K6AA_RST");
+		if (ret < 0)
+			return ret;
+
+		s5k6aa->gpio[RST] = *gpio;
 	}
-	s5k6aa->gpio[RST] = *gpio;
-	if (gpio_is_valid(gpio->gpio))
-		gpio_set_value(gpio->gpio, 0);
 
 	return 0;
 }
@@ -1593,7 +1576,7 @@ static int s5k6aa_probe(struct i2c_client *client,
 
 	ret = s5k6aa_configure_gpios(s5k6aa, pdata);
 	if (ret)
-		goto out_err2;
+		goto out_err;
 
 	for (i = 0; i < S5K6AA_NUM_SUPPLIES; i++)
 		s5k6aa->supplies[i].supply = s5k6aa_supply_names[i];
@@ -1602,12 +1585,12 @@ static int s5k6aa_probe(struct i2c_client *client,
 				 s5k6aa->supplies);
 	if (ret) {
 		dev_err(&client->dev, "Failed to get regulators\n");
-		goto out_err3;
+		goto out_err;
 	}
 
 	ret = s5k6aa_initialize_ctrls(s5k6aa);
 	if (ret)
-		goto out_err3;
+		goto out_err;
 
 	s5k6aa_presets_data_init(s5k6aa);
 
@@ -1618,9 +1601,7 @@ static int s5k6aa_probe(struct i2c_client *client,
 
 	return 0;
 
-out_err3:
-	s5k6aa_free_gpios(s5k6aa);
-out_err2:
+out_err:
 	media_entity_cleanup(&s5k6aa->sd.entity);
 	return ret;
 }
@@ -1628,12 +1609,10 @@ out_err2:
 static int s5k6aa_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
-	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	media_entity_cleanup(&sd->entity);
-	s5k6aa_free_gpios(s5k6aa);
 
 	return 0;
 }
-- 
1.8.1.5

