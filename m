Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48264 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbcGQOaL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 10:30:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 6/7] [media] doc-rst: Fix conversion for MC core functions
Date: Sun, 17 Jul 2016 11:30:03 -0300
Message-Id: <7fd756007be07e9157a3c3783995718bc258d4c5.1468765739.git.mchehab@s-opensource.com>
In-Reply-To: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
References: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
In-Reply-To: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
References: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There were lots of issues at the media controller side,
after the conversion:

- Some documentation at the header files weren't using the
  kernel-doc start block;

- Now, the C files with the exported symbols also need to be
  added. So, all headers need to be included twice: one to
  get the structs/enums/.. and another one for the functions;

- Notes should use the ReST tag, as kernel-doc doesn't
  recognizes it anymore;

- Identation needs to be fixed, as ReST uses it to identify
  when a format "tag" ends.

- Fix the cross-references at the media controller description.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/mc-core.rst | 186 ++++++++++++++++++++---------------
 include/media/media-device.h         |  24 ++---
 include/media/media-entity.h         |  83 +++++++++-------
 3 files changed, 163 insertions(+), 130 deletions(-)

diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
index 2ec242b6e4c3..2ab541ba6e88 100644
--- a/Documentation/media/kapi/mc-core.rst
+++ b/Documentation/media/kapi/mc-core.rst
@@ -4,9 +4,8 @@ Media Controller devices
 Media Controller
 ~~~~~~~~~~~~~~~~
 
-
-The media controller userspace API is documented in DocBook format in
-Documentation/DocBook/media/v4l/media-controller.xml. This document focus
+The media controller userspace API is documented in
+:ref:`the Media Controller uAPI book <media_common>`. This document focus
 on the kernel-side implementation of the media framework.
 
 Abstract media device model
@@ -35,72 +34,77 @@ pad to a sink pad.
 Media device
 ^^^^^^^^^^^^
 
-A media device is represented by a struct &media_device instance, defined in
-include/media/media-device.h. Allocation of the structure is handled by the
-media device driver, usually by embedding the &media_device instance in a
-larger driver-specific structure.
+A media device is represented by a :c:type:`struct media_device <media_device>`
+instance, defined in ``include/media/media-device.h``.
+Allocation of the structure is handled by the media device driver, usually by
+embedding the :c:type:`media_device` instance in a larger driver-specific
+structure.
 
 Drivers register media device instances by calling
-__media_device_register() via the macro media_device_register()
-and unregistered by calling
-media_device_unregister().
+:cpp:func:`__media_device_register()` via the macro ``media_device_register()``
+and unregistered by calling :cpp:func:`media_device_unregister()`.
 
 Entities
 ^^^^^^^^
 
-Entities are represented by a struct &media_entity instance, defined in
-include/media/media-entity.h. The structure is usually embedded into a
-higher-level structure, such as a v4l2_subdev or video_device instance,
-although drivers can allocate entities directly.
+Entities are represented by a :c:type:`struct media_entity <media_entity>`
+instance, defined in ``include/media/media-entity.h``. The structure is usually
+embedded into a higher-level structure, such as
+:ref:`v4l2_subdev` or :ref:`video_device`
+instances, although drivers can allocate entities directly.
 
 Drivers initialize entity pads by calling
-media_entity_pads_init().
+:cpp:func:`media_entity_pads_init()`.
 
 Drivers register entities with a media device by calling
-media_device_register_entity()
+:cpp:func:`media_device_register_entity()`
 and unregistred by calling
-media_device_unregister_entity().
+:cpp:func:`media_device_unregister_entity()`.
 
 Interfaces
 ^^^^^^^^^^
 
-Interfaces are represented by a struct &media_interface instance, defined in
-include/media/media-entity.h. Currently, only one type of interface is
-defined: a device node. Such interfaces are represented by a struct
-&media_intf_devnode.
+Interfaces are represented by a
+:c:type:`struct media_interface <media_interface>` instance, defined in
+``include/media/media-entity.h``. Currently, only one type of interface is
+defined: a device node. Such interfaces are represented by a
+:c:type:`struct media_intf_devnode <media_intf_devnode>`.
 
 Drivers initialize and create device node interfaces by calling
