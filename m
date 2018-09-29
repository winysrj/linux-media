Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40110 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbeI3CY0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 22:24:26 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RESEND PATCH v7 04/17] media: v4l2: async: Add convenience functions to allocate and add asd's
Date: Sat, 29 Sep 2018 12:54:07 -0700
Message-Id: <20180929195420.28579-5-slongerbeam@gmail.com>
In-Reply-To: <20180929195420.28579-1-slongerbeam@gmail.com>
References: <20180929195420.28579-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add these convenience functions, which allocate an asd of match type
fwnode, i2c, or device-name, of size asd_struct_size, and then adds
them to the notifier asd_list.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 76 ++++++++++++++++++++++++++++
 include/media/v4l2-async.h           | 62 +++++++++++++++++++++++
 2 files changed, 138 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 7925875d09b7..196573f4ec48 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -650,6 +650,82 @@ int v4l2_async_notifier_add_subdev(struct v4l2_async_notifier *notifier,
 }
 EXPORT_SYMBOL_GPL(v4l2_async_notifier_add_subdev);
 
+struct v4l2_async_subdev *
+v4l2_async_notifier_add_fwnode_subdev(struct v4l2_async_notifier *notifier,
+				      struct fwnode_handle *fwnode,
+				      unsigned int asd_struct_size)
+{
+	struct v4l2_async_subdev *asd;
+	int ret;
+
+	asd = kzalloc(asd_struct_size, GFP_KERNEL);
+	if (!asd)
+		return ERR_PTR(-ENOMEM);
+
+	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
+	asd->match.fwnode = fwnode;
+
+	ret = v4l2_async_notifier_add_subdev(notifier, asd);
+	if (ret) {
+		kfree(asd);
+		return ERR_PTR(ret);
+	}
+
+	return asd;
+}
+EXPORT_SYMBOL_GPL(v4l2_async_notifier_add_fwnode_subdev);
+
+struct v4l2_async_subdev *
+v4l2_async_notifier_add_i2c_subdev(struct v4l2_async_notifier *notifier,
+				   int adapter_id, unsigned short address,
+				   unsigned int asd_struct_size)
+{
+	struct v4l2_async_subdev *asd;
+	int ret;
+
+	asd = kzalloc(asd_struct_size, GFP_KERNEL);
+	if (!asd)
+		return ERR_PTR(-ENOMEM);
+
+	asd->match_type = V4L2_ASYNC_MATCH_I2C;
+	asd->match.i2c.adapter_id = adapter_id;
+	asd->match.i2c.address = address;
+
+	ret = v4l2_async_notifier_add_subdev(notifier, asd);
+	if (ret) {
+		kfree(asd);
+		return ERR_PTR(ret);
+	}
+
+	return asd;
+}
+EXPORT_SYMBOL_GPL(v4l2_async_notifier_add_i2c_subdev);
+
+struct v4l2_async_subdev *
+v4l2_async_notifier_add_devname_subdev(struct v4l2_async_notifier *notifier,
+				       const char *device_name,
+				       unsigned int asd_struct_size)
+{
+	struct v4l2_async_subdev *asd;
+	int ret;
+
+	asd = kzalloc(asd_struct_size, GFP_KERNEL);
+	if (!asd)
+		return ERR_PTR(-ENOMEM);
+
+	asd->match_type = V4L2_ASYNC_MATCH_DEVNAME;
+	asd->match.device_name = device_name;
+
+	ret = v4l2_async_notifier_add_subdev(notifier, asd);
+	if (ret) {
+		kfree(asd);
+		return ERR_PTR(ret);
+	}
+
+	return asd;
+}
+EXPORT_SYMBOL_GPL(v4l2_async_notifier_add_devname_subdev);
+
 int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 {
 	struct v4l2_async_notifier *subdev_notifier;
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index ab4d7acb7960..3489e4ccb29b 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -174,6 +174,68 @@ void v4l2_async_notifier_init(struct v4l2_async_notifier *notifier);
 int v4l2_async_notifier_add_subdev(struct v4l2_async_notifier *notifier,
 				   struct v4l2_async_subdev *asd);
 
+/**
+ * v4l2_async_notifier_add_fwnode_subdev - Allocate and add a fwnode async
+ *				subdev to the notifier's master asd_list.
+ *
+ * @notifier: pointer to &struct v4l2_async_notifier
+ * @fwnode: fwnode handle of the sub-device to be matched
+ * @asd_struct_size: size of the driver's async sub-device struct, including
+ *		     sizeof(struct v4l2_async_subdev). The &struct
+ *		     v4l2_async_subdev shall be the first member of
+ *		     the driver's async sub-device struct, i.e. both
+ *		     begin at the same memory address.
+ *
+ * This can be used before registering a notifier to add a
+ * fwnode-matched asd to the notifiers master asd_list. If the caller
+ * uses this method to compose an asd list, it must never allocate
+ * or place asd's in the @subdevs array.
+ */
+struct v4l2_async_subdev *
+v4l2_async_notifier_add_fwnode_subdev(struct v4l2_async_notifier *notifier,
+				      struct fwnode_handle *fwnode,
+				      unsigned int asd_struct_size);
+
+/**
+ * v4l2_async_notifier_add_i2c_subdev - Allocate and add an i2c async
+ *				subdev to the notifier's master asd_list.
+ *
+ * @notifier: pointer to &struct v4l2_async_notifier
+ * @adapter_id: I2C adapter ID to be matched
+ * @address: I2C address of sub-device to be matched
+ * @asd_struct_size: size of the driver's async sub-device struct, including
+ *		     sizeof(struct v4l2_async_subdev). The &struct
+ *		     v4l2_async_subdev shall be the first member of
+ *		     the driver's async sub-device struct, i.e. both
+ *		     begin at the same memory address.
+ *
+ * Same as above but for I2C matched sub-devices.
+ */
+struct v4l2_async_subdev *
+v4l2_async_notifier_add_i2c_subdev(struct v4l2_async_notifier *notifier,
+				   int adapter_id, unsigned short address,
+				   unsigned int asd_struct_size);
+
+/**
+ * v4l2_async_notifier_add_devname_subdev - Allocate and add a device-name
+ *				async subdev to the notifier's master asd_list.
+ *
+ * @notifier: pointer to &struct v4l2_async_notifier
+ * @device_name: device name string to be matched
+ * @asd_struct_size: size of the driver's async sub-device struct, including
+ *		     sizeof(struct v4l2_async_subdev). The &struct
+ *		     v4l2_async_subdev shall be the first member of
+ *		     the driver's async sub-device struct, i.e. both
+ *		     begin at the same memory address.
+ *
+ * Same as above but for device-name matched sub-devices.
+ */
+struct v4l2_async_subdev *
+v4l2_async_notifier_add_devname_subdev(struct v4l2_async_notifier *notifier,
+				       const char *device_name,
+				       unsigned int asd_struct_size);
+
+
 /**
  * v4l2_async_notifier_register - registers a subdevice asynchronous notifier
  *
-- 
2.17.1
