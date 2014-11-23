Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:59428 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbaKWMOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 07:14:07 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 87F492A0083
	for <linux-media@vger.kernel.org>; Sun, 23 Nov 2014 13:14:01 +0100 (CET)
Message-ID: <5471CF89.30209@xs4all.nl>
Date: Sun, 23 Nov 2014 13:14:01 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l2-dev: vdev->v4l2_dev is always set, so simplify code.
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These days vdev->v4l2_dev must always be set. This means that some
old code that still tests for a NULL vdev->v4l2_dev can be removed
or simplified.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 33617c3..9aa530a 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -194,7 +194,7 @@ static void v4l2_device_release(struct device *cd)
 	mutex_unlock(&videodev_lock);
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	if (v4l2_dev && v4l2_dev->mdev &&
+	if (v4l2_dev->mdev &&
 	    vdev->vfl_type != VFL_TYPE_SUBDEV)
 		media_device_unregister_entity(&vdev->entity);
 #endif
@@ -207,7 +207,7 @@ static void v4l2_device_release(struct device *cd)
 	 * TODO: In the long run all drivers that use v4l2_device should use the
 	 * v4l2_device release callback. This check will then be unnecessary.
 	 */
-	if (v4l2_dev && v4l2_dev->release == NULL)
+	if (v4l2_dev->release == NULL)
 		v4l2_dev = NULL;
 
 	/* Release video_device and perform other
@@ -360,27 +360,22 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		 * hack but it will have to do for those drivers that are not
 		 * yet converted to use unlocked_ioctl.
 		 *
-		 * There are two options: if the driver implements struct
-		 * v4l2_device, then the lock defined there is used to
-		 * serialize the ioctls. Otherwise the v4l2 core lock defined
-		 * below is used. This lock is really bad since it serializes
-		 * completely independent devices.
+		 * All drivers implement struct v4l2_device, so we use the
+		 * lock defined there to serialize the ioctls.
 		 *
-		 * Both variants suffer from the same problem: if the driver
-		 * sleeps, then it blocks all ioctls since the lock is still
-		 * held. This is very common for VIDIOC_DQBUF since that
-		 * normally waits for a frame to arrive. As a result any other
-		 * ioctl calls will proceed very, very slowly since each call
-		 * will have to wait for the VIDIOC_QBUF to finish. Things that
-		 * should take 0.01s may now take 10-20 seconds.
+		 * However, if the driver sleeps, then it blocks all ioctls
+		 * since the lock is still held. This is very common for
+		 * VIDIOC_DQBUF since that normally waits for a frame to arrive.
+		 * As a result any other ioctl calls will proceed very, very
+		 * slowly since each call will have to wait for the VIDIOC_QBUF
+		 * to finish. Things that should take 0.01s may now take 10-20
+		 * seconds.
 		 *
 		 * The workaround is to *not* take the lock for VIDIOC_DQBUF.
 		 * This actually works OK for videobuf-based drivers, since
 		 * videobuf will take its own internal lock.
 		 */
-		static DEFINE_MUTEX(v4l2_ioctl_mutex);
-		struct mutex *m = vdev->v4l2_dev ?
-			&vdev->v4l2_dev->ioctl_lock : &v4l2_ioctl_mutex;
+		struct mutex *m = &vdev->v4l2_dev->ioctl_lock;
 
 		if (cmd != VIDIOC_DQBUF && mutex_lock_interruptible(m))
 			return -ERESTARTSYS;
@@ -938,12 +933,11 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 			name_base, nr, video_device_node_name(vdev));
 
 	/* Increase v4l2_device refcount */
-	if (vdev->v4l2_dev)
-		v4l2_device_get(vdev->v4l2_dev);
+	v4l2_device_get(vdev->v4l2_dev);
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	/* Part 5: Register the entity. */
-	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
+	if (vdev->v4l2_dev->mdev &&
 	    vdev->vfl_type != VFL_TYPE_SUBDEV) {
 		vdev->entity.type = MEDIA_ENT_T_DEVNODE_V4L;
 		vdev->entity.name = vdev->name;
-- 
2.1.3

