Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1394 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab2EKHzl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 12/16] saa7146: support control events and priority handling.
Date: Fri, 11 May 2012 09:55:06 +0200
Message-Id: <b4c0cd9319c76eb4d48fcc64fdfa903d804ebe7d.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
References: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use v4l2_fh which gives you control events and priority handling for free.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146_fops.c  |   18 ++++++++++++------
 drivers/media/common/saa7146_video.c |    4 ++++
 include/media/saa7146_vv.h           |    3 +++
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index 2ea67da..afa922f 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -198,7 +198,6 @@ static int fops_open(struct file *file)
 	struct saa7146_dev *dev = video_drvdata(file);
 	struct saa7146_fh *fh = NULL;
 	int result = 0;
-
 	enum v4l2_buf_type type;
 
 	DEB_EE("file:%p, dev:%s\n", file, video_device_node_name(vdev));
@@ -227,7 +226,9 @@ static int fops_open(struct file *file)
 		goto out;
 	}
 
-	file->private_data = fh;
+	v4l2_fh_init(&fh->fh, vdev);
+
+	file->private_data = &fh->fh;
 	fh->dev = dev;
 
 	if (vdev->vfl_type == VFL_TYPE_VBI) {
@@ -251,6 +252,7 @@ static int fops_open(struct file *file)
 	}
 
 	result = 0;
+	v4l2_fh_add(&fh->fh);
 out:
 	if (fh && result != 0) {
 		kfree(fh);
@@ -280,6 +282,8 @@ static int fops_release(struct file *file)
 		saa7146_video_uops.release(dev,file);
 	}
 
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	module_put(dev->ext->module);
 	file->private_data = NULL;
 	kfree(fh);
@@ -322,12 +326,13 @@ static unsigned int fops_poll(struct file *file, struct poll_table_struct *wait)
 	struct saa7146_fh *fh = file->private_data;
 	struct videobuf_buffer *buf = NULL;
 	struct videobuf_queue *q;
+	unsigned int res = v4l2_ctrl_poll(file, wait);
 
 	DEB_EE("file:%p, poll:%p\n", file, wait);
 
 	if (vdev->vfl_type == VFL_TYPE_VBI) {
 		if( 0 == fh->vbi_q.streaming )
-			return videobuf_poll_stream(file, &fh->vbi_q, wait);
+			return res | videobuf_poll_stream(file, &fh->vbi_q, wait);
 		q = &fh->vbi_q;
 	} else {
 		DEB_D("using video queue\n");
@@ -339,17 +344,17 @@ static unsigned int fops_poll(struct file *file, struct poll_table_struct *wait)
 
 	if (!buf) {
 		DEB_D("buf == NULL!\n");
-		return POLLERR;
+		return res | POLLERR;
 	}
 
 	poll_wait(file, &buf->done, wait);
 	if (buf->state == VIDEOBUF_DONE || buf->state == VIDEOBUF_ERROR) {
 		DEB_D("poll succeeded!\n");
-		return POLLIN|POLLRDNORM;
+		return res | POLLIN | POLLRDNORM;
 	}
 
 	DEB_D("nothing to poll for, buf->state:%d\n", buf->state);
-	return 0;
+	return res;
 }
 
 static ssize_t fops_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
@@ -579,6 +584,7 @@ int saa7146_register_device(struct video_device **vid, struct saa7146_dev* dev,
 	vfd->lock = &dev->v4l2_lock;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->tvnorms = 0;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
 	for (i = 0; i < dev->ext_vv_data->num_stds; i++)
 		vfd->tvnorms |= dev->ext_vv_data->stds[i].id;
 	strlcpy(vfd->name, name, sizeof(vfd->name));
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index 8507990..4ca9a25 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -2,6 +2,8 @@
 
 #include <media/saa7146_vv.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-ctrls.h>
 #include <linux/module.h>
 
 static int max_memory = 32;
@@ -1021,6 +1023,8 @@ const struct v4l2_ioctl_ops saa7146_video_ioctl_ops = {
 	.vidioc_streamon             = vidioc_streamon,
 	.vidioc_streamoff            = vidioc_streamoff,
 	.vidioc_g_parm 		     = vidioc_g_parm,
+	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
 };
 
 /*********************************************************************************/
diff --git a/include/media/saa7146_vv.h b/include/media/saa7146_vv.h
index 2cc32c5..2bbdf30 100644
--- a/include/media/saa7146_vv.h
+++ b/include/media/saa7146_vv.h
@@ -3,6 +3,7 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-fh.h>
 #include <media/saa7146.h>
 #include <media/videobuf-dma-sg.h>
 
@@ -84,6 +85,8 @@ struct saa7146_overlay {
 
 /* per open data */
 struct saa7146_fh {
+	/* Must be the first field! */
+	struct v4l2_fh		fh;
 	struct saa7146_dev	*dev;
 
 	/* video capture */
-- 
1.7.10

