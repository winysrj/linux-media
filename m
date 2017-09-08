Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47560 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755824AbdIHNSc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 09:18:32 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v9 18/24] as3645a: Switch to fwnode property API
Date: Fri,  8 Sep 2017 16:18:16 +0300
Message-Id: <20170908131822.31020-14-sakari.ailus@linux.intel.com>
In-Reply-To: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch the as3645a from OF to the fwnode property API. Also add ACPI
support.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/leds/leds-as3645a.c | 81 +++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 35 deletions(-)

diff --git a/drivers/leds/leds-as3645a.c b/drivers/leds/leds-as3645a.c
index 605e0c64e974..2e73c3f818f1 100644
--- a/drivers/leds/leds-as3645a.c
+++ b/drivers/leds/leds-as3645a.c
@@ -25,7 +25,7 @@
 #include <linux/leds.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/of.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 
 #include <media/v4l2-flash-led-class.h>
@@ -148,8 +148,8 @@ struct as3645a {
 	struct v4l2_flash *vf;
 	struct v4l2_flash *vfind;
 
-	struct device_node *flash_node;
-	struct device_node *indicator_node;
+	struct fwnode_handle *flash_node;
+	struct fwnode_handle *indicator_node;
 
 	struct as3645a_config cfg;
 
@@ -492,30 +492,33 @@ static int as3645a_detect(struct as3645a *flash)
 
 static int as3645a_parse_node(struct as3645a *flash,
 			      struct as3645a_names *names,
-			      struct device_node *node)
+			      struct fwnode_handle *fwnode)
 {
 	struct as3645a_config *cfg = &flash->cfg;
-	struct device_node *child;
+	struct fwnode_handle *child;
 	const char *name;
+	const char *str;
 	int rval;
 
-	for_each_child_of_node(node, child) {
+	fwnode_for_each_child_node(fwnode, child) {
 		u32 id = 0;
 
-		of_property_read_u32(child, "reg", &id);
+		fwnode_property_read_u32(
+			child, is_of_node(child) ? "reg" : "led", &id);
 
 		switch (id) {
 		case AS_LED_FLASH:
-			flash->flash_node = of_node_get(child);
+			flash->flash_node = child;
 			break;
 		case AS_LED_INDICATOR:
-			flash->indicator_node = of_node_get(child);
+			flash->indicator_node = child;
 			break;
 		default:
 			dev_warn(&flash->client->dev,
 				 "unknown LED %u encountered, ignoring\n", id);
 			break;
 		}
+		fwnode_handle_get(child);
 	}
 
 	if (!flash->flash_node) {
@@ -523,14 +526,18 @@ static int as3645a_parse_node(struct as3645a *flash,
 		return -ENODEV;
 	}
 
-	rval = of_property_read_string(flash->flash_node, "label", &name);
-	if (!rval)
+	rval = fwnode_property_read_string(flash->flash_node, "label", &name);
+	if (!rval) {
 		strlcpy(names->flash, name, sizeof(names->flash));
-	else
+	} else if (is_of_node(fwnode)) {
 		snprintf(names->flash, sizeof(names->flash),
-			 "%s:flash", node->name);
+			 "%s:flash", to_of_node(fwnode)->name);
+	} else {
+		dev_err(&flash->client->dev, "flash node has no label!\n");
+		return -EINVAL;
+	}
 
-	rval = of_property_read_u32(flash->flash_node, "flash-timeout-us",
+	rval = fwnode_property_read_u32(flash->flash_node, "flash-timeout-us",
 				    &cfg->flash_timeout_us);
 	if (rval < 0) {
 		dev_err(&flash->client->dev,
@@ -538,7 +545,7 @@ static int as3645a_parse_node(struct as3645a *flash,
 		goto out_err;
 	}
 
-	rval = of_property_read_u32(flash->flash_node, "flash-max-microamp",
+	rval = fwnode_property_read_u32(flash->flash_node, "flash-max-microamp",
 				    &cfg->flash_max_ua);
 	if (rval < 0) {
 		dev_err(&flash->client->dev,
@@ -546,7 +553,7 @@ static int as3645a_parse_node(struct as3645a *flash,
 		goto out_err;
 	}
 
-	rval = of_property_read_u32(flash->flash_node, "led-max-microamp",
+	rval = fwnode_property_read_u32(flash->flash_node, "led-max-microamp",
 				    &cfg->assist_max_ua);
 	if (rval < 0) {
 		dev_err(&flash->client->dev,
@@ -554,10 +561,10 @@ static int as3645a_parse_node(struct as3645a *flash,
 		goto out_err;
 	}
 
-	of_property_read_u32(flash->flash_node, "voltage-reference",
+	fwnode_property_read_u32(flash->flash_node, "voltage-reference",
 			     &cfg->voltage_reference);
 
-	of_property_read_u32(flash->flash_node, "ams,input-max-microamp",
+	fwnode_property_read_u32(flash->flash_node, "ams,input-max-microamp",
 			     &cfg->peak);
 	cfg->peak = AS_PEAK_mA_TO_REG(cfg->peak);
 
@@ -567,14 +574,18 @@ static int as3645a_parse_node(struct as3645a *flash,
 		goto out_err;
 	}
 
-	rval = of_property_read_string(flash->indicator_node, "label", &name);
-	if (!rval)
+	rval = fwnode_property_read_string(flash->indicator_node, "label", &name);
+	if (!rval) {
 		strlcpy(names->indicator, name, sizeof(names->indicator));
-	else
+	} else if (is_of_node(fwnode)) {
 		snprintf(names->indicator, sizeof(names->indicator),
-			 "%s:indicator", node->name);
+			 "%s:indicator", to_of_node(fwnode)->name);
+	} else {
+		dev_err(&flash->client->dev, "flash node has no label!\n");
+		return -EINVAL;
+	}
 
-	rval = of_property_read_u32(flash->indicator_node, "led-max-microamp",
+	rval = fwnode_property_read_u32(flash->indicator_node, "led-max-microamp",
 				    &cfg->indicator_max_ua);
 	if (rval < 0) {
 		dev_err(&flash->client->dev,
@@ -585,8 +596,8 @@ static int as3645a_parse_node(struct as3645a *flash,
 	return 0;
 
 out_err:
-	of_node_put(flash->flash_node);
-	of_node_put(flash->indicator_node);
+	fwnode_handle_put(flash->flash_node);
+	fwnode_handle_put(flash->indicator_node);
 
 	return rval;
 }
@@ -667,14 +678,14 @@ static int as3645a_v4l2_setup(struct as3645a *flash)
 	strlcpy(cfgind.dev_name, flash->iled_cdev.name, sizeof(cfg.dev_name));
 
 	flash->vf = v4l2_flash_init(
-		&flash->client->dev, of_fwnode_handle(flash->flash_node),
-		&flash->fled, NULL, &cfg);
+		&flash->client->dev, flash->flash_node, &flash->fled, NULL,
+		&cfg);
 	if (IS_ERR(flash->vf))
 		return PTR_ERR(flash->vf);
 
 	flash->vfind = v4l2_flash_indicator_init(
-		&flash->client->dev, of_fwnode_handle(flash->indicator_node),
-		&flash->iled_cdev, &cfgind);
+		&flash->client->dev, flash->indicator_node, &flash->iled_cdev,
+		&cfgind);
 	if (IS_ERR(flash->vfind)) {
 		v4l2_flash_release(flash->vf);
 		return PTR_ERR(flash->vfind);
@@ -689,7 +700,7 @@ static int as3645a_probe(struct i2c_client *client)
 	struct as3645a *flash;
 	int rval;
 
-	if (client->dev.of_node == NULL)
+	if (!dev_fwnode(&client->dev))
 		return -ENODEV;
 
 	flash = devm_kzalloc(&client->dev, sizeof(*flash), GFP_KERNEL);
@@ -698,7 +709,7 @@ static int as3645a_probe(struct i2c_client *client)
 
 	flash->client = client;
 
-	rval = as3645a_parse_node(flash, &names, client->dev.of_node);
+	rval = as3645a_parse_node(flash, &names, dev_fwnode(&client->dev));
 	if (rval < 0)
 		return rval;
 
@@ -730,8 +741,8 @@ static int as3645a_probe(struct i2c_client *client)
 	mutex_destroy(&flash->mutex);
 
 out_put_nodes:
-	of_node_put(flash->flash_node);
-	of_node_put(flash->indicator_node);
+	fwnode_handle_put(flash->flash_node);
+	fwnode_handle_put(flash->indicator_node);
 
 	return rval;
 }
@@ -749,8 +760,8 @@ static int as3645a_remove(struct i2c_client *client)
 
 	mutex_destroy(&flash->mutex);
 
-	of_node_put(flash->flash_node);
-	of_node_put(flash->indicator_node);
+	fwnode_handle_put(flash->flash_node);
+	fwnode_handle_put(flash->indicator_node);
 
 	return 0;
 }
-- 
2.11.0
