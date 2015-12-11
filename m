Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51761 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbbLKNe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 08:34:29 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 05/10] DocBook: Move media-framework.txt contend to media-device.h
Date: Fri, 11 Dec 2015 11:34:10 -0200
Message-Id: <c698e11ebf264468a0193caf82b749aacc4d9e88.1449840443.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using a text file, let's put it together with the struct documentation
for the Media Controller.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/DocBook/device-drivers.tmpl |   1 +
 Documentation/media-framework.txt         | 373 -----------------------------
 include/media/media-device.h              | 378 ++++++++++++++++++++++++++++++
 3 files changed, 379 insertions(+), 373 deletions(-)
 delete mode 100644 Documentation/media-framework.txt

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 7b3fcc5effcd..cdd8b24db68d 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -263,6 +263,7 @@ X!Isound/sound_firmware.c
 !Iinclude/media/lirc_dev.h
     </sect1>
     <sect1><title>Media Controller devices</title>
+!Pinclude/media/media-device.h Media Controller
 !Iinclude/media/media-device.h
 !Iinclude/media/media-devnode.h
 !Iinclude/media/media-entity.h
diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
deleted file mode 100644
index ef3663af1db3..000000000000
--- a/Documentation/media-framework.txt
+++ /dev/null
@@ -1,373 +0,0 @@
-Linux kernel media framework
-============================
-
-This document describes the Linux kernel media framework, its data structures,
-functions and their usage.
-
-
-Introduction
-------------
-
-The media controller API is documented in DocBook format in
-Documentation/DocBook/media/v4l/media-controller.xml. This document will focus
-on the kernel-side implementation of the media framework.
-
-
-Abstract media device model
----------------------------
-
-Discovering a device internal topology, and configuring it at runtime, is one
-of the goals of the media framework. To achieve this, hardware devices are
-modelled as an oriented graph of building blocks called entities connected
-through pads.
-
-An entity is a basic media hardware building block. It can correspond to
-a large variety of logical blocks such as physical hardware devices
-(CMOS sensor for instance), logical hardware devices (a building block
-in a System-on-Chip image processing pipeline), DMA channels or physical
-connectors.
-
-A pad is a connection endpoint through which an entity can interact with
-other entities. Data (not restricted to video) produced by an entity
-flows from the entity's output to one or more entity inputs. Pads should
-not be confused with physical pins at chip boundaries.
-
-A link is a point-to-point oriented connection between two pads, either
-on the same entity or on different entities. Data flows from a source
-pad to a sink pad.
-
-
-Media device
-------------
-
-A media device is represented by a struct media_device instance, defined in
-include/media/media-device.h. Allocation of the structure is handled by the
-media device driver, usually by embedding the media_device instance in a
-larger driver-specific structure.
-
-Drivers register media device instances by calling
-
-	media_device_register(struct media_device *mdev);
-
-The caller is responsible for initializing the media_device structure before
-registration. The following fields must be set:
-
- - dev must point to the parent device (usually a pci_dev, usb_interface or
-   platform_device instance).
-
- - model must be filled with the device model name as a NUL-terminated UTF-8
-   string. The device/model revision must not be stored in this field.
-
-The following fields are optional:
-
- - serial is a unique serial number stored as a NUL-terminated ASCII string.
-   The field is big enough to store a GUID in text form. If the hardware
-   doesn't provide a unique serial number this field must be left empty.
-
- - bus_info represents the location of the device in the system as a
-   NUL-terminated ASCII string. For PCI/PCIe devices bus_info must be set to
-   "PCI:" (or "PCIe:") followed by the value of pci_name(). For USB devices,
-   the usb_make_path() function must be used. This field is used by
-   applications to distinguish between otherwise identical devices that don't
-   provide a serial number.
-
- - hw_revision is the hardware device revision in a driver-specific format.
-   When possible the revision should be formatted with the KERNEL_VERSION
-   macro.
-
- - driver_version is formatted with the KERNEL_VERSION macro. The version
-   minor must be incremented when new features are added to the userspace API
-   without breaking binary compatibility. The version major must be
-   incremented when binary compatibility is broken.
-
-Upon successful registration a character device named media[0-9]+ is created.
-The device major and minor numbers are dynamic. The model name is exported as
-a sysfs attribute.
-
-Drivers unregister media device instances by calling
-
-	media_device_unregister(struct media_device *mdev);
-
-Unregistering a media device that hasn't been registered is *NOT* safe.
-
-
-Entities, pads and links
-------------------------
-
-- Entities
-
-Entities are represented by a struct media_entity instance, defined in
-include/media/media-entity.h. The structure is usually embedded into a
-higher-level structure, such as a v4l2_subdev or video_device instance,
-although drivers can allocate entities directly.
-
-Drivers initialize entity pads by calling
-
-	media_entity_pads_init(struct media_entity *entity, u16 num_pads,
-			  struct media_pad *pads);
-
-If no pads are needed, drivers could directly fill entity->num_pads
-with 0 and entity->pads with NULL or to call the above function that
-will do the same.
-
-The media_entity name, type and flags fields should be initialized before
-calling media_device_register_entity(). Entities embedded in higher-level
-standard structures can have some of those fields set by the higher-level
-framework.
-
-As the number of pads is known in advance, the pads array is not allocated
-dynamically but is managed by the entity driver. Most drivers will embed the
-pads array in a driver-specific structure, avoiding dynamic allocation.
-
-Drivers must set the direction of every pad in the pads array before calling
-media_entity_pads_init. The function will initialize the other pads fields.
-
-Unlike the number of pads, the total number of links isn't always known in
-advance by the entity driver. As an initial estimate, media_entity_pads_init
-pre-allocates a number of links equal to the number of pads. The links array
-will be reallocated if it grows beyond the initial estimate.
-
-Drivers register entities with a media device by calling
-
-	media_device_register_entity(struct media_device *mdev,
-				     struct media_entity *entity);
-
-Entities are identified by a unique positive integer ID. Drivers can provide an
-ID by filling the media_entity id field prior to registration, or request the
-media controller framework to assign an ID automatically. Drivers that provide
-IDs manually must ensure that all IDs are unique. IDs are not guaranteed to be
-contiguous even when they are all assigned automatically by the framework.
-
-Drivers unregister entities by calling
-
-	media_device_unregister_entity(struct media_entity *entity);
-
-Unregistering an entity will not change the IDs of the other entities, and the
-ID will never be reused for a newly registered entity.
-
-When a media device is unregistered, all its entities are unregistered
-automatically. No manual entities unregistration is then required.
-
-Drivers free resources associated with an entity by calling
-
-	media_entity_cleanup(struct media_entity *entity);
-
-This function must be called during the cleanup phase after unregistering the
-entity. Note that the media_entity instance itself must be freed explicitly by
-the driver if required.
-
-Entities have flags that describe the entity capabilities and state.
-
-	MEDIA_ENT_FL_DEFAULT indicates the default entity for a given type.
-	This can be used to report the default audio and video devices or the
-	default camera sensor.
-
-Logical entity groups can be defined by setting the group ID of all member
-entities to the same non-zero value. An entity group serves no purpose in the
-kernel, but is reported to userspace during entities enumeration.
-
-Media device drivers should define groups if several entities are logically
-bound together. Example usages include reporting
-
-	- ALSA, VBI and video nodes that carry the same media stream
-	- lens and flash controllers associated with a sensor
-
-- Pads
-
-Pads are represented by a struct media_pad instance, defined in
-include/media/media-entity.h. Each entity stores its pads in a pads array
-managed by the entity driver. Drivers usually embed the array in a
-driver-specific structure.
-
-Pads are identified by their entity and their 0-based index in the pads array.
-Both information are stored in the media_pad structure, making the media_pad
-pointer the canonical way to store and pass link references.
-
-Pads have flags that describe the pad capabilities and state.
-
-	MEDIA_PAD_FL_SINK indicates that the pad supports sinking data.
-	MEDIA_PAD_FL_SOURCE indicates that the pad supports sourcing data.
-
-One and only one of MEDIA_PAD_FL_SINK and MEDIA_PAD_FL_SOURCE must be set for
-each pad.
-
-- Links
-
-Links are represented by a struct media_link instance, defined in
-include/media/media-entity.h. Each entity stores all links originating at or
-targeting any of its pads in a links array. A given link is thus stored
-twice, once in the source entity and once in the target entity. The array is
-pre-allocated and grows dynamically as needed.
-
-Drivers create links by calling
-
-	media_create_pad_link(struct media_entity *source, u16 source_pad,
-				 struct media_entity *sink,   u16 sink_pad,
-				 u32 flags);
-
-An entry in the link array of each entity is allocated and stores pointers
-to source and sink pads.
-
-Links have flags that describe the link capabilities and state.
-
-	MEDIA_LNK_FL_ENABLED indicates that the link is enabled and can be used
-	to transfer media data. When two or more links target a sink pad, only
-	one of them can be enabled at a time.
-	MEDIA_LNK_FL_IMMUTABLE indicates that the link enabled state can't be
-	modified at runtime. If MEDIA_LNK_FL_IMMUTABLE is set, then
-	MEDIA_LNK_FL_ENABLED must also be set since an immutable link is always
-	enabled.
-
-
-Graph traversal
----------------
-
-The media framework provides APIs to iterate over entities in a graph.
-
-To iterate over all entities belonging to a media device, drivers can use the
-media_device_for_each_entity macro, defined in include/media/media-device.h.
-
-	struct media_entity *entity;
-
-	media_device_for_each_entity(entity, mdev) {
-		/* entity will point to each entity in turn */
-		...
-	}
-
-Drivers might also need to iterate over all entities in a graph that can be
-reached only through enabled links starting at a given entity. The media
-framework provides a depth-first graph traversal API for that purpose.
-
-Note that graphs with cycles (whether directed or undirected) are *NOT*
-supported by the graph traversal API. To prevent infinite loops, the graph
-traversal code limits the maximum depth to MEDIA_ENTITY_ENUM_MAX_DEPTH,
-currently defined as 16.
-
-Drivers initiate a graph traversal by calling
-
-	media_entity_graph_walk_start(struct media_entity_graph *graph,
-				      struct media_entity *entity);
-
-The graph structure, provided by the caller, is initialized to start graph
-traversal at the given entity.
-
-Drivers can then retrieve the next entity by calling
-
-	media_entity_graph_walk_next(struct media_entity_graph *graph);
-
-When the graph traversal is complete the function will return NULL.
-
-Graph traversal can be interrupted at any moment. No cleanup function call is
-required and the graph structure can be freed normally.
-
-Helper functions can be used to find a link between two given pads, or a pad
-connected to another pad through an enabled link
-
-	media_entity_find_link(struct media_pad *source,
-			       struct media_pad *sink);
-
-	media_entity_remote_pad(struct media_pad *pad);
-
-Refer to the kerneldoc documentation for more information.
-
-
-Use count and power handling
-----------------------------
-
-Due to the wide differences between drivers regarding power management needs,
-the media controller does not implement power management. However, the
-media_entity structure includes a use_count field that media drivers can use to
-track the number of users of every entity for power management needs.
-
-The use_count field is owned by media drivers and must not be touched by entity
-drivers. Access to the field must be protected by the media device graph_mutex
-lock.
-
-
-Links setup
------------
-
-Link properties can be modified at runtime by calling
-
-	media_entity_setup_link(struct media_link *link, u32 flags);
-
-The flags argument contains the requested new link flags.
-
-The only configurable property is the ENABLED link flag to enable/disable a
-link. Links marked with the IMMUTABLE link flag can not be enabled or disabled.
-
-When a link is enabled or disabled, the media framework calls the
-link_setup operation for the two entities at the source and sink of the link,
-in that order. If the second link_setup call fails, another link_setup call is
-made on the first entity to restore the original link flags.
-
-Media device drivers can be notified of link setup operations by setting the
-media_device::link_notify pointer to a callback function. If provided, the
-notification callback will be called before enabling and after disabling
-links.
-
-Entity drivers must implement the link_setup operation if any of their links
-is non-immutable. The operation must either configure the hardware or store
-the configuration information to be applied later.
-
-Link configuration must not have any side effect on other links. If an enabled
-link at a sink pad prevents another link at the same pad from being enabled,
-the link_setup operation must return -EBUSY and can't implicitly disable the
-first enabled link.
-
-
-Pipelines and media streams
----------------------------
-
-When starting streaming, drivers must notify all entities in the pipeline to
-prevent link states from being modified during streaming by calling
-
-	media_entity_pipeline_start(struct media_entity *entity,
-				    struct media_pipeline *pipe);
-
-The function will mark all entities connected to the given entity through
-enabled links, either directly or indirectly, as streaming.
-
-The media_pipeline instance pointed to by the pipe argument will be stored in
-every entity in the pipeline. Drivers should embed the media_pipeline structure
-in higher-level pipeline structures and can then access the pipeline through
-the media_entity pipe field.
-
-Calls to media_entity_pipeline_start() can be nested. The pipeline pointer must
-be identical for all nested calls to the function.
-
-media_entity_pipeline_start() may return an error. In that case, it will
-clean up any of the changes it did by itself.
-
-When stopping the stream, drivers must notify the entities with
-
-	media_entity_pipeline_stop(struct media_entity *entity);
-
-If multiple calls to media_entity_pipeline_start() have been made the same
-number of media_entity_pipeline_stop() calls are required to stop streaming. The
-media_entity pipe field is reset to NULL on the last nested stop call.
-
-Link configuration will fail with -EBUSY by default if either end of the link is
-a streaming entity. Links that can be modified while streaming must be marked
-with the MEDIA_LNK_FL_DYNAMIC flag.
-
-If other operations need to be disallowed on streaming entities (such as
-changing entities configuration parameters) drivers can explicitly check the
-media_entity stream_count field to find out if an entity is streaming. This
-operation must be done with the media_device graph_mutex held.
-
-
-Link validation
----------------
-
-Link validation is performed by media_entity_pipeline_start() for any
-entity which has sink pads in the pipeline. The
-media_entity::link_validate() callback is used for that purpose. In
-link_validate() callback, entity driver should check that the properties of
-the source pad of the connected entity and its own sink pad match. It is up
-to the type of the entity (and in the end, the properties of the hardware)
-what matching actually means.
-
-Subsystems should facilitate link validation by providing subsystem specific
-helper functions to provide easy access for commonly needed information, and
-in the end provide a way to use driver-specific callbacks.
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 87ff299e1265..6728528df9e2 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -30,6 +30,384 @@
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
 
