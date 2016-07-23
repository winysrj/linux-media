Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43348 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbcGWLcY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2016 07:32:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 2/4] [media] doc-rst: kapi: use :c:func: instead of :cpp:func
Date: Sat, 23 Jul 2016 08:31:52 -0300
Message-Id: <7b998bae0546d7b1d9bcf0e23c4b3294c4027e4c.1469273428.git.mchehab@s-opensource.com>
In-Reply-To: <a3f57ad0e401cc19887da462b16a20d97e7bccfb.1469273428.git.mchehab@s-opensource.com>
References: <a3f57ad0e401cc19887da462b16a20d97e7bccfb.1469273428.git.mchehab@s-opensource.com>
In-Reply-To: <a3f57ad0e401cc19887da462b16a20d97e7bccfb.1469273428.git.mchehab@s-opensource.com>
References: <a3f57ad0e401cc19887da462b16a20d97e7bccfb.1469273428.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

References at the rst files for C functions generated via
kernel-doc should use :c:func:.

Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/dtv-core.rst    | 12 ++++----
 Documentation/media/kapi/mc-core.rst     | 50 ++++++++++++++++----------------
 Documentation/media/kapi/v4l2-dev.rst    | 50 ++++++++++++++++----------------
 Documentation/media/kapi/v4l2-device.rst | 24 +++++++--------
 Documentation/media/kapi/v4l2-event.rst  | 12 ++++----
 Documentation/media/kapi/v4l2-fh.rst     | 22 +++++++-------
 Documentation/media/kapi/v4l2-subdev.rst | 42 +++++++++++++--------------
 7 files changed, 106 insertions(+), 106 deletions(-)

diff --git a/Documentation/media/kapi/dtv-core.rst b/Documentation/media/kapi/dtv-core.rst
index 11da77e141ed..dd96e846fef9 100644
--- a/Documentation/media/kapi/dtv-core.rst
+++ b/Documentation/media/kapi/dtv-core.rst
@@ -34,16 +34,16 @@ drivers/media/dvb-core.
 
 Before using the Digital TV frontend core, the bridge driver should attach
 the frontend demod, tuner and SEC devices and call
-:cpp:func:`dvb_register_frontend()`,
+:c:func:`dvb_register_frontend()`,
 in order to register the new frontend at the subsystem. At device
 detach/removal, the bridge driver should call
-:cpp:func:`dvb_unregister_frontend()` to
-remove the frontend from the core and then :cpp:func:`dvb_frontend_detach()`
+:c:func:`dvb_unregister_frontend()` to
+remove the frontend from the core and then :c:func:`dvb_frontend_detach()`
 to free the memory allocated by the frontend drivers.
 
-The drivers should also call :cpp:func:`dvb_frontend_suspend()` as part of
+The drivers should also call :c:func:`dvb_frontend_suspend()` as part of
 their handler for the :c:type:`device_driver`.\ ``suspend()``, and
-:cpp:func:`dvb_frontend_resume()` as
+:c:func:`dvb_frontend_resume()` as
 part of their handler for :c:type:`device_driver`.\ ``resume()``.
 
 A few other optional functions are provided to handle some special cases.
@@ -121,7 +121,7 @@ triggered by a hardware interrupt, it is recommended to use the Linux
 bottom half mechanism or start a tasklet instead of making the callback
 function call directly from a hardware interrupt.
 
-This mechanism is implemented by :cpp:func:`dmx_ts_cb()` and :cpp:func:`dmx_section_cb()`
+This mechanism is implemented by :c:func:`dmx_ts_cb()` and :cpp:func:`dmx_section_cb()`
 callbacks.
 
 .. kernel-doc:: drivers/media/dvb-core/demux.h
diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
index deae3b7c692d..569cfc4f01cd 100644
--- a/Documentation/media/kapi/mc-core.rst
+++ b/Documentation/media/kapi/mc-core.rst
@@ -41,8 +41,8 @@ embedding the :c:type:`media_device` instance in a larger driver-specific
 structure.
 
 Drivers register media device instances by calling
-:cpp:func:`__media_device_register()` via the macro ``media_device_register()``
-and unregistered by calling :cpp:func:`media_device_unregister()`.
+:c:func:`__media_device_register()` via the macro ``media_device_register()``
+and unregistered by calling :c:func:`media_device_unregister()`.
 
 Entities
 ^^^^^^^^
@@ -54,12 +54,12 @@ embedded into a higher-level structure, such as
 instances, although drivers can allocate entities directly.
 
 Drivers initialize entity pads by calling
-:cpp:func:`media_entity_pads_init()`.
+:c:func:`media_entity_pads_init()`.
 
 Drivers register entities with a media device by calling
-:cpp:func:`media_device_register_entity()`
+:c:func:`media_device_register_entity()`
 and unregistred by calling
-:cpp:func:`media_device_unregister_entity()`.
+:c:func:`media_device_unregister_entity()`.
 
 Interfaces
 ^^^^^^^^^^
@@ -71,9 +71,9 @@ defined: a device node. Such interfaces are represented by a
 :c:type:`struct media_intf_devnode <media_intf_devnode>`.
 
 Drivers initialize and create device node interfaces by calling
