Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51333 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758625Ab0GUOfo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jul 2010 10:35:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v2 10/10] v4l: Make v4l2_subdev inherit from media_entity
Date: Wed, 21 Jul 2010 16:35:35 +0200
Message-Id: <1279722935-28493-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 subdevices are media entities. As such they need to inherit from
(include) the media_entity structure.

When registering/unregistering the subdevice, the media entity is
automatically registered/unregistered. The entity is acquired on device
open and released on device close.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 Documentation/video4linux/v4l2-framework.txt |   22 +++++++++++++++++++++
 drivers/media/video/v4l2-device.c            |   26 +++++++++++++++++++++---
 drivers/media/video/v4l2-subdev.c            |   27 +++++++++++++++++++++++++-
 include/media/v4l2-subdev.h                  |    7 ++++++
 4 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 0d9b8ce..76ecd43 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -263,6 +263,25 @@ A sub-device driver initializes the v4l2_subdev struct using:
 Afterwards you need to initialize subdev->name with a unique name and set the
 module owner. This is done for you if you use the i2c helper functions.
 
+If integration with the media framework is needed, you must initialize the
+media_entity struct embedded in the v4l2_subdev struct (entity field) by
+calling media_entity_init():
+
+	struct media_entity_pad *pads = &my_sd->pads;
+	int err;
+
+	err = media_entity_init(&sd->entity, npads, pads, 0);
+
+The pads array must have been previously initialized. There is no need to
+manually set the struct media_entity type, subtype and name fields.
+
+A reference to the entity will be automatically acquired/released when the
+subdev device node (if any) is opened/closed.
+
+Don't forget to cleanup the media entity before the sub-device is destroyed:
+
+	media_entity_cleanup(&sd->entity);
+
 A device (bridge) driver needs to register the v4l2_subdev with the
 v4l2_device:
 
@@ -272,6 +291,9 @@ This can fail if the subdev module disappeared before it could be registered.
 After this function was called successfully the subdev->dev field points to
 the v4l2_device.
 
+If the v4l2_device parent device has a non-NULL mdev field, the sub-device
+entity will be automatically registered with the media device.
+
 You can unregister a sub-device using:
 
 	v4l2_device_unregister_subdev(sd);
diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 91452cd..ccfa606 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -114,8 +114,9 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
 EXPORT_SYMBOL_GPL(v4l2_device_unregister);
 
 int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
-						struct v4l2_subdev *sd)
+				struct v4l2_subdev *sd)
 {
+	struct media_entity *entity = &sd->entity;
 	struct video_device *vdev;
 	int ret = 0;
 
@@ -129,6 +130,15 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	if (!try_module_get(sd->owner))
 		return -ENODEV;
 
+	/* Register the entity. */
+	if (v4l2_dev->mdev) {
+		ret = media_device_register_entity(v4l2_dev->mdev, entity);
+		if (ret < 0) {
+			module_put(sd->owner);
+			return ret;
+		}
+	}
+
 	sd->v4l2_dev = v4l2_dev;
 	spin_lock(&v4l2_dev->lock);
 	list_add_tail(&sd->list, &v4l2_dev->subdevs);
@@ -147,22 +157,30 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 			v4l2_device_unregister_subdev(sd);
 	}
 
-	return ret;
+	entity->v4l.major = VIDEO_MAJOR;
+	entity->v4l.minor = vdev->minor;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
 
 void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 {
+	struct v4l2_device *v4l2_dev;
+
 	/* return if it isn't registered */
 	if (sd == NULL || sd->v4l2_dev == NULL)
 		return;
 
-	spin_lock(&sd->v4l2_dev->lock);
+	v4l2_dev = sd->v4l2_dev;
+
+	spin_lock(&v4l2_dev->lock);
 	list_del(&sd->list);
-	spin_unlock(&sd->v4l2_dev->lock);
+	spin_unlock(&v4l2_dev->lock);
 	sd->v4l2_dev = NULL;
 
 	module_put(sd->owner);
+	if (v4l2_dev->mdev)
+		media_device_unregister_entity(&sd->entity);
 	video_unregister_device(&sd->devnode);
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index b063195..1efa267 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -32,7 +32,8 @@ static int subdev_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
-	struct v4l2_fh *vfh;
+	struct media_entity *entity;
+	struct v4l2_fh *vfh = NULL;
 	int ret;
 
 	if (!sd->initialized)
@@ -59,10 +60,17 @@ static int subdev_open(struct file *file)
 		file->private_data = vfh;
 	}
 
+	entity = media_entity_get(&sd->entity);
+	if (!entity) {
+		ret = -EBUSY;
+		goto err;
+	}
+
 	return 0;
 
 err:
 	if (vfh != NULL) {
+		v4l2_fh_del(vfh);
 		v4l2_fh_exit(vfh);
 		kfree(vfh);
 	}
@@ -72,8 +80,12 @@ err:
 
 static int subdev_close(struct file *file)
 {
+	struct video_device *vdev = video_devdata(file);
+	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
 	struct v4l2_fh *vfh = file->private_data;
 
+	media_entity_put(&sd->entity);
+
 	if (vfh != NULL) {
 		v4l2_fh_del(vfh);
 		v4l2_fh_exit(vfh);
@@ -172,5 +184,18 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
 	sd->grp_id = 0;
 	sd->priv = NULL;
 	sd->initialized = 1;
+	sd->entity.name = sd->name;
+	sd->entity.type = MEDIA_ENTITY_TYPE_SUBDEV;
 }
 EXPORT_SYMBOL(v4l2_subdev_init);
+
+int v4l2_subdev_set_power(struct media_entity *entity, int power)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+
+	dev_dbg(entity->parent->dev,
+		"%s power%s\n", entity->name, power ? "on" : "off");
+
+	return v4l2_subdev_call(sd, core, s_power, power);
+}
+EXPORT_SYMBOL_GPL(v4l2_subdev_set_power);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 55a8c93..f9e1897 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -21,6 +21,7 @@
 #ifndef _V4L2_SUBDEV_H
 #define _V4L2_SUBDEV_H
 
+#include <media/media-entity.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-mediabus.h>
@@ -421,6 +422,8 @@ struct v4l2_subdev_ops {
    stand-alone or embedded in a larger struct.
  */
 struct v4l2_subdev {
+	struct media_entity entity;
+
 	struct list_head list;
 	struct module *owner;
 	u32 flags;
@@ -439,6 +442,8 @@ struct v4l2_subdev {
 	unsigned int nevents;
 };
 
+#define media_entity_to_v4l2_subdev(ent) \
+	container_of(ent, struct v4l2_subdev, entity)
 #define vdev_to_v4l2_subdev(vdev) \
 	container_of(vdev, struct v4l2_subdev, devnode)
 
@@ -457,6 +462,8 @@ static inline void *v4l2_get_subdevdata(const struct v4l2_subdev *sd)
 void v4l2_subdev_init(struct v4l2_subdev *sd,
 		      const struct v4l2_subdev_ops *ops);
 
+int v4l2_subdev_set_power(struct media_entity *entity, int power);
+
 /* Call an ops of a v4l2_subdev, doing the right checks against
    NULL pointers.
 
-- 
1.7.1

