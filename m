Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:39106 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751990AbbDUNFR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:05:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 11/15] v4l2-device: keep track of registered video_devices
Date: Tue, 21 Apr 2015 14:58:54 +0200
Message-Id: <1429621138-17213-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
References: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In order to efficiently handle V4L2_REQ_CMD_QUEUE we need to know which
video_device structs are registered for the given v4l2_device struct.

So create a list of vdevs in v4l2_device and add/remove each video_device
there as it is registered/unregistered.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c    | 8 ++++++++
 drivers/media/v4l2-core/v4l2-device.c | 1 +
 include/media/v4l2-dev.h              | 3 +++
 include/media/v4l2-device.h           | 2 ++
 4 files changed, 14 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index ff206f1..a11e35d 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -768,6 +768,8 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	if (WARN_ON(!vdev->v4l2_dev))
 		return -EINVAL;
 
+	INIT_LIST_HEAD(&vdev->list);
+
 	/* v4l2_fh support */
 	spin_lock_init(&vdev->fh_lock);
 	INIT_LIST_HEAD(&vdev->fh_list);
@@ -927,6 +929,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 #endif
 	/* Part 6: Activate this minor. The char device can now be used. */
 	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
+	spin_lock(&vdev->v4l2_dev->lock);
+	list_add_tail(&vdev->list, &vdev->v4l2_dev->vdevs);
+	spin_unlock(&vdev->v4l2_dev->lock);
 
 	return 0;
 
@@ -962,6 +967,9 @@ void video_unregister_device(struct video_device *vdev)
 	 */
 	clear_bit(V4L2_FL_REGISTERED, &vdev->flags);
 	mutex_unlock(&videodev_lock);
+	spin_lock(&vdev->v4l2_dev->lock);
+	list_del(&vdev->list);
+	spin_unlock(&vdev->v4l2_dev->lock);
 	device_unregister(&vdev->dev);
 }
 EXPORT_SYMBOL(video_unregister_device);
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 5b0a30b..cdb2d72 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -36,6 +36,7 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
 		return -EINVAL;
 
 	INIT_LIST_HEAD(&v4l2_dev->subdevs);
+	INIT_LIST_HEAD(&v4l2_dev->vdevs);
 	spin_lock_init(&v4l2_dev->lock);
 	v4l2_prio_init(&v4l2_dev->prio);
 	kref_init(&v4l2_dev->ref);
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index acbcd2f..a5a3401 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -84,6 +84,9 @@ struct v4l2_file_operations {
 
 struct video_device
 {
+	/* links into v4l2_device vdevs list */
+	struct list_head list;
+
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	struct media_entity entity;
 #endif
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 603e7f3..6484e54 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -46,6 +46,8 @@ struct v4l2_device {
 #endif
 	/* used to keep track of the registered subdevs */
 	struct list_head subdevs;
+	/* used to keep track of the registered video_devices */
+	struct list_head vdevs;
 	/* lock this struct; can be used by the driver as well if this
 	   struct is embedded into a larger struct. */
 	spinlock_t lock;
-- 
2.1.4

