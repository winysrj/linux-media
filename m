Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51334 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601Ab0GUOfo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jul 2010 10:35:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v2 09/10] v4l: Make video_device inherit from media_entity
Date: Wed, 21 Jul 2010 16:35:34 +0200
Message-Id: <1279722935-28493-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 devices are media entities. As such they need to inherit from
(include) the media_entity structure.

When registering/unregistering the device, the media entity is
automatically registered/unregistered. The entity is acquired on device
open and released on device close.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 Documentation/video4linux/v4l2-framework.txt |   38 +++++++++++++++++++++++--
 drivers/media/video/v4l2-dev.c               |   35 ++++++++++++++++++++++-
 include/media/v4l2-dev.h                     |    6 ++++
 3 files changed, 74 insertions(+), 5 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 8a3f14e..0d9b8ce 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -71,6 +71,10 @@ sub-device instances, the video_device struct stores V4L2 device node data
 and in the future a v4l2_fh struct will keep track of filehandle instances
 (this is not yet implemented).
 
+The V4L2 framework also optionally integrates with the media framework. If a
+driver sets the struct v4l2_device mdev field, sub-devices and video nodes
+will automatically appear in the media framework as entities.
+
 
 struct v4l2_device
 ------------------
@@ -84,11 +88,14 @@ You must register the device instance:
 	v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev);
 
 Registration will initialize the v4l2_device struct. If the dev->driver_data
-field is NULL, it will be linked to v4l2_dev. Drivers that use the media
-device framework in addition to the V4L2 framework need to set
+field is NULL, it will be linked to v4l2_dev.
+
+Drivers that want integration with the media device framework need to set
 dev->driver_data manually to point to the driver-specific device structure
 that embed the struct v4l2_device instance. This is achieved by a
-dev_set_drvdata() call before registering the V4L2 device instance.
+dev_set_drvdata() call before registering the V4L2 device instance. They must
+also set the struct v4l2_device mdev field to point to a properly initialized
+and registered media_device instance.
 
 If v4l2_dev->name is empty then it will be set to a value derived from dev
 (driver name followed by the bus_id, to be precise). If you set it up before
@@ -523,6 +530,21 @@ If you use v4l2_ioctl_ops, then you should set either .unlocked_ioctl or
 The v4l2_file_operations struct is a subset of file_operations. The main
 difference is that the inode argument is omitted since it is never used.
 
+If integration with the media framework is needed, you must initialize the
+media_entity struct embedded in the video_device struct (entity field) by
+calling media_entity_init():
+
+	struct media_entity_pad *pad = &my_vdev->pad;
+	int err;
+
+	err = media_entity_init(&vdev->entity, 1, pad, 0);
+
+The pads array must have been previously initialized. There is no need to
+manually set the struct media_entity type, subtype and name fields.
+
+A reference to the entity will be automatically acquired/released when the
+video device is opened/closed.
+
 
 video_device registration
 -------------------------
@@ -536,6 +558,9 @@ for you.
 		return err;
 	}
 
+If the v4l2_device parent device has a non-NULL mdev field, the video device
+entity will be automatically registered with the media device.
+
 Which device is registered depends on the type argument. The following
 types exist:
 
@@ -613,6 +638,13 @@ those will still be passed on since some buffer ioctls may still be needed.
 When the last user of the video device node exits, then the vdev->release()
 callback is called and you can do the final cleanup there.
 
+Don't forget to cleanup the media entity associated with the video device if
+it has been initialized:
+
+	media_entity_cleanup(&vdev->entity);
+
+This can be done from the release callback.
+
 
 video_device helper functions
 -----------------------------
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index bcd47a0..e70424c 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -269,6 +269,7 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 static int v4l2_open(struct inode *inode, struct file *filp)
 {
 	struct video_device *vdev;
+	struct media_entity *entity = NULL;
 	int ret = 0;
 
 	/* Check if the video device is available */
@@ -283,12 +284,22 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 	/* and increase the device refcount */
 	video_get(vdev);
 	mutex_unlock(&videodev_lock);
+	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev) {
+		entity = media_entity_get(&vdev->entity);
+		if (!entity) {
+			ret = -EBUSY;
+			video_put(vdev);
+			return ret;
+		}
+	}
 	if (vdev->fops->open)
 		ret = vdev->fops->open(filp);
 
 	/* decrease the refcount in case of an error */
-	if (ret)
+	if (ret) {
+		media_entity_put(entity);
 		video_put(vdev);
+	}
 	return ret;
 }
 
@@ -301,6 +312,9 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 	if (vdev->fops->release)
 		vdev->fops->release(filp);
 
+	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
+		media_entity_put(&vdev->entity);
+
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
 	video_put(vdev);
@@ -563,11 +577,25 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 		printk(KERN_WARNING "%s: requested %s%d, got %s\n", __func__,
 			name_base, nr, video_device_node_name(vdev));
 
-	/* Part 5: Activate this minor. The char device can now be used. */
+	/* Part 5: Register the entity. */
+	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev) {
+		vdev->entity.type = MEDIA_ENTITY_TYPE_NODE;
+		vdev->entity.subtype = MEDIA_ENTITY_SUBTYPE_NODE_V4L;
+		vdev->entity.name = vdev->name;
+		vdev->entity.v4l.major = VIDEO_MAJOR;
+		vdev->entity.v4l.minor = vdev->minor;
+		ret = media_device_register_entity(vdev->v4l2_dev->mdev,
+			&vdev->entity);
+		if (ret < 0)
+			printk(KERN_ERR "error\n"); /* TODO */
+	}
+
+	/* Part 6: Activate this minor. The char device can now be used. */
 	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
 	mutex_lock(&videodev_lock);
 	video_device[vdev->minor] = vdev;
 	mutex_unlock(&videodev_lock);
+
 	return 0;
 
 cleanup:
@@ -595,6 +623,9 @@ void video_unregister_device(struct video_device *vdev)
 	if (!vdev || !video_is_registered(vdev))
 		return;
 
+	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
+		media_device_unregister_entity(&vdev->entity);
+
 	clear_bit(V4L2_FL_REGISTERED, &vdev->flags);
 	device_unregister(&vdev->dev);
 }
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 195fa56..447b154 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -16,6 +16,8 @@
 #include <linux/mutex.h>
 #include <linux/videodev2.h>
 
+#include <media/media-entity.h>
+
 #define VIDEO_MAJOR	81
 
 #define VFL_TYPE_GRABBER	0
@@ -57,6 +59,8 @@ struct v4l2_file_operations {
 
 struct video_device
 {
+	struct media_entity entity;
+
 	/* device ops */
 	const struct v4l2_file_operations *fops;
 
@@ -96,6 +100,8 @@ struct video_device
 	const struct v4l2_ioctl_ops *ioctl_ops;
 };
 
+#define media_entity_to_video_device(entity) \
+	container_of(entity, struct video_device, entity)
 /* dev to video-device */
 #define to_video_device(cd) container_of(cd, struct video_device, dev)
 
-- 
1.7.1