-media_devnode_create()
+:cpp:func:`media_devnode_create()`
 and remove them by calling:
-media_devnode_remove().
+:cpp:func:`media_devnode_remove()`.
 
 Pads
 ^^^^
-Pads are represented by a struct &media_pad instance, defined in
-include/media/media-entity.h. Each entity stores its pads in a pads array
-managed by the entity driver. Drivers usually embed the array in a
-driver-specific structure.
+Pads are represented by a :c:type:`struct media_pad <media_pad>` instance,
+defined in ``include/media/media-entity.h``. Each entity stores its pads in
+a pads array managed by the entity driver. Drivers usually embed the array in
+a driver-specific structure.
 
 Pads are identified by their entity and their 0-based index in the pads
 array.
-Both information are stored in the &media_pad structure, making the
-&media_pad pointer the canonical way to store and pass link references.
+
+Both information are stored in the :c:type:`struct media_pad`, making the
+:c:type:`media_pad` pointer the canonical way to store and pass link references.
 
 Pads have flags that describe the pad capabilities and state.
 
-%MEDIA_PAD_FL_SINK indicates that the pad supports sinking data.
-%MEDIA_PAD_FL_SOURCE indicates that the pad supports sourcing data.
+``MEDIA_PAD_FL_SINK`` indicates that the pad supports sinking data.
+``MEDIA_PAD_FL_SOURCE`` indicates that the pad supports sourcing data.
 
-NOTE: One and only one of %MEDIA_PAD_FL_SINK and %MEDIA_PAD_FL_SOURCE must
-be set for each pad.
+.. note::
+
+  One and only one of ``MEDIA_PAD_FL_SINK`` or ``MEDIA_PAD_FL_SOURCE`` must
+  be set for each pad.
 
 Links
 ^^^^^
 
-Links are represented by a struct &media_link instance, defined in
-include/media/media-entity.h. There are two types of links:
+Links are represented by a :c:type:`struct media_link <media_link>` instance,
+defined in ``include/media/media-entity.h``. There are two types of links:
 
-1. pad to pad links:
+**1. pad to pad links**:
 
 Associate two entities via their PADs. Each entity has a list that points
 to all links originating at or targeting any of its pads.
@@ -108,22 +112,24 @@ A given link is thus stored twice, once in the source entity and once in
 the target entity.
 
 Drivers create pad to pad links by calling:
-media_create_pad_link() and remove with media_entity_remove_links().
+:cpp:func:`media_create_pad_link()` and remove with
+:cpp:func:`media_entity_remove_links()`.
 
-2. interface to entity links:
+**2. interface to entity links**:
 
 Associate one interface to a Link.
 
 Drivers create interface to entity links by calling:
-media_create_intf_link() and remove with media_remove_intf_links().
+:cpp:func:`media_create_intf_link()` and remove with
+:cpp:func:`media_remove_intf_links()`.
 
 .. note::
 
    Links can only be created after having both ends already created.
 
 Links have flags that describe the link capabilities and state. The
-valid values are described at media_create_pad_link() and
-media_create_intf_link().
+valid values are described at :cpp:func:`media_create_pad_link()` and
+:cpp:func:`media_create_intf_link()`.
 
 Graph traversal
 ^^^^^^^^^^^^^^^
@@ -132,92 +138,103 @@ The media framework provides APIs to iterate over entities in a graph.
 
 To iterate over all entities belonging to a media device, drivers can use
 the media_device_for_each_entity macro, defined in
-include/media/media-device.h.
+``include/media/media-device.h``.
 
-struct media_entity *entity;
+..  code-block:: c
 
-media_device_for_each_entity(entity, mdev) {
-// entity will point to each entity in turn
-...
-}
+    struct media_entity *entity;
+
+    media_device_for_each_entity(entity, mdev) {
+    // entity will point to each entity in turn
+    ...
+    }
 
 Drivers might also need to iterate over all entities in a graph that can be
 reached only through enabled links starting at a given entity. The media
 framework provides a depth-first graph traversal API for that purpose.
 
