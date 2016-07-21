Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53019 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbcGUUUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 16:20:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/5] [media] v4l2-common.h: Add documentation for other functions
Date: Thu, 21 Jul 2016 17:19:50 -0300
Message-Id: <803a5c1a8b6cd3f593833cc883788fb120343cd6.1469132350.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not all functions at v4l2-common.h are documented. Add
documentation for some other ones.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-common.h | 43 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 9b1dfcd9e229..350cbf9fb10e 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -78,9 +78,26 @@
 			v4l2_printk(KERN_DEBUG, dev, fmt , ## arg); 	\
 	} while (0)
 
-/* ------------------------------------------------------------------------- */
+/**
+ * v4l2_ctrl_query_fill- Fill in a struct v4l2_queryctrl
+ *
+ * @qctrl: pointer to the &struct v4l2_queryctrl to be filled
+ * @min: minimum value for the control
+ * @max: maximum value for the control
+ * @step: control step
+ * @def: default value for the control
+ *
+ * Fills the &struct v4l2_queryctrl fields for the query control.
+ *
+ * .. note::
+ *
+ *    This function assumes that the @qctrl->id field is filled.
+ *
+ * Returns -EINVAL if the control is not known by the V4L2 core, 0 on success.
+ */
 
-int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 step, s32 def);
+int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl,
+			 s32 min, s32 max, s32 step, s32 def);
 
 /* ------------------------------------------------------------------------- */
 
@@ -172,12 +189,28 @@ const unsigned short *v4l2_i2c_tuner_addrs(enum v4l2_i2c_tuner_type type);
 
 struct spi_device;
 
-/* Load an spi module and return an initialized v4l2_subdev struct.
-   The client_type argument is the name of the chip that's on the adapter. */
+/**
+ *  v4l2_spi_new_subdev - Load an spi module and return an initialized
+ *	&struct v4l2_subdev.
+ *
+ *
+ * @v4l2_dev: pointer to &struct v4l2_device.
+ * @master: pointer to struct spi_master.
+ * @info: pointer to struct spi_board_info.
+ *
+ * returns a &struct v4l2_subdev pointer.
+ */
 struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
 		struct spi_master *master, struct spi_board_info *info);
 
-/* Initialize a v4l2_subdev with data from an spi_device struct */
+/**
+ * v4l2_spi_subdev_init - Initialize a v4l2_subdev with data from an
+ *	spi_device struct.
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @spi: pointer to struct spi_device.
+ * @ops: pointer to &struct v4l2_subdev_ops
+ */
 void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
 		const struct v4l2_subdev_ops *ops);
 #endif
-- 
2.7.4