+/**
+ * DOC: Media Controller
+ *
+ * Linux kernel media framework
+ * ============================
+ *
+ * This document describes the Linux kernel media framework, its data structures,
+ * functions and their usage.
+ *
+ *
+ * Introduction
+ * ------------
+ *
+ * The media controller API is documented in DocBook format in
+ * Documentation/DocBook/media/v4l/media-controller.xml. This document will focus
+ * on the kernel-side implementation of the media framework.
+ *
+ *
+ * Abstract media device model
+ * ---------------------------
+ *
+ * Discovering a device internal topology, and configuring it at runtime, is one
+ * of the goals of the media framework. To achieve this, hardware devices are
+ * modelled as an oriented graph of building blocks called entities connected
+ * through pads.
+ *
+ * An entity is a basic media hardware building block. It can correspond to
+ * a large variety of logical blocks such as physical hardware devices
+ * (CMOS sensor for instance), logical hardware devices (a building block
+ * in a System-on-Chip image processing pipeline), DMA channels or physical
+ * connectors.
+ *
+ * A pad is a connection endpoint through which an entity can interact with
+ * other entities. Data (not restricted to video) produced by an entity
+ * flows from the entity's output to one or more entity inputs. Pads should
+ * not be confused with physical pins at chip boundaries.
+ *
+ * A link is a point-to-point oriented connection between two pads, either
+ * on the same entity or on different entities. Data flows from a source
+ * pad to a sink pad.
+ *
+ *
+ * Media device
+ * ------------
+ *
+ * A media device is represented by a struct media_device instance, defined in
+ * include/media/media-device.h. Allocation of the structure is handled by the
+ * media device driver, usually by embedding the media_device instance in a
+ * larger driver-specific structure.
+ *
+ * Drivers register media device instances by calling
+ *
+ * 	media_device_register(struct media_device *mdev);
+ *
+ * The caller is responsible for initializing the media_device structure before
+ * registration. The following fields must be set:
+ *
+ *  - dev must point to the parent device (usually a pci_dev, usb_interface or
+ *    platform_device instance).
+ *
+ *  - model must be filled with the device model name as a NUL-terminated UTF-8
+ *    string. The device/model revision must not be stored in this field.
+ *
+ * The following fields are optional:
+ *
+ *  - serial is a unique serial number stored as a NUL-terminated ASCII string.
+ *    The field is big enough to store a GUID in text form. If the hardware
+ *    doesn't provide a unique serial number this field must be left empty.
+ *
+ *  - bus_info represents the location of the device in the system as a
+ *    NUL-terminated ASCII string. For PCI/PCIe devices bus_info must be set to
+ *    "PCI:" (or "PCIe:") followed by the value of pci_name(). For USB devices,
+ *    the usb_make_path() function must be used. This field is used by
+ *    applications to distinguish between otherwise identical devices that don't
+ *    provide a serial number.
+ *
+ *  - hw_revision is the hardware device revision in a driver-specific format.
+ *    When possible the revision should be formatted with the KERNEL_VERSION
+ *    macro.
+ *
+ *  - driver_version is formatted with the KERNEL_VERSION macro. The version
+ *    minor must be incremented when new features are added to the userspace API
+ *    without breaking binary compatibility. The version major must be
+ *    incremented when binary compatibility is broken.
+ *
+ * Upon successful registration a character device named media[0-9]+ is created.
+ * The device major and minor numbers are dynamic. The model name is exported as
+ * a sysfs attribute.
+ *
+ * Drivers unregister media device instances by calling
+ *
+ * 	media_device_unregister(struct media_device *mdev);
+ *
+ * Unregistering a media device that hasn't been registered is *NOT* safe.
+ *
+ *
+ * Entities, pads and links
+ * ------------------------
+ *
+ * - Entities
+ *
+ * Entities are represented by a struct media_entity instance, defined in
+ * include/media/media-entity.h. The structure is usually embedded into a
+ * higher-level structure, such as a v4l2_subdev or video_device instance,
+ * although drivers can allocate entities directly.
+ *
+ * Drivers initialize entity pads by calling
+ *
+ * 	media_entity_pads_init(struct media_entity *entity, u16 num_pads,
+ * 			  struct media_pad *pads);
+ *
+ * If no pads are needed, drivers could directly fill entity->num_pads
+ * with 0 and entity->pads with NULL or to call the above function that
+ * will do the same.
+ *
+ * The media_entity name, type and flags fields should be initialized before
+ * calling media_device_register_entity(). Entities embedded in higher-level
+ * standard structures can have some of those fields set by the higher-level
+ * framework.
+ *
+ * As the number of pads is known in advance, the pads array is not allocated
+ * dynamically but is managed by the entity driver. Most drivers will embed the
+ * pads array in a driver-specific structure, avoiding dynamic allocation.
+ *
+ * Drivers must set the direction of every pad in the pads array before calling
+ * media_entity_pads_init. The function will initialize the other pads fields.
+ *
+ * Unlike the number of pads, the total number of links isn't always known in
+ * advance by the entity driver. As an initial estimate, media_entity_pads_init
+ * pre-allocates a number of links equal to the number of pads. The links array
+ * will be reallocated if it grows beyond the initial estimate.
+ *
+ * Drivers register entities with a media device by calling
+ *
+ * 	media_device_register_entity(struct media_device *mdev,
+ * 				     struct media_entity *entity);
+ *
+ * Entities are identified by a unique positive integer ID. Drivers can provide an
+ * ID by filling the media_entity id field prior to registration, or request the
+ * media controller framework to assign an ID automatically. Drivers that provide
+ * IDs manually must ensure that all IDs are unique. IDs are not guaranteed to be
+ * contiguous even when they are all assigned automatically by the framework.
+ *
+ * Drivers unregister entities by calling
+ *
+ * 	media_device_unregister_entity(struct media_entity *entity);
+ *
+ * Unregistering an entity will not change the IDs of the other entities, and the
+ * ID will never be reused for a newly registered entity.
+ *
+ * When a media device is unregistered, all its entities are unregistered
+ * automatically. No manual entities unregistration is then required.
+ *
+ * Drivers free resources associated with an entity by calling
+ *
+ * 	media_entity_cleanup(struct media_entity *entity);
+ *
+ * This function must be called during the cleanup phase after unregistering the
+ * entity. Note that the media_entity instance itself must be freed explicitly by
+ * the driver if required.
+ *
+ * Entities have flags that describe the entity capabilities and state.
+ *
+ * 	MEDIA_ENT_FL_DEFAULT indicates the default entity for a given type.
+ * 	This can be used to report the default audio and video devices or the
+ * 	default camera sensor.
+ *
+ * Logical entity groups can be defined by setting the group ID of all member
+ * entities to the same non-zero value. An entity group serves no purpose in the
+ * kernel, but is reported to userspace during entities enumeration.
+ *
+ * Media device drivers should define groups if several entities are logically
+ * bound together. Example usages include reporting
+ *
+ * 	- ALSA, VBI and video nodes that carry the same media stream
+ * 	- lens and flash controllers associated with a sensor
+ *
+ * - Pads
+ *
+ * Pads are represented by a struct media_pad instance, defined in
+ * include/media/media-entity.h. Each entity stores its pads in a pads array
+ * managed by the entity driver. Drivers usually embed the array in a
+ * driver-specific structure.
+ *
+ * Pads are identified by their entity and their 0-based index in the pads array.
+ * Both information are stored in the media_pad structure, making the media_pad
+ * pointer the canonical way to store and pass link references.
+ *
+ * Pads have flags that describe the pad capabilities and state.
+ *
+ * 	MEDIA_PAD_FL_SINK indicates that the pad supports sinking data.
+ * 	MEDIA_PAD_FL_SOURCE indicates that the pad supports sourcing data.
+ *
+ * One and only one of MEDIA_PAD_FL_SINK and MEDIA_PAD_FL_SOURCE must be set for
+ * each pad.
+ *
+ * - Links
+ *
+ * Links are represented by a struct media_link instance, defined in
+ * include/media/media-entity.h. Each entity stores all links originating at or
+ * targeting any of its pads in a links array. A given link is thus stored
+ * twice, once in the source entity and once in the target entity. The array is
+ * pre-allocated and grows dynamically as needed.
+ *
+ * Drivers create links by calling
+ *
+ * 	media_create_pad_link(struct media_entity *source, u16 source_pad,
+ * 				 struct media_entity *sink,   u16 sink_pad,
+ * 				 u32 flags);
+ *
+ * An entry in the link array of each entity is allocated and stores pointers
+ * to source and sink pads.
+ *
+ * Links have flags that describe the link capabilities and state.
+ *
+ * 	MEDIA_LNK_FL_ENABLED indicates that the link is enabled and can be used
+ * 	to transfer media data. When two or more links target a sink pad, only
+ * 	one of them can be enabled at a time.
+ * 	MEDIA_LNK_FL_IMMUTABLE indicates that the link enabled state can't be
+ * 	modified at runtime. If MEDIA_LNK_FL_IMMUTABLE is set, then
+ * 	MEDIA_LNK_FL_ENABLED must also be set since an immutable link is always
+ * 	enabled.
+ *
+ *
+ * Graph traversal
+ * ---------------
+ *
+ * The media framework provides APIs to iterate over entities in a graph.
+ *
+ * To iterate over all entities belonging to a media device, drivers can use the
+ * media_device_for_each_entity macro, defined in include/media/media-device.h.
+ *
+ * 	struct media_entity *entity;
+ *
+ * 	media_device_for_each_entity(entity, mdev) {
+ * 		// entity will point to each entity in turn
+ * 		...
+ * 	}
+ *
+ * Drivers might also need to iterate over all entities in a graph that can be
+ * reached only through enabled links starting at a given entity. The media
+ * framework provides a depth-first graph traversal API for that purpose.
+ *
+ * Note that graphs with cycles (whether directed or undirected) are *NOT*
+ * supported by the graph traversal API. To prevent infinite loops, the graph
+ * traversal code limits the maximum depth to MEDIA_ENTITY_ENUM_MAX_DEPTH,
+ * currently defined as 16.
+ *
+ * Drivers initiate a graph traversal by calling
+ *
+ * 	media_entity_graph_walk_start(struct media_entity_graph *graph,
+ * 				      struct media_entity *entity);
+ *
+ * The graph structure, provided by the caller, is initialized to start graph
+ * traversal at the given entity.
+ *
+ * Drivers can then retrieve the next entity by calling
+ *
+ * 	media_entity_graph_walk_next(struct media_entity_graph *graph);
+ *
+ * When the graph traversal is complete the function will return NULL.
+ *
+ * Graph traversal can be interrupted at any moment. No cleanup function call is
+ * required and the graph structure can be freed normally.
+ *
+ * Helper functions can be used to find a link between two given pads, or a pad
+ * connected to another pad through an enabled link
+ *
+ * 	media_entity_find_link(struct media_pad *source,
+ * 			       struct media_pad *sink);
+ *
+ * 	media_entity_remote_pad(struct media_pad *pad);
+ *
+ * Refer to the kerneldoc documentation for more information.
+ *
+ *
+ * Use count and power handling
+ * ----------------------------
+ *
+ * Due to the wide differences between drivers regarding power management needs,
+ * the media controller does not implement power management. However, the
+ * media_entity structure includes a use_count field that media drivers can use to
+ * track the number of users of every entity for power management needs.
+ *
+ * The use_count field is owned by media drivers and must not be touched by entity
+ * drivers. Access to the field must be protected by the media device graph_mutex
+ * lock.
+ *
+ *
+ * Links setup
+ * -----------
+ *
+ * Link properties can be modified at runtime by calling
+ *
+ * 	media_entity_setup_link(struct media_link *link, u32 flags);
+ *
+ * The flags argument contains the requested new link flags.
+ *
+ * The only configurable property is the ENABLED link flag to enable/disable a
+ * link. Links marked with the IMMUTABLE link flag can not be enabled or disabled.
+ *
+ * When a link is enabled or disabled, the media framework calls the
+ * link_setup operation for the two entities at the source and sink of the link,
+ * in that order. If the second link_setup call fails, another link_setup call is
+ * made on the first entity to restore the original link flags.
+ *
+ * Media device drivers can be notified of link setup operations by setting the
+ * media_device::link_notify pointer to a callback function. If provided, the
+ * notification callback will be called before enabling and after disabling
+ * links.
+ *
+ * Entity drivers must implement the link_setup operation if any of their links
+ * is non-immutable. The operation must either configure the hardware or store
+ * the configuration information to be applied later.
+ *
+ * Link configuration must not have any side effect on other links. If an enabled
+ * link at a sink pad prevents another link at the same pad from being enabled,
+ * the link_setup operation must return -EBUSY and can't implicitly disable the
+ * first enabled link.
+ *
+ *
+ * Pipelines and media streams
+ * ---------------------------
+ *
+ * When starting streaming, drivers must notify all entities in the pipeline to
+ * prevent link states from being modified during streaming by calling
+ *
+ * 	media_entity_pipeline_start(struct media_entity *entity,
+ * 				    struct media_pipeline *pipe);
+ *
+ * The function will mark all entities connected to the given entity through
+ * enabled links, either directly or indirectly, as streaming.
+ *
+ * The media_pipeline instance pointed to by the pipe argument will be stored in
+ * every entity in the pipeline. Drivers should embed the media_pipeline structure
+ * in higher-level pipeline structures and can then access the pipeline through
+ * the media_entity pipe field.
+ *
+ * Calls to media_entity_pipeline_start() can be nested. The pipeline pointer must
+ * be identical for all nested calls to the function.
+ *
+ * media_entity_pipeline_start() may return an error. In that case, it will
+ * clean up any of the changes it did by itself.
+ *
+ * When stopping the stream, drivers must notify the entities with
+ *
+ * 	media_entity_pipeline_stop(struct media_entity *entity);
+ *
+ * If multiple calls to media_entity_pipeline_start() have been made the same
+ * number of media_entity_pipeline_stop() calls are required to stop streaming. The
+ * media_entity pipe field is reset to NULL on the last nested stop call.
+ *
+ * Link configuration will fail with -EBUSY by default if either end of the link is
+ * a streaming entity. Links that can be modified while streaming must be marked
+ * with the MEDIA_LNK_FL_DYNAMIC flag.
+ *
+ * If other operations need to be disallowed on streaming entities (such as
+ * changing entities configuration parameters) drivers can explicitly check the
+ * media_entity stream_count field to find out if an entity is streaming. This
+ * operation must be done with the media_device graph_mutex held.
+ *
+ *
+ * Link validation
+ * ---------------
+ *
+ * Link validation is performed by media_entity_pipeline_start() for any
+ * entity which has sink pads in the pipeline. The
+ * media_entity::link_validate() callback is used for that purpose. In
+ * link_validate() callback, entity driver should check that the properties of
+ * the source pad of the connected entity and its own sink pad match. It is up
+ * to the type of the entity (and in the end, the properties of the hardware)
+ * what matching actually means.
+ *
+ * Subsystems should facilitate link validation by providing subsystem specific
+ * helper functions to provide easy access for commonly needed information, and
+ * in the end provide a way to use driver-specific callbacks.
+ */
+
 struct device;
 
 /**
-- 
2.5.0


