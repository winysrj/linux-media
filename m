Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34358 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752288AbdFNJri (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 05:47:38 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org
Cc: devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org, pavel@ucw.cz
Subject: [PATCH 7/8] smiapp: Add support for flash, lens and EEPROM devices
Date: Wed, 14 Jun 2017 12:47:18 +0300
Message-Id: <1497433639-13101-8-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These types devices aren't directly related to the sensor, but are
nevertheless handled by the smiapp driver due to the relationship of these
component to the main part of the camera module --- the sensor.

Additionally, for the async sub-device registration to work, the notifier
containing matching fwnodes will need to be registered. This is natural to
perform in a sensor driver as well.

This does not yet address providing the user space with information on how
to associate the sensor, lens or EEPROM devices but the kernel now has the
necessary information to do that.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 81 +++++++++++++++++++++++++++++++---
 drivers/media/i2c/smiapp/smiapp.h      |  5 +++
 2 files changed, 79 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e0b0c03..26f2873 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2551,6 +2551,22 @@ static int smiapp_register_subdev(struct smiapp_sensor *sensor,
 	return 0;
 }
 
+static int smiapp_subdev_notifier_bound(struct v4l2_async_notifier *notifier,
+					struct v4l2_subdev *sd,
+					struct v4l2_async_subdev *asd)
+{
+	return 0;
+}
+
+static int smiapp_subdev_notifier_complete(
+	struct v4l2_async_notifier *notifier)
+{
+	struct smiapp_sensor *sensor =
+		container_of(notifier, struct smiapp_sensor, notifier);
+
+	return v4l2_device_register_subdev_nodes(sensor->src->sd.v4l2_dev);
+}
+
 static void smiapp_unregistered(struct v4l2_subdev *subdev)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
@@ -2558,6 +2574,8 @@ static void smiapp_unregistered(struct v4l2_subdev *subdev)
 
 	for (i = 1; i < sensor->ssds_used; i++)
 		v4l2_device_unregister_subdev(&sensor->ssds[i].sd);
+
+	v4l2_async_subnotifier_unregister(&sensor->notifier);
 }
 
 static int smiapp_registered(struct v4l2_subdev *subdev)
@@ -2581,6 +2599,15 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	if (rval)
 		goto out_err;
 
+	if (!sensor->notifier.num_subdevs)
+		return 0;
+
+	sensor->notifier.bound = smiapp_subdev_notifier_bound;
+	sensor->notifier.complete = smiapp_subdev_notifier_complete;
+	rval = v4l2_async_subnotifier_register(subdev, &sensor->notifier);
+	if (rval)
+		goto out_err;
+
 	return 0;
 
 out_err:
@@ -2782,13 +2809,15 @@ static int __maybe_unused smiapp_resume(struct device *dev)
 	return rval;
 }
 
-static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
+static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev,
+						   struct smiapp_sensor *sensor)
 {
+	static const char *props[] = { "flash", "lens", "eeprom" };
 	struct smiapp_hwconfig *hwcfg;
 	struct v4l2_fwnode_endpoint *bus_cfg;
 	struct fwnode_handle *ep;
 	struct fwnode_handle *fwnode = dev_fwnode(dev);
-	int i;
+	unsigned int i;
 	int rval;
 
 	if (!fwnode)
@@ -2849,6 +2878,45 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 
 	v4l2_fwnode_endpoint_free(bus_cfg);
 	fwnode_handle_put(ep);
+
+	sensor->notifier.subdevs =
+		devm_kcalloc(dev, SMIAPP_MAX_ASYNC_SUBDEVS,
+			     sizeof(struct v4l2_async_subdev *), GFP_KERNEL);
+	if (!sensor->notifier.subdevs)
+		goto out_err;
+
+	for (i = 0; i < ARRAY_SIZE(props); i++) {
+		struct device_node *node;
+		unsigned int j = 0;
+
+		while ((node = of_parse_phandle(dev->of_node, props[i], j++))) {
+			struct v4l2_async_subdev **asd =
+				 &sensor->notifier.subdevs[
+					 sensor->notifier.num_subdevs];
+
+			if (WARN_ON(sensor->notifier.num_subdevs >=
+				    SMIAPP_MAX_ASYNC_SUBDEVS)) {
+				of_node_put(node);
+				goto out;
+			}
+
+			*asd = devm_kzalloc(
+				dev, sizeof(struct v4l2_async_subdev),
+				GFP_KERNEL);
+			if (!*asd) {
+				of_node_put(node);
+				goto out_err;
+			}
+
+			(*asd)->match.fwnode.fwnode = of_fwnode_handle(node);
+			(*asd)->match_type = V4L2_ASYNC_MATCH_FWNODE;
+			sensor->notifier.num_subdevs++;
+
+			of_node_put(node);
+		}
+	}
+
+out:
 	return hwcfg;
 
 out_err:
@@ -2861,18 +2929,17 @@ static int smiapp_probe(struct i2c_client *client,
 			const struct i2c_device_id *devid)
 {
 	struct smiapp_sensor *sensor;
-	struct smiapp_hwconfig *hwcfg = smiapp_get_hwconfig(&client->dev);
 	unsigned int i;
 	int rval;
 
-	if (hwcfg == NULL)
-		return -ENODEV;
-
 	sensor = devm_kzalloc(&client->dev, sizeof(*sensor), GFP_KERNEL);
 	if (sensor == NULL)
 		return -ENOMEM;
 
-	sensor->hwcfg = hwcfg;
+	sensor->hwcfg = smiapp_get_hwconfig(&client->dev, sensor);
+	if (sensor->hwcfg == NULL)
+		return -ENODEV;
+
 	mutex_init(&sensor->mutex);
 	sensor->src = &sensor->ssds[sensor->ssds_used];
 
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index f74d695..21a55de 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -20,6 +20,7 @@
 #define __SMIAPP_PRIV_H_
 
 #include <linux/mutex.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
 #include <media/i2c/smiapp.h>
@@ -143,6 +144,9 @@ struct smiapp_csi_data_format {
 	u8 pixel_order;
 };
 
+/* Lens, EEPROM and a flash LEDs? */
+#define SMIAPP_MAX_ASYNC_SUBDEVS	3
+
 #define SMIAPP_SUBDEVS			3
 
 #define SMIAPP_PA_PAD_SRC		0
@@ -189,6 +193,7 @@ struct smiapp_sensor {
 	struct regulator *vana;
 	struct clk *ext_clk;
 	struct gpio_desc *xshutdown;
+	struct v4l2_async_notifier notifier;
 	u32 limits[SMIAPP_LIMIT_LAST];
 	u8 nbinning_subtypes;
 	struct smiapp_binning_subtype binning_subtypes[SMIAPP_BINNING_SUBTYPES];
-- 
2.1.4