-Note that graphs with cycles (whether directed or undirected) are *NOT*
-supported by the graph traversal API. To prevent infinite loops, the graph
-traversal code limits the maximum depth to MEDIA_ENTITY_ENUM_MAX_DEPTH,
-currently defined as 16.
+.. note::
+
+   Graphs with cycles (whether directed or undirected) are **NOT**
+   supported by the graph traversal API. To prevent infinite loops, the graph
+   traversal code limits the maximum depth to ``MEDIA_ENTITY_ENUM_MAX_DEPTH``,
+   currently defined as 16.
 
 Drivers initiate a graph traversal by calling
-media_entity_graph_walk_start()
+:cpp:func:`media_entity_graph_walk_start()`
 
 The graph structure, provided by the caller, is initialized to start graph
 traversal at the given entity.
 
 Drivers can then retrieve the next entity by calling
-media_entity_graph_walk_next()
+:cpp:func:`media_entity_graph_walk_next()`
 
-When the graph traversal is complete the function will return NULL.
+When the graph traversal is complete the function will return ``NULL``.
 
 Graph traversal can be interrupted at any moment. No cleanup function call
 is required and the graph structure can be freed normally.
 
 Helper functions can be used to find a link between two given pads, or a pad
 connected to another pad through an enabled link
-media_entity_find_link() and media_entity_remote_pad()
+:cpp:func:`media_entity_find_link()` and
+:cpp:func:`media_entity_remote_pad()`.
 
 Use count and power handling
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 Due to the wide differences between drivers regarding power management
 needs, the media controller does not implement power management. However,
-the &media_entity structure includes a use_count field that media drivers
+the :c:type:`struct media_entity <media_entity>` includes a ``use_count``
+field that media drivers
 can use to track the number of users of every entity for power management
 needs.
 
-The &media_entity.@use_count field is owned by media drivers and must not be
+The :c:type:`media_entity<media_entity>`.\ ``use_count`` field is owned by
+media drivers and must not be
 touched by entity drivers. Access to the field must be protected by the
-&media_device.@graph_mutex lock.
+:c:type:`media_device`.\ ``graph_mutex`` lock.
 
 Links setup
 ^^^^^^^^^^^
 
 Link properties can be modified at runtime by calling
-media_entity_setup_link()
+:cpp:func:`media_entity_setup_link()`.
 
 Pipelines and media streams
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 When starting streaming, drivers must notify all entities in the pipeline to
 prevent link states from being modified during streaming by calling
-media_entity_pipeline_start().
+:cpp:func:`media_entity_pipeline_start()`.
 
 The function will mark all entities connected to the given entity through
 enabled links, either directly or indirectly, as streaming.
 
-The &media_pipeline instance pointed to by the pipe argument will be stored
-in every entity in the pipeline. Drivers should embed the &media_pipeline
-structure in higher-level pipeline structures and can then access the
-pipeline through the &media_entity pipe field.
+The :c:type:`struct media_pipeline <media_pipeline>` instance pointed to by
+the pipe argument will be stored in every entity in the pipeline.
+Drivers should embed the :c:type:`struct media_pipeline <media_pipeline>`
+in higher-level pipeline structures and can then access the
+pipeline through the :c:type:`struct media_entity <media_entity>`
+pipe field.
 
-Calls to media_entity_pipeline_start() can be nested. The pipeline pointer
-must be identical for all nested calls to the function.
+Calls to :cpp:func:`media_entity_pipeline_start()` can be nested.
+The pipeline pointer must be identical for all nested calls to the function.
 
-media_entity_pipeline_start() may return an error. In that case, it will
-clean up any of the changes it did by itself.
+:cpp:func:`media_entity_pipeline_start()` may return an error. In that case,
+it will clean up any of the changes it did by itself.
 
 When stopping the stream, drivers must notify the entities with
-media_entity_pipeline_stop().
+:cpp:func:`media_entity_pipeline_stop()`.
 
