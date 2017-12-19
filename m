Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33290 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752455AbdLSVAC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 16:00:02 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Kristian Beilke <beilke@posteo.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 05/10] staging: atomisp: Remove non-ACPI leftovers
Date: Tue, 19 Dec 2017 22:59:52 +0200
Message-Id: <20171219205957.10933-5-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
References: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since all drivers are solely requiring ACPI enumeration, there is no
need to additionally check for legacy platform data or ACPI handle.

Remove leftovers from the sensors and platform code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c | 10 ++---
 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c |  8 +---
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c | 28 ++++----------
 .../staging/media/atomisp/i2c/atomisp-mt9m114.c    |  8 ++--
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c | 10 ++---
 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c | 17 ++-------
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      | 12 ++----
 drivers/staging/media/atomisp/i2c/ov8858.c         | 43 +++++++++++-----------
 .../platform/intel-mid/atomisp_gmin_platform.c     |  6 +--
 9 files changed, 49 insertions(+), 93 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c b/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
index e70d8afcc229..61b7598469eb 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
@@ -1370,13 +1370,9 @@ static int gc0310_probe(struct i2c_client *client)
 	dev->fmt_idx = 0;
 	v4l2_i2c_subdev_init(&(dev->sd), client, &gc0310_ops);
 
-	if (ACPI_COMPANION(&client->dev))
-		pdata = gmin_camera_platform_data(&dev->sd,
-						  ATOMISP_INPUT_FORMAT_RAW_8,
-						  atomisp_bayer_order_grbg);
-	else
-		pdata = client->dev.platform_data;
-
+	pdata = gmin_camera_platform_data(&dev->sd,
+					  ATOMISP_INPUT_FORMAT_RAW_8,
+					  atomisp_bayer_order_grbg);
 	if (!pdata) {
 		ret = -EINVAL;
 		goto out_free;
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c b/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
index 85da5fe24033..d8de46da64ae 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
@@ -1108,9 +1108,7 @@ static int gc2235_probe(struct i2c_client *client)
 	dev->fmt_idx = 0;
 	v4l2_i2c_subdev_init(&(dev->sd), client, &gc2235_ops);
 
-	gcpdev = client->dev.platform_data;
-	if (ACPI_COMPANION(&client->dev))
-		gcpdev = gmin_camera_platform_data(&dev->sd,
+	gcpdev = gmin_camera_platform_data(&dev->sd,
 				   ATOMISP_INPUT_FORMAT_RAW_10,
 				   atomisp_bayer_order_grbg);
 
@@ -1147,10 +1145,8 @@ static int gc2235_probe(struct i2c_client *client)
 	if (ret)
 		gc2235_remove(client);
 
-	if (ACPI_HANDLE(&client->dev))
-		ret = atomisp_register_i2c_module(&dev->sd, gcpdev, RAW_CAMERA);
+	return atomisp_register_i2c_module(&dev->sd, gcpdev, RAW_CAMERA);
 
-	return ret;
 out_free:
 	v4l2_device_unregister_subdev(&dev->sd);
 	kfree(dev);
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
index 974b6ff50c7a..7098bf317f16 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
@@ -824,22 +824,15 @@ static void *lm3554_platform_data_func(struct i2c_client *client)
 {
 	static struct lm3554_platform_data platform_data;
 
-	if (ACPI_COMPANION(&client->dev)) {
-		platform_data.gpio_reset =
-		    desc_to_gpio(gpiod_get_index(&(client->dev),
+	platform_data.gpio_reset =
+		    desc_to_gpio(gpiod_get_index(&client->dev,
 						 NULL, 2, GPIOD_OUT_LOW));
-		platform_data.gpio_strobe =
-		    desc_to_gpio(gpiod_get_index(&(client->dev),
+	platform_data.gpio_strobe =
+		    desc_to_gpio(gpiod_get_index(&client->dev,
 						 NULL, 0, GPIOD_OUT_LOW));
-		platform_data.gpio_torch =
-		    desc_to_gpio(gpiod_get_index(&(client->dev),
+	platform_data.gpio_torch =
+		    desc_to_gpio(gpiod_get_index(&client->dev,
 						 NULL, 1, GPIOD_OUT_LOW));
-	} else {
-		platform_data.gpio_reset = -1;
-		platform_data.gpio_strobe = -1;
-		platform_data.gpio_torch = -1;
-	}
-
 	dev_info(&client->dev, "camera pdata: lm3554: reset: %d strobe %d torch %d\n",
 		platform_data.gpio_reset, platform_data.gpio_strobe,
 		platform_data.gpio_torch);
@@ -868,10 +861,7 @@ static int lm3554_probe(struct i2c_client *client)
 	if (!flash)
 		return -ENOMEM;
 
-	flash->pdata = client->dev.platform_data;
-
-	if (!flash->pdata || ACPI_COMPANION(&client->dev))
-		flash->pdata = lm3554_platform_data_func(client);
+	flash->pdata = lm3554_platform_data_func(client);
 
 	v4l2_i2c_subdev_init(&flash->sd, client, &lm3554_ops);
 	flash->sd.internal_ops = &lm3554_internal_ops;
@@ -914,9 +904,7 @@ static int lm3554_probe(struct i2c_client *client)
 		dev_err(&client->dev, "gpio request/direction_output fail");
 		goto fail2;
 	}
-	if (ACPI_HANDLE(&client->dev))
-		err = atomisp_register_i2c_module(&flash->sd, NULL, LED_FLASH);
-	return 0;
+	return atomisp_register_i2c_module(&flash->sd, NULL, LED_FLASH);
 fail2:
 	media_entity_cleanup(&flash->sd.entity);
 	v4l2_ctrl_handler_free(&flash->ctrl_handler);
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c b/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
index 55882bea2049..df253a557c76 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
@@ -1844,11 +1844,9 @@ static int mt9m114_probe(struct i2c_client *client)
 		return -ENOMEM;
 
 	v4l2_i2c_subdev_init(&dev->sd, client, &mt9m114_ops);
-	pdata = client->dev.platform_data;
-	if (ACPI_COMPANION(&client->dev))
-		pdata = gmin_camera_platform_data(&dev->sd,
-						  ATOMISP_INPUT_FORMAT_RAW_10,
-						  atomisp_bayer_order_grbg);
+	pdata = gmin_camera_platform_data(&dev->sd,
+					  ATOMISP_INPUT_FORMAT_RAW_10,
+					  atomisp_bayer_order_grbg);
 	if (pdata)
 		ret = mt9m114_s_config(&dev->sd, client->irq, pdata);
 	if (!pdata || ret) {
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
index cd67d38f183a..84f8d33ce2d1 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
@@ -1447,13 +1447,9 @@ static int ov2680_probe(struct i2c_client *client)
 	dev->fmt_idx = 0;
 	v4l2_i2c_subdev_init(&(dev->sd), client, &ov2680_ops);
 
-	if (ACPI_COMPANION(&client->dev))
-		pdata = gmin_camera_platform_data(&dev->sd,
-						  ATOMISP_INPUT_FORMAT_RAW_10,
-						  atomisp_bayer_order_bggr);
-	else
-		pdata = client->dev.platform_data;
-
+	pdata = gmin_camera_platform_data(&dev->sd,
+					  ATOMISP_INPUT_FORMAT_RAW_10,
+					  atomisp_bayer_order_bggr);
 	if (!pdata) {
 		ret = -EINVAL;
 		goto out_free;
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
index 4df7eba8d375..2b6ae0faf972 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
@@ -1259,7 +1259,6 @@ static int ov2722_probe(struct i2c_client *client)
 	struct ov2722_device *dev;
 	void *ovpdev;
 	int ret;
-	struct acpi_device *adev;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
@@ -1270,14 +1269,9 @@ static int ov2722_probe(struct i2c_client *client)
 	dev->fmt_idx = 0;
 	v4l2_i2c_subdev_init(&(dev->sd), client, &ov2722_ops);
 
-	ovpdev = client->dev.platform_data;
-	adev = ACPI_COMPANION(&client->dev);
-	if (adev) {
-		adev->power.flags.power_resources = 0;
-		ovpdev = gmin_camera_platform_data(&dev->sd,
-						   ATOMISP_INPUT_FORMAT_RAW_10,
-						   atomisp_bayer_order_grbg);
-	}
+	ovpdev = gmin_camera_platform_data(&dev->sd,
+					   ATOMISP_INPUT_FORMAT_RAW_10,
+					   atomisp_bayer_order_grbg);
 
 	ret = ov2722_s_config(&dev->sd, client->irq, ovpdev);
 	if (ret)
@@ -1296,10 +1290,7 @@ static int ov2722_probe(struct i2c_client *client)
 	if (ret)
 		ov2722_remove(client);
 
-	if (ACPI_HANDLE(&client->dev))
-		ret = atomisp_register_i2c_module(&dev->sd, ovpdev, RAW_CAMERA);
-
-	return ret;
+	return atomisp_register_i2c_module(&dev->sd, ovpdev, RAW_CAMERA);
 
 out_ctrl_handler_free:
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
index 3e7c3851280f..2a680eae20d3 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
@@ -1928,7 +1928,6 @@ static int ov5693_probe(struct i2c_client *client)
 	int i2c;
 	int ret = 0;
 	void *pdata = client->dev.platform_data;
-	struct acpi_device *adev;
 	unsigned int i;
 
 	/* Firmware workaround: Some modules use a "secondary default"
@@ -1952,14 +1951,9 @@ static int ov5693_probe(struct i2c_client *client)
 	dev->fmt_idx = 0;
 	v4l2_i2c_subdev_init(&(dev->sd), client, &ov5693_ops);
 
-	adev = ACPI_COMPANION(&client->dev);
-	if (adev) {
-		adev->power.flags.power_resources = 0;
-		pdata = gmin_camera_platform_data(&dev->sd,
-						  ATOMISP_INPUT_FORMAT_RAW_10,
-						  atomisp_bayer_order_bggr);
-	}
-
+	pdata = gmin_camera_platform_data(&dev->sd,
+					  ATOMISP_INPUT_FORMAT_RAW_10,
+					  atomisp_bayer_order_bggr);
 	if (!pdata)
 		goto out_free;
 
diff --git a/drivers/staging/media/atomisp/i2c/ov8858.c b/drivers/staging/media/atomisp/i2c/ov8858.c
index ba147ac2e36f..3cf8c710ac65 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858.c
+++ b/drivers/staging/media/atomisp/i2c/ov8858.c
@@ -2077,29 +2077,28 @@ static int ov8858_probe(struct i2c_client *client)
 
 	v4l2_i2c_subdev_init(&(dev->sd), client, &ov8858_ops);
 
-	if (ACPI_COMPANION(&client->dev)) {
-		pdata = gmin_camera_platform_data(&dev->sd,
-						  ATOMISP_INPUT_FORMAT_RAW_10,
-						  atomisp_bayer_order_bggr);
-		if (!pdata) {
-			dev_err(&client->dev,
-				"%s: failed to get acpi platform data\n",
-				__func__);
-			goto out_free;
-		}
-		ret = ov8858_s_config(&dev->sd, client->irq, pdata);
-		if (ret) {
-			dev_err(&client->dev,
-				"%s: failed to set config\n", __func__);
-			goto out_free;
-		}
-		ret = atomisp_register_i2c_module(&dev->sd, pdata, RAW_CAMERA);
-		if (ret) {
-			dev_err(&client->dev,
-				"%s: failed to register subdev\n", __func__);
-			goto out_free;
-		}
+	pdata = gmin_camera_platform_data(&dev->sd,
+					  ATOMISP_INPUT_FORMAT_RAW_10,
+					  atomisp_bayer_order_bggr);
+	if (!pdata) {
+		dev_err(&client->dev,
+			"%s: failed to get acpi platform data\n",
+			__func__);
+		goto out_free;
+	}
+	ret = ov8858_s_config(&dev->sd, client->irq, pdata);
+	if (ret) {
+		dev_err(&client->dev,
+			"%s: failed to set config\n", __func__);
+		goto out_free;
 	}
+	ret = atomisp_register_i2c_module(&dev->sd, pdata, RAW_CAMERA);
+	if (ret) {
+		dev_err(&client->dev,
+			"%s: failed to register subdev\n", __func__);
+		goto out_free;
+	}
+
 	/*
 	 * sd->name is updated with sensor driver name by the v4l2.
 	 * change it to sensor name in this case.
diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 8fb5147531a5..8dcec0e780a1 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -114,7 +114,7 @@ int atomisp_register_i2c_module(struct v4l2_subdev *subdev,
 	struct i2c_board_info *bi;
 	struct gmin_subdev *gs;
 	struct i2c_client *client = v4l2_get_subdevdata(subdev);
-	struct acpi_device *adev;
+	struct acpi_device *adev = ACPI_COMPANION(&client->dev);
 
 	dev_info(&client->dev, "register atomisp i2c module type %d\n", type);
 
@@ -124,9 +124,7 @@ int atomisp_register_i2c_module(struct v4l2_subdev *subdev,
 	 * tickled during suspend/resume.  This has caused power and
 	 * performance issues on multiple devices.
 	 */
-	adev = ACPI_COMPANION(&client->dev);
-	if (adev)
-		adev->power.flags.power_resources = 0;
+	adev->power.flags.power_resources = 0;
 
 	for (i = 0; i < MAX_SUBDEVS; i++)
 		if (!pdata.subdevs[i].type)
-- 
2.15.1
