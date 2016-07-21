Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52891 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbcGUUS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 16:18:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 07/12] [media] v4l2-subdev.rst: add cross-references
Date: Thu, 21 Jul 2016 17:18:12 -0300
Message-Id: <13dcb9648e94f6cabbd24b6dd721663047a5f64e.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enrich the subdevice description by linking it to the
functions and structs from v4l2-subdev.h.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-subdev.rst | 158 ++++++++++++++++---------------
 1 file changed, 83 insertions(+), 75 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index 3e2b25b47ff4..101902c930b9 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -7,35 +7,37 @@ encoding or decoding. For webcams common sub-devices are sensors and camera
 controllers.
 
 Usually these are I2C devices, but not necessarily. In order to provide the
-driver with a consistent interface to these sub-devices the v4l2_subdev struct
-(v4l2-subdev.h) was created.
+driver with a consistent interface to these sub-devices the
+:c:type:`v4l2_subdev` struct (v4l2-subdev.h) was created.
 
-Each sub-device driver must have a v4l2_subdev struct. This struct can be
-stand-alone for simple sub-devices or it might be embedded in a larger struct
-if more state information needs to be stored. Usually there is a low-level
-device struct (e.g. i2c_client) that contains the device data as setup
-by the kernel. It is recommended to store that pointer in the private
-data of v4l2_subdev using v4l2_set_subdevdata(). That makes it easy to go
-from a v4l2_subdev to the actual low-level bus-specific device data.
+Each sub-device driver must have a :c:type:`v4l2_subdev` struct. This struct
+can be stand-alone for simple sub-devices or it might be embedded in a larger
+struct if more state information needs to be stored. Usually there is a
+low-level device struct (e.g. ``i2c_client``) that contains the device data as
+setup by the kernel. It is recommended to store that pointer in the private
+data of :c:type:`v4l2_subdev` using :cpp:func:`v4l2_set_subdevdata`. That makes
+it easy to go from a :c:type:`v4l2_subdev` to the actual low-level bus-specific
+device data.
 
-You also need a way to go from the low-level struct to v4l2_subdev. For the
-common i2c_client struct the i2c_set_clientdata() call is used to store a
-v4l2_subdev pointer, for other busses you may have to use other methods.
+You also need a way to go from the low-level struct to :c:type:`v4l2_subdev`.
+For the common i2c_client struct the i2c_set_clientdata() call is used to store
+a :c:type:`v4l2_subdev` pointer, for other busses you may have to use other
+methods.
 
 Bridges might also need to store per-subdev private data, such as a pointer to
-bridge-specific per-subdev private data. The v4l2_subdev structure provides
-host private data for that purpose that can be accessed with
-v4l2_get_subdev_hostdata() and v4l2_set_subdev_hostdata().
+bridge-specific per-subdev private data. The :c:type:`v4l2_subdev` structure
+provides host private data for that purpose that can be accessed with
+:cpp:func:`v4l2_get_subdev_hostdata` and :cpp:func:`v4l2_set_subdev_hostdata`.
 
-From the bridge driver perspective you load the sub-device module and somehow
-obtain the v4l2_subdev pointer. For i2c devices this is easy: you call
-i2c_get_clientdata(). For other busses something similar needs to be done.
+From the bridge driver perspective, you load the sub-device module and somehow
+obtain the :c:type:`v4l2_subdev` pointer. For i2c devices this is easy: you call
+``i2c_get_clientdata()``. For other busses something similar needs to be done.
 Helper functions exists for sub-devices on an I2C bus that do most of this
 tricky work for you.
 
-Each v4l2_subdev contains function pointers that sub-device drivers can
-implement (or leave NULL if it is not applicable). Since sub-devices can do
-so many different things and you do not want to end up with a huge ops struct
+Each :c:type:`v4l2_subdev` contains function pointers that sub-device drivers
+can implement (or leave ``NULL`` if it is not applicable). Since sub-devices can
+do so many different things and you do not want to end up with a huge ops struct
 of which only a handful of ops are commonly implemented, the function pointers
 are sorted according to category and each category has its own ops struct.
 
@@ -44,7 +46,7 @@ may be NULL if the subdev driver does not support anything from that category.
 
 It looks like this:
 