-If multiple calls to media_entity_pipeline_start() have been made the same
-number of media_entity_pipeline_stop() calls are required to stop streaming.
-The &media_entity pipe field is reset to NULL on the last nested stop call.
+If multiple calls to :cpp:func:`media_entity_pipeline_start()` have been
+made the same number of :cpp:func:`media_entity_pipeline_stop()` calls
+are required to stop streaming.
+The :c:type:`media_entity`.\ ``pipe`` field is reset to ``NULL`` on the last
+nested stop call.
 
-Link configuration will fail with -%EBUSY by default if either end of the
+Link configuration will fail with ``-EBUSY`` by default if either end of the
 link is a streaming entity. Links that can be modified while streaming must
-be marked with the %MEDIA_LNK_FL_DYNAMIC flag.
+be marked with the ``MEDIA_LNK_FL_DYNAMIC`` flag.
 
 If other operations need to be disallowed on streaming entities (such as
 changing entities configuration parameters) drivers can explicitly check the
@@ -227,13 +244,13 @@ operation must be done with the media_device graph_mutex held.
 Link validation
 ^^^^^^^^^^^^^^^
 
-Link validation is performed by media_entity_pipeline_start() for any
-entity which has sink pads in the pipeline. The
-&media_entity.@link_validate() callback is used for that purpose. In
-@link_validate() callback, entity driver should check that the properties of
-the source pad of the connected entity and its own sink pad match. It is up
-to the type of the entity (and in the end, the properties of the hardware)
-what matching actually means.
+Link validation is performed by :cpp:func:`media_entity_pipeline_start()`
+for any entity which has sink pads in the pipeline. The
+:c:type:`media_entity`.\ ``link_validate()`` callback is used for that
+purpose. In ``link_validate()`` callback, entity driver should check
+that the properties of the source pad of the connected entity and its own
+sink pad match. It is up to the type of the entity (and in the end, the
+properties of the hardware) what matching actually means.
 
 Subsystems should facilitate link validation by providing subsystem specific
 helper functions to provide easy access for commonly needed information, and
@@ -245,3 +262,10 @@ in the end provide a way to use driver-specific callbacks.
 
 .. kernel-doc:: include/media/media-entity.h
 
+
+
+.. kernel-doc:: include/media/media-device.h
+   :export: drivers/media/media-device.c
+
+.. kernel-doc:: include/media/media-entity.h
+   :export: drivers/media/media-entity.c
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 4605fee0c228..28195242386c 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -242,13 +242,11 @@ void media_device_cleanup(struct media_device *mdev);
  *    without breaking binary compatibility. The version major must be
  *    incremented when binary compatibility is broken.
  *
- * Notes:
+ * .. note::
  *
- * Upon successful registration a character device named media[0-9]+ is created.
- * The device major and minor numbers are dynamic. The model name is exported as
- * a sysfs attribute.
+ *    #) Upon successful registration a character device named media[0-9]+ is created. The device major and minor numbers are dynamic. The model name is exported as a sysfs attribute.
  *
- * Unregistering a media device that hasn't been registered is *NOT* safe.
+ *    #) Unregistering a media device that hasn't been registered is **NOT** safe.
  *
  * Return: returns zero on success or a negative error code.
  */
@@ -296,14 +294,16 @@ void media_device_unregister(struct media_device *mdev);
  *	This can be used to report the default audio and video devices or the
  *	default camera sensor.
  *
- * NOTE: Drivers should set the entity function before calling this function.
- * Please notice that the values %MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN and
- * %MEDIA_ENT_F_UNKNOWN should not be used by the drivers.
+ * .. note::
+ *
+ *    Drivers should set the entity function before calling this function.
+ *    Please notice that the values %MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN and
+ *    %MEDIA_ENT_F_UNKNOWN should not be used by the drivers.
  */
 int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity);
 
-/*
+/**
  * media_device_unregister_entity() - unregisters a media entity.
  *
  * @entity:	pointer to struct &media_entity to be unregistered
@@ -317,8 +317,10 @@ int __must_check media_device_register_entity(struct media_device *mdev,
  * When a media device is unregistered, all its entities are unregistered
  * automatically. No manual entities unregistration is then required.
  *
- * Note: the media_entity instance itself must be freed explicitly by
- * the driver if required.
+ * .. note::
+ *
+ *    The media_entity instance itself must be freed explicitly by
+ *    the driver if required.
  */
 void media_device_unregister_entity(struct media_entity *entity);
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index cbb266f7f2b5..83877719bef4 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -104,7 +104,7 @@ struct media_entity_graph {
 	int top;
 };
 
