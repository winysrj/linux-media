Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59044 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751433AbdGRRg2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 13:36:28 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org
Cc: devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org, pavel@ucw.cz, jacek.anaszewski@gmail.com
Subject: [PATCH v1.1 1/1] v4l2-flash: Flash ops aren't mandatory
Date: Tue, 18 Jul 2017 20:36:23 +0300
Message-Id: <20170718173623.7821-1-sakari.ailus@linux.intel.com>
In-Reply-To: <1497433639-13101-6-git-send-email-sakari.ailus@linux.intel.com>
References: <1497433639-13101-6-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

None of the flash operations are mandatory and therefore there should be
no need for the flash ops structure either. Accept NULL.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
---
Hi folks,

I'm planning to get this one plus "v4l2-flash: Use led_classdev instead of
led_classdev_flash for indicator" to linux-media in the near future. The
rest still needs work.

since v1:

- Use has_flash_op() in __fill_ctrl_init_data() to check an op exists.

 drivers/media/v4l2-core/v4l2-flash-led-class.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
index 6d69119ff097..aabc85dbb8b5 100644
--- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
+++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
@@ -18,7 +18,7 @@
 #include <media/v4l2-flash-led-class.h>
 
 #define has_flash_op(v4l2_flash, op)				\
-	(v4l2_flash && v4l2_flash->ops->op)
+	(v4l2_flash && v4l2_flash->ops && v4l2_flash->ops->op)
 
 #define call_flash_op(v4l2_flash, op, arg)			\
 		(has_flash_op(v4l2_flash, op) ?			\
@@ -299,7 +299,6 @@ static void __fill_ctrl_init_data(struct v4l2_flash *v4l2_flash,
 			  struct v4l2_flash_ctrl_data *ctrl_init_data)
 {
 	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
-	const struct led_flash_ops *fled_cdev_ops = fled_cdev->ops;
 	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
 	struct v4l2_ctrl_config *ctrl_cfg;
 	u32 mask;
@@ -376,7 +375,7 @@ static void __fill_ctrl_init_data(struct v4l2_flash *v4l2_flash,
 	}
 
 	/* Init STROBE_STATUS ctrl data */
-	if (fled_cdev_ops->strobe_get) {
+	if (has_flash_op(fled_cdev, strobe_get)) {
 		ctrl_init_data[STROBE_STATUS].cid =
 					V4L2_CID_FLASH_STROBE_STATUS;
 		ctrl_cfg = &ctrl_init_data[STROBE_STATUS].config;
@@ -386,7 +385,7 @@ static void __fill_ctrl_init_data(struct v4l2_flash *v4l2_flash,
 	}
 
 	/* Init FLASH_TIMEOUT ctrl data */
-	if (fled_cdev_ops->timeout_set) {
+	if (has_flash_op(fled_cdev, timeout_set)) {
 		ctrl_init_data[FLASH_TIMEOUT].cid = V4L2_CID_FLASH_TIMEOUT;
 		ctrl_cfg = &ctrl_init_data[FLASH_TIMEOUT].config;
 		__lfs_to_v4l2_ctrl_config(&fled_cdev->timeout, ctrl_cfg);
@@ -394,7 +393,7 @@ static void __fill_ctrl_init_data(struct v4l2_flash *v4l2_flash,
 	}
 
 	/* Init FLASH_INTENSITY ctrl data */
-	if (fled_cdev_ops->flash_brightness_set) {
+	if (has_flash_op(fled_cdev, flash_brightness_set)) {
 		ctrl_init_data[FLASH_INTENSITY].cid = V4L2_CID_FLASH_INTENSITY;
 		ctrl_cfg = &ctrl_init_data[FLASH_INTENSITY].config;
 		__lfs_to_v4l2_ctrl_config(&fled_cdev->brightness, ctrl_cfg);
@@ -618,7 +617,7 @@ struct v4l2_flash *v4l2_flash_init(
 	struct v4l2_subdev *sd;
 	int ret;
 
-	if (!fled_cdev || !ops || !config)
+	if (!fled_cdev || !config)
 		return ERR_PTR(-EINVAL);
 
 	led_cdev = &fled_cdev->led_cdev;
-- 
2.11.0
