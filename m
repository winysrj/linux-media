Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58556 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab3EHNqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 09:46:53 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.146.12])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id B0D5E35A51
	for <linux-media@vger.kernel.org>; Wed,  8 May 2013 15:46:24 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH RESEND 4/9] media: i2c: Convert to devm_kzalloc()
Date: Wed,  8 May 2013 15:46:29 +0200
Message-Id: <1368020794-21264-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the managed function the kfree() calls can be removed from the
probe error path and the remove handler.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 drivers/media/i2c/ad9389b.c              |  8 ++------
 drivers/media/i2c/adp1653.c              |  5 ++---
 drivers/media/i2c/adv7170.c              |  3 +--
 drivers/media/i2c/adv7175.c              |  3 +--
 drivers/media/i2c/adv7180.c              |  4 +---
 drivers/media/i2c/adv7183.c              |  8 ++------
 drivers/media/i2c/adv7393.c              |  8 ++------
 drivers/media/i2c/adv7604.c              | 11 +++--------
 drivers/media/i2c/ak881x.c               |  4 +---
 drivers/media/i2c/as3645a.c              |  7 ++-----
 drivers/media/i2c/bt819.c                |  4 +---
 drivers/media/i2c/bt856.c                |  3 +--
 drivers/media/i2c/bt866.c                |  3 +--
 drivers/media/i2c/cs5345.c               |  4 +---
 drivers/media/i2c/cs53l32a.c             |  4 +---
 drivers/media/i2c/cx25840/cx25840-core.c |  4 +---
 drivers/media/i2c/cx25840/cx25840-ir.c   |  7 ++-----
 drivers/media/i2c/ir-kbd-i2c.c           | 10 +++-------
 drivers/media/i2c/ks0127.c               |  3 +--
 drivers/media/i2c/m52790.c               |  3 +--
 drivers/media/i2c/m5mols/m5mols_core.c   |  8 +++-----
 drivers/media/i2c/msp3400-driver.c       |  5 +----
 drivers/media/i2c/mt9m032.c              |  4 +---
 drivers/media/i2c/mt9t001.c              |  4 +---
 drivers/media/i2c/mt9v011.c              |  6 ++----
 drivers/media/i2c/mt9v032.c              |  7 ++-----
 drivers/media/i2c/noon010pc30.c          |  5 ++---
 drivers/media/i2c/ov7640.c               |  5 ++---
 drivers/media/i2c/ov7670.c               |  5 +----
 drivers/media/i2c/saa6588.c              | 10 +++-------
 drivers/media/i2c/saa7110.c              |  4 +---
 drivers/media/i2c/saa7115.c              |  4 +---
 drivers/media/i2c/saa7127.c              |  4 +---
 drivers/media/i2c/saa717x.c              |  5 +----
 drivers/media/i2c/saa7185.c              |  3 +--
 drivers/media/i2c/saa7191.c              |  4 +---
 drivers/media/i2c/sony-btf-mpx.c         |  3 +--
 drivers/media/i2c/sr030pc30.c            |  4 +---
 drivers/media/i2c/tda7432.c              |  4 +---
 drivers/media/i2c/tda9840.c              |  3 +--
 drivers/media/i2c/tea6415c.c             |  3 +--
 drivers/media/i2c/tea6420.c              |  3 +--
 drivers/media/i2c/tlv320aic23b.c         |  4 +---
 drivers/media/i2c/tvaudio.c              |  5 +----
 drivers/media/i2c/tvp5150.c              | 14 ++++----------
 drivers/media/i2c/tw2804.c               |  5 +----
 drivers/media/i2c/tw9903.c               |  5 +----
 drivers/media/i2c/tw9906.c               |  5 +----
 drivers/media/i2c/uda1342.c              |  3 +--
 drivers/media/i2c/upd64031a.c            |  3 +--
 drivers/media/i2c/upd64083.c             |  3 +--
 drivers/media/i2c/vp27smpx.c             |  3 +--
 drivers/media/i2c/vpx3220.c              |  5 ++---
 drivers/media/i2c/vs6624.c               |  9 ++-------
 drivers/media/i2c/wm8739.c               |  4 +---
 drivers/media/i2c/wm8775.c               |  4 +---
 56 files changed, 79 insertions(+), 202 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 58344b6..1504355 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -1188,15 +1188,14 @@ static int ad9389b_probe(struct i2c_client *client, const struct i2c_device_id *
 	v4l_dbg(1, debug, client, "detecting ad9389b client on address 0x%x\n",
 			client->addr << 1);
 
-	state = kzalloc(sizeof(struct ad9389b_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (!state)
 		return -ENOMEM;
 
 	/* Platform data */
 	if (pdata == NULL) {
 		v4l_err(client, "No platform data!\n");
-		err = -ENODEV;
-		goto err_free;
+		return -ENODEV;
 	}
 	memcpy(&state->pdata, pdata, sizeof(state->pdata));
 
@@ -1276,8 +1275,6 @@ err_entity:
 	media_entity_cleanup(&sd->entity);
 err_hdl:
 	v4l2_ctrl_handler_free(&state->hdl);
-err_free:
-	kfree(state);
 	return err;
 }
 
@@ -1302,7 +1299,6 @@ static int ad9389b_remove(struct i2c_client *client)
 	v4l2_device_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
-	kfree(get_ad9389b_state(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
index ef75abe..873fe19 100644
--- a/drivers/media/i2c/adp1653.c
+++ b/drivers/media/i2c/adp1653.c
@@ -417,7 +417,7 @@ static int adp1653_probe(struct i2c_client *client,
 	if (client->dev.platform_data == NULL)
 		return -ENODEV;
 
-	flash = kzalloc(sizeof(*flash), GFP_KERNEL);
+	flash = devm_kzalloc(&client->dev, sizeof(*flash), GFP_KERNEL);
 	if (flash == NULL)
 		return -ENOMEM;
 
@@ -443,7 +443,6 @@ static int adp1653_probe(struct i2c_client *client,
 
 free_and_quit:
 	v4l2_ctrl_handler_free(&flash->ctrls);
-	kfree(flash);
 	return ret;
 }
 
@@ -455,7 +454,7 @@ static int adp1653_remove(struct i2c_client *client)
 	v4l2_device_unregister_subdev(&flash->subdev);
 	v4l2_ctrl_handler_free(&flash->ctrls);
 	media_entity_cleanup(&flash->subdev.entity);
-	kfree(flash);
+
 	return 0;
 }
 
diff --git a/drivers/media/i2c/adv7170.c b/drivers/media/i2c/adv7170.c
index 6bc01fb..d07689d 100644
--- a/drivers/media/i2c/adv7170.c
+++ b/drivers/media/i2c/adv7170.c
@@ -359,7 +359,7 @@ static int adv7170_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	encoder = kzalloc(sizeof(struct adv7170), GFP_KERNEL);
+	encoder = devm_kzalloc(&client->dev, sizeof(*encoder), GFP_KERNEL);
 	if (encoder == NULL)
 		return -ENOMEM;
 	sd = &encoder->sd;
@@ -384,7 +384,6 @@ static int adv7170_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_adv7170(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/adv7175.c b/drivers/media/i2c/adv7175.c
index c7640fa..eaefa50 100644
--- a/drivers/media/i2c/adv7175.c
+++ b/drivers/media/i2c/adv7175.c
@@ -409,7 +409,7 @@ static int adv7175_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	encoder = kzalloc(sizeof(struct adv7175), GFP_KERNEL);
+	encoder = devm_kzalloc(&client->dev, sizeof(*encoder), GFP_KERNEL);
 	if (encoder == NULL)
 		return -ENOMEM;
 	sd = &encoder->sd;
@@ -434,7 +434,6 @@ static int adv7175_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_adv7175(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index afd561a..3d14567 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -555,7 +555,7 @@ static int adv7180_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%02x (%s)\n",
 		 client->addr, client->adapter->name);
 
-	state = kzalloc(sizeof(struct adv7180_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL) {
 		ret = -ENOMEM;
 		goto err;
@@ -582,7 +582,6 @@ err_free_ctrl:
 err_unreg_subdev:
 	mutex_destroy(&state->mutex);
 	v4l2_device_unregister_subdev(sd);
-	kfree(state);
 err:
 	printk(KERN_ERR KBUILD_MODNAME ": Failed to probe: %d\n", ret);
 	return ret;
@@ -607,7 +606,6 @@ static int adv7180_remove(struct i2c_client *client)
 
 	mutex_destroy(&state->mutex);
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_state(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index 2bc0328..5690417 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -573,7 +573,7 @@ static int adv7183_probe(struct i2c_client *client,
 	if (pin_array == NULL)
 		return -EINVAL;
 
-	decoder = kzalloc(sizeof(struct adv7183), GFP_KERNEL);
+	decoder = devm_kzalloc(&client->dev, sizeof(*decoder), GFP_KERNEL);
 	if (decoder == NULL)
 		return -ENOMEM;
 
@@ -583,8 +583,7 @@ static int adv7183_probe(struct i2c_client *client,
 	if (gpio_request_one(decoder->reset_pin, GPIOF_OUT_INIT_LOW,
 			     "ADV7183 Reset")) {
 		v4l_err(client, "failed to request GPIO %d\n", decoder->reset_pin);
-		ret = -EBUSY;
-		goto err_free_decoder;
+		return -EBUSY;
 	}
 
 	if (gpio_request_one(decoder->oe_pin, GPIOF_OUT_INIT_HIGH,
@@ -646,8 +645,6 @@ err_free_oe:
 	gpio_free(decoder->oe_pin);
 err_free_reset:
 	gpio_free(decoder->reset_pin);
-err_free_decoder:
-	kfree(decoder);
 	return ret;
 }
 
@@ -660,7 +657,6 @@ static int adv7183_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	gpio_free(decoder->oe_pin);
 	gpio_free(decoder->reset_pin);
-	kfree(decoder);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/adv7393.c b/drivers/media/i2c/adv7393.c
index 3dc6098..ec50509 100644
--- a/drivers/media/i2c/adv7393.c
+++ b/drivers/media/i2c/adv7393.c
@@ -410,7 +410,7 @@ static int adv7393_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kzalloc(sizeof(struct adv7393_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 
@@ -444,16 +444,13 @@ static int adv7393_probe(struct i2c_client *client,
 		int err = state->hdl.error;
 
 		v4l2_ctrl_handler_free(&state->hdl);
-		kfree(state);
 		return err;
 	}
 	v4l2_ctrl_handler_setup(&state->hdl);
 
 	err = adv7393_initialize(&state->sd);
-	if (err) {
+	if (err)
 		v4l2_ctrl_handler_free(&state->hdl);
-		kfree(state);
-	}
 	return err;
 }
 
@@ -464,7 +461,6 @@ static int adv7393_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&state->hdl);
-	kfree(state);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 31a63c9..4cdcfc9 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1968,7 +1968,7 @@ static int adv7604_probe(struct i2c_client *client,
 	v4l_dbg(1, debug, client, "detecting adv7604 client on address 0x%x\n",
 			client->addr << 1);
 
-	state = kzalloc(sizeof(struct adv7604_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (!state) {
 		v4l_err(client, "Could not allocate adv7604_state memory!\n");
 		return -ENOMEM;
@@ -1977,8 +1977,7 @@ static int adv7604_probe(struct i2c_client *client,
 	/* platform data */
 	if (!pdata) {
 		v4l_err(client, "No platform data!\n");
-		err = -ENODEV;
-		goto err_state;
+		return -ENODEV;
 	}
 	memcpy(&state->pdata, pdata, sizeof(state->pdata));
 
@@ -1991,8 +1990,7 @@ static int adv7604_probe(struct i2c_client *client,
 	if (adv_smbus_read_byte_data_check(client, 0xfb, false) != 0x68) {
 		v4l2_info(sd, "not an adv7604 on address 0x%x\n",
 				client->addr << 1);
-		err = -ENODEV;
-		goto err_state;
+		return -ENODEV;
 	}
 
 	/* control handlers */
@@ -2093,8 +2091,6 @@ err_i2c:
 	adv7604_unregister_clients(state);
 err_hdl:
 	v4l2_ctrl_handler_free(hdl);
-err_state:
-	kfree(state);
 	return err;
 }
 
@@ -2111,7 +2107,6 @@ static int adv7604_remove(struct i2c_client *client)
 	media_entity_cleanup(&sd->entity);
 	adv7604_unregister_clients(to_state(sd));
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
-	kfree(to_state(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/ak881x.c b/drivers/media/i2c/ak881x.c
index fd47465..b918c3f 100644
--- a/drivers/media/i2c/ak881x.c
+++ b/drivers/media/i2c/ak881x.c
@@ -264,7 +264,7 @@ static int ak881x_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	ak881x = kzalloc(sizeof(struct ak881x), GFP_KERNEL);
+	ak881x = devm_kzalloc(&client->dev, sizeof(*ak881x), GFP_KERNEL);
 	if (!ak881x)
 		return -ENOMEM;
 
@@ -282,7 +282,6 @@ static int ak881x_probe(struct i2c_client *client,
 	default:
 		dev_err(&client->dev,
 			"No ak881x chip detected, register read %x\n", data);
-		kfree(ak881x);
 		return -ENODEV;
 	}
 
@@ -331,7 +330,6 @@ static int ak881x_remove(struct i2c_client *client)
 	struct ak881x *ak881x = to_ak881x(client);
 
 	v4l2_device_unregister_subdev(&ak881x->subdev);
-	kfree(ak881x);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/as3645a.c b/drivers/media/i2c/as3645a.c
index 58d523f..301084b 100644
--- a/drivers/media/i2c/as3645a.c
+++ b/drivers/media/i2c/as3645a.c
@@ -813,7 +813,7 @@ static int as3645a_probe(struct i2c_client *client,
 	if (client->dev.platform_data == NULL)
 		return -ENODEV;
 
-	flash = kzalloc(sizeof(*flash), GFP_KERNEL);
+	flash = devm_kzalloc(&client->dev, sizeof(*flash), GFP_KERNEL);
 	if (flash == NULL)
 		return -ENOMEM;
 
@@ -838,10 +838,8 @@ static int as3645a_probe(struct i2c_client *client,
 	flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
 
 done:
-	if (ret < 0) {
+	if (ret < 0)
 		v4l2_ctrl_handler_free(&flash->ctrls);
-		kfree(flash);
-	}
 
 	return ret;
 }
@@ -855,7 +853,6 @@ static int as3645a_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&flash->ctrls);
 	media_entity_cleanup(&flash->subdev.entity);
 	mutex_destroy(&flash->power_lock);
-	kfree(flash);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/bt819.c b/drivers/media/i2c/bt819.c
index 377bf05..ee9ed67 100644
--- a/drivers/media/i2c/bt819.c
+++ b/drivers/media/i2c/bt819.c
@@ -425,7 +425,7 @@ static int bt819_probe(struct i2c_client *client,
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -ENODEV;
 
-	decoder = kzalloc(sizeof(struct bt819), GFP_KERNEL);
+	decoder = devm_kzalloc(&client->dev, sizeof(*decoder), GFP_KERNEL);
 	if (decoder == NULL)
 		return -ENOMEM;
 	sd = &decoder->sd;
@@ -476,7 +476,6 @@ static int bt819_probe(struct i2c_client *client,
 		int err = decoder->hdl.error;
 
 		v4l2_ctrl_handler_free(&decoder->hdl);
-		kfree(decoder);
 		return err;
 	}
 	v4l2_ctrl_handler_setup(&decoder->hdl);
@@ -490,7 +489,6 @@ static int bt819_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&decoder->hdl);
-	kfree(decoder);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/bt856.c b/drivers/media/i2c/bt856.c
index 7e5bd36..7e50111 100644
--- a/drivers/media/i2c/bt856.c
+++ b/drivers/media/i2c/bt856.c
@@ -216,7 +216,7 @@ static int bt856_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	encoder = kzalloc(sizeof(struct bt856), GFP_KERNEL);
+	encoder = devm_kzalloc(&client->dev, sizeof(*encoder), GFP_KERNEL);
 	if (encoder == NULL)
 		return -ENOMEM;
 	sd = &encoder->sd;
@@ -250,7 +250,6 @@ static int bt856_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_bt856(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/bt866.c b/drivers/media/i2c/bt866.c
index 905320b..9355b92 100644
--- a/drivers/media/i2c/bt866.c
+++ b/drivers/media/i2c/bt866.c
@@ -207,7 +207,7 @@ static int bt866_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	encoder = kzalloc(sizeof(*encoder), GFP_KERNEL);
+	encoder = devm_kzalloc(&client->dev, sizeof(*encoder), GFP_KERNEL);
 	if (encoder == NULL)
 		return -ENOMEM;
 	sd = &encoder->sd;
@@ -220,7 +220,6 @@ static int bt866_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_bt866(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/cs5345.c b/drivers/media/i2c/cs5345.c
index 1d2f7c8..841b9c4 100644
--- a/drivers/media/i2c/cs5345.c
+++ b/drivers/media/i2c/cs5345.c
@@ -190,7 +190,7 @@ static int cs5345_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kzalloc(sizeof(struct cs5345_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;
@@ -206,7 +206,6 @@ static int cs5345_probe(struct i2c_client *client,
 		int err = state->hdl.error;
 
 		v4l2_ctrl_handler_free(&state->hdl);
-		kfree(state);
 		return err;
 	}
 	/* set volume/mute */
@@ -227,7 +226,6 @@ static int cs5345_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&state->hdl);
-	kfree(state);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/cs53l32a.c b/drivers/media/i2c/cs53l32a.c
index b293912..1082fb7 100644
--- a/drivers/media/i2c/cs53l32a.c
+++ b/drivers/media/i2c/cs53l32a.c
@@ -175,7 +175,7 @@ static int cs53l32a_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kzalloc(sizeof(struct cs53l32a_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;
@@ -197,7 +197,6 @@ static int cs53l32a_probe(struct i2c_client *client,
 		int err = state->hdl.error;
 
 		v4l2_ctrl_handler_free(&state->hdl);
-		kfree(state);
 		return err;
 	}
 
@@ -228,7 +227,6 @@ static int cs53l32a_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&state->hdl);
-	kfree(state);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 12fb9b2..bdfec4c 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -5190,7 +5190,7 @@ static int cx25840_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	state = kzalloc(sizeof(struct cx25840_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 
@@ -5292,7 +5292,6 @@ static int cx25840_probe(struct i2c_client *client,
 		int err = state->hdl.error;
 
 		v4l2_ctrl_handler_free(&state->hdl);
-		kfree(state);
 		return err;
 	}
 	if (!is_cx2583x(state))
@@ -5317,7 +5316,6 @@ static int cx25840_remove(struct i2c_client *client)
 	cx25840_ir_remove(sd);
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&state->hdl);
-	kfree(state);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
index 9ae977b..e6588ee 100644
--- a/drivers/media/i2c/cx25840/cx25840-ir.c
+++ b/drivers/media/i2c/cx25840/cx25840-ir.c
@@ -1230,16 +1230,14 @@ int cx25840_ir_probe(struct v4l2_subdev *sd)
 	if (!(is_cx23885(state) || is_cx23887(state)))
 		return 0;
 
-	ir_state = kzalloc(sizeof(struct cx25840_ir_state), GFP_KERNEL);
+	ir_state = devm_kzalloc(&state->c->dev, sizeof(*ir_state), GFP_KERNEL);
 	if (ir_state == NULL)
 		return -ENOMEM;
 
 	spin_lock_init(&ir_state->rx_kfifo_lock);
 	if (kfifo_alloc(&ir_state->rx_kfifo,
-			CX25840_IR_RX_KFIFO_SIZE, GFP_KERNEL)) {
-		kfree(ir_state);
+			CX25840_IR_RX_KFIFO_SIZE, GFP_KERNEL))
 		return -ENOMEM;
-	}
 
 	ir_state->c = state->c;
 	state->ir_state = ir_state;
@@ -1273,7 +1271,6 @@ int cx25840_ir_remove(struct v4l2_subdev *sd)
 	cx25840_ir_tx_shutdown(sd);
 
 	kfifo_free(&ir_state->rx_kfifo);
-	kfree(ir_state);
 	state->ir_state = NULL;
 	return 0;
 }
diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 8e2f79c..82bf567 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -295,7 +295,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	unsigned short addr = client->addr;
 	int err;
 
-	ir = kzalloc(sizeof(struct IR_i2c), GFP_KERNEL);
+	ir = devm_kzalloc(&client->dev, sizeof(*ir), GFP_KERNEL);
 	if (!ir)
 		return -ENOMEM;
 
@@ -398,10 +398,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		 * internally
 		 */
 		rc = rc_allocate_device();
-		if (!rc) {
-			err = -ENOMEM;
-			goto err_out_free;
-		}
+		if (!rc)
+			return -ENOMEM;
 	}
 	ir->rc = rc;
 
@@ -454,7 +452,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
  err_out_free:
 	/* Only frees rc if it were allocated internally */
 	rc_free_device(rc);
-	kfree(ir);
 	return err;
 }
 
@@ -470,7 +467,6 @@ static int ir_remove(struct i2c_client *client)
 		rc_unregister_device(ir->rc);
 
 	/* free memory */
-	kfree(ir);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/ks0127.c b/drivers/media/i2c/ks0127.c
index 04a6efa..c722776 100644
--- a/drivers/media/i2c/ks0127.c
+++ b/drivers/media/i2c/ks0127.c
@@ -685,7 +685,7 @@ static int ks0127_probe(struct i2c_client *client, const struct i2c_device_id *i
 		client->addr == (I2C_KS0127_ADDON >> 1) ? "addon" : "on-board",
 		client->addr << 1, client->adapter->name);
 
-	ks = kzalloc(sizeof(*ks), GFP_KERNEL);
+	ks = devm_kzalloc(&client->dev, sizeof(*ks), GFP_KERNEL);
 	if (ks == NULL)
 		return -ENOMEM;
 	sd = &ks->sd;
@@ -708,7 +708,6 @@ static int ks0127_remove(struct i2c_client *client)
 	v4l2_device_unregister_subdev(sd);
 	ks0127_write(sd, KS_OFMTA, 0x20); /* tristate */
 	ks0127_write(sd, KS_CMDA, 0x2c | 0x80); /* power down */
-	kfree(to_ks0127(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/m52790.c b/drivers/media/i2c/m52790.c
index 39f50fd..0d153f3 100644
--- a/drivers/media/i2c/m52790.c
+++ b/drivers/media/i2c/m52790.c
@@ -174,7 +174,7 @@ static int m52790_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kzalloc(sizeof(struct m52790_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 
@@ -191,7 +191,6 @@ static int m52790_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_state(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index f0b870c..08ff082 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -950,7 +950,7 @@ static int m5mols_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	info = kzalloc(sizeof(struct m5mols_info), GFP_KERNEL);
+	info = devm_kzalloc(&client->dev, sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
@@ -962,7 +962,7 @@ static int m5mols_probe(struct i2c_client *client,
 	ret = gpio_request_one(pdata->gpio_reset, gpio_flags, "M5MOLS_NRST");
 	if (ret) {
 		dev_err(&client->dev, "Failed to request gpio: %d\n", ret);
-		goto out_free;
+		return ret;
 	}
 
 	ret = regulator_bulk_get(&client->dev, ARRAY_SIZE(supplies), supplies);
@@ -1015,8 +1015,6 @@ out_reg:
 	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
 out_gpio:
 	gpio_free(pdata->gpio_reset);
-out_free:
-	kfree(info);
 	return ret;
 }
 
@@ -1032,7 +1030,7 @@ static int m5mols_remove(struct i2c_client *client)
 	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
 	gpio_free(info->pdata->gpio_reset);
 	media_entity_cleanup(&sd->entity);
-	kfree(info);
+
 	return 0;
 }
 
diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index 54a9dd3..ae92c20 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -707,7 +707,7 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return -ENODEV;
 	}
 
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (!state)
 		return -ENOMEM;
 
@@ -732,7 +732,6 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (state->rev1 == -1 || (state->rev1 == 0 && state->rev2 == 0)) {
 		v4l_dbg(1, msp_debug, client,
 				"not an msp3400 (cannot read chip version)\n");
-		kfree(state);
 		return -ENODEV;
 	}
 
@@ -827,7 +826,6 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		int err = hdl->error;
 
 		v4l2_ctrl_handler_free(hdl);
-		kfree(state);
 		return err;
 	}
 
@@ -889,7 +887,6 @@ static int msp_remove(struct i2c_client *client)
 	msp_reset(client);
 
 	v4l2_ctrl_handler_free(&state->hdl);
-	kfree(state);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index 8edb3d8..cca704e 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -730,7 +730,7 @@ static int mt9m032_probe(struct i2c_client *client,
 	if (!client->dev.platform_data)
 		return -ENODEV;
 
-	sensor = kzalloc(sizeof(*sensor), GFP_KERNEL);
+	sensor = devm_kzalloc(&client->dev, sizeof(*sensor), GFP_KERNEL);
 	if (sensor == NULL)
 		return -ENOMEM;
 
@@ -860,7 +860,6 @@ error_ctrl:
 	v4l2_ctrl_handler_free(&sensor->ctrls);
 error_sensor:
 	mutex_destroy(&sensor->lock);
-	kfree(sensor);
 	return ret;
 }
 
@@ -873,7 +872,6 @@ static int mt9m032_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&sensor->ctrls);
 	media_entity_cleanup(&subdev->entity);
 	mutex_destroy(&sensor->lock);
-	kfree(sensor);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
index 2e189d8..7964634 100644
--- a/drivers/media/i2c/mt9t001.c
+++ b/drivers/media/i2c/mt9t001.c
@@ -740,7 +740,7 @@ static int mt9t001_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
-	mt9t001 = kzalloc(sizeof(*mt9t001), GFP_KERNEL);
+	mt9t001 = devm_kzalloc(&client->dev, sizeof(*mt9t001), GFP_KERNEL);
 	if (!mt9t001)
 		return -ENOMEM;
 
@@ -801,7 +801,6 @@ done:
 	if (ret < 0) {
 		v4l2_ctrl_handler_free(&mt9t001->ctrls);
 		media_entity_cleanup(&mt9t001->subdev.entity);
-		kfree(mt9t001);
 	}
 
 	return ret;
@@ -815,7 +814,6 @@ static int mt9t001_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&mt9t001->ctrls);
 	v4l2_device_unregister_subdev(subdev);
 	media_entity_cleanup(&subdev->entity);
-	kfree(mt9t001);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
index 3f415fd..c64c9d9 100644
--- a/drivers/media/i2c/mt9v011.c
+++ b/drivers/media/i2c/mt9v011.c
@@ -526,7 +526,7 @@ static int mt9v011_probe(struct i2c_client *c,
 	     I2C_FUNC_SMBUS_READ_BYTE | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
 		return -EIO;
 
-	core = kzalloc(sizeof(struct mt9v011), GFP_KERNEL);
+	core = devm_kzalloc(&c->dev, sizeof(struct mt9v011), GFP_KERNEL);
 	if (!core)
 		return -ENOMEM;
 
@@ -539,7 +539,6 @@ static int mt9v011_probe(struct i2c_client *c,
 	    (version != MT9V011_REV_B_VERSION)) {
 		v4l2_info(sd, "*** unknown micron chip detected (0x%04x).\n",
 			  version);
-		kfree(core);
 		return -EINVAL;
 	}
 
@@ -562,7 +561,6 @@ static int mt9v011_probe(struct i2c_client *c,
 
 		v4l2_err(sd, "control initialization error %d\n", ret);
 		v4l2_ctrl_handler_free(&core->ctrls);
-		kfree(core);
 		return ret;
 	}
 	core->sd.ctrl_handler = &core->ctrls;
@@ -598,7 +596,7 @@ static int mt9v011_remove(struct i2c_client *c)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&core->ctrls);
-	kfree(to_mt9v011(sd));
+
 	return 0;
 }
 
diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 24ea6fd..60c6f67 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -744,7 +744,7 @@ static int mt9v032_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	mt9v032 = kzalloc(sizeof(*mt9v032), GFP_KERNEL);
+	mt9v032 = devm_kzalloc(&client->dev, sizeof(*mt9v032), GFP_KERNEL);
 	if (!mt9v032)
 		return -ENOMEM;
 
@@ -831,10 +831,8 @@ static int mt9v032_probe(struct i2c_client *client,
 	mt9v032->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_init(&mt9v032->subdev.entity, 1, &mt9v032->pad, 0);
 
-	if (ret < 0) {
+	if (ret < 0)
 		v4l2_ctrl_handler_free(&mt9v032->ctrls);
-		kfree(mt9v032);
-	}
 
 	return ret;
 }
@@ -847,7 +845,6 @@ static int mt9v032_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&mt9v032->ctrls);
 	v4l2_device_unregister_subdev(subdev);
 	media_entity_cleanup(&subdev->entity);
-	kfree(mt9v032);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
index a115842..d205522 100644
--- a/drivers/media/i2c/noon010pc30.c
+++ b/drivers/media/i2c/noon010pc30.c
@@ -712,7 +712,7 @@ static int noon010_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = devm_kzalloc(&client->dev, sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
@@ -796,7 +796,6 @@ np_gpio_err:
 np_err:
 	v4l2_ctrl_handler_free(&info->hdl);
 	v4l2_device_unregister_subdev(sd);
-	kfree(info);
 	return ret;
 }
 
@@ -817,7 +816,7 @@ static int noon010_remove(struct i2c_client *client)
 		gpio_free(info->gpio_nstby);
 
 	media_entity_cleanup(&sd->entity);
-	kfree(info);
+
 	return 0;
 }
 
diff --git a/drivers/media/i2c/ov7640.c b/drivers/media/i2c/ov7640.c
index b0cc927..5e117ab 100644
--- a/drivers/media/i2c/ov7640.c
+++ b/drivers/media/i2c/ov7640.c
@@ -59,7 +59,7 @@ static int ov7640_probe(struct i2c_client *client,
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -ENODEV;
 
-	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+	sd = devm_kzalloc(&client->dev, sizeof(*sd), GFP_KERNEL);
 	if (sd == NULL)
 		return -ENOMEM;
 	v4l2_i2c_subdev_init(sd, client, &ov7640_ops);
@@ -71,7 +71,6 @@ static int ov7640_probe(struct i2c_client *client,
 
 	if (write_regs(client, initial_registers) < 0) {
 		v4l_err(client, "error initializing OV7640\n");
-		kfree(sd);
 		return -ENODEV;
 	}
 
@@ -84,7 +83,7 @@ static int ov7640_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(sd);
+
 	return 0;
 }
 
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 617ad3f..d71602f 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1552,7 +1552,7 @@ static int ov7670_probe(struct i2c_client *client,
 	struct ov7670_info *info;
 	int ret;
 
-	info = kzalloc(sizeof(struct ov7670_info), GFP_KERNEL);
+	info = devm_kzalloc(&client->dev, sizeof(*info), GFP_KERNEL);
 	if (info == NULL)
 		return -ENOMEM;
 	sd = &info->sd;
@@ -1590,7 +1590,6 @@ static int ov7670_probe(struct i2c_client *client,
 		v4l_dbg(1, debug, client,
 			"chip found @ 0x%x (%s) is not an ov7670 chip.\n",
 			client->addr << 1, client->adapter->name);
-		kfree(info);
 		return ret;
 	}
 	v4l_info(client, "chip found @ 0x%02x (%s)\n",
@@ -1635,7 +1634,6 @@ static int ov7670_probe(struct i2c_client *client,
 		int err = info->hdl.error;
 
 		v4l2_ctrl_handler_free(&info->hdl);
-		kfree(info);
 		return err;
 	}
 	/*
@@ -1659,7 +1657,6 @@ static int ov7670_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
-	kfree(info);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/saa6588.c b/drivers/media/i2c/saa6588.c
index b4e1ccb..729e78d 100644
--- a/drivers/media/i2c/saa6588.c
+++ b/drivers/media/i2c/saa6588.c
@@ -478,17 +478,15 @@ static int saa6588_probe(struct i2c_client *client,
 	v4l_info(client, "saa6588 found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	s = kzalloc(sizeof(*s), GFP_KERNEL);
+	s = devm_kzalloc(&client->dev, sizeof(*s), GFP_KERNEL);
 	if (s == NULL)
 		return -ENOMEM;
 
 	s->buf_size = bufblocks * 3;
 
-	s->buffer = kmalloc(s->buf_size, GFP_KERNEL);
-	if (s->buffer == NULL) {
-		kfree(s);
+	s->buffer = devm_kzalloc(&client->dev, s->buf_size, GFP_KERNEL);
+	if (s->buffer == NULL)
 		return -ENOMEM;
-	}
 	sd = &s->sd;
 	v4l2_i2c_subdev_init(sd, client, &saa6588_ops);
 	spin_lock_init(&s->lock);
@@ -516,8 +514,6 @@ static int saa6588_remove(struct i2c_client *client)
 
 	cancel_delayed_work_sync(&s->work);
 
-	kfree(s->buffer);
-	kfree(s);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/saa7110.c b/drivers/media/i2c/saa7110.c
index 51cd4c8..e4026aa 100644
--- a/drivers/media/i2c/saa7110.c
+++ b/drivers/media/i2c/saa7110.c
@@ -406,7 +406,7 @@ static int saa7110_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	decoder = kzalloc(sizeof(struct saa7110), GFP_KERNEL);
+	decoder = devm_kzalloc(&client->dev, sizeof(*decoder), GFP_KERNEL);
 	if (!decoder)
 		return -ENOMEM;
 	sd = &decoder->sd;
@@ -428,7 +428,6 @@ static int saa7110_probe(struct i2c_client *client,
 		int err = decoder->hdl.error;
 
 		v4l2_ctrl_handler_free(&decoder->hdl);
-		kfree(decoder);
 		return err;
 	}
 	v4l2_ctrl_handler_setup(&decoder->hdl);
@@ -469,7 +468,6 @@ static int saa7110_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&decoder->hdl);
-	kfree(decoder);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 52c717d..eecb92d 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1614,7 +1614,7 @@ static int saa711x_probe(struct i2c_client *client,
 	v4l_info(client, "saa711%c found (%s) @ 0x%x (%s)\n", chip_id, name,
 		 client->addr << 1, client->adapter->name);
 
-	state = kzalloc(sizeof(struct saa711x_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;
@@ -1640,7 +1640,6 @@ static int saa711x_probe(struct i2c_client *client,
 		int err = hdl->error;
 
 		v4l2_ctrl_handler_free(hdl);
-		kfree(state);
 		return err;
 	}
 	v4l2_ctrl_auto_cluster(2, &state->agc, 0, true);
@@ -1712,7 +1711,6 @@ static int saa711x_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
-	kfree(to_state(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/saa7127.c b/drivers/media/i2c/saa7127.c
index 8a47ac1..9882c83 100644
--- a/drivers/media/i2c/saa7127.c
+++ b/drivers/media/i2c/saa7127.c
@@ -752,7 +752,7 @@ static int saa7127_probe(struct i2c_client *client,
 	v4l_dbg(1, debug, client, "detecting saa7127 client on address 0x%x\n",
 			client->addr << 1);
 
-	state = kzalloc(sizeof(struct saa7127_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 
@@ -767,7 +767,6 @@ static int saa7127_probe(struct i2c_client *client,
 	if ((saa7127_read(sd, 0) & 0xe4) != 0 ||
 			(saa7127_read(sd, 0x29) & 0x3f) != 0x1d) {
 		v4l2_dbg(1, debug, sd, "saa7127 not found\n");
-		kfree(state);
 		return -ENODEV;
 	}
 
@@ -823,7 +822,6 @@ static int saa7127_remove(struct i2c_client *client)
 	v4l2_device_unregister_subdev(sd);
 	/* Turn off TV output */
 	saa7127_set_video_enable(sd, 0);
-	kfree(to_state(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/saa717x.c b/drivers/media/i2c/saa717x.c
index cf3a0aa..7132810 100644
--- a/drivers/media/i2c/saa717x.c
+++ b/drivers/media/i2c/saa717x.c
@@ -1262,7 +1262,7 @@ static int saa717x_probe(struct i2c_client *client,
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
-	decoder = kzalloc(sizeof(struct saa717x_state), GFP_KERNEL);
+	decoder = devm_kzalloc(&client->dev, sizeof(*decoder), GFP_KERNEL);
 	if (decoder == NULL)
 		return -ENOMEM;
 
@@ -1276,7 +1276,6 @@ static int saa717x_probe(struct i2c_client *client,
 		id = saa717x_read(sd, 0x5a0);
 	if (id != 0xc2 && id != 0x32 && id != 0xf2 && id != 0x6c) {
 		v4l2_dbg(1, debug, sd, "saa717x not found (id=%02x)\n", id);
-		kfree(decoder);
 		return -ENODEV;
 	}
 	if (id == 0xc2)
@@ -1316,7 +1315,6 @@ static int saa717x_probe(struct i2c_client *client,
 		int err = hdl->error;
 
 		v4l2_ctrl_handler_free(hdl);
-		kfree(decoder);
 		return err;
 	}
 
@@ -1353,7 +1351,6 @@ static int saa717x_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
-	kfree(to_state(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/saa7185.c b/drivers/media/i2c/saa7185.c
index 2c6b65c..e95a0ed 100644
--- a/drivers/media/i2c/saa7185.c
+++ b/drivers/media/i2c/saa7185.c
@@ -326,7 +326,7 @@ static int saa7185_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	encoder = kzalloc(sizeof(struct saa7185), GFP_KERNEL);
+	encoder = devm_kzalloc(&client->dev, sizeof(*encoder), GFP_KERNEL);
 	if (encoder == NULL)
 		return -ENOMEM;
 	encoder->norm = V4L2_STD_NTSC;
@@ -352,7 +352,6 @@ static int saa7185_remove(struct i2c_client *client)
 	v4l2_device_unregister_subdev(sd);
 	/* SW: output off is active */
 	saa7185_write(sd, 0x61, (encoder->reg[0x61]) | 0x40);
-	kfree(encoder);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/saa7191.c b/drivers/media/i2c/saa7191.c
index d7d1670..84f7899 100644
--- a/drivers/media/i2c/saa7191.c
+++ b/drivers/media/i2c/saa7191.c
@@ -605,7 +605,7 @@ static int saa7191_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	decoder = kzalloc(sizeof(*decoder), GFP_KERNEL);
+	decoder = devm_kzalloc(&client->dev, sizeof(*decoder), GFP_KERNEL);
 	if (!decoder)
 		return -ENOMEM;
 
@@ -615,7 +615,6 @@ static int saa7191_probe(struct i2c_client *client,
 	err = saa7191_write_block(sd, sizeof(initseq), initseq);
 	if (err) {
 		printk(KERN_ERR "SAA7191 initialization failed\n");
-		kfree(decoder);
 		return err;
 	}
 
@@ -636,7 +635,6 @@ static int saa7191_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_saa7191(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/sony-btf-mpx.c b/drivers/media/i2c/sony-btf-mpx.c
index 38cbea9..efa3061 100644
--- a/drivers/media/i2c/sony-btf-mpx.c
+++ b/drivers/media/i2c/sony-btf-mpx.c
@@ -355,7 +355,7 @@ static int sony_btf_mpx_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	t = kzalloc(sizeof(struct sony_btf_mpx), GFP_KERNEL);
+	t = devm_kzalloc(&client->dev, sizeof(*t), GFP_KERNEL);
 	if (t == NULL)
 		return -ENOMEM;
 
@@ -374,7 +374,6 @@ static int sony_btf_mpx_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_state(sd));
 
 	return 0;
 }
diff --git a/drivers/media/i2c/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
index e9d95bd..4c5a9ee 100644
--- a/drivers/media/i2c/sr030pc30.c
+++ b/drivers/media/i2c/sr030pc30.c
@@ -820,7 +820,7 @@ static int sr030pc30_probe(struct i2c_client *client,
 	if (ret)
 		return ret;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = devm_kzalloc(&client->dev, sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
@@ -841,10 +841,8 @@ static int sr030pc30_probe(struct i2c_client *client,
 static int sr030pc30_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
-	struct sr030pc30_info *info = to_sr030pc30(sd);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(info);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/tda7432.c b/drivers/media/i2c/tda7432.c
index 28b5121..72af644 100644
--- a/drivers/media/i2c/tda7432.c
+++ b/drivers/media/i2c/tda7432.c
@@ -359,7 +359,7 @@ static int tda7432_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%02x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	t = kzalloc(sizeof(*t), GFP_KERNEL);
+	t = devm_kzalloc(&client->dev, sizeof(*t), GFP_KERNEL);
 	if (!t)
 		return -ENOMEM;
 	sd = &t->sd;
@@ -380,7 +380,6 @@ static int tda7432_probe(struct i2c_client *client,
 		int err = t->hdl.error;
 
 		v4l2_ctrl_handler_free(&t->hdl);
-		kfree(t);
 		return err;
 	}
 	v4l2_ctrl_cluster(2, &t->bass);
@@ -406,7 +405,6 @@ static int tda7432_remove(struct i2c_client *client)
 	tda7432_set(sd);
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&t->hdl);
-	kfree(t);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/tda9840.c b/drivers/media/i2c/tda9840.c
index 01441e3..3f12662 100644
--- a/drivers/media/i2c/tda9840.c
+++ b/drivers/media/i2c/tda9840.c
@@ -184,7 +184,7 @@ static int tda9840_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+	sd = devm_kzalloc(&client->dev, sizeof(*sd), GFP_KERNEL);
 	if (sd == NULL)
 		return -ENOMEM;
 	v4l2_i2c_subdev_init(sd, client, &tda9840_ops);
@@ -201,7 +201,6 @@ static int tda9840_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(sd);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/tea6415c.c b/drivers/media/i2c/tea6415c.c
index 3d5b06a..52ebc38 100644
--- a/drivers/media/i2c/tea6415c.c
+++ b/drivers/media/i2c/tea6415c.c
@@ -152,7 +152,7 @@ static int tea6415c_probe(struct i2c_client *client,
 
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
-	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+	sd = devm_kzalloc(&client->dev, sizeof(*sd), GFP_KERNEL);
 	if (sd == NULL)
 		return -ENOMEM;
 	v4l2_i2c_subdev_init(sd, client, &tea6415c_ops);
@@ -164,7 +164,6 @@ static int tea6415c_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(sd);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/tea6420.c b/drivers/media/i2c/tea6420.c
index 3875721..1f86974 100644
--- a/drivers/media/i2c/tea6420.c
+++ b/drivers/media/i2c/tea6420.c
@@ -125,7 +125,7 @@ static int tea6420_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+	sd = devm_kzalloc(&client->dev, sizeof(*sd), GFP_KERNEL);
 	if (sd == NULL)
 		return -ENOMEM;
 	v4l2_i2c_subdev_init(sd, client, &tea6420_ops);
@@ -146,7 +146,6 @@ static int tea6420_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(sd);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/tlv320aic23b.c b/drivers/media/i2c/tlv320aic23b.c
index 809a75a..ef87f7b 100644
--- a/drivers/media/i2c/tlv320aic23b.c
+++ b/drivers/media/i2c/tlv320aic23b.c
@@ -162,7 +162,7 @@ static int tlv320aic23b_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kzalloc(sizeof(struct tlv320aic23b_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;
@@ -191,7 +191,6 @@ static int tlv320aic23b_probe(struct i2c_client *client,
 		int err = state->hdl.error;
 
 		v4l2_ctrl_handler_free(&state->hdl);
-		kfree(state);
 		return err;
 	}
 	v4l2_ctrl_handler_setup(&state->hdl);
@@ -205,7 +204,6 @@ static int tlv320aic23b_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&state->hdl);
-	kfree(state);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index b72a59d..fc69e9c 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -1910,7 +1910,7 @@ static int tvaudio_probe(struct i2c_client *client, const struct i2c_device_id *
 		printk("\n");
 	}
 
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 	sd = &chip->sd;
@@ -1930,7 +1930,6 @@ static int tvaudio_probe(struct i2c_client *client, const struct i2c_device_id *
 	}
 	if (desc->name == NULL) {
 		v4l2_dbg(1, debug, sd, "no matching chip description found\n");
-		kfree(chip);
 		return -EIO;
 	}
 	v4l2_info(sd, "%s found @ 0x%x (%s)\n", desc->name, client->addr<<1, client->adapter->name);
@@ -2001,7 +2000,6 @@ static int tvaudio_probe(struct i2c_client *client, const struct i2c_device_id *
 		int err = chip->hdl.error;
 
 		v4l2_ctrl_handler_free(&chip->hdl);
-		kfree(chip);
 		return err;
 	}
 	/* set controls to the default values */
@@ -2043,7 +2041,6 @@ static int tvaudio_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&chip->hdl);
-	kfree(chip);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 485159a..de9db3b 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1152,10 +1152,9 @@ static int tvp5150_probe(struct i2c_client *c,
 	     I2C_FUNC_SMBUS_READ_BYTE | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
 		return -EIO;
 
-	core = kzalloc(sizeof(struct tvp5150), GFP_KERNEL);
-	if (!core) {
+	core = devm_kzalloc(&c->dev, sizeof(*core), GFP_KERNEL);
+	if (!core)
 		return -ENOMEM;
-	}
 	sd = &core->sd;
 	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
 
@@ -1166,7 +1165,7 @@ static int tvp5150_probe(struct i2c_client *c,
 	for (i = 0; i < 4; i++) {
 		res = tvp5150_read(sd, TVP5150_MSB_DEV_ID + i);
 		if (res < 0)
-			goto free_core;
+			return res;
 		tvp5150_id[i] = res;
 	}
 
@@ -1209,7 +1208,7 @@ static int tvp5150_probe(struct i2c_client *c,
 	if (core->hdl.error) {
 		res = core->hdl.error;
 		v4l2_ctrl_handler_free(&core->hdl);
-		goto free_core;
+		return res;
 	}
 	v4l2_ctrl_handler_setup(&core->hdl);
 
@@ -1225,10 +1224,6 @@ static int tvp5150_probe(struct i2c_client *c,
 	if (debug > 1)
 		tvp5150_log_status(sd);
 	return 0;
-
-free_core:
-	kfree(core);
-	return res;
 }
 
 static int tvp5150_remove(struct i2c_client *c)
@@ -1242,7 +1237,6 @@ static int tvp5150_remove(struct i2c_client *c)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&decoder->hdl);
-	kfree(to_tvp5150(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/tw2804.c b/drivers/media/i2c/tw2804.c
index c5dc2c3..41a5c9b 100644
--- a/drivers/media/i2c/tw2804.c
+++ b/drivers/media/i2c/tw2804.c
@@ -368,8 +368,7 @@ static int tw2804_probe(struct i2c_client *client,
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -ENODEV;
 
-	state = kzalloc(sizeof(struct tw2804), GFP_KERNEL);
-
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;
@@ -410,7 +409,6 @@ static int tw2804_probe(struct i2c_client *client,
 	err = state->hdl.error;
 	if (err) {
 		v4l2_ctrl_handler_free(&state->hdl);
-		kfree(state);
 		return err;
 	}
 
@@ -427,7 +425,6 @@ static int tw2804_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&state->hdl);
-	kfree(state);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/tw9903.c b/drivers/media/i2c/tw9903.c
index 87880b1..285b759 100644
--- a/drivers/media/i2c/tw9903.c
+++ b/drivers/media/i2c/tw9903.c
@@ -215,7 +215,7 @@ static int tw9903_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%02x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	dec = kzalloc(sizeof(struct tw9903), GFP_KERNEL);
+	dec = devm_kzalloc(&client->dev, sizeof(*dec), GFP_KERNEL);
 	if (dec == NULL)
 		return -ENOMEM;
 	sd = &dec->sd;
@@ -233,7 +233,6 @@ static int tw9903_probe(struct i2c_client *client,
 		int err = hdl->error;
 
 		v4l2_ctrl_handler_free(hdl);
-		kfree(dec);
 		return err;
 	}
 
@@ -242,7 +241,6 @@ static int tw9903_probe(struct i2c_client *client,
 
 	if (write_regs(sd, initial_registers) < 0) {
 		v4l2_err(client, "error initializing TW9903\n");
-		kfree(dec);
 		return -EINVAL;
 	}
 
@@ -255,7 +253,6 @@ static int tw9903_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&to_state(sd)->hdl);
-	kfree(to_state(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/tw9906.c b/drivers/media/i2c/tw9906.c
index accd79e..f6bef25 100644
--- a/drivers/media/i2c/tw9906.c
+++ b/drivers/media/i2c/tw9906.c
@@ -183,7 +183,7 @@ static int tw9906_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%02x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	dec = kzalloc(sizeof(struct tw9906), GFP_KERNEL);
+	dec = devm_kzalloc(&client->dev, sizeof(*dec), GFP_KERNEL);
 	if (dec == NULL)
 		return -ENOMEM;
 	sd = &dec->sd;
@@ -201,7 +201,6 @@ static int tw9906_probe(struct i2c_client *client,
 		int err = hdl->error;
 
 		v4l2_ctrl_handler_free(hdl);
-		kfree(dec);
 		return err;
 	}
 
@@ -210,7 +209,6 @@ static int tw9906_probe(struct i2c_client *client,
 
 	if (write_regs(sd, initial_registers) < 0) {
 		v4l2_err(client, "error initializing TW9906\n");
-		kfree(dec);
 		return -EINVAL;
 	}
 
@@ -223,7 +221,6 @@ static int tw9906_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&to_state(sd)->hdl);
-	kfree(to_state(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/uda1342.c b/drivers/media/i2c/uda1342.c
index 3af4085..081786d 100644
--- a/drivers/media/i2c/uda1342.c
+++ b/drivers/media/i2c/uda1342.c
@@ -69,7 +69,7 @@ static int uda1342_probe(struct i2c_client *client,
 	dev_dbg(&client->dev, "initializing UDA1342 at address %d on %s\n",
 		client->addr, adapter->name);
 
-	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+	sd = devm_kzalloc(&client->dev, sizeof(*sd), GFP_KERNEL);
 	if (sd == NULL)
 		return -ENOMEM;
 
@@ -89,7 +89,6 @@ static int uda1342_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(sd);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/upd64031a.c b/drivers/media/i2c/upd64031a.c
index f0a0921..4283fc5 100644
--- a/drivers/media/i2c/upd64031a.c
+++ b/drivers/media/i2c/upd64031a.c
@@ -230,7 +230,7 @@ static int upd64031a_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kzalloc(sizeof(struct upd64031a_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;
@@ -249,7 +249,6 @@ static int upd64031a_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_state(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/upd64083.c b/drivers/media/i2c/upd64083.c
index 343e021..b2ac56c 100644
--- a/drivers/media/i2c/upd64083.c
+++ b/drivers/media/i2c/upd64083.c
@@ -202,7 +202,7 @@ static int upd64083_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kzalloc(sizeof(struct upd64083_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;
@@ -221,7 +221,6 @@ static int upd64083_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_state(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/vp27smpx.c b/drivers/media/i2c/vp27smpx.c
index e71f139..208a095 100644
--- a/drivers/media/i2c/vp27smpx.c
+++ b/drivers/media/i2c/vp27smpx.c
@@ -169,7 +169,7 @@ static int vp27smpx_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kzalloc(sizeof(struct vp27smpx_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;
@@ -186,7 +186,6 @@ static int vp27smpx_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_state(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/vpx3220.c b/drivers/media/i2c/vpx3220.c
index 2f67b4c..f02e74b 100644
--- a/drivers/media/i2c/vpx3220.c
+++ b/drivers/media/i2c/vpx3220.c
@@ -499,7 +499,7 @@ static int vpx3220_probe(struct i2c_client *client,
 		I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA))
 		return -ENODEV;
 
-	decoder = kzalloc(sizeof(struct vpx3220), GFP_KERNEL);
+	decoder = devm_kzalloc(&client->dev, sizeof(*decoder), GFP_KERNEL);
 	if (decoder == NULL)
 		return -ENOMEM;
 	sd = &decoder->sd;
@@ -521,7 +521,6 @@ static int vpx3220_probe(struct i2c_client *client,
 		int err = decoder->hdl.error;
 
 		v4l2_ctrl_handler_free(&decoder->hdl);
-		kfree(decoder);
 		return err;
 	}
 	v4l2_ctrl_handler_setup(&decoder->hdl);
@@ -566,7 +565,7 @@ static int vpx3220_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&decoder->hdl);
-	kfree(decoder);
+
 	return 0;
 }
 
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index 6b8c0b7..94e2849 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -813,11 +813,9 @@ static int vs6624_probe(struct i2c_client *client,
 	/* wait 100ms before any further i2c writes are performed */
 	mdelay(100);
 
-	sensor = kzalloc(sizeof(*sensor), GFP_KERNEL);
-	if (sensor == NULL) {
-		gpio_free(*ce);
+	sensor = devm_kzalloc(&client->dev, sizeof(*sensor), GFP_KERNEL);
+	if (sensor == NULL)
 		return -ENOMEM;
-	}
 
 	sd = &sensor->sd;
 	v4l2_i2c_subdev_init(sd, client, &vs6624_ops);
@@ -865,7 +863,6 @@ static int vs6624_probe(struct i2c_client *client,
 		int err = hdl->error;
 
 		v4l2_ctrl_handler_free(hdl);
-		kfree(sensor);
 		gpio_free(*ce);
 		return err;
 	}
@@ -874,7 +871,6 @@ static int vs6624_probe(struct i2c_client *client,
 	ret = v4l2_ctrl_handler_setup(hdl);
 	if (ret) {
 		v4l2_ctrl_handler_free(hdl);
-		kfree(sensor);
 		gpio_free(*ce);
 	}
 	return ret;
@@ -888,7 +884,6 @@ static int vs6624_remove(struct i2c_client *client)
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	gpio_free(sensor->ce_pin);
-	kfree(sensor);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/wm8739.c b/drivers/media/i2c/wm8739.c
index 3bb99e9..ac3faa7 100644
--- a/drivers/media/i2c/wm8739.c
+++ b/drivers/media/i2c/wm8739.c
@@ -220,7 +220,7 @@ static int wm8739_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kzalloc(sizeof(struct wm8739_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;
@@ -237,7 +237,6 @@ static int wm8739_probe(struct i2c_client *client,
 		int err = state->hdl.error;
 
 		v4l2_ctrl_handler_free(&state->hdl);
-		kfree(state);
 		return err;
 	}
 	v4l2_ctrl_cluster(3, &state->volume);
@@ -271,7 +270,6 @@ static int wm8739_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&state->hdl);
-	kfree(to_state(sd));
 	return 0;
 }
 
diff --git a/drivers/media/i2c/wm8775.c b/drivers/media/i2c/wm8775.c
index 27c27b4..75ded82 100644
--- a/drivers/media/i2c/wm8775.c
+++ b/drivers/media/i2c/wm8775.c
@@ -241,7 +241,7 @@ static int wm8775_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%02x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kzalloc(sizeof(struct wm8775_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;
@@ -261,7 +261,6 @@ static int wm8775_probe(struct i2c_client *client,
 	err = state->hdl.error;
 	if (err) {
 		v4l2_ctrl_handler_free(&state->hdl);
-		kfree(state);
 		return err;
 	}
 
@@ -319,7 +318,6 @@ static int wm8775_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&state->hdl);
-	kfree(state);
 	return 0;
 }
 
-- 
1.8.1.5

