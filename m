Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:51498 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbbDUNFf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:05:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 12/15] v4l2-device: add v4l2_device_req_queue
Date: Tue, 21 Apr 2015 14:58:55 +0200
Message-Id: <1429621138-17213-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
References: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v4l2_device_req_queue() function is a helper that can be used
as the req_queue callback in simple cases: it will walk over all
registered video_devices and call vb2_qbuf_request() for each video
device.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-device.c | 25 +++++++++++++++++++++++++
 include/media/v4l2-device.h           |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index cdb2d72..5f073ad 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -29,6 +29,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/videobuf2-core.h>
 
 int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
 {
@@ -295,3 +296,27 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 		module_put(sd->owner);
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
+
+int v4l2_device_req_queue(struct v4l2_device *v4l2_dev, u16 request)
+{
+	struct video_device *vdev;
+	struct video_device *tmp;
+	int err;
+
+	if (request == 0)
+		return -EINVAL;
+
+	list_for_each_entry_safe(vdev, tmp, &v4l2_dev->vdevs, list) {
+		if (vdev->queue == NULL || !vdev->queue->allow_requests)
+			continue;
+		if (vdev->lock && mutex_lock_interruptible(vdev->lock))
+			return -ERESTARTSYS;
+		err = vb2_qbuf_request(vdev->queue, request, NULL);
+		if (vdev->lock)
+			mutex_unlock(vdev->lock);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_device_req_queue);
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 6484e54..3595475 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -130,6 +130,9 @@ static inline void v4l2_subdev_notify(struct v4l2_subdev *sd,
 		sd->v4l2_dev->notify(sd, notification, arg);
 }
 
+/* For each registered video_device struct call vb2_qbuf_request(). */
+int v4l2_device_req_queue(struct v4l2_device *v4l2_dev, u16 request);
+
 /* Iterate over all subdevs. */
 #define v4l2_device_for_each_subdev(sd, v4l2_dev)			\
 	list_for_each_entry(sd, &(v4l2_dev)->subdevs, list)
-- 
2.1.4

