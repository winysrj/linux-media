Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34423 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934400Ab1ESSel (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 14:34:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, michael.jones@matrix-vision.de
Subject: [RFC/PATCH 2/2] omap3isp: Use generic subdev registration function
Date: Thu, 19 May 2011 20:34:40 +0200
Message-Id: <1305830080-18211-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1305830080-18211-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1305830080-18211-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Replace custom subdev registration with a call to
v4l2_new_subdev_board().

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isp.c |   32 +++++++++-----------------------
 drivers/media/video/omap3isp/isp.h |    7 +------
 2 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 472a693..8280165 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -1642,9 +1642,9 @@ static void isp_unregister_entities(struct isp_device *isp)
 /*
  * isp_register_subdev_group - Register a group of subdevices
  * @isp: OMAP3 ISP device
- * @board_info: I2C subdevs board information array
+ * @board_info: V4L2 subdevs board information array
  *
- * Register all I2C subdevices in the board_info array. The array must be
+ * Register all V4L2 subdevices in the board_info array. The array must be
  * terminated by a NULL entry, and the first entry must be the sensor.
  *
  * Return a pointer to the sensor media entity if it has been successfully
@@ -1652,36 +1652,22 @@ static void isp_unregister_entities(struct isp_device *isp)
  */
 static struct v4l2_subdev *
 isp_register_subdev_group(struct isp_device *isp,
-		     struct isp_subdev_i2c_board_info *board_info)
+		     struct v4l2_subdev_board_info *board_info)
 {
 	struct v4l2_subdev *sensor = NULL;
-	unsigned int first;
-
-	if (board_info->board_info == NULL)
-		return NULL;
+	unsigned int i;
 
-	for (first = 1; board_info->board_info; ++board_info, first = 0) {
+	for (i = 0; board_info; ++board_info, ++i) {
 		struct v4l2_subdev *subdev;
-		struct i2c_adapter *adapter;
-
-		adapter = i2c_get_adapter(board_info->i2c_adapter_id);
-		if (adapter == NULL) {
-			printk(KERN_ERR "%s: Unable to get I2C adapter %d for "
-				"device %s\n", __func__,
-				board_info->i2c_adapter_id,
-				board_info->board_info->type);
-			continue;
-		}
 
-		subdev = v4l2_i2c_new_subdev_board(&isp->v4l2_dev, adapter,
-				board_info->board_info, NULL);
+		subdev = v4l2_new_subdev_board(&isp->v4l2_dev, board_info);
 		if (subdev == NULL) {
-			printk(KERN_ERR "%s: Unable to register subdev %s\n",
-				__func__, board_info->board_info->type);
+			printk(KERN_ERR "%s: Unable to register subdev %u\n",
+				__func__, i);
 			continue;
 		}
 
-		if (first)
+		if (i == 0)
 			sensor = subdev;
 	}
 
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index 2620c40..c3ecc36 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -180,13 +180,8 @@ struct isp_csi2_platform_data {
 	unsigned vpclk_div:2;
 };
 
-struct isp_subdev_i2c_board_info {
-	struct i2c_board_info *board_info;
-	int i2c_adapter_id;
-};
-
 struct isp_v4l2_subdevs_group {
-	struct isp_subdev_i2c_board_info *subdevs;
+	struct v4l2_subdev_board_info *subdevs;
 	enum isp_interface_type interface;
 	union {
 		struct isp_parallel_platform_data parallel;
-- 
1.7.3.4

