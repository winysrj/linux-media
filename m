Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43896 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941745AbcIHMEY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 23/47] [media] v4l2-device.h: fix some doc tags
Date: Thu,  8 Sep 2016 09:03:45 -0300
Message-Id: <519b03395f5b726dfdab85e429c45d251933ff0c.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix some minor issues at the documentation tags on this file,
adding cross-references where needed, and fixing some broken
ones.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-device.h | 54 ++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index a9d6aa41790e..781cbfd168f0 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -39,7 +39,7 @@ struct v4l2_ctrl_handler;
  *	if this struct is embedded into a larger struct.
  * @name: unique device name, by default the driver name + bus ID
  * @notify: notify callback called by some sub-devices.
- * @ctrl_handler: The control handler. May be NULL.
+ * @ctrl_handler: The control handler. May be %NULL.
  * @prio: Device's priority state
  * @ref: Keep track of the references to this struct.
  * @release: Release function that is called when the ref count
@@ -53,8 +53,8 @@ struct v4l2_ctrl_handler;
  *
  * .. note::
  *
- *    #) dev->driver_data points to this struct.
- *    #) dev might be NULL if there is no parent device
+ *    #) @dev->driver_data points to this struct.
+ *    #) @dev might be %NULL if there is no parent device
  */
 
 struct v4l2_device {
@@ -76,10 +76,10 @@ struct v4l2_device {
 /**
  * v4l2_device_get - gets a V4L2 device reference
  *
- * @v4l2_dev: pointer to struct v4l2_device
+ * @v4l2_dev: pointer to struct &v4l2_device
  *
  * This is an ancillary routine meant to increment the usage for the
- * struct v4l2_device pointed by @v4l2_dev.
+ * struct &v4l2_device pointed by @v4l2_dev.
  */
 static inline void v4l2_device_get(struct v4l2_device *v4l2_dev)
 {
@@ -89,23 +89,23 @@ static inline void v4l2_device_get(struct v4l2_device *v4l2_dev)
 /**
  * v4l2_device_put - putss a V4L2 device reference
  *
- * @v4l2_dev: pointer to struct v4l2_device
+ * @v4l2_dev: pointer to struct &v4l2_device
  *
  * This is an ancillary routine meant to decrement the usage for the
- * struct v4l2_device pointed by @v4l2_dev.
+ * struct &v4l2_device pointed by @v4l2_dev.
  */
 int v4l2_device_put(struct v4l2_device *v4l2_dev);
 
 /**
- * v4l2_device_register -Initialize v4l2_dev and make dev->driver_data
- * 	point to v4l2_dev.
+ * v4l2_device_register - Initialize v4l2_dev and make @dev->driver_data
+ * 	point to @v4l2_dev.
  *
- * @dev: pointer to struct device
- * @v4l2_dev: pointer to struct v4l2_device
+ * @dev: pointer to struct &device
+ * @v4l2_dev: pointer to struct &v4l2_device
  *
  * .. note::
- *	dev may be NULL in rare cases (ISA devices).
- *	In such case the caller must fill in the v4l2_dev->name field
+ *	@dev may be %NULL in rare cases (ISA devices).
+ *	In such case the caller must fill in the @v4l2_dev->name field
  *	before calling this function.
  */
 int __must_check v4l2_device_register(struct device *dev,
@@ -113,14 +113,14 @@ int __must_check v4l2_device_register(struct device *dev,
 
 /**
  * v4l2_device_set_name - Optional function to initialize the
- * 	name field of struct v4l2_device
+ * 	name field of struct &v4l2_device
  *
- * @v4l2_dev: pointer to struct v4l2_device
+ * @v4l2_dev: pointer to struct &v4l2_device
  * @basename: base name for the device name
  * @instance: pointer to a static atomic_t var with the instance usage for
  * 	the device driver.
  *
- * v4l2_device_set_name() initializes the name field of struct v4l2_device
+ * v4l2_device_set_name() initializes the name field of struct &v4l2_device
  * using the driver name and a driver-global atomic_t instance.
  *
  * This function will increment the instance counter and returns the
@@ -132,7 +132,7 @@ int __must_check v4l2_device_register(struct device *dev,
  *
  *   ...
  *
- *   instance = v4l2_device_set_name(&v4l2_dev, "foo", &drv_instance);
+ *   instance = v4l2_device_set_name(&\ v4l2_dev, "foo", &\ drv_instance);
  *
  * The first time this is called the name field will be set to foo0 and
  * this function returns 0. If the name ends with a digit (e.g. cx18),
@@ -147,16 +147,16 @@ int v4l2_device_set_name(struct v4l2_device *v4l2_dev, const char *basename,
  * @v4l2_dev: pointer to struct v4l2_device
  *
  * Should be called when the USB parent disconnects.
- * Since the parent disappears, this ensures that v4l2_dev doesn't have
+ * Since the parent disappears, this ensures that @v4l2_dev doesn't have
  * an invalid parent pointer.
  *
- * .. note:: This function sets v4l2_dev->dev to NULL.
+ * .. note:: This function sets @v4l2_dev->dev to NULL.
  */
 void v4l2_device_disconnect(struct v4l2_device *v4l2_dev);
 
 /**
  *  v4l2_device_unregister - Unregister all sub-devices and any other
- *	 resources related to v4l2_dev.
+ *	 resources related to @v4l2_dev.
  *
  * @v4l2_dev: pointer to struct v4l2_device
  */
@@ -165,8 +165,8 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev);
 /**
  * v4l2_device_register_subdev - Registers a subdev with a v4l2 device.
  *
- * @v4l2_dev: pointer to struct v4l2_device
- * @sd: pointer to struct v4l2_subdev
+ * @v4l2_dev: pointer to struct &v4l2_device
+ * @sd: pointer to struct &v4l2_subdev
  *
  * While registered, the subdev module is marked as in-use.
  *
@@ -179,7 +179,7 @@ int __must_check v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 /**
  * v4l2_device_unregister_subdev - Unregisters a subdev with a v4l2 device.
  *
- * @sd: pointer to struct v4l2_subdev
+ * @sd: pointer to struct &v4l2_subdev
  *
  * .. note ::
  *
@@ -191,7 +191,7 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
 /**
  * v4l2_device_register_subdev_nodes - Registers device nodes for all subdevs
  *	of the v4l2 device that are marked with
- * 	the V4L2_SUBDEV_FL_HAS_DEVNODE flag.
+ * 	the %V4L2_SUBDEV_FL_HAS_DEVNODE flag.
  *
  * @v4l2_dev: pointer to struct v4l2_device
  */
@@ -201,7 +201,7 @@ v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev);
 /**
  * v4l2_subdev_notify - Sends a notification to v4l2_device.
  *
- * @sd: pointer to struct v4l2_subdev
+ * @sd: pointer to struct &v4l2_subdev
  * @notification: type of notification. Please notice that the notification
  * 	type is driver-specific.
  * @arg: arguments for the notification. Those are specific to each
@@ -300,8 +300,8 @@ static inline void v4l2_subdev_notify(struct v4l2_subdev *sd,
 
 /*
  * Call the specified callback for all subdevs where grp_id & grpmsk != 0
- * (if grpmsk == `0, then match them all). If the callback returns an error
- * other than 0 or -ENOIOCTLCMD, then return with that error code. Note that
+ * (if grpmsk == 0, then match them all). If the callback returns an error
+ * other than 0 or %-ENOIOCTLCMD, then return with that error code. Note that
  * you cannot add or delete a subdev while walking the subdevs list.
  */
 #define v4l2_device_mask_call_until_err(v4l2_dev, grpmsk, o, f, args...) \
-- 
2.7.4


