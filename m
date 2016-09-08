Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56893 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938577AbcIHVhu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 15/15] [media] v4l2-subdev: fix some references to v4l2_dev
Date: Thu,  8 Sep 2016 18:37:41 -0300
Message-Id: <da0c0d40e30d4c6428ab567f6e801f48084dbbe4.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a warning there, because it was pointing to a different
name. Fix it.

While here, use struct &foo, instead of &struct foo.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-subdev.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 2c1e328ccb1d..e175c2c891a8 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -764,7 +764,7 @@ struct v4l2_subdev_platform_data {
  * @entity: pointer to &struct media_entity
  * @list: List of sub-devices
  * @owner: The owner is the same as the driver's &struct device owner.
- * @owner_v4l2_dev: true if the &sd->owner matches the owner of &v4l2_dev->dev
+ * @owner_v4l2_dev: true if the &sd->owner matches the owner of @v4l2_dev->dev
  *	ownner. Initialized by v4l2_device_register_subdev().
  * @flags: subdev flags. Can be:
  *   %V4L2_SUBDEV_FL_IS_I2C - Set this flag if this subdev is a i2c device;
@@ -774,9 +774,9 @@ struct v4l2_subdev_platform_data {
  *   %V4L2_SUBDEV_FL_HAS_EVENTS -  Set this flag if this subdev generates
  *   events.
  *
- * @v4l2_dev: pointer to &struct v4l2_device
- * @ops: pointer to &struct v4l2_subdev_ops
- * @internal_ops: pointer to &struct v4l2_subdev_internal_ops.
+ * @v4l2_dev: pointer to struct &v4l2_device
+ * @ops: pointer to struct &v4l2_subdev_ops
+ * @internal_ops: pointer to struct &v4l2_subdev_internal_ops.
  *	Never call these internal ops from within a driver!
  * @ctrl_handler: The control handler of this subdev. May be NULL.
  * @name: Name of the sub-device. Please notice that the name must be unique.
-- 
2.7.4


