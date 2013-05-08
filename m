Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58557 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab3EHNqy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 09:46:54 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.146.12])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id D4F3F35A53
	for <linux-media@vger.kernel.org>; Wed,  8 May 2013 15:46:24 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH RESEND 5/9] media: i2c: Convert to devm_gpio_request_one()
Date: Wed,  8 May 2013 15:46:30 +0200
Message-Id: <1368020794-21264-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the managed function the gpio_free() calls can be removed from the
probe error path and the remove handler.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/adv7183.c            | 24 ++++++++----------------
 drivers/media/i2c/m5mols/m5mols_core.c |  9 +++------
 drivers/media/i2c/noon010pc30.c        | 27 ++++++++-------------------
 drivers/media/i2c/smiapp/smiapp-core.c | 18 +++++-------------
 drivers/media/i2c/vs6624.c             | 10 +++-------
 5 files changed, 27 insertions(+), 61 deletions(-)

diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index 5690417..42b2dec 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -580,17 +580,17 @@ static int adv7183_probe(struct i2c_client *client,
 	decoder->reset_pin = pin_array[0];
 	decoder->oe_pin = pin_array[1];
 
-	if (gpio_request_one(decoder->reset_pin, GPIOF_OUT_INIT_LOW,
-			     "ADV7183 Reset")) {
+	if (devm_gpio_request_one(&client->dev, decoder->reset_pin,
+				  GPIOF_OUT_INIT_LOW, "ADV7183 Reset")) {
 		v4l_err(client, "failed to request GPIO %d\n", decoder->reset_pin);
 		return -EBUSY;
 	}
 
-	if (gpio_request_one(decoder->oe_pin, GPIOF_OUT_INIT_HIGH,
-			     "ADV7183 Output Enable")) {
+	if (devm_gpio_request_one(&client->dev, decoder->oe_pin,
+				  GPIOF_OUT_INIT_HIGH,
+				  "ADV7183 Output Enable")) {
 		v4l_err(client, "failed to request GPIO %d\n", decoder->oe_pin);
-		ret = -EBUSY;
-		goto err_free_reset;
+		return -EBUSY;
 	}
 
 	sd = &decoder->sd;
@@ -612,7 +612,7 @@ static int adv7183_probe(struct i2c_client *client,
 		ret = hdl->error;
 
 		v4l2_ctrl_handler_free(hdl);
-		goto err_free_oe;
+		return ret;
 	}
 
 	/* v4l2 doesn't support an autodetect standard, pick PAL as default */
@@ -637,26 +637,18 @@ static int adv7183_probe(struct i2c_client *client,
 	ret = v4l2_ctrl_handler_setup(hdl);
 	if (ret) {
 		v4l2_ctrl_handler_free(hdl);
-		goto err_free_oe;
+		return ret;
 	}
 
 	return 0;
-err_free_oe:
-	gpio_free(decoder->oe_pin);
-err_free_reset:
-	gpio_free(decoder->reset_pin);
-	return ret;
 }
 
 static int adv7183_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
-	struct adv7183 *decoder = to_adv7183(sd);
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
-	gpio_free(decoder->oe_pin);
-	gpio_free(decoder->reset_pin);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 08ff082..f870d50 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -959,7 +959,8 @@ static int m5mols_probe(struct i2c_client *client,
 
 	gpio_flags = pdata->reset_polarity
 		   ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
-	ret = gpio_request_one(pdata->gpio_reset, gpio_flags, "M5MOLS_NRST");
+	ret = devm_gpio_request_one(&client->dev, pdata->gpio_reset, gpio_flags,
+				    "M5MOLS_NRST");
 	if (ret) {
 		dev_err(&client->dev, "Failed to request gpio: %d\n", ret);
 		return ret;
@@ -968,7 +969,7 @@ static int m5mols_probe(struct i2c_client *client,
 	ret = regulator_bulk_get(&client->dev, ARRAY_SIZE(supplies), supplies);
 	if (ret) {
 		dev_err(&client->dev, "Failed to get regulators: %d\n", ret);
-		goto out_gpio;
+		return ret;
 	}
 
 	sd = &info->sd;
@@ -1013,22 +1014,18 @@ out_me:
 	media_entity_cleanup(&sd->entity);
 out_reg:
 	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
-out_gpio:
-	gpio_free(pdata->gpio_reset);
 	return ret;
 }
 
 static int m5mols_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
-	struct m5mols_info *info = to_m5mols(sd);
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	free_irq(client->irq, sd);
 
 	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
-	gpio_free(info->pdata->gpio_reset);
 	media_entity_cleanup(&sd->entity);
 
 	return 0;
diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
index d205522..6f81b99 100644
--- a/drivers/media/i2c/noon010pc30.c
+++ b/drivers/media/i2c/noon010pc30.c
@@ -746,8 +746,9 @@ static int noon010_probe(struct i2c_client *client,
 	info->curr_win		= &noon010_sizes[0];
 
 	if (gpio_is_valid(pdata->gpio_nreset)) {
-		ret = gpio_request_one(pdata->gpio_nreset, GPIOF_OUT_INIT_LOW,
-				       "NOON010PC30 NRST");
+		ret = devm_gpio_request_one(&client->dev, pdata->gpio_nreset,
+					    GPIOF_OUT_INIT_LOW,
+					    "NOON010PC30 NRST");
 		if (ret) {
 			dev_err(&client->dev, "GPIO request error: %d\n", ret);
 			goto np_err;
@@ -757,11 +758,12 @@ static int noon010_probe(struct i2c_client *client,
 	}
 
 	if (gpio_is_valid(pdata->gpio_nstby)) {
-		ret = gpio_request_one(pdata->gpio_nstby, GPIOF_OUT_INIT_LOW,
-				      "NOON010PC30 NSTBY");
+		ret = devm_gpio_request_one(&client->dev, pdata->gpio_nstby,
+					    GPIOF_OUT_INIT_LOW,
+					    "NOON010PC30 NSTBY");
 		if (ret) {
 			dev_err(&client->dev, "GPIO request error: %d\n", ret);
-			goto np_gpio_err;
+			goto np_err;
 		}
 		info->gpio_nstby = pdata->gpio_nstby;
 		gpio_export(info->gpio_nstby, 0);
@@ -773,7 +775,7 @@ static int noon010_probe(struct i2c_client *client,
 	ret = regulator_bulk_get(&client->dev, NOON010_NUM_SUPPLIES,
 				 info->supply);
 	if (ret)
-		goto np_reg_err;
+		goto np_err;
 
 	info->pad.flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
@@ -787,12 +789,6 @@ static int noon010_probe(struct i2c_client *client,
 
 np_me_err:
 	regulator_bulk_free(NOON010_NUM_SUPPLIES, info->supply);
-np_reg_err:
-	if (gpio_is_valid(info->gpio_nstby))
-		gpio_free(info->gpio_nstby);
-np_gpio_err:
-	if (gpio_is_valid(info->gpio_nreset))
-		gpio_free(info->gpio_nreset);
 np_err:
 	v4l2_ctrl_handler_free(&info->hdl);
 	v4l2_device_unregister_subdev(sd);
@@ -808,13 +804,6 @@ static int noon010_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&info->hdl);
 
 	regulator_bulk_free(NOON010_NUM_SUPPLIES, info->supply);
-
-	if (gpio_is_valid(info->gpio_nreset))
-		gpio_free(info->gpio_nreset);
-
-	if (gpio_is_valid(info->gpio_nstby))
-		gpio_free(info->gpio_nstby);
-
 	media_entity_cleanup(&sd->entity);
 
 	return 0;
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index cae4f46..c385454 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2383,8 +2383,9 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	}
 
 	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN) {
-		if (gpio_request_one(sensor->platform_data->xshutdown, 0,
-				     "SMIA++ xshutdown") != 0) {
+		if (devm_gpio_request_one(&client->dev,
+					  sensor->platform_data->xshutdown, 0,
+					  "SMIA++ xshutdown") != 0) {
 			dev_err(&client->dev,
 				"unable to acquire reset gpio %d\n",
 				sensor->platform_data->xshutdown);
@@ -2393,10 +2394,8 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	}
 
 	rval = smiapp_power_on(sensor);
-	if (rval) {
-		rval = -ENODEV;
-		goto out_smiapp_power_on;
-	}
+	if (rval)
+		return -ENODEV;
 
 	rval = smiapp_identify_module(subdev);
 	if (rval) {
@@ -2656,11 +2655,6 @@ out_ident_release:
 
 out_power_off:
 	smiapp_power_off(sensor);
-
-out_smiapp_power_on:
-	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
-		gpio_free(sensor->platform_data->xshutdown);
-
 	return rval;
 }
 
@@ -2858,8 +2852,6 @@ static int smiapp_remove(struct i2c_client *client)
 		v4l2_device_unregister_subdev(&sensor->ssds[i].sd);
 	}
 	smiapp_free_controls(sensor);
-	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
-		gpio_free(sensor->platform_data->xshutdown);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index 94e2849..7b55b3d 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -805,7 +805,8 @@ static int vs6624_probe(struct i2c_client *client,
 	if (ce == NULL)
 		return -EINVAL;
 
-	ret = gpio_request_one(*ce, GPIOF_OUT_INIT_HIGH, "VS6624 Chip Enable");
+	ret = devm_gpio_request_one(&client->dev, *ce, GPIOF_OUT_INIT_HIGH,
+				    "VS6624 Chip Enable");
 	if (ret) {
 		v4l_err(client, "failed to request GPIO %d\n", *ce);
 		return ret;
@@ -863,27 +864,22 @@ static int vs6624_probe(struct i2c_client *client,
 		int err = hdl->error;
 
 		v4l2_ctrl_handler_free(hdl);
-		gpio_free(*ce);
 		return err;
 	}
 
 	/* initialize the hardware to the default control values */
 	ret = v4l2_ctrl_handler_setup(hdl);
-	if (ret) {
+	if (ret)
 		v4l2_ctrl_handler_free(hdl);
-		gpio_free(*ce);
-	}
 	return ret;
 }
 
 static int vs6624_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
-	struct vs6624 *sensor = to_vs6624(sd);
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
-	gpio_free(sensor->ce_pin);
 	return 0;
 }
 
-- 
1.8.1.5

