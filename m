Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751668AbeACUdk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 15:33:40 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Cc: Olivier BRAUN <olivier.braun@stereolabs.com>,
        kieran.bingham@ideasonboard.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Patrick Johnson <teknotus@teknot.us>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Jim Lin <jilin@nvidia.com>
Subject: [RFC/RFT PATCH 5/6] uvcvideo: queue: Support asynchronous buffer handling
Date: Wed,  3 Jan 2018 20:32:55 +0000
Message-Id: <339eccd0fc0fc21b0fbd025bec177f584a3eef6f.1515010476.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
References: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
References: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

The buffer queue interface currently operates sequentially, processing
buffers after they have fully completed.

In preparation for supporting parallel tasks operating on the buffers,
we will need to support buffers being processed on multiple CPUs.

Adapt the uvc_queue_next_buffer() such that a reference count tracks the
active use of the buffer, returning the buffer to the VB2 stack at
completion.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 61 ++++++++++++++++++++++++++------
 drivers/media/usb/uvc/uvcvideo.h  |  4 ++-
 2 files changed, 54 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 28dbdf8bb533..204dd91a8526 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -131,6 +131,7 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
 
 	spin_lock_irqsave(&queue->irqlock, flags);
 	if (likely(!(queue->flags & UVC_QUEUE_DISCONNECTED))) {
+		kref_init(&buf->ref);
 		list_add_tail(&buf->queue, &queue->irqqueue);
 	} else {
 		/* If the device is disconnected return the buffer to userspace
@@ -425,28 +426,66 @@ struct uvc_buffer *uvc_queue_get_current_buffer(struct uvc_video_queue *queue)
 	return nextbuf;
 }
 
-struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
+/*
+ * uvc_queue_requeue: Requeue a buffer on our internal irqqueue
+ *
+ * Reuse a buffer through our internal queue without the need to 'prepare'
+ * The buffer will be returned to userspace through the uvc_buffer_queue call if
+ * the device has been disconnected
+ */
+static void uvc_queue_requeue(struct uvc_video_queue *queue,
 		struct uvc_buffer *buf)
 {
-	struct uvc_buffer *nextbuf;
-	unsigned long flags;
+	buf->error = 0;
+	buf->state = UVC_BUF_STATE_QUEUED;
+	buf->bytesused = 0;
+	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
+
+	uvc_buffer_queue(&buf->buf.vb2_buf);
+}
+
+static void uvc_queue_buffer_complete(struct kref *ref)
+{
+	struct uvc_buffer *buf = container_of(ref, struct uvc_buffer, ref);
+	struct vb2_buffer *vb = &buf->buf.vb2_buf;
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
 
 	if ((queue->flags & UVC_QUEUE_DROP_CORRUPTED) && buf->error) {
-		buf->error = 0;
-		buf->state = UVC_BUF_STATE_QUEUED;
-		buf->bytesused = 0;
-		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
-		return buf;
+		uvc_queue_requeue(queue, buf);
+		return;
 	}
 
+	buf->state = buf->error ? UVC_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
+	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
+	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
+}
+
+/*
+ * Release a reference on the buffer. Complete the buffer when the last
+ * reference is released
+ */
+void uvc_queue_buffer_release(struct uvc_buffer *buf)
+{
+	kref_put(&buf->ref, uvc_queue_buffer_complete);
+}
+
+/*
+ * Remove this buffer from the queue. Lifetime will persist while async actions
+ * are still running (if any), and uvc_queue_buffer_release will give the buffer
+ * back to VB2 when all users have completed.
+ */
+struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
+		struct uvc_buffer *buf)
+{
+	struct uvc_buffer *nextbuf;
+	unsigned long flags;
+
 	spin_lock_irqsave(&queue->irqlock, flags);
 	list_del(&buf->queue);
 	nextbuf = __uvc_queue_get_current_buffer(queue);
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
-	buf->state = buf->error ? UVC_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
-	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
-	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
+	uvc_queue_buffer_release(buf);
 
 	return nextbuf;
 }
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index f274c685087d..2e51bbdf5dac 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -404,6 +404,9 @@ struct uvc_buffer {
 	unsigned int bytesused;
 
 	u32 pts;
+
+	/* asynchronous buffer handling */
+	struct kref ref;
 };
 
 #define UVC_QUEUE_DISCONNECTED		(1 << 0)
@@ -696,6 +699,7 @@ extern struct uvc_buffer *
 		uvc_queue_get_current_buffer(struct uvc_video_queue *queue);
 extern struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 		struct uvc_buffer *buf);
+extern void uvc_queue_buffer_release(struct uvc_buffer *buf);
 extern int uvc_queue_mmap(struct uvc_video_queue *queue,
 		struct vm_area_struct *vma);
 extern unsigned int uvc_queue_poll(struct uvc_video_queue *queue,
-- 
git-series 0.9.1
