Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:56559 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751173AbeEVIOy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 04:14:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 5/5] v4l2-ioctl: delete unused v4l2_disable_ioctl_locking
Date: Tue, 22 May 2018 10:14:51 +0200
Message-Id: <20180522081451.94794-6-hverkuil@xs4all.nl>
In-Reply-To: <20180522081451.94794-1-hverkuil@xs4all.nl>
References: <20180522081451.94794-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The last user of this 'feature' was the gspca driver. Now that
that driver has been converted to vb2 we can delete this code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |  2 --
 include/media/v4l2-dev.h             | 15 ---------------
 2 files changed, 17 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 212aac1d22c1..c23fbfe90a9e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2666,8 +2666,6 @@ struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev, unsigned cmd)
 {
 	if (_IOC_NR(cmd) >= V4L2_IOCTLS)
 		return vdev->lock;
-	if (test_bit(_IOC_NR(cmd), vdev->disable_locking))
-		return NULL;
 	if (vdev->queue && vdev->queue->lock &&
 			(v4l2_ioctls[_IOC_NR(cmd)].flags & INFO_FL_QUEUE))
 		return vdev->queue->lock;
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 73073f6ee48c..30423aefe7c5 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -238,7 +238,6 @@ struct v4l2_file_operations {
  * @ioctl_ops: pointer to &struct v4l2_ioctl_ops with ioctl callbacks
  *
  * @valid_ioctls: bitmap with the valid ioctls for this device
- * @disable_locking: bitmap with the ioctls that don't require locking
  * @lock: pointer to &struct mutex serialization lock
  *
  * .. note::
@@ -291,7 +290,6 @@ struct video_device
 	const struct v4l2_ioctl_ops *ioctl_ops;
 	DECLARE_BITMAP(valid_ioctls, BASE_VIDIOC_PRIVATE);
 
-	DECLARE_BITMAP(disable_locking, BASE_VIDIOC_PRIVATE);
 	struct mutex *lock;
 };
 
@@ -446,19 +444,6 @@ void video_device_release_empty(struct video_device *vdev);
  */
 bool v4l2_is_known_ioctl(unsigned int cmd);
 
-/** v4l2_disable_ioctl_locking - mark that a given command
- *	shouldn't use core locking
- *
- * @vdev: pointer to &struct video_device
- * @cmd: ioctl command
- */
-static inline void v4l2_disable_ioctl_locking(struct video_device *vdev,
-					      unsigned int cmd)
-{
-	if (_IOC_NR(cmd) < BASE_VIDIOC_PRIVATE)
-		set_bit(_IOC_NR(cmd), vdev->disable_locking);
-}
-
 /**
  * v4l2_disable_ioctl- mark that a given command isn't implemented.
  *	shouldn't use core locking
-- 
2.17.0
