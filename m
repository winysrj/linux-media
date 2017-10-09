Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:53048 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753995AbdJIKTg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 10/24] media: v4l2-subdev: use kernel-doc markups to document subdev flags
Date: Mon,  9 Oct 2017 07:19:16 -0300
Message-Id: <170d2a91bb05ae196ea65713e4f9cd179c7cc4b2.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, those are documented together with the subdev struct,
instead of together with the definitions.

Convert the definitions to an enum, use BIT() macros and document
it at its right place.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-subdev.h | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index e83872078376..6286c69a12ba 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -18,6 +18,7 @@
 #define _V4L2_SUBDEV_H
 
 #include <linux/types.h>
+#include <linux/bitops.h>
 #include <linux/v4l2-subdev.h>
 #include <media/media-entity.h>
 #include <media/v4l2-async.h>
@@ -734,14 +735,23 @@ struct v4l2_subdev_internal_ops {
 
 #define V4L2_SUBDEV_NAME_SIZE 32
 
-/* Set this flag if this subdev is a i2c device. */
-#define V4L2_SUBDEV_FL_IS_I2C			(1U << 0)
-/* Set this flag if this subdev is a spi device. */
-#define V4L2_SUBDEV_FL_IS_SPI			(1U << 1)
-/* Set this flag if this subdev needs a device node. */
-#define V4L2_SUBDEV_FL_HAS_DEVNODE		(1U << 2)
-/* Set this flag if this subdev generates events. */
-#define V4L2_SUBDEV_FL_HAS_EVENTS		(1U << 3)
+/**
+ * enum v4l2_subdev_flags - flags used to describe a sub-device
+ *	at &struct v4l2_subdev.
+ *
+ * @V4L2_SUBDEV_FL_IS_I2C: set this flag if this subdev is an I2C device;
+ * @V4L2_SUBDEV_FL_IS_SPI: set this flag if this subdev is a SPI device;
+ * @V4L2_SUBDEV_FL_HAS_DEVNODE: set this flag if this subdev needs
+ *				a device node;
+ * @V4L2_SUBDEV_FL_HAS_EVENTS: set this flag if this subdev
+ *			       generates events.
+ */
+enum v4l2_subdev_flags {
+	V4L2_SUBDEV_FL_IS_I2C		= BIT(0),
+	V4L2_SUBDEV_FL_IS_SPI		= BIT(1),
+	V4L2_SUBDEV_FL_HAS_DEVNODE	= BIT(2),
+	V4L2_SUBDEV_FL_HAS_EVENTS	= BIT(3),
+};
 
 struct regulator_bulk_data;
 
@@ -767,13 +777,7 @@ struct v4l2_subdev_platform_data {
  * @owner: The owner is the same as the driver's &struct device owner.
  * @owner_v4l2_dev: true if the &sd->owner matches the owner of @v4l2_dev->dev
  *	ownner. Initialized by v4l2_device_register_subdev().
- * @flags: subdev flags. Can be:
- *   %V4L2_SUBDEV_FL_IS_I2C - Set this flag if this subdev is a i2c device;
- *   %V4L2_SUBDEV_FL_IS_SPI - Set this flag if this subdev is a spi device;
- *   %V4L2_SUBDEV_FL_HAS_DEVNODE - Set this flag if this subdev needs a
- *   device node;
- *   %V4L2_SUBDEV_FL_HAS_EVENTS -  Set this flag if this subdev generates
- *   events.
+ * @flags: subdev flags, as defined by &enum v4l2_subdev_flags.
  *
  * @v4l2_dev: pointer to struct &v4l2_device
  * @ops: pointer to struct &v4l2_subdev_ops
@@ -808,7 +812,7 @@ struct v4l2_subdev {
 	struct list_head list;
 	struct module *owner;
 	bool owner_v4l2_dev;
-	u32 flags;
+	enum v4l2_subdev_flags flags;
 	struct v4l2_device *v4l2_dev;
 	const struct v4l2_subdev_ops *ops;
 	const struct v4l2_subdev_internal_ops *internal_ops;
-- 
2.13.6
