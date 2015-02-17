Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43928 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932954AbbBQIo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 03:44:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 3/6] uvc gadget: switch to v4l2 core locking
Date: Tue, 17 Feb 2015 09:44:06 +0100
Message-Id: <1424162649-17249-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1424162649-17249-1-git-send-email-hverkuil@xs4all.nl>
References: <1424162649-17249-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Switch this driver over to the V4L2 core locking mechanism in preparation
for switching to unlocked_ioctl. Suggested by Laurent Pinchart.

This patch introduces a new mutex at the struct uvc_video level and
drops the old mutex at the queue level. The new lock is now used for all
ioctl locking and in the release file operation (the driver always has
to take care of locking in file operations, the core only serializes
ioctls).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/usb/gadget/function/f_uvc.c     |  2 +
 drivers/usb/gadget/function/uvc.h       |  1 +
 drivers/usb/gadget/function/uvc_queue.c | 79 ++++++---------------------------
 drivers/usb/gadget/function/uvc_queue.h |  4 +-
 drivers/usb/gadget/function/uvc_v4l2.c  |  3 +-
 drivers/usb/gadget/function/uvc_video.c |  3 +-
 6 files changed, 22 insertions(+), 70 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index 945b3bd..87876371 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -446,6 +446,7 @@ uvc_register_video(struct uvc_device *uvc)
 	video->ioctl_ops = &uvc_v4l2_ioctl_ops;
 	video->release = video_device_release;
 	video->vfl_dir = VFL_DIR_TX;
+	video->lock = &uvc->video.mutex;
 	strlcpy(video->name, cdev->gadget->name, sizeof(video->name));
 
 	uvc->vdev = video;
@@ -817,6 +818,7 @@ static struct usb_function *uvc_alloc(struct usb_function_instance *fi)
 	if (uvc == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&uvc->video.mutex);
 	uvc->state = UVC_STATE_DISCONNECTED;
 	opts = to_f_uvc_opts(fi);
 
diff --git a/drivers/usb/gadget/function/uvc.h b/drivers/usb/gadget/function/uvc.h
index f67695c..3390ecd 100644
--- a/drivers/usb/gadget/function/uvc.h
+++ b/drivers/usb/gadget/function/uvc.h
@@ -115,6 +115,7 @@ struct uvc_video
 	unsigned int width;
 	unsigned int height;
 	unsigned int imagesize;
+	struct mutex mutex;	/* protects frame parameters */
 
 	/* Requests */
 	unsigned int req_size;
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 8ea8b3b..d617c39 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -104,29 +104,16 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 }
 
-static void uvc_wait_prepare(struct vb2_queue *vq)
-{
-	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
-
-	mutex_unlock(&queue->mutex);
-}
-
-static void uvc_wait_finish(struct vb2_queue *vq)
-{
-	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
-
-	mutex_lock(&queue->mutex);
-}
-
 static struct vb2_ops uvc_queue_qops = {
 	.queue_setup = uvc_queue_setup,
 	.buf_prepare = uvc_buffer_prepare,
 	.buf_queue = uvc_buffer_queue,
-	.wait_prepare = uvc_wait_prepare,
-	.wait_finish = uvc_wait_finish,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
 };
 
-int uvcg_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type)
+int uvcg_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
+		    struct mutex *lock)
 {
 	int ret;
 
@@ -135,6 +122,7 @@ int uvcg_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type)
 	queue->queue.drv_priv = queue;
 	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
 	queue->queue.ops = &uvc_queue_qops;
+	queue->queue.lock = lock;
 	queue->queue.mem_ops = &vb2_vmalloc_memops;
 	queue->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
 				     | V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
@@ -142,7 +130,6 @@ int uvcg_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type)
 	if (ret)
 		return ret;
 
-	mutex_init(&queue->mutex);
 	spin_lock_init(&queue->irqlock);
 	INIT_LIST_HEAD(&queue->irqqueue);
 	queue->flags = 0;
