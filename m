Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56193 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751967AbbESXFb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 19:05:31 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, j.anaszewski@samsung.com,
	cooloney@gmail.com, g.liakhovetski@gmx.de, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com
Subject: [PATCH 3/5] v4l: flash: Pass struct device and device_node to v4l2_flash_init()
Date: Wed, 20 May 2015 02:04:03 +0300
Message-Id: <1432076645-4799-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1432076645-4799-1-git-send-email-sakari.ailus@iki.fi>
References: <1432076645-4799-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 sub-device node's dev will thus refer to the physical device, not
the LED flash device node. Also matching against device_node is possible in
cases where the LED flash controller drives multiple LEDs.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/v4l2-core/v4l2-flash.c |   10 ++++++----
 include/media/v4l2-flash.h           |   10 +++++++---
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-flash.c b/drivers/media/v4l2-core/v4l2-flash.c
index bed2036..d182adc 100644
--- a/drivers/media/v4l2-core/v4l2-flash.c
+++ b/drivers/media/v4l2-core/v4l2-flash.c
@@ -542,9 +542,10 @@ static const struct v4l2_subdev_ops v4l2_flash_subdev_ops = {
 	.core = &v4l2_flash_core_ops,
 };
 
-struct v4l2_flash *v4l2_flash_init(struct led_classdev_flash *fled_cdev,
-				   const struct v4l2_flash_ops *ops,
-				   struct v4l2_flash_config *config)
+struct v4l2_flash *v4l2_flash_init(
+	struct device *dev, struct device_node *of_node,
+	struct led_classdev_flash *fled_cdev, const struct v4l2_flash_ops *ops,
+	struct v4l2_flash_config *config)
 {
 	struct v4l2_flash *v4l2_flash;
 	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
@@ -562,7 +563,8 @@ struct v4l2_flash *v4l2_flash_init(struct led_classdev_flash *fled_cdev,
 	sd = &v4l2_flash->sd;
 	v4l2_flash->fled_cdev = fled_cdev;
 	v4l2_flash->ops = ops;
-	sd->dev = led_cdev->dev;
+	sd->dev = dev;
+	sd->of_node = of_node;
 	v4l2_subdev_init(sd, &v4l2_flash_subdev_ops);
 	sd->internal_ops = &v4l2_flash_subdev_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/include/media/v4l2-flash.h b/include/media/v4l2-flash.h
index 67a2cbf..31e421d 100644
--- a/include/media/v4l2-flash.h
+++ b/include/media/v4l2-flash.h
@@ -115,6 +115,8 @@ static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
 #if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
 /**
  * v4l2_flash_init - initialize V4L2 flash led sub-device
+ * @dev:	flash device, e.g. an I2C device
+ * @of_node:	of_node of the LED, may be NULL if the same as device's
  * @fled_cdev:	the LED Flash class device to wrap
  * @flash_ops:	V4L2 Flash device ops
  * @config:	initialization data for V4L2 Flash sub-device
@@ -125,9 +127,10 @@ static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
  * value is encoded using ERR_PTR(). Use IS_ERR() to check and
  * PTR_ERR() to obtain the numeric return value.
  */
-struct v4l2_flash *v4l2_flash_init(struct led_classdev_flash *fled_cdev,
-				   const struct v4l2_flash_ops *ops,
-				   struct v4l2_flash_config *config);
+struct v4l2_flash *v4l2_flash_init(
+	struct device *dev, struct device_node *of_node,
+	struct led_classdev_flash *fled_cdev, const struct v4l2_flash_ops *ops,
+	struct v4l2_flash_config *config);
 
 /**
  * v4l2_flash_release - release V4L2 Flash sub-device
@@ -139,6 +142,7 @@ void v4l2_flash_release(struct v4l2_flash *v4l2_flash);
 
 #else
 static inline struct v4l2_flash *v4l2_flash_init(
+	struct device *dev, struct device_node *of_node,
 	struct led_classdev_flash *fled_cdev, const struct v4l2_flash_ops *ops,
 	struct v4l2_flash_config *config)
 {
-- 
1.7.10.4

