Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36563 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1DKO0Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 10:26:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH] v4l: Don't register media entities for subdev device nodes
Date: Mon, 11 Apr 2011 16:26:30 +0200
Message-Id: <1302531990-5395-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Subdevs already have their own entity, don't register as second one when
registering the subdev device node.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-dev.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 498e674..6dc7196 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -389,7 +389,8 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 	video_get(vdev);
 	mutex_unlock(&videodev_lock);
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev) {
+	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
+	    vdev->vfl_type != VFL_TYPE_SUBDEV) {
 		entity = media_entity_get(&vdev->entity);
 		if (!entity) {
 			ret = -EBUSY;
@@ -415,7 +416,8 @@ err:
 	/* decrease the refcount in case of an error */
 	if (ret) {
 #if defined(CONFIG_MEDIA_CONTROLLER)
-		if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
+		if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
+		    vdev->vfl_type != VFL_TYPE_SUBDEV)
 			media_entity_put(entity);
 #endif
 		video_put(vdev);
@@ -437,7 +439,8 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 			mutex_unlock(vdev->lock);
 	}
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
+	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
+	    vdev->vfl_type != VFL_TYPE_SUBDEV)
 		media_entity_put(&vdev->entity);
 #endif
 	/* decrease the refcount unconditionally since the release()
@@ -686,7 +689,8 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	/* Part 5: Register the entity. */
-	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev) {
+	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
+	    vdev->vfl_type != VFL_TYPE_SUBDEV) {
 		vdev->entity.type = MEDIA_ENT_T_DEVNODE_V4L;
 		vdev->entity.name = vdev->name;
 		vdev->entity.v4l.major = VIDEO_MAJOR;
@@ -733,7 +737,8 @@ void video_unregister_device(struct video_device *vdev)
 		return;
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
+	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
+	    vdev->vfl_type != VFL_TYPE_SUBDEV)
 		media_device_unregister_entity(&vdev->entity);
 #endif
 
-- 
1.7.3.4