-/*
+/**
  * struct media_pipeline - Media pipeline related information
  *
  * @streaming_count:	Streaming start count - streaming stop count
@@ -180,7 +180,7 @@ struct media_pad {
  *			view. The media_entity_pipeline_start() function
  *			validates all links by calling this operation. Optional.
  *
- * Note: Those these callbacks are called with struct media_device.@graph_mutex
+ * .. note:: Those these callbacks are called with struct media_device.@graph_mutex
  * mutex held.
  */
 struct media_entity_operations {
@@ -602,19 +602,20 @@ static inline void media_entity_cleanup(struct media_entity *entity) {};
  * @flags:	Link flags, as defined in include/uapi/linux/media.h.
  *
  * Valid values for flags:
- * A %MEDIA_LNK_FL_ENABLED flag indicates that the link is enabled and can be
- *	used to transfer media data. When two or more links target a sink pad,
- *	only one of them can be enabled at a time.
  *
- * A %MEDIA_LNK_FL_IMMUTABLE flag indicates that the link enabled state can't
- *	be modified at runtime. If %MEDIA_LNK_FL_IMMUTABLE is set, then
- *	%MEDIA_LNK_FL_ENABLED must also be set since an immutable link is
- *	always enabled.
+ * - A %MEDIA_LNK_FL_ENABLED flag indicates that the link is enabled and can
+ *   be used to transfer media data. When two or more links target a sink pad,
+ *   only one of them can be enabled at a time.
  *
- * NOTE:
+ * - A %MEDIA_LNK_FL_IMMUTABLE flag indicates that the link enabled state can't
+ *   be modified at runtime. If %MEDIA_LNK_FL_IMMUTABLE is set, then
+ *   %MEDIA_LNK_FL_ENABLED must also be set since an immutable link is
+ *   always enabled.
  *
- * Before calling this function, media_entity_pads_init() and
- * media_device_register_entity() should be called previously for both ends.
+ * .. note::
+ *
+ *    Before calling this function, media_entity_pads_init() and
+ *    media_device_register_entity() should be called previously for both ends.
  */
 __must_check int media_create_pad_link(struct media_entity *source,
 			u16 source_pad, struct media_entity *sink,
@@ -641,6 +642,7 @@ __must_check int media_create_pad_link(struct media_entity *source,
  *	and @sink are NULL.
  *
  * Valid values for flags:
+ *
  * A %MEDIA_LNK_FL_ENABLED flag indicates that the link is enabled and can be
  *	used to transfer media data. If multiple links are created and this
  *	flag is passed as an argument, only the first created link will have
@@ -677,8 +679,10 @@ void __media_entity_remove_links(struct media_entity *entity);
  *
  * @entity:	pointer to &media_entity
  *
- * Note: this is called automatically when an entity is unregistered via
- * media_device_register_entity().
+ * .. note::
+ *
+ *    This is called automatically when an entity is unregistered via
+ *    media_device_register_entity().
  */
 void media_entity_remove_links(struct media_entity *entity);
 
@@ -728,9 +732,11 @@ int __media_entity_setup_link(struct media_link *link, u32 flags);
  * being enabled, the link_setup operation must return -EBUSY and can't
  * implicitly disable the first enabled link.
  *
- * NOTE: the valid values of the flags for the link is the same as described
- * on media_create_pad_link(), for pad to pad links or the same as described
- * on media_create_intf_link(), for interface to entity links.
+ * .. note::
+ *
+ *    The valid values of the flags for the link is the same as described
+ *    on media_create_pad_link(), for pad to pad links or the same as described
+ *    on media_create_intf_link(), for interface to entity links.
  */
 int media_entity_setup_link(struct media_link *link, u32 flags);
 
@@ -844,7 +850,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
  * @entity: Starting entity
  * @pipe: Media pipeline to be assigned to all entities in the pipeline.
  *
- * Note: This is the non-locking version of media_entity_pipeline_start()
+ * ..note:: This is the non-locking version of media_entity_pipeline_start()
  */
 __must_check int __media_entity_pipeline_start(struct media_entity *entity,
 					       struct media_pipeline *pipe);
@@ -868,7 +874,7 @@ void media_entity_pipeline_stop(struct media_entity *entity);
  *
  * @entity: Starting entity
  *
- * Note: This is the non-locking version of media_entity_pipeline_stop()
+ * .. note:: This is the non-locking version of media_entity_pipeline_stop()
  */
 void __media_entity_pipeline_stop(struct media_entity *entity);
 
@@ -909,20 +915,21 @@ struct media_link *
  *
  *
  * Valid values for flags:
- * The %MEDIA_LNK_FL_ENABLED flag indicates that the interface is connected to
- *	the entity hardware. That's the default value for interfaces. An
- *	interface may be disabled if the hardware is busy due to the usage
- *	of some other interface that it is currently controlling the hardware.
- *	A typical example is an hybrid TV device that handle only one type of
- *	stream on a given time. So, when the digital TV is streaming,
- *	the V4L2 interfaces won't be enabled, as such device is not able to
- *	also stream analog TV or radio.
  *
- * Note:
+ * - The %MEDIA_LNK_FL_ENABLED flag indicates that the interface is connected to
+ *   the entity hardware. That's the default value for interfaces. An
+ *   interface may be disabled if the hardware is busy due to the usage
+ *   of some other interface that it is currently controlling the hardware.
+ *   A typical example is an hybrid TV device that handle only one type of
+ *   stream on a given time. So, when the digital TV is streaming,
+ *   the V4L2 interfaces won't be enabled, as such device is not able to
+ *   also stream analog TV or radio.
  *
- * Before calling this function, media_devnode_create() should be called for
- * the interface and media_device_register_entity() should be called for the
- * interface that will be part of the link.
+ * .. note::
+ *
+ *    Before calling this function, media_devnode_create() should be called for
+ *    the interface and media_device_register_entity() should be called for the
+ *    interface that will be part of the link.
  */
 __must_check media_create_intf_link(struct media_entity *entity,
 				    struct media_interface *intf,
@@ -932,7 +939,7 @@ __must_check media_create_intf_link(struct media_entity *entity,
  *
  * @link:	pointer to &media_link.
  *
- * Note: this is an unlocked version of media_remove_intf_link()
+ * .. note:: This is an unlocked version of media_remove_intf_link()
  */
 void __media_remove_intf_link(struct media_link *link);
 
@@ -941,7 +948,7 @@ void __media_remove_intf_link(struct media_link *link);
  *
  * @link:	pointer to &media_link.
  *
- * Note: prefer to use this one, instead of __media_remove_intf_link()
+ * .. note:: Prefer to use this one, instead of __media_remove_intf_link()
  */
 void media_remove_intf_link(struct media_link *link);
 
@@ -950,7 +957,7 @@ void media_remove_intf_link(struct media_link *link);
  *
  * @intf:	pointer to &media_interface
  *
- * Note: this is an unlocked version of media_remove_intf_links().
+ * .. note:: This is an unlocked version of media_remove_intf_links().
  */
 void __media_remove_intf_links(struct media_interface *intf);
 
@@ -959,12 +966,12 @@ void __media_remove_intf_links(struct media_interface *intf);
  *
  * @intf:	pointer to &media_interface
  *
- * Notes:
+ * ..note::
  *
- * this is called automatically when an entity is unregistered via
- * media_device_register_entity() and by media_devnode_remove().
+ *   - This is called automatically when an entity is unregistered via
+ *     media_device_register_entity() and by media_devnode_remove().
  *
- * Prefer to use this one, instead of __media_remove_intf_links().
+ *   - Prefer to use this one, instead of __media_remove_intf_links().
  */
 void media_remove_intf_links(struct media_interface *intf);
 
-- 
2.7.4

