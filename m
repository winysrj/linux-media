Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60014 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751430AbdGRTEG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:04:06 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hverkuil@xs4all.nl
Subject: [RFC 06/19] leds: as3645a: Separate flash and indicator LED sub-devices
Date: Tue, 18 Jul 2017 22:03:48 +0300
Message-Id: <20170718190401.14797-7-sakari.ailus@linux.intel.com>
In-Reply-To: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To be merged to the as3645a driver patch.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/leds/leds-as3645a.c | 64 +++++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff --git a/drivers/leds/leds-as3645a.c b/drivers/leds/leds-as3645a.c
index b1dc32a3c620..9df480cea160 100644
--- a/drivers/leds/leds-as3645a.c
+++ b/drivers/leds/leds-as3645a.c
@@ -138,6 +138,10 @@ struct as3645a {
 	struct led_classdev iled_cdev;
 
 	struct v4l2_flash *vf;
+	struct v4l2_flash *vfind;
+
+	struct device_node *flash_node;
+	struct device_node *indicator_node;
 
 	struct as3645a_config cfg;
 
@@ -508,16 +512,15 @@ static int as3645a_parse_node(struct as3645a *flash,
 			      struct device_node *node)
 {
 	struct as3645a_config *cfg = &flash->cfg;
-	struct device_node *child;
 	int rval;
 
-	child = of_get_child_by_name(node, "flash");
-	if (!child) {
+	flash->flash_node = of_get_child_by_name(node, "flash");
+	if (!flash->flash_node) {
 		dev_err(&flash->client->dev, "can't find flash node\n");
 		return -ENODEV;
 	}
 
-	rval = of_property_read_u32(child, "flash-timeout-us",
+	rval = of_property_read_u32(flash->flash_node, "flash-timeout-us",
 				   &cfg->flash_timeout_us);
 	if (rval < 0) {
 		dev_err(&flash->client->dev,
@@ -525,7 +528,7 @@ static int as3645a_parse_node(struct as3645a *flash,
 		goto out_err;
 	}
 
-	rval = of_property_read_u32(child, "flash-max-microamp",
+	rval = of_property_read_u32(flash->flash_node, "flash-max-microamp",
 				   &cfg->flash_max_ua);
 	if (rval < 0) {
 		dev_err(&flash->client->dev,
@@ -533,7 +536,7 @@ static int as3645a_parse_node(struct as3645a *flash,
 		goto out_err;
 	}
 
-	rval = of_property_read_u32(child, "led-max-microamp",
+	rval = of_property_read_u32(flash->flash_node, "led-max-microamp",
 				   &cfg->assist_max_ua);
 	if (rval < 0) {
 		dev_err(&flash->client->dev,
@@ -541,22 +544,21 @@ static int as3645a_parse_node(struct as3645a *flash,
 		goto out_err;
 	}
 
-	of_property_read_u32(child, "voltage-reference",
+	of_property_read_u32(flash->flash_node, "voltage-reference",
 			     &cfg->voltage_reference);
 
-	of_property_read_u32(child, "peak-current-limit", &cfg->peak);
+	of_property_read_u32(flash->flash_node, "peak-current-limit",
+			     &cfg->peak);
 	cfg->peak = AS_PEAK_mA_TO_REG(cfg->peak);
 
-	of_node_put(child);
-
-	child = of_get_child_by_name(node, "indicator");
-	if (!child) {
+	flash->indicator_node = of_get_child_by_name(node, "indicator");
+	if (!flash->indicator_node) {
 		dev_warn(&flash->client->dev,
 			 "can't find indicator node\n");
-		return 0;
+		goto out_err;
 	}
 
-	rval = of_property_read_u32(child, "led-max-microamp",
+	rval = of_property_read_u32(flash->indicator_node, "led-max-microamp",
 				   &cfg->indicator_max_ua);
 	if (rval < 0) {
 		dev_err(&flash->client->dev,
@@ -564,12 +566,11 @@ static int as3645a_parse_node(struct as3645a *flash,
 		goto out_err;
 	}
 
-	of_node_put(child);
-
 	return 0;
 
 out_err:
-	of_node_put(child);
+	of_node_put(flash->flash_node);
+	of_node_put(flash->indicator_node);
 
 	return rval;
 }
@@ -628,13 +629,15 @@ static int as3645a_v4l2_setup(struct as3645a *flash)
 	struct led_classdev_flash *fled = &flash->fled;
 	struct led_classdev *led = &fled->led_cdev;
 	struct v4l2_flash_config cfg = {
-		.torch_intensity = {
+		.intensity = {
 			.min = AS_TORCH_INTENSITY_MIN,
 			.max = flash->cfg.assist_max_ua,
 			.step = AS_TORCH_INTENSITY_STEP,
 			.val = flash->cfg.assist_max_ua,
 		},
-		.indicator_intensity = {
+	};
+	struct v4l2_flash_config cfgind = {
+		.intensity = {
 			.min = AS_INDICATOR_INTENSITY_MIN,
 			.max = flash->cfg.indicator_max_ua,
 			.step = AS_INDICATOR_INTENSITY_STEP,
@@ -643,12 +646,22 @@ static int as3645a_v4l2_setup(struct as3645a *flash)
 	};
 
 	strlcpy(cfg.dev_name, led->name, sizeof(cfg.dev_name));
+	strlcpy(cfgind.dev_name, flash->iled_cdev.name, sizeof(cfg.dev_name));
 
-	flash->vf = v4l2_flash_init(&flash->client->dev, NULL, &flash->fled,
-				    &flash->iled_cdev, NULL, &cfg);
+	flash->vf = v4l2_flash_init(
+		&flash->client->dev, of_fwnode_handle(flash->flash_node),
+		&flash->fled, NULL, &cfg);
 	if (IS_ERR(flash->vf))
 		return PTR_ERR(flash->vf);
 
+	flash->vfind = v4l2_flash_indicator_init(
+		&flash->client->dev, of_fwnode_handle(flash->indicator_node),
+		&flash->iled_cdev, &cfgind);
+	if (IS_ERR(flash->vfind)) {
+		v4l2_flash_release(flash->vf);
+		return PTR_ERR(flash->vfind);
+	}
+
 	return 0;
 }
 
@@ -672,7 +685,7 @@ static int as3645a_probe(struct i2c_client *client)
 
 	rval = as3645a_detect(flash);
 	if (rval < 0)
-		return rval;
+		goto out_put_nodes;
 
 	mutex_init(&flash->mutex);
 	i2c_set_clientdata(client, flash);
@@ -697,6 +710,10 @@ static int as3645a_probe(struct i2c_client *client)
 out_mutex_destroy:
 	mutex_destroy(&flash->mutex);
 
+out_put_nodes:
+	of_node_put(flash->flash_node);
+	of_node_put(flash->indicator_node);
+
 	return rval;
 }
 
@@ -713,6 +730,9 @@ static int as3645a_remove(struct i2c_client *client)
 
 	mutex_destroy(&flash->mutex);
 
+	of_node_put(flash->flash_node);
+	of_node_put(flash->indicator_node);
+
 	return 0;
 }
 
-- 
2.11.0
