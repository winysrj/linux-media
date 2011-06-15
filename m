Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50394 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab1FOIgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 04:36:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, hdegoede@redhat.com, sakari.ailus@iki.fi
Subject: [PATCH] v4l: Don't access media entity after is has been destroyed
Date: Wed, 15 Jun 2011 10:36:26 +0200
Message-Id: <1308126986-7679-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <201106131809.28074.laurent.pinchart@ideasonboard.com>
References: <201106131809.28074.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Entities associated with video device nodes are unregistered in
video_unregister_device(). This destroys the entity even though it can
still be accessed through open video device nodes.

Move the media_device_unregister_entity() call from
video_unregister_device() to v4l2_device_release() to ensure that the
entity isn't unregistered until the last reference to the video device
is released.

Also remove the media_entity_get()/put() calls from v4l2-dev.c. Those
functions were designed for subdevs, to avoid a parent module from being
removed while still accessible through board code. They're not currently
needed for video device nodes, and will oops when a hotpluggable device
is disconnected during streaming, as media_entity_put() called in
v4l2_device_release() tries to access entity->parent->dev->driver which
is set to NULL when the device is disconnected.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-dev.c |   36 +++++++-----------------------------
 1 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 19d5ae2..5dc1fa1 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -167,6 +167,12 @@ static void v4l2_device_release(struct device *cd)
 
 	mutex_unlock(&videodev_lock);
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
+	    vdev->vfl_type != VFL_TYPE_SUBDEV)
+		media_device_unregister_entity(&vdev->entity);
+#endif
+
 	/* Release video_device and perform other
 	   cleanups as needed. */
 	vdev->release(vdev);
@@ -405,17 +411,6 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 	/* and increase the device refcount */
 	video_get(vdev);
 	mutex_unlock(&videodev_lock);
-#if defined(CONFIG_MEDIA_CONTROLLER)
-	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
-	    vdev->vfl_type != VFL_TYPE_SUBDEV) {
-		entity = media_entity_get(&vdev->entity);
-		if (!entity) {
-			ret = -EBUSY;
-			video_put(vdev);
-			return ret;
-		}
-	}
-#endif
 	if (vdev->fops->open) {
 		if (vdev->lock && mutex_lock_interruptible(vdev->lock)) {
 			ret = -ERESTARTSYS;
@@ -431,14 +426,8 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 
 err:
 	/* decrease the refcount in case of an error */
-	if (ret) {
-#if defined(CONFIG_MEDIA_CONTROLLER)
-		if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
-		    vdev->vfl_type != VFL_TYPE_SUBDEV)
-			media_entity_put(entity);
-#endif
+	if (ret)
 		video_put(vdev);
-	}
 	return ret;
 }
 
@@ -455,11 +444,6 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 		if (vdev->lock)
 			mutex_unlock(vdev->lock);
 	}
-#if defined(CONFIG_MEDIA_CONTROLLER)
-	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
-	    vdev->vfl_type != VFL_TYPE_SUBDEV)
-		media_entity_put(&vdev->entity);
-#endif
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
 	video_put(vdev);
@@ -754,12 +738,6 @@ void video_unregister_device(struct video_device *vdev)
 	if (!vdev || !video_is_registered(vdev))
 		return;
 
-#if defined(CONFIG_MEDIA_CONTROLLER)
-	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
-	    vdev->vfl_type != VFL_TYPE_SUBDEV)
-		media_device_unregister_entity(&vdev->entity);
-#endif
-
 	mutex_lock(&videodev_lock);
 	/* This must be in a critical section to prevent a race with v4l2_open.
 	 * Once this bit has been cleared video_get may never be called again.
-- 
1.7.3.4