@@ -155,9 +142,7 @@ int uvcg_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type)
  */
 void uvcg_free_buffers(struct uvc_video_queue *queue)
 {
-	mutex_lock(&queue->mutex);
 	vb2_queue_release(&queue->queue);
-	mutex_unlock(&queue->mutex);
 }
 
 /*
@@ -168,22 +153,14 @@ int uvcg_alloc_buffers(struct uvc_video_queue *queue,
 {
 	int ret;
 
-	mutex_lock(&queue->mutex);
 	ret = vb2_reqbufs(&queue->queue, rb);
-	mutex_unlock(&queue->mutex);
 
 	return ret ? ret : rb->count;
 }
 
 int uvcg_query_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
 {
-	int ret;
-
-	mutex_lock(&queue->mutex);
-	ret = vb2_querybuf(&queue->queue, buf);
-	mutex_unlock(&queue->mutex);
-
-	return ret;
+	return vb2_querybuf(&queue->queue, buf);
 }
 
 int uvcg_queue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
@@ -191,18 +168,14 @@ int uvcg_queue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
 	unsigned long flags;
 	int ret;
 
-	mutex_lock(&queue->mutex);
 	ret = vb2_qbuf(&queue->queue, buf);
 	if (ret < 0)
-		goto done;
+		return ret;
 
 	spin_lock_irqsave(&queue->irqlock, flags);
 	ret = (queue->flags & UVC_QUEUE_PAUSED) != 0;
 	queue->flags &= ~UVC_QUEUE_PAUSED;
 	spin_unlock_irqrestore(&queue->irqlock, flags);
-
-done:
-	mutex_unlock(&queue->mutex);
 	return ret;
 }
 
@@ -213,13 +186,7 @@ done:
 int uvcg_dequeue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf,
 			int nonblocking)
 {
-	int ret;
-
-	mutex_lock(&queue->mutex);
-	ret = vb2_dqbuf(&queue->queue, buf, nonblocking);
-	mutex_unlock(&queue->mutex);
-
-	return ret;
+	return vb2_dqbuf(&queue->queue, buf, nonblocking);
 }
 
 /*
@@ -231,24 +198,12 @@ int uvcg_dequeue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf,
 unsigned int uvcg_queue_poll(struct uvc_video_queue *queue, struct file *file,
 			     poll_table *wait)
 {
-	unsigned int ret;
-
-	mutex_lock(&queue->mutex);
-	ret = vb2_poll(&queue->queue, file, wait);
-	mutex_unlock(&queue->mutex);
-
-	return ret;
+	return vb2_poll(&queue->queue, file, wait);
 }
 
 int uvcg_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 {
-	int ret;
-
-	mutex_lock(&queue->mutex);
-	ret = vb2_mmap(&queue->queue, vma);
-	mutex_unlock(&queue->mutex);
-
-	return ret;
+	return vb2_mmap(&queue->queue, vma);
 }
 
 #ifndef CONFIG_MMU
@@ -260,12 +215,7 @@ int uvcg_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 unsigned long uvcg_queue_get_unmapped_area(struct uvc_video_queue *queue,
 					   unsigned long pgoff)
 {
-	unsigned long ret;
-
-	mutex_lock(&queue->mutex);
-	ret = vb2_get_unmapped_area(&queue->queue, 0, 0, pgoff, 0);
-	mutex_unlock(&queue->mutex);
-	return ret;
+	return vb2_get_unmapped_area(&queue->queue, 0, 0, pgoff, 0);
 }
 #endif
 
@@ -327,18 +277,17 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
 	unsigned long flags;
 	int ret = 0;
 
-	mutex_lock(&queue->mutex);
 	if (enable) {
 		ret = vb2_streamon(&queue->queue, queue->queue.type);
 		if (ret < 0)
-			goto done;
+			return ret;
 
 		queue->sequence = 0;
 		queue->buf_used = 0;
 	} else {
 		ret = vb2_streamoff(&queue->queue, queue->queue.type);
 		if (ret < 0)
-			goto done;
+			return ret;
 
 		spin_lock_irqsave(&queue->irqlock, flags);
 		INIT_LIST_HEAD(&queue->irqqueue);
@@ -353,8 +302,6 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
 		spin_unlock_irqrestore(&queue->irqlock, flags);
 	}
 
-done:
-	mutex_unlock(&queue->mutex);
 	return ret;
 }
 
diff --git a/drivers/usb/gadget/function/uvc_queue.h b/drivers/usb/gadget/function/uvc_queue.h
index 03919c7..01ca9ea 100644
--- a/drivers/usb/gadget/function/uvc_queue.h
+++ b/drivers/usb/gadget/function/uvc_queue.h
@@ -41,7 +41,6 @@ struct uvc_buffer {
 
 struct uvc_video_queue {
 	struct vb2_queue queue;
-	struct mutex mutex;	/* Protects queue */
 
 	unsigned int flags;
 	__u32 sequence;
@@ -57,7 +56,8 @@ static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
 	return vb2_is_streaming(&queue->queue);
 }
 
-int uvcg_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type);
+int uvcg_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
+		    struct mutex *lock);
 
 void uvcg_free_buffers(struct uvc_video_queue *queue);
 
diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/function/uvc_v4l2.c
index 5aad7fe..0bd6965 100644
--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -14,7 +14,6 @@
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/list.h>
-#include <linux/mutex.h>
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
@@ -311,8 +310,10 @@ uvc_v4l2_release(struct file *file)
 
 	uvc_function_disconnect(uvc);
 
+	mutex_lock(&video->mutex);
 	uvcg_video_enable(video, 0);
 	uvcg_free_buffers(&video->queue);
+	mutex_unlock(&video->mutex);
 
 	file->private_data = NULL;
 	v4l2_fh_del(&handle->vfh);
diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 9cb86bc..8927358 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -390,7 +390,8 @@ int uvcg_video_init(struct uvc_video *video)
 	video->imagesize = 320 * 240 * 2;
 
 	/* Initialize the video buffers queue. */
-	uvcg_queue_init(&video->queue, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	uvcg_queue_init(&video->queue, V4L2_BUF_TYPE_VIDEO_OUTPUT,
+			&video->mutex);
 	return 0;
 }
 
-- 
2.1.4

