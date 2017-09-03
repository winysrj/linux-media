Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49464 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753186AbdICRuG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 13:50:06 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v7 17/18] smiapp: Add support for flash and lens devices
Date: Sun,  3 Sep 2017 20:49:57 +0300
Message-Id: <20170903174958.27058-18-sakari.ailus@linux.intel.com>
In-Reply-To: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse async sub-devices by using
v4l2_subdev_fwnode_reference_parse_sensor_common().

These types devices aren't directly related to the sensor, but are
nevertheless handled by the smiapp driver due to the relationship of these
component to the main part of the camera module --- the sensor.

This does not yet address providing the user space with information on how
to associate the sensor or lens devices but the kernel now has the
necessary information to do that.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 29 +++++++++++++++++++++++++++--
 drivers/media/i2c/smiapp/smiapp.h      |  4 +++-
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 700f433261d0..34fb5a2f63ce 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -31,7 +31,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/smiapp.h>
-#include <linux/v4l2-mediabus.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-fwnode.h>
 #include <media/v4l2-device.h>
 
@@ -2784,6 +2784,16 @@ static int __maybe_unused smiapp_resume(struct device *dev)
 	return rval;
 }
 
+static int smiapp_async_complete(struct v4l2_async_notifier *notifier)
+{
+	return v4l2_device_register_subdev_nodes(
+		notifier->master->v4l2_dev);
+}
+
+static const struct v4l2_async_notifier_operations smiapp_async_notifier_ops = {
+	.complete = smiapp_async_complete,
+};
+
 static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 {
 	struct smiapp_hwconfig *hwcfg;
@@ -2887,6 +2897,11 @@ static int smiapp_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(&sensor->src->sd, client, &smiapp_ops);
 	sensor->src->sd.internal_ops = &smiapp_internal_src_ops;
 
+	rval = v4l2_fwnode_reference_parse_sensor_common(
+		&client->dev, &sensor->notifier);
+	if (rval < 0 && rval != -ENOENT)
+		return rval;
+
 	sensor->vana = devm_regulator_get(&client->dev, "vana");
 	if (IS_ERR(sensor->vana)) {
 		dev_err(&client->dev, "could not get regulator for vana\n");
@@ -3092,9 +3107,15 @@ static int smiapp_probe(struct i2c_client *client,
 	if (rval < 0)
 		goto out_media_entity_cleanup;
 
+	sensor->notifier.ops = &smiapp_async_notifier_ops;
+	rval = v4l2_async_subdev_notifier_register(&sensor->src->sd,
+						   &sensor->notifier);
+	if (rval)
+		goto out_media_entity_cleanup;
+
 	rval = v4l2_async_register_subdev(&sensor->src->sd);
 	if (rval < 0)
-		goto out_media_entity_cleanup;
+		goto out_unregister_async_notifier;
 
 	pm_runtime_set_active(&client->dev);
 	pm_runtime_get_noresume(&client->dev);
@@ -3105,6 +3126,9 @@ static int smiapp_probe(struct i2c_client *client,
 
 	return 0;
 
+out_unregister_async_notifier:
+	v4l2_async_notifier_unregister(&sensor->notifier);
+
 out_media_entity_cleanup:
 	media_entity_cleanup(&sensor->src->sd.entity);
 
@@ -3124,6 +3148,7 @@ static int smiapp_remove(struct i2c_client *client)
 	unsigned int i;
 
 	v4l2_async_unregister_subdev(subdev);
+	v4l2_async_notifier_unregister(&sensor->notifier);
 
 	pm_runtime_disable(&client->dev);
 	if (!pm_runtime_status_suspended(&client->dev))
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index f74d695018b9..be92cb5713f4 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -20,9 +20,10 @@
 #define __SMIAPP_PRIV_H_
 
 #include <linux/mutex.h>
+#include <media/i2c/smiapp.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
-#include <media/i2c/smiapp.h>
 
 #include "smiapp-pll.h"
 #include "smiapp-reg.h"
@@ -172,6 +173,7 @@ struct smiapp_subdev {
  * struct smiapp_sensor - Main device structure
  */
 struct smiapp_sensor {
+	struct v4l2_async_notifier notifier;
 	/*
 	 * "mutex" is used to serialise access to all fields here
 	 * except v4l2_ctrls at the end of the struct. "mutex" is also
-- 
2.11.0
