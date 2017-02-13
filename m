Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27917 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751947AbdBMNae (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 08:30:34 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 1/8] v4l: flash led class: Use fwnode_handle instead of device_node in init
Date: Mon, 13 Feb 2017 15:28:09 +0200
Message-Id: <1486992496-21078-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1486992496-21078-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1486992496-21078-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pass the more generic fwnode_handle to the init function than the
device_node.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/leds/leds-aat1290.c                    |  5 +++--
 drivers/leds/leds-max77693.c                   |  5 +++--
 drivers/media/v4l2-core/v4l2-flash-led-class.c | 11 ++++++-----
 include/media/v4l2-flash-led-class.h           |  4 ++--
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/leds/leds-aat1290.c b/drivers/leds/leds-aat1290.c
index def3cf9..a21e192 100644
--- a/drivers/leds/leds-aat1290.c
+++ b/drivers/leds/leds-aat1290.c
@@ -503,8 +503,9 @@ static int aat1290_led_probe(struct platform_device *pdev)
 	aat1290_init_v4l2_flash_config(led, &led_cfg, &v4l2_sd_cfg);
 
 	/* Create V4L2 Flash subdev. */
-	led->v4l2_flash = v4l2_flash_init(dev, sub_node, fled_cdev, NULL,
-					  &v4l2_flash_ops, &v4l2_sd_cfg);
+	led->v4l2_flash = v4l2_flash_init(dev, of_fwnode_handle(sub_node),
+					  fled_cdev, NULL, &v4l2_flash_ops,
+					  &v4l2_sd_cfg);
 	if (IS_ERR(led->v4l2_flash)) {
 		ret = PTR_ERR(led->v4l2_flash);
 		goto error_v4l2_flash_init;
diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
index 1eb58ef..2d3062d 100644
--- a/drivers/leds/leds-max77693.c
+++ b/drivers/leds/leds-max77693.c
@@ -930,8 +930,9 @@ static int max77693_register_led(struct max77693_sub_led *sub_led,
 	max77693_init_v4l2_flash_config(sub_led, led_cfg, &v4l2_sd_cfg);
 
 	/* Register in the V4L2 subsystem. */
-	sub_led->v4l2_flash = v4l2_flash_init(dev, sub_node, fled_cdev, NULL,
-					      &v4l2_flash_ops, &v4l2_sd_cfg);
+	sub_led->v4l2_flash = v4l2_flash_init(dev, of_fwnode_handle(sub_node),
+					      fled_cdev, NULL, &v4l2_flash_ops,
+					      &v4l2_sd_cfg);
 	if (IS_ERR(sub_led->v4l2_flash)) {
 		ret = PTR_ERR(sub_led->v4l2_flash);
 		goto err_v4l2_flash_init;
diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
index 794e563..bd47e6d 100644
--- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
+++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <media/v4l2-flash-led-class.h>
@@ -612,7 +613,7 @@ static const struct v4l2_subdev_internal_ops v4l2_flash_subdev_internal_ops = {
 static const struct v4l2_subdev_ops v4l2_flash_subdev_ops;
 
 struct v4l2_flash *v4l2_flash_init(
-	struct device *dev, struct device_node *of_node,
+	struct device *dev, struct fwnode_handle *fwn,
 	struct led_classdev_flash *fled_cdev,
 	struct led_classdev_flash *iled_cdev,
 	const struct v4l2_flash_ops *ops,
@@ -638,7 +639,7 @@ struct v4l2_flash *v4l2_flash_init(
 	v4l2_flash->iled_cdev = iled_cdev;
 	v4l2_flash->ops = ops;
 	sd->dev = dev;
-	sd->of_node = of_node ? of_node : led_cdev->dev->of_node;
+	sd->fwnode = fwn ? fwn : device_fwnode_handle(led_cdev->dev);
 	v4l2_subdev_init(sd, &v4l2_flash_subdev_ops);
 	sd->internal_ops = &v4l2_flash_subdev_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
@@ -654,7 +655,7 @@ struct v4l2_flash *v4l2_flash_init(
 	if (ret < 0)
 		goto err_init_controls;
 
-	of_node_get(sd->of_node);
+	fwnode_handle_get(sd->fwnode);
 
 	ret = v4l2_async_register_subdev(sd);
 	if (ret < 0)
@@ -663,7 +664,7 @@ struct v4l2_flash *v4l2_flash_init(
 	return v4l2_flash;
 
 err_async_register_sd:
-	of_node_put(sd->of_node);
+	fwnode_handle_put(sd->fwnode);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 err_init_controls:
 	media_entity_cleanup(&sd->entity);
@@ -683,7 +684,7 @@ void v4l2_flash_release(struct v4l2_flash *v4l2_flash)
 
 	v4l2_async_unregister_subdev(sd);
 
-	of_node_put(sd->of_node);
+	fwnode_handle_put(sd->fwnode);
 
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	media_entity_cleanup(&sd->entity);
diff --git a/include/media/v4l2-flash-led-class.h b/include/media/v4l2-flash-led-class.h
index b0fe4d6..5695853 100644
--- a/include/media/v4l2-flash-led-class.h
+++ b/include/media/v4l2-flash-led-class.h
@@ -108,7 +108,7 @@ static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
 /**
  * v4l2_flash_init - initialize V4L2 flash led sub-device
  * @dev:	flash device, e.g. an I2C device
- * @of_node:	of_node of the LED, may be NULL if the same as device's
+ * @fwn:	fwnode_handle of the LED, may be NULL if the same as device's
  * @fled_cdev:	LED flash class device to wrap
  * @iled_cdev:	LED flash class device representing indicator LED associated
  *		with fled_cdev, may be NULL
@@ -122,7 +122,7 @@ static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
  * PTR_ERR() to obtain the numeric return value.
  */
 struct v4l2_flash *v4l2_flash_init(
-	struct device *dev, struct device_node *of_node,
+	struct device *dev, struct fwnode_handle *fwn,
 	struct led_classdev_flash *fled_cdev,
 	struct led_classdev_flash *iled_cdev,
 	const struct v4l2_flash_ops *ops,
-- 
2.7.4