-:cpp:func:`media_devnode_create()`
+:c:func:`media_devnode_create()`
 and remove them by calling:
-:cpp:func:`media_devnode_remove()`.
+:c:func:`media_devnode_remove()`.
 
 Pads
 ^^^^
@@ -112,24 +112,24 @@ A given link is thus stored twice, once in the source entity and once in
 the target entity.
 
 Drivers create pad to pad links by calling:
-:cpp:func:`media_create_pad_link()` and remove with
-:cpp:func:`media_entity_remove_links()`.
+:c:func:`media_create_pad_link()` and remove with
+:c:func:`media_entity_remove_links()`.
 
 **2. interface to entity links**:
 
 Associate one interface to a Link.
 
 Drivers create interface to entity links by calling:
-:cpp:func:`media_create_intf_link()` and remove with
-:cpp:func:`media_remove_intf_links()`.
+:c:func:`media_create_intf_link()` and remove with
+:c:func:`media_remove_intf_links()`.
 
 .. note::
 
    Links can only be created after having both ends already created.
 
 Links have flags that describe the link capabilities and state. The
-valid values are described at :cpp:func:`media_create_pad_link()` and
-:cpp:func:`media_create_intf_link()`.
+valid values are described at :c:func:`media_create_pad_link()` and
+:c:func:`media_create_intf_link()`.
 
 Graph traversal
 ^^^^^^^^^^^^^^^
@@ -161,13 +161,13 @@ framework provides a depth-first graph traversal API for that purpose.
    currently defined as 16.
 
 Drivers initiate a graph traversal by calling
-:cpp:func:`media_entity_graph_walk_start()`
+:c:func:`media_entity_graph_walk_start()`
 
 The graph structure, provided by the caller, is initialized to start graph
 traversal at the given entity.
 
 Drivers can then retrieve the next entity by calling
-:cpp:func:`media_entity_graph_walk_next()`
+:c:func:`media_entity_graph_walk_next()`
 
 When the graph traversal is complete the function will return ``NULL``.
 
@@ -176,8 +176,8 @@ is required and the graph structure can be freed normally.
 
 Helper functions can be used to find a link between two given pads, or a pad
 connected to another pad through an enabled link
-:cpp:func:`media_entity_find_link()` and
-:cpp:func:`media_entity_remote_pad()`.
+:c:func:`media_entity_find_link()` and
+:c:func:`media_entity_remote_pad()`.
 
 Use count and power handling
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
@@ -198,14 +198,14 @@ Links setup
 ^^^^^^^^^^^
 
 Link properties can be modified at runtime by calling
-:cpp:func:`media_entity_setup_link()`.
+:c:func:`media_entity_setup_link()`.
 
 Pipelines and media streams
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 When starting streaming, drivers must notify all entities in the pipeline to
 prevent link states from being modified during streaming by calling
-:cpp:func:`media_entity_pipeline_start()`.
+:c:func:`media_entity_pipeline_start()`.
 
 The function will mark all entities connected to the given entity through
 enabled links, either directly or indirectly, as streaming.
@@ -217,17 +217,17 @@ in higher-level pipeline structures and can then access the
 pipeline through the :c:type:`struct media_entity <media_entity>`
 pipe field.
 
-Calls to :cpp:func:`media_entity_pipeline_start()` can be nested.
+Calls to :c:func:`media_entity_pipeline_start()` can be nested.
 The pipeline pointer must be identical for all nested calls to the function.
 
-:cpp:func:`media_entity_pipeline_start()` may return an error. In that case,
+:c:func:`media_entity_pipeline_start()` may return an error. In that case,
 it will clean up any of the changes it did by itself.
 
 When stopping the stream, drivers must notify the entities with
-:cpp:func:`media_entity_pipeline_stop()`.
+:c:func:`media_entity_pipeline_stop()`.
 
-If multiple calls to :cpp:func:`media_entity_pipeline_start()` have been
-made the same number of :cpp:func:`media_entity_pipeline_stop()` calls
+If multiple calls to :c:func:`media_entity_pipeline_start()` have been
+made the same number of :c:func:`media_entity_pipeline_stop()` calls
 are required to stop streaming.
 The :c:type:`media_entity`.\ ``pipe`` field is reset to ``NULL`` on the last
 nested stop call.
@@ -244,7 +244,7 @@ operation must be done with the media_device graph_mutex held.
 Link validation
 ^^^^^^^^^^^^^^^
 
-Link validation is performed by :cpp:func:`media_entity_pipeline_start()`
+Link validation is performed by :c:func:`media_entity_pipeline_start()`
 for any entity which has sink pads in the pipeline. The
 :c:type:`media_entity`.\ ``link_validate()`` callback is used for that
 purpose. In ``link_validate()`` callback, entity driver should check
