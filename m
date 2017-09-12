Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36670 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751481AbdILNmM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 09:42:12 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v12 23/26] et8ek8: Add support for flash and lens devices
Date: Tue, 12 Sep 2017 16:41:57 +0300
Message-Id: <20170912134200.19556-24-sakari.ailus@linux.intel.com>
In-Reply-To: <20170912134200.19556-1-sakari.ailus@linux.intel.com>
References: <20170912134200.19556-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pavel Machek <pavel@ucw.cz>

Parse async sub-devices by using
v4l2_subdev_fwnode_reference_parse_sensor_common().

These types devices aren't directly related to the sensor, but are
nevertheless handled by the et8ek8 driver due to the relationship of these
component to the main part of the camera module --- the sensor.

[Sakari Ailus: Rename fwnode function, check for ret < 0 only.]
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/et8ek8/et8ek8_driver.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/et8ek8/et8ek8_driver.c
index c14f0fd6ded3..0ef1b8025935 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -34,10 +34,12 @@
 #include <linux/sort.h>
 #include <linux/v4l2-mediabus.h>
 
+#include <media/v4l2-async.h>
 #include <media/media-entity.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
+#include <media/v4l2-fwnode.h>
 
 #include "et8ek8_reg.h"
 
@@ -46,6 +48,7 @@
 #define ET8EK8_MAX_MSG		8
 
 struct et8ek8_sensor {
+	struct v4l2_async_notifier notifier;
 	struct v4l2_subdev subdev;
 	struct media_pad pad;
 	struct v4l2_mbus_framefmt format;
@@ -1446,6 +1449,11 @@ static int et8ek8_probe(struct i2c_client *client,
 	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	sensor->subdev.internal_ops = &et8ek8_internal_ops;
 
+	ret = v4l2_async_notifier_parse_fwnode_sensor_common(
+		&client->dev, &sensor->notifier);
+	if (ret < 0)
+		goto err_release;
+
 	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_pads_init(&sensor->subdev.entity, 1, &sensor->pad);
 	if (ret < 0) {
@@ -1453,18 +1461,27 @@ static int et8ek8_probe(struct i2c_client *client,
 		goto err_mutex;
 	}
 
+	ret = v4l2_async_subdev_notifier_register(&sensor->subdev,
+						  &sensor->notifier);
+	if (ret)
+		goto err_entity;
+
 	ret = v4l2_async_register_subdev(&sensor->subdev);
 	if (ret < 0)
-		goto err_entity;
+		goto err_async;
 
 	dev_dbg(dev, "initialized!\n");
 
 	return 0;
 
+err_async:
+	v4l2_async_notifier_unregister(&sensor->notifier);
 err_entity:
 	media_entity_cleanup(&sensor->subdev.entity);
 err_mutex:
 	mutex_destroy(&sensor->power_lock);
+err_release:
+	v4l2_async_notifier_release(&sensor->notifier);
 	return ret;
 }
 
@@ -1480,6 +1497,8 @@ static int __exit et8ek8_remove(struct i2c_client *client)
 	}
 
 	v4l2_device_unregister_subdev(&sensor->subdev);
+	v4l2_async_notifier_unregister(&sensor->notifier);
+	v4l2_async_notifier_release(&sensor->notifier);
 	device_remove_file(&client->dev, &dev_attr_priv_mem);
 	v4l2_ctrl_handler_free(&sensor->ctrl_handler);
 	v4l2_async_unregister_subdev(&sensor->subdev);
-- 
2.11.0