-.. code-block:: none
+.. code-block:: c
 
 	struct v4l2_subdev_core_ops {
 		int (*log_status)(struct v4l2_subdev *sd);
@@ -83,20 +85,22 @@ audio ops and vice versa.
 This setup limits the number of function pointers while still making it easy
 to add new ops and categories.
 
-A sub-device driver initializes the v4l2_subdev struct using:
+A sub-device driver initializes the :c:type:`v4l2_subdev` struct using:
 
-.. code-block:: none
+	:cpp:func:`v4l2_subdev_init <v4l2_subdev_init>`
+	(:c:type:`sd <v4l2_subdev>`, &\ :c:type:`ops <v4l2_subdev_ops>`).
 
-	v4l2_subdev_init(sd, &ops);
 
-Afterwards you need to initialize subdev->name with a unique name and set the
-module owner. This is done for you if you use the i2c helper functions.
+Afterwards you need to initialize :c:type:`sd <v4l2_subdev>`->name with a
+unique name and set the module owner. This is done for you if you use the
+i2c helper functions.
 
 If integration with the media framework is needed, you must initialize the
-media_entity struct embedded in the v4l2_subdev struct (entity field) by
-calling media_entity_pads_init(), if the entity has pads:
+:c:type:`media_entity` struct embedded in the :c:type:`v4l2_subdev` struct
+(entity field) by calling :cpp:func:`media_entity_pads_init`, if the entity has
+pads:
 
-.. code-block:: none
+.. code-block:: c
 
 	struct media_pad *pads = &my_sd->pads;
 	int err;
@@ -104,7 +108,7 @@ calling media_entity_pads_init(), if the entity has pads:
 	err = media_entity_pads_init(&sd->entity, npads, pads);
 
 The pads array must have been previously initialized. There is no need to
-manually set the struct media_entity function and name fields, but the
+manually set the struct :c:type:`media_entity` function and name fields, but the
 revision field must be initialized if needed.
 
 A reference to the entity will be automatically acquired/released when the
@@ -112,13 +116,13 @@ subdev device node (if any) is opened/closed.
 
 Don't forget to cleanup the media entity before the sub-device is destroyed:
 
-.. code-block:: none
+.. code-block:: c
 
 	media_entity_cleanup(&sd->entity);
 
 If the subdev driver intends to process video and integrate with the media
 framework, it must implement format related functionality using
-v4l2_subdev_pad_ops instead of v4l2_subdev_video_ops.
+:c:type:`v4l2_subdev_pad_ops` instead of :c:type:`v4l2_subdev_video_ops`.
 
 In that case, the subdev driver may set the link_validate field to provide
 its own link validation function. The link validation function is called for
@@ -127,9 +131,9 @@ sub-devices. The driver is still responsible for validating the correctness
 of the format configuration between sub-devices and video nodes.
 
 If link_validate op is not set, the default function
-v4l2_subdev_link_validate_default() is used instead. This function ensures
-that width, height and the media bus pixel code are equal on both source and
-sink of the link. Subdev drivers are also free to use this function to
+:cpp:func:`v4l2_subdev_link_validate_default` is used instead. This function
+ensures that width, height and the media bus pixel code are equal on both source
+and sink of the link. Subdev drivers are also free to use this function to
 perform the checks mentioned above in addition to their own checks.
 
 There are currently two ways to register subdevices with the V4L2 core. The
@@ -152,105 +156,109 @@ Using one or the other registration method only affects the probing process, the
 run-time bridge-subdevice interaction is in both cases the same.
 
 In the synchronous case a device (bridge) driver needs to register the
-v4l2_subdev with the v4l2_device:
+:c:type:`v4l2_subdev` with the v4l2_device:
 
-.. code-block:: none
-
-	int err = v4l2_device_register_subdev(v4l2_dev, sd);
+	:cpp:func:`v4l2_device_register_subdev <v4l2_device_register_subdev>`
+	(:c:type:`v4l2_dev <v4l2_device>`, :c:type:`sd <v4l2_subdev>`).
 
 This can fail if the subdev module disappeared before it could be registered.
 After this function was called successfully the subdev->dev field points to
-the v4l2_device.
+the :c:type:`v4l2_device`.
 
 If the v4l2_device parent device has a non-NULL mdev field, the sub-device
 entity will be automatically registered with the media device.
 
 You can unregister a sub-device using:
 
-.. code-block:: none
+	:cpp:func:`v4l2_device_unregister_subdev <v4l2_device_unregister_subdev>`
+	(:c:type:`sd <v4l2_subdev>`).
 
-	v4l2_device_unregister_subdev(sd);
 
-Afterwards the subdev module can be unloaded and sd->dev == NULL.
+Afterwards the subdev module can be unloaded and
+:c:type:`sd <v4l2_subdev>`->dev == ``NULL``.
 
 You can call an ops function either directly:
 
-.. code-block:: none
+.. code-block:: c
 
 	err = sd->ops->core->g_std(sd, &norm);
 
 but it is better and easier to use this macro:
 
-.. code-block:: none
+.. code-block:: c
 
 	err = v4l2_subdev_call(sd, core, g_std, &norm);
 
-The macro will to the right NULL pointer checks and returns -ENODEV if subdev
-is NULL, -ENOIOCTLCMD if either subdev->core or subdev->core->g_std is
-NULL, or the actual result of the subdev->ops->core->g_std ops.
+The macro will to the right ``NULL`` pointer checks and returns ``-ENODEV``
+if :c:type:`sd <v4l2_subdev>` is ``NULL``, ``-ENOIOCTLCMD`` if either
+:c:type:`sd <v4l2_subdev>`->core or :c:type:`sd <v4l2_subdev>`->core->g_std is ``NULL``, or the actual result of the
+:c:type:`sd <v4l2_subdev>`->ops->core->g_std ops.
 
 It is also possible to call all or a subset of the sub-devices:
 
-.. code-block:: none
+.. code-block:: c
 
 	v4l2_device_call_all(v4l2_dev, 0, core, g_std, &norm);
 
 Any subdev that does not support this ops is skipped and error results are
 ignored. If you want to check for errors use this:
 
-.. code-block:: none
+.. code-block:: c
 
 	err = v4l2_device_call_until_err(v4l2_dev, 0, core, g_std, &norm);
 
-Any error except -ENOIOCTLCMD will exit the loop with that error. If no
-errors (except -ENOIOCTLCMD) occurred, then 0 is returned.
+Any error except ``-ENOIOCTLCMD`` will exit the loop with that error. If no
+errors (except ``-ENOIOCTLCMD``) occurred, then 0 is returned.
 
 The second argument to both calls is a group ID. If 0, then all subdevs are
 called. If non-zero, then only those whose group ID match that value will
-be called. Before a bridge driver registers a subdev it can set sd->grp_id
-to whatever value it wants (it's 0 by default). This value is owned by the
-bridge driver and the sub-device driver will never modify or use it.
+be called. Before a bridge driver registers a subdev it can set
+:c:type:`sd <v4l2_subdev>`->grp_id to whatever value it wants (it's 0 by
+default). This value is owned by the bridge driver and the sub-device driver
+will never modify or use it.
 
 The group ID gives the bridge driver more control how callbacks are called.
 For example, there may be multiple audio chips on a board, each capable of
 changing the volume. But usually only one will actually be used when the
 user want to change the volume. You can set the group ID for that subdev to
 e.g. AUDIO_CONTROLLER and specify that as the group ID value when calling
-v4l2_device_call_all(). That ensures that it will only go to the subdev
+``v4l2_device_call_all()``. That ensures that it will only go to the subdev
 that needs it.
 
 If the sub-device needs to notify its v4l2_device parent of an event, then
-it can call v4l2_subdev_notify(sd, notification, arg). This macro checks
-whether there is a notify() callback defined and returns -ENODEV if not.
-Otherwise the result of the notify() call is returned.
+it can call ``v4l2_subdev_notify(sd, notification, arg)``. This macro checks
+whether there is a ``notify()`` callback defined and returns ``-ENODEV`` if not.
+Otherwise the result of the ``notify()`` call is returned.
 
-The advantage of using v4l2_subdev is that it is a generic struct and does
-not contain any knowledge about the underlying hardware. So a driver might
+The advantage of using :c:type:`v4l2_subdev` is that it is a generic struct and
+does not contain any knowledge about the underlying hardware. So a driver might
 contain several subdevs that use an I2C bus, but also a subdev that is
 controlled through GPIO pins. This distinction is only relevant when setting
 up the device, but once the subdev is registered it is completely transparent.
 
-
 In the asynchronous case subdevice probing can be invoked independently of the
 bridge driver availability. The subdevice driver then has to verify whether all
 the requirements for a successful probing are satisfied. This can include a
 check for a master clock availability. If any of the conditions aren't satisfied
-the driver might decide to return -EPROBE_DEFER to request further reprobing
+the driver might decide to return ``-EPROBE_DEFER`` to request further reprobing
 attempts. Once all conditions are met the subdevice shall be registered using
-the v4l2_async_register_subdev() function. Unregistration is performed using
-the v4l2_async_unregister_subdev() call. Subdevices registered this way are
-stored in a global list of subdevices, ready to be picked up by bridge drivers.
+the :cpp:func:`v4l2_async_register_subdev` function. Unregistration is
+performed using the :cpp:func:`v4l2_async_unregister_subdev` call. Subdevices
+registered this way are stored in a global list of subdevices, ready to be
+picked up by bridge drivers.
 
 Bridge drivers in turn have to register a notifier object with an array of
 subdevice descriptors that the bridge device needs for its operation. This is
-performed using the v4l2_async_notifier_register() call. To unregister the
-notifier the driver has to call v4l2_async_notifier_unregister(). The former of
-the two functions takes two arguments: a pointer to struct v4l2_device and a
-pointer to struct v4l2_async_notifier. The latter contains a pointer to an array
-of pointers to subdevice descriptors of type struct v4l2_async_subdev type. The
-V4L2 core will then use these descriptors to match asynchronously registered
-subdevices to them. If a match is detected the .bound() notifier callback is
-called. After all subdevices have been located the .complete() callback is
+performed using the :cpp:func:`v4l2_async_notifier_register` call. To
+unregister the notifier the driver has to call
+:cpp:func:`v4l2_async_notifier_unregister`. The former of the two functions
+takes two arguments: a pointer to struct :c:type:`v4l2_device` and a pointer to
+struct :c:type:`v4l2_async_notifier`. The latter contains a pointer to an array
+of pointers to subdevice descriptors of type struct :c:type:`v4l2_async_subdev`
+type. The V4L2 core will then use these descriptors to match asynchronously
+registered
+subdevices to them. If a match is detected the ``.bound()`` notifier callback
+is called. After all subdevices have been located the .complete() callback is
 called. When a subdevice is removed from the system the .unbind() method is
 called. All three callbacks are optional.
 
-- 
2.7.4

