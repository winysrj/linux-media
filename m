Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44147 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941751AbcIHMEZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 11/47] [media] docs-rst: improve the kAPI documentation for the mediactl
Date: Thu,  8 Sep 2016 09:03:33 -0300
Message-Id: <eb36b039e1ddc20c6a83d40c7a478a33d1008d04.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several issues on the documentation:
  - the media.h header were not properly referenced;
  - verbatim expressions were not properly marked as such;
  - struct member references were wrong;
  - some notes were not using the right markup;
  - a comment that were moved to the kernel-doc markup were
    duplicated as a comment inside the struct media_entity;
  - some args were not pointing to the struct they're using;
  - macros weren't documented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/media-device.h  | 115 ++++++++++++--------
 include/media/media-devnode.h |   2 +-
 include/media/media-entity.h  | 237 ++++++++++++++++++++++++++++--------------
 3 files changed, 231 insertions(+), 123 deletions(-)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index 28195242386c..481dd6c672cb 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -53,7 +53,7 @@ struct media_entity_notify {
  * @dev:	Parent device
  * @devnode:	Media device node
  * @driver_name: Optional device driver name. If not set, calls to
- *		%MEDIA_IOC_DEVICE_INFO will return dev->driver->name.
+ *		%MEDIA_IOC_DEVICE_INFO will return ``dev->driver->name``.
  *		This is needed for USB drivers for example, as otherwise
  *		they'll all appear as if the driver name was "usb".
  * @model:	Device model name
@@ -102,16 +102,18 @@ struct media_entity_notify {
  * sink entity  and deactivate the link between them. Drivers
  * should call this handler to release the source.
  *
- * Note: Bridge driver is expected to implement and set the
- * handler when media_device is registered or when
- * bridge driver finds the media_device during probe.
- * Bridge driver sets source_priv with information
- * necessary to run enable/disable source handlers.
- *
  * Use-case: find tuner entity connected to the decoder
  * entity and check if it is available, and activate the
- * the link between them from enable_source and deactivate
- * from disable_source.
+ * the link between them from @enable_source and deactivate
+ * from @disable_source.
+ *
+ * .. note::
+ *
+ *    Bridge driver is expected to implement and set the
+ *    handler when &media_device is registered or when
+ *    bridge driver finds the media_device during probe.
+ *    Bridge driver sets source_priv with information
+ *    necessary to run @enable_source and @disable_source handlers.
  */
 struct media_device {
 	/* dev->driver_data points to this struct. */
@@ -168,7 +170,7 @@ struct usb_device;
  * @ent_enum: Entity enumeration to be initialised
  * @mdev: The related media device
  *
- * Returns zero on success or a negative error code.
+ * Return: zero on success or a negative error code.
  */
 static inline __must_check int media_entity_enum_init(
 	struct media_entity_enum *ent_enum, struct media_device *mdev)
@@ -211,36 +213,38 @@ void media_device_cleanup(struct media_device *mdev);
  *
  * Users, should, instead, call the media_device_register() macro.
  *
- * The caller is responsible for initializing the media_device structure before
- * registration. The following fields must be set:
+ * The caller is responsible for initializing the &media_device structure
+ * before registration. The following fields of &media_device must be set:
  *
- *  - dev must point to the parent device (usually a &pci_dev, &usb_interface or
- *    &platform_device instance).
+ *  - &media_entity.dev must point to the parent device (usually a &pci_dev,
+ *    &usb_interface or &platform_device instance).
  *
- *  - model must be filled with the device model name as a NUL-terminated UTF-8
- *    string. The device/model revision must not be stored in this field.
+ *  - &media_entity.model must be filled with the device model name as a
+ *    NUL-terminated UTF-8 string. The device/model revision must not be
+ *    stored in this field.
  *
  * The following fields are optional:
  *
- *  - serial is a unique serial number stored as a NUL-terminated ASCII string.
- *    The field is big enough to store a GUID in text form. If the hardware
- *    doesn't provide a unique serial number this field must be left empty.
+ *  - &media_entity.serial is a unique serial number stored as a
+ *    NUL-terminated ASCII string. The field is big enough to store a GUID
+ *    in text form. If the hardware doesn't provide a unique serial number
+ *    this field must be left empty.
  *
- *  - bus_info represents the location of the device in the system as a
- *    NUL-terminated ASCII string. For PCI/PCIe devices bus_info must be set to
- *    "PCI:" (or "PCIe:") followed by the value of pci_name(). For USB devices,
- *    the usb_make_path() function must be used. This field is used by
- *    applications to distinguish between otherwise identical devices that don't
- *    provide a serial number.
+ *  - &media_entity.bus_info represents the location of the device in the
+ *    system as a NUL-terminated ASCII string. For PCI/PCIe devices
+ *    &media_entity.bus_info must be set to "PCI:" (or "PCIe:") followed by
+ *    the value of pci_name(). For USB devices,the usb_make_path() function
+ *    must be used. This field is used by applications to distinguish between
+ *    otherwise identical devices that don't provide a serial number.
  *
- *  - hw_revision is the hardware device revision in a driver-specific format.
- *    When possible the revision should be formatted with the KERNEL_VERSION
- *    macro.
+ *  - &media_entity.hw_revision is the hardware device revision in a
+ *    driver-specific format. When possible the revision should be formatted
+ *    with the KERNEL_VERSION() macro.
  *
- *  - driver_version is formatted with the KERNEL_VERSION macro. The version
- *    minor must be incremented when new features are added to the userspace API
- *    without breaking binary compatibility. The version major must be
- *    incremented when binary compatibility is broken.
+ *  - &media_entity.driver_version is formatted with the KERNEL_VERSION()
+ *    macro. The version minor must be incremented when new features are added
+ *    to the userspace API without breaking binary compatibility. The version
+ *    major must be incremented when binary compatibility is broken.
  *
  * .. note::
  *
@@ -252,6 +256,16 @@ void media_device_cleanup(struct media_device *mdev);
  */
 int __must_check __media_device_register(struct media_device *mdev,
 					 struct module *owner);
+
+
+/**
+ * media_device_register() - Registers a media device element
+ *
+ * @mdev:	pointer to struct &media_device
+ *
+ * This macro calls __media_device_register() passing %THIS_MODULE as
+ * the __media_device_register() second argument (**owner**).
+ */
 #define media_device_register(mdev) __media_device_register(mdev, THIS_MODULE)
 
 /**
@@ -259,7 +273,6 @@ int __must_check __media_device_register(struct media_device *mdev,
  *
  * @mdev:	pointer to struct &media_device
  *
- *
  * It is safe to call this function on an unregistered (but initialised)
  * media device.
  */
@@ -285,14 +298,15 @@ void media_device_unregister(struct media_device *mdev);
  * framework.
  *
  * If the device has pads, media_entity_pads_init() should be called before
- * this function. Otherwise, the &media_entity.@pad and &media_entity.@num_pads
+ * this function. Otherwise, the &media_entity.pad and &media_entity.num_pads
  * should be zeroed before calling this function.
  *
  * Entities have flags that describe the entity capabilities and state:
  *
- * %MEDIA_ENT_FL_DEFAULT indicates the default entity for a given type.
- *	This can be used to report the default audio and video devices or the
- *	default camera sensor.
+ * %MEDIA_ENT_FL_DEFAULT
+ *    indicates the default entity for a given type.
+ *    This can be used to report the default audio and video devices or the
+ *    default camera sensor.
  *
  * .. note::
  *
@@ -331,8 +345,10 @@ void media_device_unregister_entity(struct media_entity *entity);
  * @mdev:      The media device
  * @nptr:      The media_entity_notify
  *
- * Note: When a new entity is registered, all the registered
- * media_entity_notify callbacks are invoked.
+ * .. note::
+ *
+ *    When a new entity is registered, all the registered
+ *    media_entity_notify callbacks are invoked.
  */
 
 int __must_check media_device_register_entity_notify(struct media_device *mdev,
@@ -410,11 +426,13 @@ void media_device_pci_init(struct media_device *mdev,
  * @board_name:	media device name. If %NULL, the routine will use the usb
  *		product name, if available.
  * @driver_name: name of the driver. if %NULL, the routine will use the name
- *		given by udev->dev->driver->name, with is usually the wrong
+ *		given by ``udev->dev->driver->name``, with is usually the wrong
  *		thing to do.
  *
- * NOTE: It is better to call media_device_usb_init() instead, as
- * such macro fills driver_name with %KBUILD_MODNAME.
+ * .. note::
+ *
+ *    It is better to call media_device_usb_init() instead, as
+ *    such macro fills driver_name with %KBUILD_MODNAME.
  */
 void __media_device_usb_init(struct media_device *mdev,
 			     struct usb_device *udev,
@@ -472,6 +490,19 @@ static inline void __media_device_usb_init(struct media_device *mdev,
 
 #endif /* CONFIG_MEDIA_CONTROLLER */
 
+/**
+ * media_device_usb_init() - create and initialize a
+ *	struct &media_device from a PCI device.
+ *
+ * @mdev:	pointer to struct &media_device
+ * @udev:	pointer to struct usb_device
+ * @name:	media device name. If %NULL, the routine will use the usb
+ *		product name, if available.
+ *
+ * This macro calls media_device_usb_init() passing the
+ * media_device_usb_init() **driver_name** parameter filled with
+ * %KBUILD_MODNAME.
+ */
 #define media_device_usb_init(mdev, udev, name) \
 	__media_device_usb_init(mdev, udev, name, KBUILD_MODNAME)
 
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index 37d494805944..972168e90413 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -75,7 +75,7 @@ struct media_file_operations {
  * @cdev:	struct cdev pointer character device
  * @parent:	parent device
  * @minor:	device node minor number
- * @flags:	flags, combination of the MEDIA_FLAG_* constants
+ * @flags:	flags, combination of the ``MEDIA_FLAG_*`` constants
  * @release:	release callback called at the end of media_devnode_release()
  *
  * This structure represents a media-related device node.
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 7bf6885dd37f..9d81666786a7 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -56,7 +56,7 @@ enum media_gobj_type {
 /**
  * struct media_gobj - Define a graph object.
  *
- * @mdev:	Pointer to the struct media_device that owns the object
+ * @mdev:	Pointer to the struct &media_device that owns the object
  * @id:		Non-zero object ID identifier. The ID should be unique
  *		inside a media_device, as it is composed by
  *		%MEDIA_BITS_PER_TYPE to store the type plus
@@ -162,7 +162,9 @@ struct media_link {
  * @graph_obj:	Embedded structure containing the media object common data
  * @entity:	Entity this pad belongs to
  * @index:	Pad index in the entity pads array, numbered from 0 to n
- * @flags:	Pad flags, as defined in uapi/media.h (MEDIA_PAD_FL_*)
+ * @flags:	Pad flags, as defined in
+ *		:ref:`include/uapi/linux/media.h <media_header>`
+ * 		(seek for ``MEDIA_PAD_FL_*``)
  */
 struct media_pad {
 	struct media_gobj graph_obj;	/* must be first field in struct */
@@ -182,7 +184,7 @@ struct media_pad {
  *
  * .. note::
  *
- *    Those these callbacks are called with struct media_device.@graph_mutex
+ *    Those these callbacks are called with struct &media_device.graph_mutex
  *    mutex held.
  */
 struct media_entity_operations {
@@ -210,7 +212,7 @@ struct media_entity_operations {
  * This allows runtime type identification of media entities and safe casting to
  * the correct object type. For instance, a media entity structure instance
  * embedded in a v4l2_subdev structure instance will have the type
- * MEDIA_ENTITY_TYPE_V4L2_SUBDEV and can safely be cast to a v4l2_subdev
+ * %MEDIA_ENTITY_TYPE_V4L2_SUBDEV and can safely be cast to a &v4l2_subdev
  * structure using the container_of() macro.
  */
 enum media_entity_type {
@@ -225,9 +227,12 @@ enum media_entity_type {
  * @graph_obj:	Embedded structure containing the media object common data.
  * @name:	Entity name.
  * @obj_type:	Type of the object that implements the media_entity.
- * @function:	Entity main function, as defined in uapi/media.h
- *		(MEDIA_ENT_F_*)
- * @flags:	Entity flags, as defined in uapi/media.h (MEDIA_ENT_FL_*)
+ * @function:	Entity main function, as defined in
+ *		:ref:`include/uapi/linux/media.h <media_header>`
+ *		(seek for ``MEDIA_ENT_F_*``)
+ * @flags:	Entity flags, as defined in
+ *		:ref:`include/uapi/linux/media.h <media_header>`
+ *		(seek for ``MEDIA_ENT_FL_*``)
  * @num_pads:	Number of sink and source pads.
  * @num_links:	Total number of links, forward and back, enabled and disabled.
  * @num_backlinks: Number of backlinks
@@ -246,9 +251,12 @@ enum media_entity_type {
  * @minor:	Devnode minor number (zero if not applicable). Kept just
  *		for backward compatibility.
  *
- * NOTE: @stream_count and @use_count reference counts must never be
- * negative, but are signed integers on purpose: a simple WARN_ON(<0) check
- * can be used to detect reference count bugs that would make them negative.
+ * .. note::
+ *
+ *    @stream_count and @use_count reference counts must never be
+ *    negative, but are signed integers on purpose: a simple ``WARN_ON(<0)``
+ *    check can be used to detect reference count bugs that would make them
+ *    negative.
  */
 struct media_entity {
 	struct media_gobj graph_obj;	/* must be first field in struct */
@@ -267,10 +275,6 @@ struct media_entity {
 
 	const struct media_entity_operations *ops;
 
-	/* Reference counts must never be negative, but are signed integers on
-	 * purpose: a simple WARN_ON(<0) check can be used to detect reference
-	 * count bugs that would make them negative.
-	 */
 	int stream_count;
 	int use_count;
 
@@ -289,10 +293,16 @@ struct media_entity {
  *
  * @graph_obj:		embedded graph object
  * @links:		List of links pointing to graph entities
- * @type:		Type of the interface as defined in the
- *			uapi/media/media.h header, e. g.
- *			MEDIA_INTF_T_*
- * @flags:		Interface flags as defined in uapi/media/media.h
+ * @type:		Type of the interface as defined in
+ *			:ref:`include/uapi/linux/media.h <media_header>`
+ *			(seek for ``MEDIA_INTF_T_*``)
+ * @flags:		Interface flags as defined in
+ * 			:ref:`include/uapi/linux/media.h <media_header>`
+ * 			(seek for ``MEDIA_INTF_FL_*``)
+ *
+ * .. note::
+ *
+ *    Currently, no flags for &media_interface is defined.
  */
 struct media_interface {
 	struct media_gobj		graph_obj;
@@ -319,7 +329,7 @@ struct media_intf_devnode {
 /**
  * media_entity_id() - return the media entity graph object id
  *
- * @entity:	pointer to entity
+ * @entity:	pointer to &media_entity
  */
 static inline u32 media_entity_id(struct media_entity *entity)
 {
@@ -329,7 +339,7 @@ static inline u32 media_entity_id(struct media_entity *entity)
 /**
  * media_type() - return the media object type
  *
- * @gobj:	pointer to the media graph object
+ * @gobj:	Pointer to the struct &media_gobj graph object
  */
 static inline enum media_gobj_type media_type(struct media_gobj *gobj)
 {
@@ -339,7 +349,7 @@ static inline enum media_gobj_type media_type(struct media_gobj *gobj)
 /**
  * media_id() - return the media object ID
  *
- * @gobj:	pointer to the media graph object
+ * @gobj:	Pointer to the struct &media_gobj graph object
  */
 static inline u32 media_id(struct media_gobj *gobj)
 {
@@ -350,7 +360,7 @@ static inline u32 media_id(struct media_gobj *gobj)
  * media_gobj_gen_id() - encapsulates type and ID on at the object ID
  *
  * @type:	object type as define at enum &media_gobj_type.
- * @local_id:	next ID, from struct &media_device.@id.
+ * @local_id:	next ID, from struct &media_device.id.
  */
 static inline u32 media_gobj_gen_id(enum media_gobj_type type, u64 local_id)
 {
@@ -366,9 +376,9 @@ static inline u32 media_gobj_gen_id(enum media_gobj_type type, u64 local_id)
  * is_media_entity_v4l2_video_device() - Check if the entity is a video_device
  * @entity:	pointer to entity
  *
- * Return: true if the entity is an instance of a video_device object and can
+ * Return: %true if the entity is an instance of a video_device object and can
  * safely be cast to a struct video_device using the container_of() macro, or
- * false otherwise.
+ * %false otherwise.
  */
 static inline bool is_media_entity_v4l2_video_device(struct media_entity *entity)
 {
@@ -379,9 +389,9 @@ static inline bool is_media_entity_v4l2_video_device(struct media_entity *entity
  * is_media_entity_v4l2_subdev() - Check if the entity is a v4l2_subdev
  * @entity:	pointer to entity
  *
- * Return: true if the entity is an instance of a v4l2_subdev object and can
- * safely be cast to a struct v4l2_subdev using the container_of() macro, or
- * false otherwise.
+ * Return: %true if the entity is an instance of a &v4l2_subdev object and can
+ * safely be cast to a struct &v4l2_subdev using the container_of() macro, or
+ * %false otherwise.
  */
 static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
 {
@@ -452,13 +462,13 @@ static inline void media_entity_enum_clear(struct media_entity_enum *ent_enum,
  * @ent_enum: Entity enumeration
  * @entity: Entity to be tested
  *
- * Returns true if the entity was marked.
+ * Returns %true if the entity was marked.
  */
 static inline bool media_entity_enum_test(struct media_entity_enum *ent_enum,
 					  struct media_entity *entity)
 {
 	if (WARN_ON(entity->internal_idx >= ent_enum->idx_max))
-		return true;
+		return %true;
 
 	return test_bit(entity->internal_idx, ent_enum->bmap);
 }
@@ -469,14 +479,14 @@ static inline bool media_entity_enum_test(struct media_entity_enum *ent_enum,
  * @ent_enum: Entity enumeration
  * @entity: Entity to be tested
  *
- * Returns true if the entity was marked, and mark it before doing so.
+ * Returns %true if the entity was marked, and mark it before doing so.
  */
 static inline bool
 media_entity_enum_test_and_set(struct media_entity_enum *ent_enum,
 			       struct media_entity *entity)
 {
 	if (WARN_ON(entity->internal_idx >= ent_enum->idx_max))
-		return true;
+		return %true;
 
 	return __test_and_set_bit(entity->internal_idx, ent_enum->bmap);
 }
@@ -486,7 +496,7 @@ media_entity_enum_test_and_set(struct media_entity_enum *ent_enum,
  *
  * @ent_enum: Entity enumeration
  *
- * Returns true if the entity was empty.
+ * Return: %true if the entity was empty.
  */
 static inline bool media_entity_enum_empty(struct media_entity_enum *ent_enum)
 {
@@ -499,7 +509,8 @@ static inline bool media_entity_enum_empty(struct media_entity_enum *ent_enum)
  * @ent_enum1: First entity enumeration
  * @ent_enum2: Second entity enumeration
  *
- * Returns true if entity enumerations e and f intersect, otherwise false.
+ * Return: %true if entity enumerations @ent_enum1 and @ent_enum2 intersect,
+ * otherwise %false.
  */
 static inline bool media_entity_enum_intersects(
 	struct media_entity_enum *ent_enum1,
@@ -511,33 +522,63 @@ static inline bool media_entity_enum_intersects(
 				 min(ent_enum1->idx_max, ent_enum2->idx_max));
 }
 
+/**
+ * gobj_to_entity - returns the struct &media_entity pointer from the
+ *	@gobj contained on it.
+ *
+ * @gobj: Pointer to the struct &media_gobj graph object
+ */
 #define gobj_to_entity(gobj) \
 		container_of(gobj, struct media_entity, graph_obj)
 
+/**
+ * gobj_to_entity - returns the struct &media_pad pointer from the
+ *	@gobj contained on it.
+ *
+ * @gobj: Pointer to the struct &media_gobj graph object
+ */
 #define gobj_to_pad(gobj) \
 		container_of(gobj, struct media_pad, graph_obj)
 
+/**
+ * gobj_to_entity - returns the struct &media_link pointer from the
+ *	@gobj contained on it.
+ *
+ * @gobj: Pointer to the struct &media_gobj graph object
+ */
 #define gobj_to_link(gobj) \
 		container_of(gobj, struct media_link, graph_obj)
 
+/**
+ * gobj_to_entity - returns the struct &media_interface pointer from the
+ *	@gobj contained on it.
+ *
+ * @gobj: Pointer to the struct &media_gobj graph object
+ */
 #define gobj_to_intf(gobj) \
 		container_of(gobj, struct media_interface, graph_obj)
 
+/**
+ * gobj_to_entity - returns the struct media_intf_devnode pointer from the
+ *	@intf contained on it.
+ *
+ * @intf: Pointer to struct &media_intf_devnode
+ */
 #define intf_to_devnode(intf) \
 		container_of(intf, struct media_intf_devnode, intf)
 
 /**
  *  media_gobj_create - Initialize a graph object
  *
- * @mdev:	Pointer to the media_device that contains the object
+ * @mdev:	Pointer to the &media_device that contains the object
  * @type:	Type of the object
- * @gobj:	Pointer to the graph object
+ * @gobj:	Pointer to the struct &media_gobj graph object
  *
- * This routine initializes the embedded struct media_gobj inside a
- * media graph object. It is called automatically if media_*_create\(\)
- * calls are used. However, if the object (entity, link, pad, interface)
- * is embedded on some other object, this function should be called before
- * registering the object at the media controller.
+ * This routine initializes the embedded struct &media_gobj inside a
+ * media graph object. It is called automatically if ``media_*_create``
+ * function calls are used. However, if the object (entity, link, pad,
+ * interface) is embedded on some other object, this function should be
+ * called before registering the object at the media controller.
  */
 void media_gobj_create(struct media_device *mdev,
 		    enum media_gobj_type type,
@@ -546,7 +587,7 @@ void media_gobj_create(struct media_device *mdev,
 /**
  *  media_gobj_destroy - Stop using a graph object on a media device
  *
- * @gobj:	Pointer to the graph object
+ * @gobj:	Pointer to the struct &media_gobj graph object
  *
  * This should be called by all routines like media_device_unregister()
  * that remove/destroy media graph objects.
@@ -561,11 +602,11 @@ void media_gobj_destroy(struct media_gobj *gobj);
  * @pads:	Array of @num_pads pads.
  *
  * The pads array is managed by the entity driver and passed to
- * media_entity_pads_init() where its pointer will be stored in the entity
- * structure.
+ * media_entity_pads_init() where its pointer will be stored in the
+ * &media_entity structure.
  *
  * If no pads are needed, drivers could either directly fill
- * &media_entity->@num_pads with 0 and &media_entity->@pads with NULL or call
+ * &media_entity->num_pads with 0 and &media_entity->pads with %NULL or call
  * this function that will do the same.
  *
  * As the number of pads is known in advance, the pads array is not allocated
@@ -595,18 +636,21 @@ static inline void media_entity_cleanup(struct media_entity *entity) {};
  * @source_pad:	number of the source pad in the pads array
  * @sink:	pointer to &media_entity of the sink pad.
  * @sink_pad:	number of the sink pad in the pads array.
- * @flags:	Link flags, as defined in include/uapi/linux/media.h.
+ * @flags:	Link flags, as defined in
+ *		:ref:`include/uapi/linux/media.h <media_header>`
+ *		( seek for ``MEDIA_LNK_FL_*``)
  *
  * Valid values for flags:
  *
- * - A %MEDIA_LNK_FL_ENABLED flag indicates that the link is enabled and can
- *   be used to transfer media data. When two or more links target a sink pad,
- *   only one of them can be enabled at a time.
+ * %MEDIA_LNK_FL_ENABLED
+ *   Indicates that the link is enabled and can be used to transfer media data.
+ *   When two or more links target a sink pad, only one of them can be
+ *   enabled at a time.
  *
- * - A %MEDIA_LNK_FL_IMMUTABLE flag indicates that the link enabled state can't
- *   be modified at runtime. If %MEDIA_LNK_FL_IMMUTABLE is set, then
- *   %MEDIA_LNK_FL_ENABLED must also be set since an immutable link is
- *   always enabled.
+ * %MEDIA_LNK_FL_IMMUTABLE
+ *   Indicates that the link enabled state can't be modified at runtime. If
+ *   %MEDIA_LNK_FL_IMMUTABLE is set, then %MEDIA_LNK_FL_ENABLED must also be
+ *   set, since an immutable link is always enabled.
  *
  * .. note::
  *
@@ -631,10 +675,10 @@ __must_check int media_create_pad_link(struct media_entity *source,
  * 	all entities that matches the @sink_function.
  * @sink_pad: number of the sink pad in the pads array.
  * @flags: Link flags, as defined in include/uapi/linux/media.h.
- * @allow_both_undefined: if true, then both @source and @sink can be NULL.
+ * @allow_both_undefined: if %true, then both @source and @sink can be NULL.
  *	In such case, it will create a crossbar between all entities that
  *	matches @source_function to all entities that matches @sink_function.
- *	If false, it will return 0 and won't create any link if both @source
+ *	If %false, it will return 0 and won't create any link if both @source
  *	and @sink are NULL.
  *
  * Valid values for flags:
@@ -654,9 +698,11 @@ __must_check int media_create_pad_link(struct media_entity *source,
  * creates link by link, this function is meant to allow 1:n, n:1 and even
  * cross-bar (n:n) links.
  *
- * NOTE: Before calling this function, media_entity_pads_init() and
- * media_device_register_entity() should be called previously for the entities
- * to be linked.
+ * .. note::
+ *
+ *    Before calling this function, media_entity_pads_init() and
+ *    media_device_register_entity() should be called previously for the
+ *    entities to be linked.
  */
 int media_create_pad_links(const struct media_device *mdev,
 			   const u32 source_function,
@@ -715,7 +761,7 @@ int __media_entity_setup_link(struct media_link *link, u32 flags);
  * flags.
  *
  * Media device drivers can be notified of link setup operations by setting the
- * media_device::link_notify pointer to a callback function. If provided, the
+ * &media_device.link_notify pointer to a callback function. If provided, the
  * notification callback will be called before enabling and after disabling
  * links.
  *
@@ -725,7 +771,7 @@ int __media_entity_setup_link(struct media_link *link, u32 flags);
  *
  * Link configuration must not have any side effect on other links. If an
  * enabled link at a sink pad prevents another link at the same pad from
- * being enabled, the link_setup operation must return -EBUSY and can't
+ * being enabled, the link_setup operation must return %-EBUSY and can't
  * implicitly disable the first enabled link.
  *
  * .. note::
@@ -741,8 +787,8 @@ int media_entity_setup_link(struct media_link *link, u32 flags);
  * @source: Source pad
  * @sink: Sink pad
  *
- * Return a pointer to the link between the two entities. If no such link
- * exists, return NULL.
+ * Return: returns a pointer to the link between the two entities. If no
+ * such link exists, return %NULL.
  */
 struct media_link *media_entity_find_link(struct media_pad *source,
 		struct media_pad *sink);
@@ -754,8 +800,8 @@ struct media_link *media_entity_find_link(struct media_pad *source,
  * Search for a remote pad connected to the given pad by iterating over all
  * links originating or terminating at that pad until an enabled link is found.
  *
- * Return a pointer to the pad at the remote end of the first found enabled
- * link, or NULL if no enabled link has been found.
+ * Return: returns a pointer to the pad at the remote end of the first found
+ * enabled link, or %NULL if no enabled link has been found.
  */
 struct media_pad *media_entity_remote_pad(struct media_pad *pad);
 
@@ -766,12 +812,18 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad);
  *
  * Get a reference to the parent media device module.
  *
- * The function will return immediately if @entity is NULL.
+ * The function will return immediately if @entity is %NULL.
  *
- * Return a pointer to the entity on success or NULL on failure.
+ * Return: returns a pointer to the entity on success or %NULL on failure.
  */
 struct media_entity *media_entity_get(struct media_entity *entity);
 
+/**
+ * media_entity_graph_walk_init - Allocate resources used by graph walk.
+ *
+ * @graph: Media graph structure that will be used to walk the graph
+ * @mdev: Pointer to the &media_device that contains the object
+ */
 __must_check int media_entity_graph_walk_init(
 	struct media_entity_graph *graph, struct media_device *mdev);
 
@@ -789,12 +841,14 @@ void media_entity_graph_walk_cleanup(struct media_entity_graph *graph);
  *
  * Release the reference count acquired by media_entity_get().
  *
- * The function will return immediately if @entity is NULL.
+ * The function will return immediately if @entity is %NULL.
  */
 void media_entity_put(struct media_entity *entity);
 
 /**
- * media_entity_graph_walk_start - Start walking the media graph at a given entity
+ * media_entity_graph_walk_start - Start walking the media graph at a
+ *	given entity
+ *
  * @graph: Media graph structure that will be used to walk the graph
  * @entity: Starting entity
  *
@@ -818,8 +872,8 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
  * The graph structure must have been previously initialized with a call to
  * media_entity_graph_walk_start().
  *
- * Return the next entity in the graph or NULL if the whole graph have been
- * traversed.
+ * Return: returns the next entity in the graph or %NULL if the whole graph
+ * have been traversed.
  */
 struct media_entity *
 media_entity_graph_walk_next(struct media_entity_graph *graph);
@@ -830,8 +884,8 @@ media_entity_graph_walk_next(struct media_entity_graph *graph);
  * @pipe: Media pipeline to be assigned to all entities in the pipeline.
  *
  * Mark all entities connected to a given entity through enabled links, either
- * directly or indirectly, as streaming. The given pipeline object is assigned to
- * every entity in the pipeline and stored in the media_entity pipe field.
+ * directly or indirectly, as streaming. The given pipeline object is assigned
+ * to every entity in the pipeline and stored in the media_entity pipe field.
  *
  * Calls to this function can be nested, in which case the same number of
  * media_entity_pipeline_stop() calls will be required to stop streaming. The
@@ -857,7 +911,7 @@ __must_check int __media_entity_pipeline_start(struct media_entity *entity,
  *
  * Mark all entities connected to a given entity through enabled links, either
  * directly or indirectly, as not streaming. The media_entity pipe field is
- * reset to NULL.
+ * reset to %NULL.
  *
  * If multiple calls to media_entity_pipeline_start() have been made, the same
  * number of calls to this function are required to mark the pipeline as not
@@ -878,14 +932,21 @@ void __media_entity_pipeline_stop(struct media_entity *entity);
  * media_devnode_create() - creates and initializes a device node interface
  *
  * @mdev:	pointer to struct &media_device
- * @type:	type of the interface, as given by MEDIA_INTF_T_* macros
- *		as defined in the uapi/media/media.h header.
- * @flags:	Interface flags as defined in uapi/media/media.h.
+ * @type:	type of the interface, as given by
+ *		:ref:`include/uapi/linux/media.h <media_header>`
+ *		( seek for ``MEDIA_INTF_T_*``) macros.
+ * @flags:	Interface flags, as defined in
+ *		:ref:`include/uapi/linux/media.h <media_header>`
+ *		( seek for ``MEDIA_INTF_FL_*``)
  * @major:	Device node major number.
  * @minor:	Device node minor number.
  *
  * Return: if succeeded, returns a pointer to the newly allocated
  *	&media_intf_devnode pointer.
+ *
+ * .. note::
+ *
+ *    Currently, no flags for &media_interface is defined.
  */
 struct media_intf_devnode *
 __must_check media_devnode_create(struct media_device *mdev,
@@ -907,15 +968,19 @@ struct media_link *
  *
  * @entity:	pointer to %media_entity
  * @intf:	pointer to %media_interface
- * @flags:	Link flags, as defined in include/uapi/linux/media.h.
+ * @flags:	Link flags, as defined in
+ *		:ref:`include/uapi/linux/media.h <media_header>`
+ *		( seek for ``MEDIA_LNK_FL_*``)
  *
  *
  * Valid values for flags:
  *
- * - The %MEDIA_LNK_FL_ENABLED flag indicates that the interface is connected to
- *   the entity hardware. That's the default value for interfaces. An
- *   interface may be disabled if the hardware is busy due to the usage
- *   of some other interface that it is currently controlling the hardware.
+ * %MEDIA_LNK_FL_ENABLED
+ *   Indicates that the interface is connected to the entity hardware.
+ *   That's the default value for interfaces. An interface may be disabled if
+ *   the hardware is busy due to the usage of some other interface that it is
+ *   currently controlling the hardware.
+ *
  *   A typical example is an hybrid TV device that handle only one type of
  *   stream on a given time. So, when the digital TV is streaming,
  *   the V4L2 interfaces won't be enabled, as such device is not able to
@@ -971,6 +1036,18 @@ void __media_remove_intf_links(struct media_interface *intf);
  */
 void media_remove_intf_links(struct media_interface *intf);
 
+/**
+ * media_entity_call - Calls a struct media_entity_operations operation on
+ *	an entity
+ *
+ * @entity: entity where the @operation will be called
+ * @operation: type of the operation. Should be the name of a member of
+ *	struct &media_entity_operations.
+ *
+ * This helper function will check if @operation is not %NULL. On such case,
+ * it will issue a call to @operation\(@entity, @args\).
+ */
+
 #define media_entity_call(entity, operation, args...)			\
 	(((entity)->ops && (entity)->ops->operation) ?			\
 	 (entity)->ops->operation((entity) , ##args) : -ENOIOCTLCMD)
-- 
2.7.4


