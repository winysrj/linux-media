Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34419 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933829Ab1ESSel (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 14:34:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, michael.jones@matrix-vision.de
Subject: [RFC/PATCH 1/2] v4l: Add generic board subdev registration function
Date: Thu, 19 May 2011 20:34:39 +0200
Message-Id: <1305830080-18211-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The new v4l2_new_subdev_board() function creates and register a subdev
based on generic board information. The board information structure
includes a bus type and bus type-specific information.

Only I2C and SPI busses are currently supported.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-common.c |   70 +++++++++++++++++++++++++++++++++++++
 drivers/media/video/v4l2-device.c |    8 ++++
 include/media/v4l2-common.h       |   28 +++++++++++++++
 include/media/v4l2-subdev.h       |    3 ++
 4 files changed, 109 insertions(+), 0 deletions(-)

Hi everybody,

This approach has been briefly discussed during the Warsaw V4L meeting. Now
that support for platform subdevs has been requested, I'd like to move bus type
handling to the V4L2 core instead of duplicating the logic in every driver. As
usual, comments will be appreciated.

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 06b9f9f..46aee94 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -474,6 +474,76 @@ EXPORT_SYMBOL_GPL(v4l2_spi_new_subdev);
 
 #endif /* defined(CONFIG_SPI) */
 
+/*
+ * v4l2_new_subdev_board - Register a subdevice based on board information
+ * @v4l2_dev: Parent V4L2 device
+ * @info: I2C subdevs board information array
+ *
+ * Register a subdevice identified by a geenric board information structure. The
+ * structure contains the bus type and bus type-specific information.
+ *
+ * Return a pointer to the subdevice if registration was successful, or NULL
+ * otherwise.
+ */
+struct v4l2_subdev *v4l2_new_subdev_board(struct v4l2_device *v4l2_dev,
+		struct v4l2_subdev_board_info *info)
+{
+	struct v4l2_subdev *subdev;
+
+	switch (info->type) {
+#if defined(CONFIG_I2C)
+	case V4L2_SUBDEV_BUS_TYPE_I2C: {
+		struct i2c_adapter *adapter;
+
+		adapter = i2c_get_adapter(info->info.i2c.i2c_adapter_id);
+		if (adapter == NULL) {
+			printk(KERN_ERR "%s: Unable to get I2C adapter %d for "
+				"device %s/%u\n", __func__,
+				info->info.i2c.i2c_adapter_id,
+				info->info.i2c.board_info->type,
+				info->info.i2c.board_info->addr);
+			return NULL;
+		}
+
+		subdev = v4l2_i2c_new_subdev_board(v4l2_dev, adapter,
+					info->info.i2c.board_info, NULL);
+		if (subdev == NULL) {
+			i2c_put_adapter(adapter);
+			return NULL;
+		}
+
+		subdev->flags |= V4L2_SUBDEV_FL_RELEASE_ADAPTER;
+		break;
+	}
+#endif /* defined(CONFIG_I2C) */
+#if defined(CONFIG_SPI)
+	case V4L2_SUBDEV_BUS_TYPE_SPI: {
+		struct spi_master *master;
+
+		master = spi_busnum_to_master(info->info.spi->bus_num);
+		if (master == NULL) {
+			printk(KERN_ERR "%s: Unable to get SPI master %u for "
+				"device %s/%u\n", __func__,
+				info->info.spi->bus_num,
+				info->info.spi->modalias,
+				info->info.spi->chip_select);
+			return NULL;
+		}
+
+		subdev = v4l2_spi_new_subdev(v4l2_dev, master, info->info.spi);
+		spi_master_put(master);
+		break;
+	}
+#endif /* defined(CONFIG_SPI) */
+	default:
+		subdev = NULL;
+		break;
+	}
+
+	return subdev;
+}
+EXPORT_SYMBOL_GPL(v4l2_new_subdev_board);
+
 /* Clamp x to be between min and max, aligned to a multiple of 2^align.  min
  * and max don't have to be aligned, but there must be at least one valid
  * value.  E.g., min=17,max=31,align=4 is not allowed as there are no multiples
diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 4aae501..cfd9caf 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -246,5 +246,13 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 #endif
 	video_unregister_device(&sd->devnode);
 	module_put(sd->owner);
+
+#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
+	if ((sd->flags & V4L2_SUBDEV_FL_IS_I2C) &&
+	    (sd->flags & V4L2_SUBDEV_FL_RELEASE_ADAPTER)) {
+		struct i2c_client *client = v4l2_get_subdevdata(sd);
+		i2c_put_adapter(client->adapter);
+	}
+#endif
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index a298ec4..88c38d9 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -171,6 +171,34 @@ void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
 		const struct v4l2_subdev_ops *ops);
 #endif
 
+/* -------------------------------------------------------------------------- */
+
+/* Generic helper functions */
+
+struct v4l2_subdev_i2c_board_info {
+	struct i2c_board_info *board_info;
+	int i2c_adapter_id;
+};
+
+enum v4l2_subdev_bus_type {
+	V4L2_SUBDEV_BUS_TYPE_NONE,
+	V4L2_SUBDEV_BUS_TYPE_I2C,
+	V4L2_SUBDEV_BUS_TYPE_SPI,
+};
+
+struct v4l2_subdev_board_info {
+	enum v4l2_subdev_bus_type type;
+	union {
+		struct v4l2_subdev_i2c_board_info i2c;
+		struct spi_board_info *spi;
+	} info;
+};
+
+/* Create a subdevice and load its module. The info argumentidentifies the
+ * subdev bus type and the bus type-specific information. */
+struct v4l2_subdev *v4l2_new_subdev_board(struct v4l2_device *v4l2_dev,
+		struct v4l2_subdev_board_info *info);
+
 /* ------------------------------------------------------------------------- */
 
 /* Note: these remaining ioctls/structs should be removed as well, but they are
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 1562c4f..bc1c4d8 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -483,6 +483,9 @@ struct v4l2_subdev_internal_ops {
 #define V4L2_SUBDEV_FL_HAS_DEVNODE		(1U << 2)
 /* Set this flag if this subdev generates events. */
 #define V4L2_SUBDEV_FL_HAS_EVENTS		(1U << 3)
+/* Set by the core if the bus adapter needs to be released. Do NOT use in
+ * drivers. */
+#define V4L2_SUBDEV_FL_RELEASE_ADAPTER		(1U << 4)
 
 /* Each instance of a subdev driver should create this struct, either
    stand-alone or embedded in a larger struct.
-- 
Regards,

Laurent Pinchart

