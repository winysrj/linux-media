Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39600 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbcCXIuQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 04:50:16 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH v6 1/2] media: Add obj_type field to struct media_entity
Date: Thu, 24 Mar 2016 10:50:07 +0200
Message-Id: <1458809408-32611-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458809408-32611-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458809408-32611-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Code that processes media entities can require knowledge of the
structure type that embeds a particular media entity instance in order
to cast the entity to the proper object type. This needs is shown by the
presence of the is_media_entity_v4l2_io and is_media_entity_v4l2_subdev
functions.

The implementation of those two functions relies on the entity function
field, which is both a wrong and an inefficient design, without even
mentioning the maintenance issue involved in updating the functions
every time a new entity function is added. Fix this by adding add an
obj_type field to the media entity structure to carry the information.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-dev.c    |  1 +
 drivers/media/v4l2-core/v4l2-subdev.c |  1 +
 include/media/media-entity.h          | 76 ++++++++++++++++++-----------------
 3 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index d8e5994cccf1..70b559d7ca80 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -735,6 +735,7 @@ static int video_register_media_controller(struct video_device *vdev, int type)
 	if (!vdev->v4l2_dev->mdev)
 		return 0;
 
+	vdev->entity.obj_type = MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
 	vdev->entity.function = MEDIA_ENT_F_UNKNOWN;
 
 	switch (type) {
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index d63083803144..0fa60801a428 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -584,6 +584,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
 	sd->host_priv = NULL;
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	sd->entity.name = sd->name;
+	sd->entity.obj_type = MEDIA_ENTITY_TYPE_V4L2_SUBDEV;
 	sd->entity.function = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
 #endif
 }
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 6dc9e4e8cbd4..1986340a8cf2 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -188,10 +188,38 @@ struct media_entity_operations {
 };
 
 /**
+ * enum media_entity_type - Media entity type
+ *
+ * @MEDIA_ENTITY_TYPE_BASE:
+ *	The entity isn't embedded in another subsystem structure.
+ * @MEDIA_ENTITY_TYPE_VIDEO_DEVICE:
+ *	The entity is embedded in a struct video_device instance.
+ * @MEDIA_ENTITY_TYPE_V4L2_SUBDEV:
+ *	The entity is embedded in a struct v4l2_subdev instance.
+ *
+ * Media entity objects are often not instantiated directly, but the media
+ * entity structure is inherited by (through embedding) other subsystem-specific
+ * structures. The media entity type identifies the type of the subclass
+ * structure that implements a media entity instance.
+ *
+ * This allows runtime type identification of media entities and safe casting to
+ * the correct object type. For instance, a media entity structure instance
+ * embedded in a v4l2_subdev structure instance will have the type
+ * MEDIA_ENTITY_TYPE_V4L2_SUBDEV and can safely be cast to a v4l2_subdev
+ * structure using the container_of() macro.
+ */
+enum media_entity_type {
+	MEDIA_ENTITY_TYPE_BASE,
+	MEDIA_ENTITY_TYPE_VIDEO_DEVICE,
+	MEDIA_ENTITY_TYPE_V4L2_SUBDEV,
+};
+
+/**
  * struct media_entity - A media entity graph object.
  *
  * @graph_obj:	Embedded structure containing the media object common data.
  * @name:	Entity name.
+ * @obj_type:	Type of the object that implements the media_entity.
  * @function:	Entity main function, as defined in uapi/media.h
  *		(MEDIA_ENT_F_*)
  * @flags:	Entity flags, as defined in uapi/media.h (MEDIA_ENT_FL_*)
@@ -220,6 +248,7 @@ struct media_entity_operations {
 struct media_entity {
 	struct media_gobj graph_obj;	/* must be first field in struct */
 	const char *name;
+	enum media_entity_type obj_type;
 	u32 function;
 	unsigned long flags;
 
@@ -329,56 +358,29 @@ static inline u32 media_gobj_gen_id(enum media_gobj_type type, u64 local_id)
 }
 
 /**
- * is_media_entity_v4l2_io() - identify if the entity main function
- *			       is a V4L2 I/O
- *
+ * is_media_entity_v4l2_io() - Check if the entity is a video_device
  * @entity:	pointer to entity
  *
- * Return: true if the entity main function is one of the V4L2 I/O types
- *	(video, VBI or SDR radio); false otherwise.
+ * Return: true if the entity is an instance of a video_device object and can
+ * safely be cast to a struct video_device using the container_of() macro, or
+ * false otherwise.
  */
 static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
 {
-	if (!entity)
-		return false;
-
-	switch (entity->function) {
-	case MEDIA_ENT_F_IO_V4L:
-	case MEDIA_ENT_F_IO_VBI:
-	case MEDIA_ENT_F_IO_SWRADIO:
-		return true;
-	default:
-		return false;
-	}
+	return entity && entity->obj_type == MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
 }
 
 /**
- * is_media_entity_v4l2_subdev - return true if the entity main function is
- *				 associated with the V4L2 API subdev usage
- *
+ * is_media_entity_v4l2_subdev() - Check if the entity is a v4l2_subdev
  * @entity:	pointer to entity
  *
- * This is an ancillary function used by subdev-based V4L2 drivers.
- * It checks if the entity function is one of functions used by a V4L2 subdev,
- * e. g. camera-relatef functions, analog TV decoder, TV tuner, V4L2 DSPs.
+ * Return: true if the entity is an instance of a v4l2_subdev object and can
+ * safely be cast to a struct v4l2_subdev using the container_of() macro, or
+ * false otherwise.
  */
 static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
 {
-	if (!entity)
-		return false;
-
-	switch (entity->function) {
-	case MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN:
-	case MEDIA_ENT_F_CAM_SENSOR:
-	case MEDIA_ENT_F_FLASH:
-	case MEDIA_ENT_F_LENS:
-	case MEDIA_ENT_F_ATV_DECODER:
-	case MEDIA_ENT_F_TUNER:
-		return true;
-
-	default:
-		return false;
-	}
+	return entity && entity->obj_type == MEDIA_ENTITY_TYPE_V4L2_SUBDEV;
 }
 
 /**
-- 
2.7.3

