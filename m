Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36484 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751483AbdILNmN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 09:42:13 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v12 24/26] ov5670: Add support for flash and lens devices
Date: Tue, 12 Sep 2017 16:41:58 +0300
Message-Id: <20170912134200.19556-25-sakari.ailus@linux.intel.com>
In-Reply-To: <20170912134200.19556-1-sakari.ailus@linux.intel.com>
References: <20170912134200.19556-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse async sub-devices by using
v4l2_subdev_fwnode_reference_parse_sensor_common().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov5670.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index 6f7a1d6d2200..a791701fa2b9 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -18,6 +18,7 @@
 #include <linux/pm_runtime.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-fwnode.h>
 
 #define OV5670_REG_CHIP_ID		0x300a
 #define OV5670_CHIP_ID			0x005670
@@ -1807,6 +1808,7 @@ static const struct ov5670_mode supported_modes[] = {
 struct ov5670 {
 	struct v4l2_subdev sd;
 	struct media_pad pad;
+	struct v4l2_async_notifier notifier;
 
 	struct v4l2_ctrl_handler ctrl_handler;
 	/* V4L2 Controls */
@@ -2473,11 +2475,13 @@ static int ov5670_probe(struct i2c_client *client)
 		return -EINVAL;
 
 	ov5670 = devm_kzalloc(&client->dev, sizeof(*ov5670), GFP_KERNEL);
-	if (!ov5670) {
-		ret = -ENOMEM;
-		err_msg = "devm_kzalloc() error";
-		goto error_print;
-	}
+	if (!ov5670)
+		return -ENOMEM;
+
+	ret = v4l2_async_notifier_parse_fwnode_sensor_common(
+		&client->dev, &ov5670->notifier);
+	if (ret < 0)
+		return ret;
 
 	/* Initialize subdev */
 	v4l2_i2c_subdev_init(&ov5670->sd, client, &ov5670_subdev_ops);
@@ -2486,7 +2490,7 @@ static int ov5670_probe(struct i2c_client *client)
 	ret = ov5670_identify_module(ov5670);
 	if (ret) {
 		err_msg = "ov5670_identify_module() error";
-		goto error_print;
+		goto error_release_notifier;
 	}
 
 	mutex_init(&ov5670->mutex);
@@ -2513,11 +2517,18 @@ static int ov5670_probe(struct i2c_client *client)
 		goto error_handler_free;
 	}
 
+	ret = v4l2_async_subdev_notifier_register(&ov5670->sd,
+						  &ov5670->notifier);
+	if (ret) {
+		err_msg = "can't register async notifier";
+		goto error_entity_cleanup;
+	}
+
 	/* Async register for subdev */
 	ret = v4l2_async_register_subdev(&ov5670->sd);
 	if (ret < 0) {
 		err_msg = "v4l2_async_register_subdev() error";
-		goto error_entity_cleanup;
+		goto error_unregister_notifier;
 	}
 
 	ov5670->streaming = false;
@@ -2533,6 +2544,9 @@ static int ov5670_probe(struct i2c_client *client)
 
 	return 0;
 
+error_unregister_notifier:
+	v4l2_async_notifier_unregister(&ov5670->notifier);
+
 error_entity_cleanup:
 	media_entity_cleanup(&ov5670->sd.entity);
 
@@ -2542,7 +2556,8 @@ static int ov5670_probe(struct i2c_client *client)
 error_mutex_destroy:
 	mutex_destroy(&ov5670->mutex);
 
-error_print:
+error_release_notifier:
+	v4l2_async_notifier_release(&ov5670->notifier);
 	dev_err(&client->dev, "%s: %s %d\n", __func__, err_msg, ret);
 
 	return ret;
@@ -2554,6 +2569,8 @@ static int ov5670_remove(struct i2c_client *client)
 	struct ov5670 *ov5670 = to_ov5670(sd);
 
 	v4l2_async_unregister_subdev(sd);
+	v4l2_async_notifier_unregister(&ov5670->notifier);
+	v4l2_async_notifier_release(&ov5670->notifier);
 	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	mutex_destroy(&ov5670->mutex);
-- 
2.11.0
