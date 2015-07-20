Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58815 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755127AbbGTNKt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:10:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/6] fsl-viu: add control event support.
Date: Mon, 20 Jul 2015 15:09:31 +0200
Message-Id: <1437397773-5752-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397773-5752-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397773-5752-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Convert the driver to use v4l2_fh in order to support control events.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/fsl-viu.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 7d0e360..906442e 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -29,6 +29,8 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 #include <media/videobuf-dma-contig.h>
 
 #define DRV_NAME		"fsl_viu"
@@ -154,6 +156,8 @@ struct viu_dev {
 };
 
 struct viu_fh {
+	/* must remain the first field of this struct */
+	struct v4l2_fh		fh;
 	struct viu_dev		*dev;
 
 	/* video capture */
@@ -1199,6 +1203,7 @@ static int viu_open(struct file *file)
 		return -ENOMEM;
 	}
 
+	v4l2_fh_init(&fh->fh, vdev);
 	file->private_data = fh;
 	fh->dev = dev;
 
@@ -1234,6 +1239,7 @@ static int viu_open(struct file *file)
 				       fh->type, V4L2_FIELD_INTERLACED,
 				       sizeof(struct viu_buf), fh,
 				       &fh->dev->lock);
+	v4l2_fh_add(&fh->fh);
 	mutex_unlock(&dev->lock);
 	return 0;
 }
@@ -1266,13 +1272,17 @@ static unsigned int viu_poll(struct file *file, struct poll_table_struct *wait)
 	struct viu_fh *fh = file->private_data;
 	struct videobuf_queue *q = &fh->vb_vidq;
 	struct viu_dev *dev = fh->dev;
-	unsigned int res;
+	unsigned long req_events = poll_requested_events(wait);
+	unsigned int res = v4l2_ctrl_poll(file, wait);
 
 	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
 		return POLLERR;
 
+	if (!(req_events & (POLLIN | POLLRDNORM)))
+		return res;
+
 	mutex_lock(&dev->lock);
-	res = videobuf_poll_stream(file, q, wait);
+	res |= videobuf_poll_stream(file, q, wait);
 	mutex_unlock(&dev->lock);
 	return res;
 }
@@ -1287,6 +1297,8 @@ static int viu_release(struct file *file)
 	viu_stop_dma(dev);
 	videobuf_stop(&fh->vb_vidq);
 	videobuf_mmap_free(&fh->vb_vidq);
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	mutex_unlock(&dev->lock);
 
 	kfree(fh);
@@ -1367,6 +1379,9 @@ static const struct v4l2_ioctl_ops viu_ioctl_ops = {
 	.vidioc_s_input       = vidioc_s_input,
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
+	.vidioc_log_status    = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device viu_template = {
@@ -1468,7 +1483,7 @@ static int viu_of_probe(struct platform_device *op)
 		goto err_vdev;
 	}
 
-	memcpy(vdev, &viu_template, sizeof(viu_template));
+	*vdev = viu_template;
 
 	vdev->v4l2_dev = &viu_dev->v4l2_dev;
 
-- 
2.1.4