diff --git a/Documentation/media/kapi/v4l2-dev.rst b/Documentation/media/kapi/v4l2-dev.rst
index b03f9b33ad93..cdfcf0bc78be 100644
--- a/Documentation/media/kapi/v4l2-dev.rst
+++ b/Documentation/media/kapi/v4l2-dev.rst
@@ -5,7 +5,7 @@ The actual device nodes in the ``/dev`` directory are created using the
 :c:type:`video_device` struct (``v4l2-dev.h``). This struct can either be
 allocated dynamically or embedded in a larger struct.
 
-To allocate it dynamically use :cpp:func:`video_device_alloc`:
+To allocate it dynamically use :c:func:`video_device_alloc`:
 
 .. code-block:: c
 
@@ -28,10 +28,10 @@ callback to your own function:
 The ``release()`` callback must be set and it is called when the last user
 of the video device exits.
 
-The default :cpp:func:`video_device_release` callback currently
+The default :c:func:`video_device_release` callback currently
 just calls ``kfree`` to free the allocated memory.
 
-There is also a ::cpp:func:`video_device_release_empty` function that does
+There is also a ::c:func:`video_device_release_empty` function that does
 nothing (is empty) and should be used if the struct is embedded and there
 is nothing to do when it is released.
 
@@ -97,14 +97,14 @@ You should also set these fields of :c:type:`video_device`:
   PCI device to use and so you set ``dev_device`` to the correct PCI device.
 
 If you use :c:type:`v4l2_ioctl_ops`, then you should set
-:c:type:`video_device`->unlocked_ioctl to :cpp:func:`video_ioctl2` in your
+:c:type:`video_device`->unlocked_ioctl to :c:func:`video_ioctl2` in your
 :c:type:`v4l2_file_operations` struct.
 
 In some cases you want to tell the core that a function you had specified in
 your :c:type:`v4l2_ioctl_ops` should be ignored. You can mark such ioctls by
-calling this function before :cpp:func:`video_register_device` is called:
+calling this function before :c:func:`video_register_device` is called:
 
