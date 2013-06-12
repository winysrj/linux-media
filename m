Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4084 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3FLPCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jun 2013 11:02:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 10/12] v4l2: always require v4l2_dev, rename parent to dev_parent
Date: Wed, 12 Jun 2013 17:01:00 +0200
Message-Id: <1371049262-5799-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
References: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The last set of drivers still using the parent field of video_device instead
of the v4l2_dev field have been converted, so v4l2_dev is now always set.

A proper pointer to v4l2_dev is necessary these days otherwise the advanced
debugging ioctls will not work when addressing sub-devices. It also ensures
that the core can always go from a video_device struct to the top-level
v4l2_device struct.

There is still one single use case for the parent pointer: if there are
multiple busses, each being the parent of one or more video nodes, and if
they all share the same v4l2_device struct. In that case one still needs a
parent pointer since the v4l2_device struct can only refer to a single
parent device. The cx88 driver is one such case. Unfortunately, the cx88
failed to set the parent pointer since 3.6. The next patch will correct this.

In order to support this use-case the parent pointer is only renamed to
dev_parent, not removed altogether. It has been renamed to ensure that the
compiler will catch any (possibly out-of-tree) drivers that were missed during
the conversion.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-dev.c   |   34 +++++++++++++++-------------------
 drivers/media/v4l2-core/v4l2-ioctl.c |    7 +------
 include/media/v4l2-dev.h             |    4 ++--
 3 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 2f3fac5..8856ef1 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -495,8 +495,8 @@ static const struct file_operations v4l2_fops = {
 };
 
 /**
- * get_index - assign stream index number based on parent device
- * @vdev: video_device to assign index number to, vdev->parent should be assigned
+ * get_index - assign stream index number based on v4l2_dev
+ * @vdev: video_device to assign index number to, vdev->v4l2_dev should be assigned
  *
  * Note that when this is called the new device has not yet been registered
  * in the video_device array, but it was able to obtain a minor number.
@@ -514,15 +514,11 @@ static int get_index(struct video_device *vdev)
 	static DECLARE_BITMAP(used, VIDEO_NUM_DEVICES);
 	int i;
 
-	/* Some drivers do not set the parent. In that case always return 0. */
-	if (vdev->parent == NULL)
-		return 0;
-
 	bitmap_zero(used, VIDEO_NUM_DEVICES);
 
 	for (i = 0; i < VIDEO_NUM_DEVICES; i++) {
 		if (video_device[i] != NULL &&
-		    video_device[i]->parent == vdev->parent) {
+		    video_device[i]->v4l2_dev == vdev->v4l2_dev) {
 			set_bit(video_device[i]->index, used);
 		}
 	}
@@ -776,6 +772,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	/* the release callback MUST be present */
 	if (WARN_ON(!vdev->release))
 		return -EINVAL;
+	/* the v4l2_dev pointer MUST be present */
+	if (WARN_ON(!vdev->v4l2_dev))
+		return -EINVAL;
 
 	/* v4l2_fh support */
 	spin_lock_init(&vdev->fh_lock);
@@ -803,16 +802,14 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 
 	vdev->vfl_type = type;
 	vdev->cdev = NULL;
-	if (vdev->v4l2_dev) {
-		if (vdev->v4l2_dev->dev)
-			vdev->parent = vdev->v4l2_dev->dev;
-		if (vdev->ctrl_handler == NULL)
-			vdev->ctrl_handler = vdev->v4l2_dev->ctrl_handler;
-		/* If the prio state pointer is NULL, then use the v4l2_device
-		   prio state. */
-		if (vdev->prio == NULL)
-			vdev->prio = &vdev->v4l2_dev->prio;
-	}
+	if (vdev->dev_parent == NULL)
+		vdev->dev_parent = vdev->v4l2_dev->dev;
+	if (vdev->ctrl_handler == NULL)
+		vdev->ctrl_handler = vdev->v4l2_dev->ctrl_handler;
+	/* If the prio state pointer is NULL, then use the v4l2_device
+	   prio state. */
+	if (vdev->prio == NULL)
+		vdev->prio = &vdev->v4l2_dev->prio;
 
 	/* Part 2: find a free minor, device node number and device index. */
 #ifdef CONFIG_VIDEO_FIXED_MINOR_RANGES
@@ -897,8 +894,7 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	/* Part 4: register the device with sysfs */
 	vdev->dev.class = &video_class;
 	vdev->dev.devt = MKDEV(VIDEO_MAJOR, vdev->minor);
-	if (vdev->parent)
-		vdev->dev.parent = vdev->parent;
+	vdev->dev.parent = vdev->dev_parent;
 	dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);
 	ret = device_register(&vdev->dev);
 	if (ret < 0) {
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 19e2988..3dcdaa3 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1845,12 +1845,7 @@ static int v4l_dbg_g_chip_info(const struct v4l2_ioctl_ops *ops,
 			p->flags |= V4L2_CHIP_FL_WRITABLE;
 		if (ops->vidioc_g_register)
 			p->flags |= V4L2_CHIP_FL_READABLE;
-		if (vfd->v4l2_dev)
-			strlcpy(p->name, vfd->v4l2_dev->name, sizeof(p->name));
-		else if (vfd->parent)
-			strlcpy(p->name, vfd->parent->driver->name, sizeof(p->name));
-		else
-			strlcpy(p->name, "bridge", sizeof(p->name));
+		strlcpy(p->name, vfd->v4l2_dev->name, sizeof(p->name));
 		if (ops->vidioc_g_chip_info)
 			return ops->vidioc_g_chip_info(file, fh, arg);
 		if (p->match.addr)
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index b2c3776..c768c9f 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -96,9 +96,9 @@ struct video_device
 	struct device dev;		/* v4l device */
 	struct cdev *cdev;		/* character device */
 
-	/* Set either parent or v4l2_dev if your driver uses v4l2_device */
-	struct device *parent;		/* device parent */
 	struct v4l2_device *v4l2_dev;	/* v4l2_device parent */
+	/* Only set parent if that can't be deduced from v4l2_dev */
+	struct device *dev_parent;	/* device parent */
 
 	/* Control handler associated with this device node. May be NULL. */
 	struct v4l2_ctrl_handler *ctrl_handler;
-- 
1.7.10.4

