Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52893 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbcGUUS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 16:18:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 01/12] [media] v4l2-device.h: document functions
Date: Thu, 21 Jul 2016 17:18:06 -0300
Message-Id: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The functions at v4l2-device.h are not using the proper
markups. Add it, and include at the v4l2-core.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-core.rst |   2 +
 include/media/v4l2-device.h            | 194 ++++++++++++++++++++++++---------
 2 files changed, 143 insertions(+), 53 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
index a1b73e8d6795..db571a4f498a 100644
--- a/Documentation/media/kapi/v4l2-core.rst
+++ b/Documentation/media/kapi/v4l2-core.rst
@@ -11,6 +11,8 @@ Video2Linux devices
 
 .. kernel-doc:: include/media/v4l2-ctrls.h
 
+.. kernel-doc:: include/media/v4l2-device.h
+
 .. kernel-doc:: include/media/v4l2-dv-timings.h
 
 .. kernel-doc:: include/media/v4l2-event.h
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index d5d45a8d3998..a9d6aa41790e 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -25,100 +25,188 @@
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-dev.h>
 
-/* Each instance of a V4L2 device should create the v4l2_device struct,
-   either stand-alone or embedded in a larger struct.
-
-   It allows easy access to sub-devices (see v4l2-subdev.h) and provides
-   basic V4L2 device-level support.
- */
-
 #define V4L2_DEVICE_NAME_SIZE (20 + 16)
 
 struct v4l2_ctrl_handler;
 
+/**
+ * struct v4l2_device - main struct to for V4L2 device drivers
+ *
+ * @dev: pointer to struct device.
+ * @mdev: pointer to struct media_device
+ * @subdevs: used to keep track of the registered subdevs
+ * @lock: lock this struct; can be used by the driver as well
+ *	if this struct is embedded into a larger struct.
+ * @name: unique device name, by default the driver name + bus ID
+ * @notify: notify callback called by some sub-devices.
+ * @ctrl_handler: The control handler. May be NULL.
+ * @prio: Device's priority state
+ * @ref: Keep track of the references to this struct.
+ * @release: Release function that is called when the ref count
+ *	goes to 0.
+ *
+ * Each instance of a V4L2 device should create the v4l2_device struct,
+ * either stand-alone or embedded in a larger struct.
+ *
+ * It allows easy access to sub-devices (see v4l2-subdev.h) and provides
+ * basic V4L2 device-level support.
+ *
+ * .. note::
+ *
+ *    #) dev->driver_data points to this struct.
+ *    #) dev might be NULL if there is no parent device
+ */
+
 struct v4l2_device {
-	/* dev->driver_data points to this struct.
-	   Note: dev might be NULL if there is no parent device
-	   as is the case with e.g. ISA devices. */
 	struct device *dev;
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	struct media_device *mdev;
 #endif
-	/* used to keep track of the registered subdevs */
 	struct list_head subdevs;
-	/* lock this struct; can be used by the driver as well if this
-	   struct is embedded into a larger struct. */
 	spinlock_t lock;
-	/* unique device name, by default the driver name + bus ID */
 	char name[V4L2_DEVICE_NAME_SIZE];
-	/* notify callback called by some sub-devices. */
 	void (*notify)(struct v4l2_subdev *sd,
 			unsigned int notification, void *arg);
-	/* The control handler. May be NULL. */
 	struct v4l2_ctrl_handler *ctrl_handler;
-	/* Device's priority state */
 	struct v4l2_prio_state prio;
-	/* Keep track of the references to this struct. */
 	struct kref ref;
-	/* Release function that is called when the ref count goes to 0. */
 	void (*release)(struct v4l2_device *v4l2_dev);
 };
 
+/**
+ * v4l2_device_get - gets a V4L2 device reference
+ *
+ * @v4l2_dev: pointer to struct v4l2_device
+ *
+ * This is an ancillary routine meant to increment the usage for the
+ * struct v4l2_device pointed by @v4l2_dev.
+ */
 static inline void v4l2_device_get(struct v4l2_device *v4l2_dev)
 {
 	kref_get(&v4l2_dev->ref);
 }
 
+/**
+ * v4l2_device_put - putss a V4L2 device reference
+ *
+ * @v4l2_dev: pointer to struct v4l2_device
+ *
+ * This is an ancillary routine meant to decrement the usage for the
+ * struct v4l2_device pointed by @v4l2_dev.
+ */
 int v4l2_device_put(struct v4l2_device *v4l2_dev);
 
-/* Initialize v4l2_dev and make dev->driver_data point to v4l2_dev.
-   dev may be NULL in rare cases (ISA devices). In that case you
-   must fill in the v4l2_dev->name field before calling this function. */
-int __must_check v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev);
+/**
+ * v4l2_device_register -Initialize v4l2_dev and make dev->driver_data
+ * 	point to v4l2_dev.
+ *
+ * @dev: pointer to struct device
+ * @v4l2_dev: pointer to struct v4l2_device
+ *
+ * .. note::
+ *	dev may be NULL in rare cases (ISA devices).
+ *	In such case the caller must fill in the v4l2_dev->name field
+ *	before calling this function.
+ */
+int __must_check v4l2_device_register(struct device *dev,
+				      struct v4l2_device *v4l2_dev);
 