-	:cpp:func:`v4l2_disable_ioctl <v4l2_disable_ioctl>`
+	:c:func:`v4l2_disable_ioctl <v4l2_disable_ioctl>`
 	(:c:type:`vdev <video_device>`, cmd).
 
 This tends to be needed if based on external factors (e.g. which card is
@@ -117,7 +117,7 @@ used.
 
 If integration with the media framework is needed, you must initialize the
 :c:type:`media_entity` struct embedded in the :c:type:`video_device` struct
-(entity field) by calling :cpp:func:`media_entity_pads_init`:
+(entity field) by calling :c:func:`media_entity_pads_init`:
 
 .. code-block:: c
 
@@ -166,7 +166,7 @@ something.
 In the case of :ref:`videobuf2 <vb2_framework>` you will need to implement the
 ``wait_prepare()`` and ``wait_finish()`` callbacks to unlock/lock if applicable.
 If you use the ``queue->lock`` pointer, then you can use the helper functions
-:cpp:func:`vb2_ops_wait_prepare` and :cpp:func:`vb2_ops_wait_finish`.
+:c:func:`vb2_ops_wait_prepare` and :cpp:func:`vb2_ops_wait_finish`.
 
 The implementation of a hotplug disconnect should also take the lock from
 :c:type:`video_device` before calling v4l2_device_disconnect. If you are also
@@ -178,7 +178,7 @@ That way you can be sure no ioctl is running when you call
 Video device registration
 -------------------------
 
-Next you register the video device with :cpp:func:`video_register_device`.
+Next you register the video device with :c:func:`video_register_device`.
 This will create the character device for you.
 
 .. code-block:: c
@@ -221,7 +221,7 @@ first free number.
 
 Since in this case you do not care about a warning about not being able
 to select the specified device node number, you can call the function
-:cpp:func:`video_register_device_no_warn` instead.
+:c:func:`video_register_device_no_warn` instead.
 
 Whenever a device node is created some attributes are also created for you.
 If you look in ``/sys/class/video4linux`` you see the devices. Go into e.g.
@@ -231,7 +231,7 @@ If you look in ``/sys/class/video4linux`` you see the devices. Go into e.g.
 section for more detailed information on this.
 
 The 'index' attribute is the index of the device node: for each call to
-:cpp:func:`video_register_device()` the index is just increased by 1. The
+:c:func:`video_register_device()` the index is just increased by 1. The
 first video device node you register always starts with index 0.
 
 Users can setup udev rules that utilize the index attribute to make fancy
@@ -240,14 +240,14 @@ device names (e.g. '``mpegX``' for MPEG video capture device nodes).
 After the device was successfully registered, then you can use these fields:
 
 - :c:type:`video_device`->vfl_type: the device type passed to
-  :cpp:func:`video_register_device`.
+  :c:func:`video_register_device`.
 - :c:type:`video_device`->minor: the assigned device minor number.
 - :c:type:`video_device`->num: the device node number (i.e. the X in
   ``videoX``).
 - :c:type:`video_device`->index: the device index number.
 
 If the registration failed, then you need to call
-:cpp:func:`video_device_release` to free the allocated :c:type:`video_device`
+:c:func:`video_device_release` to free the allocated :c:type:`video_device`
 struct, or free your own struct if the :c:type:`video_device` was embedded in
 it. The ``vdev->release()`` callback will never be called if the registration
 failed, nor should you ever attempt to unregister the device if the
@@ -286,13 +286,13 @@ When the video device nodes have to be removed, either during the unload
 of the driver or because the USB device was disconnected, then you should
 unregister them with:
 
-	:cpp:func:`video_unregister_device`
+	:c:func:`video_unregister_device`
 	(:c:type:`vdev <video_device>`);
 
 This will remove the device nodes from sysfs (causing udev to remove them
 from ``/dev``).
 
-After :cpp:func:`video_unregister_device` returns no new opens can be done.
+After :c:func:`video_unregister_device` returns no new opens can be done.
 However, in the case of USB devices some application might still have one of
 these device nodes open. So after the unregister all file operations (except
 release, of course) will return an error as well.
@@ -303,7 +303,7 @@ callback is called and you can do the final cleanup there.
 Don't forget to cleanup the media entity associated with the video device if
 it has been initialized:
 
-	:cpp:func:`media_entity_cleanup <media_entity_cleanup>`
+	:c:func:`media_entity_cleanup <media_entity_cleanup>`
 	(&vdev->entity);
 
 This can be done from the release callback.
@@ -318,26 +318,26 @@ There are a few useful helper functions:
 
 You can set/get driver private data in the video_device struct using:
 
-	:cpp:func:`video_get_drvdata <video_get_drvdata>`
+	:c:func:`video_get_drvdata <video_get_drvdata>`
 	(:c:type:`vdev <video_device>`);
 
-	:cpp:func:`video_set_drvdata <video_set_drvdata>`
+	:c:func:`video_set_drvdata <video_set_drvdata>`
 	(:c:type:`vdev <video_device>`);
 
-Note that you can safely call :cpp:func:`video_set_drvdata` before calling
-:cpp:func:`video_register_device`.
+Note that you can safely call :c:func:`video_set_drvdata` before calling
+:c:func:`video_register_device`.
 
 And this function:
 
-	:cpp:func:`video_devdata <video_devdata>`
+	:c:func:`video_devdata <video_devdata>`
 	(struct file \*file);
 
 returns the video_device belonging to the file struct.
 
-The :cpp:func:`video_devdata` function combines :cpp:func:`video_get_drvdata`
-with :cpp:func:`video_devdata`:
+The :c:func:`video_devdata` function combines :cpp:func:`video_get_drvdata`
+with :c:func:`video_devdata`:
 
-	:cpp:func:`video_drvdata <video_drvdata>`
+	:c:func:`video_drvdata <video_drvdata>`
 	(struct file \*file);
 
 You can go from a :c:type:`video_device` struct to the v4l2_device struct using:
@@ -350,7 +350,7 @@ You can go from a :c:type:`video_device` struct to the v4l2_device struct using:
 
 The :c:type:`video_device` node kernel name can be retrieved using:
 
-	:cpp:func:`video_device_node_name <video_device_node_name>`
+	:c:func:`video_device_node_name <video_device_node_name>`
 	(:c:type:`vdev <video_device>`);
 
 The name is used as a hint by userspace tools such as udev. The function
diff --git a/Documentation/media/kapi/v4l2-device.rst b/Documentation/media/kapi/v4l2-device.rst
index c9115bcd8a9d..6c58bbbaa66f 100644
--- a/Documentation/media/kapi/v4l2-device.rst
+++ b/Documentation/media/kapi/v4l2-device.rst
@@ -7,7 +7,7 @@ would embed this struct inside a larger struct.
 
 You must register the device instance by calling:
 
-	:cpp:func:`v4l2_device_register <v4l2_device_register>`
+	:c:func:`v4l2_device_register <v4l2_device_register>`
 	(dev, :c:type:`v4l2_dev <v4l2_device>`).
 
 Registration will initialize the :c:type:`v4l2_device` struct. If the
@@ -23,12 +23,12 @@ properly initialized and registered :c:type:`media_device` instance.
 
 If :c:type:`v4l2_dev <v4l2_device>`\ ->name is empty then it will be set to a
 value derived from dev (driver name followed by the bus_id, to be precise).
-If you set it up before  calling :cpp:func:`v4l2_device_register` then it will
+If you set it up before  calling :c:func:`v4l2_device_register` then it will
 be untouched. If dev is ``NULL``, then you **must** setup
 :c:type:`v4l2_dev <v4l2_device>`\ ->name before calling
-:cpp:func:`v4l2_device_register`.
+:c:func:`v4l2_device_register`.
 
-You can use :cpp:func:`v4l2_device_set_name` to set the name based on a driver
+You can use :c:func:`v4l2_device_set_name` to set the name based on a driver
 name and a driver-global atomic_t instance. This will generate names like
 ``ivtv0``, ``ivtv1``, etc. If the name ends with a digit, then it will insert
 a dash: ``cx18-0``, ``cx18-1``, etc. This function returns the instance number.
@@ -46,7 +46,7 @@ in ``include/media/subdevice.h``.
 
 V4L2 devices are unregistered by calling:
 
-	:cpp:func:`v4l2_device_unregister`
+	:c:func:`v4l2_device_unregister`
 	(:c:type:`v4l2_dev <v4l2_device>`).
 
 If the dev->driver_data field points to :c:type:`v4l2_dev <v4l2_device>`,
@@ -58,12 +58,12 @@ happens the parent device becomes invalid. Since :c:type:`v4l2_device` has a
 pointer to that parent device it has to be cleared as well to mark that the
 parent is gone. To do this call:
 
-	:cpp:func:`v4l2_device_disconnect`
+	:c:func:`v4l2_device_disconnect`
 	(:c:type:`v4l2_dev <v4l2_device>`).
 
 This does *not* unregister the subdevs, so you still need to call the
-:cpp:func:`v4l2_device_unregister` function for that. If your driver is not
-hotpluggable, then there is no need to call :cpp:func:`v4l2_device_disconnect`.
+:c:func:`v4l2_device_unregister` function for that. If your driver is not
+hotpluggable, then there is no need to call :c:func:`v4l2_device_disconnect`.
 
 Sometimes you need to iterate over all devices registered by a specific
 driver. This is usually the case if multiple device drivers use the same
@@ -117,7 +117,7 @@ The recommended approach is as follows:
 If you have multiple device nodes then it can be difficult to know when it is
 safe to unregister :c:type:`v4l2_device` for hotpluggable devices. For this
 purpose :c:type:`v4l2_device` has refcounting support. The refcount is
-increased whenever :cpp:func:`video_register_device` is called and it is
+increased whenever :c:func:`video_register_device` is called and it is
 decreased whenever that device node is released. When the refcount reaches
 zero, then the :c:type:`v4l2_device` release() callback is called. You can
 do your final cleanup there.
@@ -125,16 +125,16 @@ do your final cleanup there.
 If other device nodes (e.g. ALSA) are created, then you can increase and
 decrease the refcount manually as well by calling:
 
-	:cpp:func:`v4l2_device_get`
+	:c:func:`v4l2_device_get`
 	(:c:type:`v4l2_dev <v4l2_device>`).
 
 or:
 
-	:cpp:func:`v4l2_device_put`
+	:c:func:`v4l2_device_put`
 	(:c:type:`v4l2_dev <v4l2_device>`).
 
 Since the initial refcount is 1 you also need to call
-:cpp:func:`v4l2_device_put` in the ``disconnect()`` callback (for USB devices)
+:c:func:`v4l2_device_put` in the ``disconnect()`` callback (for USB devices)
 or in the ``remove()`` callback (for e.g. PCI devices), otherwise the refcount
 will never reach 0.
 
diff --git a/Documentation/media/kapi/v4l2-event.rst b/Documentation/media/kapi/v4l2-event.rst
index d81bbf23b6b1..f962686a7b63 100644
--- a/Documentation/media/kapi/v4l2-event.rst
+++ b/Documentation/media/kapi/v4l2-event.rst
@@ -39,7 +39,7 @@ A good example of these ``replace``/``merge`` callbacks is in v4l2-event.c:
 
 In order to queue events to video device, drivers should call:
 
-	:cpp:func:`v4l2_event_queue <v4l2_event_queue>`
+	:c:func:`v4l2_event_queue <v4l2_event_queue>`
 	(:c:type:`vdev <video_device>`, :ref:`ev <v4l2-event>`)
 
 The driver's only responsibility is to fill in the type and the data fields.
@@ -50,7 +50,7 @@ Event subscription
 
 Subscribing to an event is via:
 
-	:cpp:func:`v4l2_event_subscribe <v4l2_event_subscribe>`
+	:c:func:`v4l2_event_subscribe <v4l2_event_subscribe>`
 	(:c:type:`fh <v4l2_fh>`, :ref:`sub <v4l2-event-subscription>` ,
 	elems, :c:type:`ops <v4l2_subscribed_event_ops>`)
 
@@ -59,7 +59,7 @@ This function is used to implement :c:type:`video_device`->
 :c:type:`ioctl_ops <v4l2_ioctl_ops>`-> ``vidioc_subscribe_event``,
 but the driver must check first if the driver is able to produce events
 with specified event id, and then should call
-:cpp:func:`v4l2_event_subscribe` to subscribe the event.
+:c:func:`v4l2_event_subscribe` to subscribe the event.
 
 The elems argument is the size of the event queue for this event. If it is 0,
 then the framework will fill in a default value (this depends on the event
@@ -85,12 +85,12 @@ Unsubscribing an event
 
 Unsubscribing to an event is via:
 
-	:cpp:func:`v4l2_event_unsubscribe <v4l2_event_unsubscribe>`
+	:c:func:`v4l2_event_unsubscribe <v4l2_event_unsubscribe>`
 	(:c:type:`fh <v4l2_fh>`, :ref:`sub <v4l2-event-subscription>`)
 
 This function is used to implement :c:type:`video_device`->
 :c:type:`ioctl_ops <v4l2_ioctl_ops>`-> ``vidioc_unsubscribe_event``.
-A driver may call :cpp:func:`v4l2_event_unsubscribe` directly unless it
+A driver may call :c:func:`v4l2_event_unsubscribe` directly unless it
 wants to be involved in unsubscription process.
 
 The special type ``V4L2_EVENT_ALL`` may be used to unsubscribe all events. The
@@ -101,7 +101,7 @@ Check if there's a pending event
 
 Checking if there's a pending event is via:
 
-	:cpp:func:`v4l2_event_pending <v4l2_event_pending>`
+	:c:func:`v4l2_event_pending <v4l2_event_pending>`
 	(:c:type:`fh <v4l2_fh>`)
 
 
diff --git a/Documentation/media/kapi/v4l2-fh.rst b/Documentation/media/kapi/v4l2-fh.rst
index ef4ae046c0c5..9e87d5ca3e4a 100644
--- a/Documentation/media/kapi/v4l2-fh.rst
+++ b/Documentation/media/kapi/v4l2-fh.rst
@@ -12,7 +12,7 @@ data that is used by the V4L2 framework.
 The users of :c:type:`v4l2_fh` (in the V4L2 framework, not the driver) know
 whether a driver uses :c:type:`v4l2_fh` as its ``file->private_data`` pointer
 by testing the ``V4L2_FL_USES_V4L2_FH`` bit in :c:type:`video_device`->flags.
-This bit is set whenever :cpp:func:`v4l2_fh_init` is called.
+This bit is set whenever :c:func:`v4l2_fh_init` is called.
 
 struct :c:type:`v4l2_fh` is allocated as a part of the driver's own file handle
 structure and ``file->private_data`` is set to it in the driver's ``open()``
@@ -21,8 +21,8 @@ function by the driver.
 In many cases the struct :c:type:`v4l2_fh` will be embedded in a larger
 structure. In that case you should call:
 
-#) :cpp:func:`v4l2_fh_init` and :cpp:func:`v4l2_fh_add` in ``open()``
-#) :cpp:func:`v4l2_fh_del` and :cpp:func:`v4l2_fh_exit` in ``release()``
+#) :c:func:`v4l2_fh_init` and :cpp:func:`v4l2_fh_add` in ``open()``
+#) :c:func:`v4l2_fh_del` and :cpp:func:`v4l2_fh_exit` in ``release()``
 
 Drivers can extract their own file handle structure by using the container_of
 macro.
@@ -73,7 +73,7 @@ Example:
 
 Below is a short description of the :c:type:`v4l2_fh` functions used:
 
-:cpp:func:`v4l2_fh_init <v4l2_fh_init>`
+:c:func:`v4l2_fh_init <v4l2_fh_init>`
 (:c:type:`fh <v4l2_fh>`, :c:type:`vdev <video_device>`)
 
 
@@ -81,19 +81,19 @@ Below is a short description of the :c:type:`v4l2_fh` functions used:
   :c:type:`v4l2_file_operations`->open() handler.
 
 
-:cpp:func:`v4l2_fh_add <v4l2_fh_add>`
+:c:func:`v4l2_fh_add <v4l2_fh_add>`
 (:c:type:`fh <v4l2_fh>`)
 
 - Add a :c:type:`v4l2_fh` to :c:type:`video_device` file handle list.
   Must be called once the file handle is completely initialized.
 
-:cpp:func:`v4l2_fh_del <v4l2_fh_del>`
+:c:func:`v4l2_fh_del <v4l2_fh_del>`
 (:c:type:`fh <v4l2_fh>`)
 
 - Unassociate the file handle from :c:type:`video_device`. The file handle
   exit function may now be called.
 
-:cpp:func:`v4l2_fh_exit <v4l2_fh_exit>`
+:c:func:`v4l2_fh_exit <v4l2_fh_exit>`
 (:c:type:`fh <v4l2_fh>`)
 
 - Uninitialise the file handle. After uninitialisation the :c:type:`v4l2_fh`
@@ -102,13 +102,13 @@ Below is a short description of the :c:type:`v4l2_fh` functions used:
 
 If struct :c:type:`v4l2_fh` is not embedded, then you can use these helper functions:
 
-:cpp:func:`v4l2_fh_open <v4l2_fh_open>`
+:c:func:`v4l2_fh_open <v4l2_fh_open>`
 (struct file \*filp)
 
 - This allocates a struct :c:type:`v4l2_fh`, initializes it and adds it to
   the struct :c:type:`video_device` associated with the file struct.
 
-:cpp:func:`v4l2_fh_release <v4l2_fh_release>`
+:c:func:`v4l2_fh_release <v4l2_fh_release>`
 (struct file \*filp)
 
 - This deletes it from the struct :c:type:`video_device` associated with the
@@ -122,12 +122,12 @@ when the last file handle closes. Two helper functions were added to check
 whether the :c:type:`v4l2_fh` struct is the only open filehandle of the
 associated device node:
 
-:cpp:func:`v4l2_fh_is_singular <v4l2_fh_is_singular>`
+:c:func:`v4l2_fh_is_singular <v4l2_fh_is_singular>`
 (:c:type:`fh <v4l2_fh>`)
 
 -  Returns 1 if the file handle is the only open file handle, else 0.
 
-:cpp:func:`v4l2_fh_is_singular_file <v4l2_fh_is_singular_file>`
+:c:func:`v4l2_fh_is_singular_file <v4l2_fh_is_singular_file>`
 (struct file \*filp)
 
 - Same, but it calls v4l2_fh_is_singular with filp->private_data.
diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index 7e45b23ad3bd..d767b61e9842 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -15,7 +15,7 @@ can be stand-alone for simple sub-devices or it might be embedded in a larger
 struct if more state information needs to be stored. Usually there is a
 low-level device struct (e.g. ``i2c_client``) that contains the device data as
 setup by the kernel. It is recommended to store that pointer in the private
-data of :c:type:`v4l2_subdev` using :cpp:func:`v4l2_set_subdevdata`. That makes
+data of :c:type:`v4l2_subdev` using :c:func:`v4l2_set_subdevdata`. That makes
 it easy to go from a :c:type:`v4l2_subdev` to the actual low-level bus-specific
 device data.
 
@@ -27,7 +27,7 @@ methods.
 Bridges might also need to store per-subdev private data, such as a pointer to
 bridge-specific per-subdev private data. The :c:type:`v4l2_subdev` structure
 provides host private data for that purpose that can be accessed with
-:cpp:func:`v4l2_get_subdev_hostdata` and :cpp:func:`v4l2_set_subdev_hostdata`.
+:c:func:`v4l2_get_subdev_hostdata` and :cpp:func:`v4l2_set_subdev_hostdata`.
 
 From the bridge driver perspective, you load the sub-device module and somehow
 obtain the :c:type:`v4l2_subdev` pointer. For i2c devices this is easy: you call
@@ -87,7 +87,7 @@ to add new ops and categories.
 
 A sub-device driver initializes the :c:type:`v4l2_subdev` struct using:
 
-	:cpp:func:`v4l2_subdev_init <v4l2_subdev_init>`
+	:c:func:`v4l2_subdev_init <v4l2_subdev_init>`
 	(:c:type:`sd <v4l2_subdev>`, &\ :c:type:`ops <v4l2_subdev_ops>`).
 
 
@@ -97,7 +97,7 @@ i2c helper functions.
 
 If integration with the media framework is needed, you must initialize the
 :c:type:`media_entity` struct embedded in the :c:type:`v4l2_subdev` struct
-(entity field) by calling :cpp:func:`media_entity_pads_init`, if the entity has
+(entity field) by calling :c:func:`media_entity_pads_init`, if the entity has
 pads:
 
 .. code-block:: c
@@ -131,7 +131,7 @@ sub-devices. The driver is still responsible for validating the correctness
 of the format configuration between sub-devices and video nodes.
 
 If link_validate op is not set, the default function
-:cpp:func:`v4l2_subdev_link_validate_default` is used instead. This function
+:c:func:`v4l2_subdev_link_validate_default` is used instead. This function
 ensures that width, height and the media bus pixel code are equal on both source
 and sink of the link. Subdev drivers are also free to use this function to
 perform the checks mentioned above in addition to their own checks.
@@ -158,7 +158,7 @@ run-time bridge-subdevice interaction is in both cases the same.
 In the synchronous case a device (bridge) driver needs to register the
 :c:type:`v4l2_subdev` with the v4l2_device:
 
-	:cpp:func:`v4l2_device_register_subdev <v4l2_device_register_subdev>`
+	:c:func:`v4l2_device_register_subdev <v4l2_device_register_subdev>`
 	(:c:type:`v4l2_dev <v4l2_device>`, :c:type:`sd <v4l2_subdev>`).
 
 This can fail if the subdev module disappeared before it could be registered.
@@ -170,7 +170,7 @@ entity will be automatically registered with the media device.
 
 You can unregister a sub-device using:
 
-	:cpp:func:`v4l2_device_unregister_subdev <v4l2_device_unregister_subdev>`
+	:c:func:`v4l2_device_unregister_subdev <v4l2_device_unregister_subdev>`
 	(:c:type:`sd <v4l2_subdev>`).
 
 
@@ -242,16 +242,16 @@ the requirements for a successful probing are satisfied. This can include a
 check for a master clock availability. If any of the conditions aren't satisfied
 the driver might decide to return ``-EPROBE_DEFER`` to request further reprobing
 attempts. Once all conditions are met the subdevice shall be registered using
-the :cpp:func:`v4l2_async_register_subdev` function. Unregistration is
-performed using the :cpp:func:`v4l2_async_unregister_subdev` call. Subdevices
+the :c:func:`v4l2_async_register_subdev` function. Unregistration is
+performed using the :c:func:`v4l2_async_unregister_subdev` call. Subdevices
 registered this way are stored in a global list of subdevices, ready to be
 picked up by bridge drivers.
 
 Bridge drivers in turn have to register a notifier object with an array of
 subdevice descriptors that the bridge device needs for its operation. This is
-performed using the :cpp:func:`v4l2_async_notifier_register` call. To
+performed using the :c:func:`v4l2_async_notifier_register` call. To
 unregister the notifier the driver has to call
-:cpp:func:`v4l2_async_notifier_unregister`. The former of the two functions
+:c:func:`v4l2_async_notifier_unregister`. The former of the two functions
 takes two arguments: a pointer to struct :c:type:`v4l2_device` and a pointer to
 struct :c:type:`v4l2_async_notifier`. The latter contains a pointer to an array
 of pointers to subdevice descriptors of type struct :c:type:`v4l2_async_subdev`
@@ -275,7 +275,7 @@ it must set the ``V4L2_SUBDEV_FL_HAS_DEVNODE`` flag before being registered.
 After registering sub-devices, the :c:type:`v4l2_device` driver can create
 device nodes for all registered sub-devices marked with
 ``V4L2_SUBDEV_FL_HAS_DEVNODE`` by calling
-:cpp:func:`v4l2_device_register_subdev_nodes`. Those device nodes will be
+:c:func:`v4l2_device_register_subdev_nodes`. Those device nodes will be
 automatically removed when sub-devices are unregistered.
 
 The device node handles a subset of the V4L2 API.
@@ -372,7 +372,7 @@ And this to go from an ``i2c_client`` to a :c:type:`v4l2_subdev` struct:
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 Make sure to call
-:cpp:func:`v4l2_device_unregister_subdev`\ (:c:type:`sd <v4l2_subdev>`)
+:c:func:`v4l2_device_unregister_subdev`\ (:c:type:`sd <v4l2_subdev>`)
 when the ``remove()`` callback is called. This will unregister the sub-device
 from the bridge driver. It is safe to call this even if the sub-device was
 never registered.
@@ -381,7 +381,7 @@ You need to do this because when the bridge driver destroys the i2c adapter
 the ``remove()`` callbacks are called of the i2c devices on that adapter.
 After that the corresponding v4l2_subdev structures are invalid, so they
 have to be unregistered first. Calling
-:cpp:func:`v4l2_device_unregister_subdev`\ (:c:type:`sd <v4l2_subdev>`)
+:c:func:`v4l2_device_unregister_subdev`\ (:c:type:`sd <v4l2_subdev>`)
 from the ``remove()`` callback ensures that this is always done correctly.
 
 
@@ -393,18 +393,18 @@ The bridge driver also has some helper functions it can use:
 					"module_foo", "chipid", 0x36, NULL);
 
 This loads the given module (can be ``NULL`` if no module needs to be loaded)
-and calls :cpp:func:`i2c_new_device` with the given ``i2c_adapter`` and
+and calls :c:func:`i2c_new_device` with the given ``i2c_adapter`` and
 chip/address arguments. If all goes well, then it registers the subdev with
 the v4l2_device.
 
-You can also use the last argument of :cpp:func:`v4l2_i2c_new_subdev` to pass
+You can also use the last argument of :c:func:`v4l2_i2c_new_subdev` to pass
 an array of possible I2C addresses that it should probe. These probe addresses
 are only used if the previous argument is 0. A non-zero argument means that you
 know the exact i2c address so in that case no probing will take place.
 
 Both functions return ``NULL`` if something went wrong.
 
-Note that the chipid you pass to :cpp:func:`v4l2_i2c_new_subdev` is usually
+Note that the chipid you pass to :c:func:`v4l2_i2c_new_subdev` is usually
 the same as the module name. It allows you to specify a chip variant, e.g.
 "saa7114" or "saa7115". In general though the i2c driver autodetects this.
 The use of chipid is something that needs to be looked at more closely at a
@@ -414,7 +414,7 @@ for the i2c_device_id table. This lists all the possibilities.
 
 There are two more helper functions:
 
-:cpp:func:`v4l2_i2c_new_subdev_cfg`: this function adds new irq and
+:c:func:`v4l2_i2c_new_subdev_cfg`: this function adds new irq and
 platform_data arguments and has both 'addr' and 'probed_addrs' arguments:
 if addr is not 0 then that will be used (non-probing variant), otherwise the
 probed_addrs are probed.
@@ -426,15 +426,15 @@ For example: this will probe for address 0x10:
 	struct v4l2_subdev *sd = v4l2_i2c_new_subdev_cfg(v4l2_dev, adapter,
 			  "module_foo", "chipid", 0, NULL, 0, I2C_ADDRS(0x10));
 
-:cpp:func:`v4l2_i2c_new_subdev_board` uses an :c:type:`i2c_board_info` struct
+:c:func:`v4l2_i2c_new_subdev_board` uses an :c:type:`i2c_board_info` struct
 which is passed to the i2c driver and replaces the irq, platform_data and addr
 arguments.
 
 If the subdev supports the s_config core ops, then that op is called with
 the irq and platform_data arguments after the subdev was setup.
 
-The older :cpp:func:`v4l2_i2c_new_subdev` and
-:cpp:func:`v4l2_i2c_new_probed_subdev` functions will call ``s_config`` as
+The older :c:func:`v4l2_i2c_new_subdev` and
+:c:func:`v4l2_i2c_new_probed_subdev` functions will call ``s_config`` as
 well, but with irq set to 0 and platform_data set to ``NULL``.
 
 V4L2 sub-device functions and data structures
-- 
2.7.4

