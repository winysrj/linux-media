Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58172 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab1BNMVS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v9 11/12] v4l: Make video_device inherit from media_entity
Date: Mon, 14 Feb 2011 13:21:06 +0100
Message-Id: <1297686067-9666-12-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686067-9666-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686067-9666-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

V4L2 devices are media entities. As such they need to inherit from
(include) the media_entity structure.

When registering/unregistering the device, the media entity is
automatically registered/unregistered. The entity is acquired on device
open and released on device close.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/video4linux/v4l2-framework.txt |   38 ++++++++++++++++++--
 drivers/media/video/v4l2-dev.c               |   49 +++++++++++++++++++++++--
 include/media/v4l2-dev.h                     |    7 ++++
 3 files changed, 87 insertions(+), 7 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 7de55cf..0627081 100644
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
@@ -530,6 +537,21 @@ If you use v4l2_ioctl_ops, then you should set either .unlocked_ioctl or
 The v4l2_file_operations struct is a subset of file_operations. The main
 difference is that the inode argument is omitted since it is never used.
 
+If integration with the media framework is needed, you must initialize the
+media_entity struct embedded in the video_device struct (entity field) by
+calling media_entity_init():
+
+	struct media_pad *pad = &my_vdev->pad;
+	int err;
+
+	err = media_entity_init(&vdev->entity, 1, pad, 0);
+
+The pads array must have been previously initialized. There is no need to
+manually set the struct media_entity type and name fields.
+
+A reference to the entity will be automatically acquired/released when the
+video device is opened/closed.
+
 v4l2_file_operations and locking
 --------------------------------
 
@@ -559,6 +581,9 @@ for you.
 		return err;
 	}
 
+If the v4l2_device parent device has a non-NULL mdev field, the video device
+entity will be automatically registered with the media device.
+
 Which device is registered depends on the type argument. The following
 types exist:
 
@@ -634,6 +659,13 @@ release, of course) will return an error as well.
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
index abe04ef..e405b80 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -303,6 +303,9 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 static int v4l2_open(struct inode *inode, struct file *filp)
 {
 	struct video_device *vdev;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_entity *entity = NULL;
+#endif
 	int ret = 0;
 
 	/* Check if the video device is available */
@@ -316,6 +319,16 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 	/* and increase the device refcount */
 	video_get(vdev);
 	mutex_unlock(&videodev_lock);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev) {
+		entity = media_entity_get(&vdev->entity);
+		if (!entity) {
+			ret = -EBUSY;
+			video_put(vdev);
+			return ret;
+		}
+	}
+#endif
 	if (vdev->fops->open) {
 		if (vdev->lock && mutex_lock_interruptible(vdev->lock)) {
 			ret = -ERESTARTSYS;
@@ -331,8 +344,13 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 
 err:
 	/* decrease the refcount in case of an error */
-	if (ret)
+	if (ret) {
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
+			media_entity_put(entity);
+#endif
 		video_put(vdev);
+	}
 	return ret;
 }
 
@@ -349,7 +367,10 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 		if (vdev->lock)
 			mutex_unlock(vdev->lock);
 	}
-
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
+		media_entity_put(&vdev->entity);
+#endif
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
 	video_put(vdev);
@@ -585,12 +606,27 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	if (nr != -1 && nr != vdev->num && warn_if_nr_in_use)
 		printk(KERN_WARNING "%s: requested %s%d, got %s\n", __func__,
 			name_base, nr, video_device_node_name(vdev));
-
-	/* Part 5: Activate this minor. The char device can now be used. */
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	/* Part 5: Register the entity. */
+	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev) {
+		vdev->entity.type = MEDIA_ENT_T_DEVNODE_V4L;
+		vdev->entity.name = vdev->name;
+		vdev->entity.v4l.major = VIDEO_MAJOR;
+		vdev->entity.v4l.minor = vdev->minor;
+		ret = media_device_register_entity(vdev->v4l2_dev->mdev,
+			&vdev->entity);
+		if (ret < 0)
+			printk(KERN_WARNING
+			       "%s: media_device_register_entity failed\n",
+			       __func__);
+	}
+#endif
+	/* Part 6: Activate this minor. The char device can now be used. */
 	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
 	mutex_lock(&videodev_lock);
 	video_device[vdev->minor] = vdev;
 	mutex_unlock(&videodev_lock);
+
 	return 0;
 
 cleanup:
@@ -618,6 +654,11 @@ void video_unregister_device(struct video_device *vdev)
 	if (!vdev || !video_is_registered(vdev))
 		return;
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
+		media_device_unregister_entity(&vdev->entity);
+#endif
+
 	mutex_lock(&videodev_lock);
 	/* This must be in a critical section to prevent a race with v4l2_open.
 	 * Once this bit has been cleared video_get may never be called again.
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 4fe6831..51b2c51 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -16,6 +16,8 @@
 #include <linux/mutex.h>
 #include <linux/videodev2.h>
 
+#include <media/media-entity.h>
+
 #define VIDEO_MAJOR	81
 
 #define VFL_TYPE_GRABBER	0
@@ -55,6 +57,9 @@ struct v4l2_file_operations {
 
 struct video_device
 {
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_entity entity;
+#endif
 	/* device ops */
 	const struct v4l2_file_operations *fops;
 
@@ -100,6 +105,8 @@ struct video_device
 	struct mutex *lock;
 };
 
+#define media_entity_to_video_device(entity) \
+	container_of(entity, struct video_device, entity)
 /* dev to video-device */
 #define to_video_device(cd) container_of(cd, struct video_device, dev)
 
-- 
1.7.3.4