-/* Optional function to initialize the name field of struct v4l2_device using
-   the driver name and a driver-global atomic_t instance.
-   This function will increment the instance counter and returns the instance
-   value used in the name.
-
-   Example:
-
-   static atomic_t drv_instance = ATOMIC_INIT(0);
-
-   ...
-
-   instance = v4l2_device_set_name(&v4l2_dev, "foo", &drv_instance);
-
-   The first time this is called the name field will be set to foo0 and
-   this function returns 0. If the name ends with a digit (e.g. cx18),
-   then the name will be set to cx18-0 since cx180 looks really odd. */
+/**
+ * v4l2_device_set_name - Optional function to initialize the
+ * 	name field of struct v4l2_device
+ *
+ * @v4l2_dev: pointer to struct v4l2_device
+ * @basename: base name for the device name
+ * @instance: pointer to a static atomic_t var with the instance usage for
+ * 	the device driver.
+ *
+ * v4l2_device_set_name() initializes the name field of struct v4l2_device
+ * using the driver name and a driver-global atomic_t instance.
+ *
+ * This function will increment the instance counter and returns the
+ * instance value used in the name.
+ *
+ * Example:
+ *
+ *   static atomic_t drv_instance = ATOMIC_INIT(0);
+ *
+ *   ...
+ *
+ *   instance = v4l2_device_set_name(&v4l2_dev, "foo", &drv_instance);
+ *
+ * The first time this is called the name field will be set to foo0 and
+ * this function returns 0. If the name ends with a digit (e.g. cx18),
+ * then the name will be set to cx18-0 since cx180 would look really odd.
+ */
 int v4l2_device_set_name(struct v4l2_device *v4l2_dev, const char *basename,
-						atomic_t *instance);
+			 atomic_t *instance);
 
-/* Set v4l2_dev->dev to NULL. Call when the USB parent disconnects.
-   Since the parent disappears this ensures that v4l2_dev doesn't have an
-   invalid parent pointer. */
+/**
+ * v4l2_device_disconnect - Change V4L2 device state to disconnected.
+ *
+ * @v4l2_dev: pointer to struct v4l2_device
+ *
+ * Should be called when the USB parent disconnects.
+ * Since the parent disappears, this ensures that v4l2_dev doesn't have
+ * an invalid parent pointer.
+ *
+ * .. note:: This function sets v4l2_dev->dev to NULL.
+ */
 void v4l2_device_disconnect(struct v4l2_device *v4l2_dev);
 
-/* Unregister all sub-devices and any other resources related to v4l2_dev. */
+/**
+ *  v4l2_device_unregister - Unregister all sub-devices and any other
+ *	 resources related to v4l2_dev.
+ *
+ * @v4l2_dev: pointer to struct v4l2_device
+ */
 void v4l2_device_unregister(struct v4l2_device *v4l2_dev);
 
-/* Register a subdev with a v4l2 device. While registered the subdev module
-   is marked as in-use. An error is returned if the module is no longer
-   loaded when you attempt to register it. */
+/**
+ * v4l2_device_register_subdev - Registers a subdev with a v4l2 device.
+ *
+ * @v4l2_dev: pointer to struct v4l2_device
+ * @sd: pointer to struct v4l2_subdev
+ *
+ * While registered, the subdev module is marked as in-use.
+ *
+ * An error is returned if the module is no longer loaded on any attempts
+ * to register it.
+ */
 int __must_check v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
-						struct v4l2_subdev *sd);
-/* Unregister a subdev with a v4l2 device. Can also be called if the subdev
-   wasn't registered. In that case it will do nothing. */
+					     struct v4l2_subdev *sd);
+
+/**
+ * v4l2_device_unregister_subdev - Unregisters a subdev with a v4l2 device.
+ *
+ * @sd: pointer to struct v4l2_subdev
+ *
+ * .. note ::
+ *
+ *	Can also be called if the subdev wasn't registered. In such
+ *	case, it will do nothing.
+ */
 void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
 
-/* Register device nodes for all subdev of the v4l2 device that are marked with
- * the V4L2_SUBDEV_FL_HAS_DEVNODE flag.
+/**
+ * v4l2_device_register_subdev_nodes - Registers device nodes for all subdevs
+ *	of the v4l2 device that are marked with
+ * 	the V4L2_SUBDEV_FL_HAS_DEVNODE flag.
+ *
+ * @v4l2_dev: pointer to struct v4l2_device
  */
 int __must_check
 v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev);
 
-/* Send a notification to v4l2_device. */
+/**
+ * v4l2_subdev_notify - Sends a notification to v4l2_device.
+ *
+ * @sd: pointer to struct v4l2_subdev
+ * @notification: type of notification. Please notice that the notification
+ * 	type is driver-specific.
+ * @arg: arguments for the notification. Those are specific to each
+ *	notification type.
+ */
 static inline void v4l2_subdev_notify(struct v4l2_subdev *sd,
 				      unsigned int notification, void *arg)
 {
-- 
2.7.4

