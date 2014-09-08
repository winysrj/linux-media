Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3940 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaIHOPC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Sep 2014 10:15:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 01/12] vb2: introduce buf_prepare/finish_for_cpu
Date: Mon,  8 Sep 2014 16:14:30 +0200
Message-Id: <1410185681-20111-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1410185681-20111-1-git-send-email-hverkuil@xs4all.nl>
References: <1410185681-20111-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This splits the buf_prepare and buf_finish actions into two: one
called while the cpu can still access the buffer contents, and one where
the memory has been prepared for DMA and the cpu no longer can access it.

With this change the old buf_finish is really buf_finish_for_cpu and so the
few drivers that use it are updated.

The reason for this split is that some drivers need to modify the buffer,
either before or after the DMA has taken place, in order to e.g. add JPEG
headers or do other touch ups.

You cannot do that in buf_prepare since at that time the buffer is already
synced for DMA and the CPU shouldn't touch is. So add these extra ops to
make this explicit.

Note that the dma-sg memory model doesn't sync the buffers yet in the memop
prepare. This will change in future patches.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/parport/bw-qcam.c              |  4 +--
 drivers/media/pci/sta2x11/sta2x11_vip.c      |  4 +--
 drivers/media/platform/vivid/vivid-vid-cap.c |  4 +--
 drivers/media/usb/go7007/go7007-v4l2.c       |  4 +--
 drivers/media/usb/pwc/pwc-if.c               |  4 +--
 drivers/media/usb/uvc/uvc_queue.c            |  4 +--
 drivers/media/v4l2-core/videobuf2-core.c     | 29 ++++++++++++-----
 include/media/videobuf2-core.h               | 48 ++++++++++++++++++++++------
 8 files changed, 72 insertions(+), 29 deletions(-)

diff --git a/drivers/media/parport/bw-qcam.c b/drivers/media/parport/bw-qcam.c
index 67b9da1..528558f 100644
--- a/drivers/media/parport/bw-qcam.c
+++ b/drivers/media/parport/bw-qcam.c
@@ -667,7 +667,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 }
 
-static void buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish_for_cpu(struct vb2_buffer *vb)
 {
 	struct qcam *qcam = vb2_get_drv_priv(vb->vb2_queue);
 	void *vbuf = vb2_plane_vaddr(vb, 0);
@@ -699,7 +699,7 @@ static void buffer_finish(struct vb2_buffer *vb)
 static struct vb2_ops qcam_video_qops = {
 	.queue_setup		= queue_setup,
 	.buf_queue		= buffer_queue,
-	.buf_finish		= buffer_finish,
+	.buf_finish_for_cpu	= buffer_finish_for_cpu,
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
 };
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 365bd21..bfb05cb 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -327,7 +327,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 	}
 	spin_unlock(&vip->lock);
 }
-static void buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish_for_cpu(struct vb2_buffer *vb)
 {
 	struct sta2x11_vip *vip = vb2_get_drv_priv(vb->vb2_queue);
 	struct vip_buffer *vip_buf = to_vip_buffer(vb);
@@ -380,7 +380,7 @@ static struct vb2_ops vip_video_qops = {
 	.queue_setup		= queue_setup,
 	.buf_init		= buffer_init,
 	.buf_prepare		= buffer_prepare,
-	.buf_finish		= buffer_finish,
+	.buf_finish_for_cpu	= buffer_finish_for_cpu,
 	.buf_queue		= buffer_queue,
 	.start_streaming	= start_streaming,
 	.stop_streaming		= stop_streaming,
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 115437a..e8e4974 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -200,7 +200,7 @@ static int vid_cap_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void vid_cap_buf_finish(struct vb2_buffer *vb)
+static void vid_cap_buf_finish_for_cpu(struct vb2_buffer *vb)
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct v4l2_timecode *tc = &vb->v4l2_buf.timecode;
@@ -283,7 +283,7 @@ static void vid_cap_stop_streaming(struct vb2_queue *vq)
 const struct vb2_ops vivid_vid_cap_qops = {
 	.queue_setup		= vid_cap_queue_setup,
 	.buf_prepare		= vid_cap_buf_prepare,
-	.buf_finish		= vid_cap_buf_finish,
+	.buf_finish_for_cpu	= vid_cap_buf_finish_for_cpu,
 	.buf_queue		= vid_cap_buf_queue,
 	.start_streaming	= vid_cap_start_streaming,
 	.stop_streaming		= vid_cap_stop_streaming,
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index ec799b4..5bef286 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -404,7 +404,7 @@ static int go7007_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void go7007_buf_finish(struct vb2_buffer *vb)
+static void go7007_buf_finish_for_cpu(struct vb2_buffer *vb)
 {
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct go7007 *go = vb2_get_drv_priv(vq);
@@ -478,7 +478,7 @@ static struct vb2_ops go7007_video_qops = {
 	.queue_setup    = go7007_queue_setup,
 	.buf_queue      = go7007_buf_queue,
 	.buf_prepare    = go7007_buf_prepare,
-	.buf_finish     = go7007_buf_finish,
+	.buf_finish_for_cpu = go7007_buf_finish_for_cpu,
 	.start_streaming = go7007_start_streaming,
 	.stop_streaming = go7007_stop_streaming,
 	.wait_prepare   = vb2_ops_wait_prepare,
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 15b754d..879b455 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -614,7 +614,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish_for_cpu(struct vb2_buffer *vb)
 {
 	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2_queue);
 	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
@@ -700,7 +700,7 @@ static struct vb2_ops pwc_vb_queue_ops = {
 	.queue_setup		= queue_setup,
 	.buf_init		= buffer_init,
 	.buf_prepare		= buffer_prepare,
-	.buf_finish		= buffer_finish,
+	.buf_finish_for_cpu	= buffer_finish_for_cpu,
 	.buf_cleanup		= buffer_cleanup,
 	.buf_queue		= buffer_queue,
 	.start_streaming	= start_streaming,
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 6e92d20..86a67cd 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -106,7 +106,7 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 }
 
-static void uvc_buffer_finish(struct vb2_buffer *vb)
+static void uvc_buffer_finish_for_cpu(struct vb2_buffer *vb)
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
 	struct uvc_streaming *stream =
@@ -135,7 +135,7 @@ static struct vb2_ops uvc_queue_qops = {
 	.queue_setup = uvc_queue_setup,
 	.buf_prepare = uvc_buffer_prepare,
 	.buf_queue = uvc_buffer_queue,
-	.buf_finish = uvc_buffer_finish,
+	.buf_finish_for_cpu = uvc_buffer_finish_for_cpu,
 	.wait_prepare = uvc_wait_prepare,
 	.wait_finish = uvc_wait_finish,
 };
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7e6aff6..e5247a4 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -501,14 +501,17 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 				  vb->cnt_mem_map_dmabuf != vb->cnt_mem_unmap_dmabuf ||
 				  vb->cnt_buf_queue != vb->cnt_buf_done ||
 				  vb->cnt_buf_prepare != vb->cnt_buf_finish ||
+				  vb->cnt_buf_prepare_for_cpu != vb->cnt_buf_finish_for_cpu ||
 				  vb->cnt_buf_init != vb->cnt_buf_cleanup;
 
 		if (unbalanced || debug) {
 			pr_info("vb2:   counters for queue %p, buffer %d:%s\n",
 				q, buffer, unbalanced ? " UNBALANCED!" : "");
-			pr_info("vb2:     buf_init: %u buf_cleanup: %u buf_prepare: %u buf_finish: %u\n",
-				vb->cnt_buf_init, vb->cnt_buf_cleanup,
-				vb->cnt_buf_prepare, vb->cnt_buf_finish);
+			pr_info("vb2:     buf_init: %u buf_cleanup: %u\n",
+				vb->cnt_buf_init, vb->cnt_buf_cleanup);
+			pr_info("vb2:     buf_prepare_for_cpu: %u buf_prepare: %u buf_finish: %u buf_finish_for_cpu: %u\n",
+				vb->cnt_buf_prepare_for_cpu, vb->cnt_buf_prepare,
+				vb->cnt_buf_finish, vb->cnt_buf_finish_for_cpu);
 			pr_info("vb2:     buf_queue: %u buf_done: %u\n",
 				vb->cnt_buf_queue, vb->cnt_buf_done);
 			pr_info("vb2:     alloc: %u put: %u prepare: %u finish: %u mmap: %u\n",
@@ -1192,6 +1195,8 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	dprintk(4, "done processing on buffer %d, state: %d\n",
 			vb->v4l2_buf.index, state);
 
+	call_void_vb_qop(vb, buf_finish, vb);
+
 	/* sync buffers */
 	for (plane = 0; plane < vb->num_planes; ++plane)
 		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
@@ -1622,6 +1627,12 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	vb->v4l2_buf.timestamp.tv_usec = 0;
 	vb->v4l2_buf.sequence = 0;
 
+	ret = call_vb_qop(vb, buf_prepare_for_cpu, vb);
+	if (ret) {
+		dprintk(1, "buf_prepare_for_cpu failed\n");
+		return ret;
+	}
+
 	switch (q->memory) {
 	case V4L2_MEMORY_MMAP:
 		ret = __qbuf_mmap(vb, b);
@@ -1637,8 +1648,10 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		ret = -EINVAL;
 	}
 
-	if (ret)
+	if (ret) {
 		dprintk(1, "buffer preparation failed: %d\n", ret);
+		call_void_vb_qop(vb, buf_finish_for_cpu, vb);
+	}
 	vb->state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
 
 	return ret;
@@ -2048,7 +2061,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 		return -EINVAL;
 	}
 
-	call_void_vb_qop(vb, buf_finish, vb);
+	call_void_vb_qop(vb, buf_finish_for_cpu, vb);
 
 	/* Fill buffer information for the userspace */
 	__fill_v4l2_buffer(vb, b);
@@ -2076,7 +2089,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
  * Should be called from vidioc_dqbuf ioctl handler of a driver.
  * This function:
  * 1) verifies the passed buffer,
- * 2) calls buf_finish callback in the driver (if provided), in which
+ * 2) calls buf_finish_for_cpu callback in the driver (if provided), in which
  *    driver can perform any additional operations that may be required before
  *    returning the buffer to userspace, such as cache sync,
  * 3) the buffer struct members are filled with relevant information for
@@ -2139,7 +2152,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 
 	/*
 	 * Reinitialize all buffers for next use.
-	 * Make sure to call buf_finish for any queued buffers. Normally
+	 * Make sure to call buf_finish_for_cpu for any queued buffers. Normally
 	 * that's done in dqbuf, but that's not going to happen when we
 	 * cancel the whole queue. Note: this code belongs here, not in
 	 * __vb2_dqbuf() since in vb2_internal_dqbuf() there is a critical
@@ -2151,7 +2164,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 
 		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
 			vb->state = VB2_BUF_STATE_PREPARED;
-			call_void_vb_qop(vb, buf_finish, vb);
+			call_void_vb_qop(vb, buf_finish_for_cpu, vb);
 		}
 		__vb2_dqbuf(vb);
 	}
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 5a10d8d..fff159c 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -227,8 +227,10 @@ struct vb2_buffer {
 	u32		cnt_mem_mmap;
 
 	u32		cnt_buf_init;
+	u32		cnt_buf_prepare_for_cpu;
 	u32		cnt_buf_prepare;
 	u32		cnt_buf_finish;
+	u32		cnt_buf_finish_for_cpu;
 	u32		cnt_buf_cleanup;
 	u32		cnt_buf_queue;
 
@@ -268,17 +270,43 @@ struct vb2_buffer {
  *			perform additional buffer-related initialization;
  *			initialization failure (return != 0) will prevent
  *			queue setup from completing successfully; optional.
- * @buf_prepare:	called every time the buffer is queued from userspace
+ * @buf_prepare_for_cpu:called every time the buffer is queued from userspace
  *			and from the VIDIOC_PREPARE_BUF ioctl; drivers may
- *			perform any initialization required before each hardware
- *			operation in this callback; drivers that support
- *			VIDIOC_CREATE_BUFS must also validate the buffer size;
- *			if an error is returned, the buffer will not be queued
- *			in driver; optional.
+ *			use this to access and modify the contents of the buffer
+ *			before it is prepared for DMA in the next step
+ *			(@buf_prepare). Drivers that support VIDIOC_CREATE_BUFS
+ *			must also validate the buffer size. If an error is
+ *			returned, the buffer will not be queued	in the driver;
+ *			optional.
+ * @buf_prepare:	called every time the buffer is queued from userspace
+ *			and from the VIDIOC_PREPARE_BUF ioctl; at this point
+ *			the buffer is prepared for DMA and the drivers may no
+ *			longer access the contents of the buffer. The driver
+ *			must perform any initialization required before each
+ *			hardware operation in this callback; drivers that
+ *			support	VIDIOC_CREATE_BUFS must also validate the
+ *			buffer size, if they haven't done that yet in
+ *			@buf_prepare_for_cpu. If an error is returned, the
+ *			buffer will not be queued in the driver; optional.
  * @buf_finish:		called before every dequeue of the buffer back to
- *			userspace; drivers may perform any operations required
- *			before userspace accesses the buffer; optional. The
- *			buffer state can be one of the following: DONE and
+ *			userspace; the contents of the buffer cannot be
+ *			accessed by the cpu at this stage as it is still setup
+ *			for DMA. Drivers may perform any operations required
+ *			before userspace accesses the buffer; optional.
+ *			The buffer state can be one of the following: DONE and
+ *			ERROR occur while streaming is in progress, and the
+ *			PREPARED state occurs when the queue has been canceled
+ *			and all pending buffers are being returned to their
+ *			default DEQUEUED state. Typically you only have to do
+ *			something if the state is VB2_BUF_STATE_DONE, since in
+ *			all other cases the buffer contents will be ignored
+ *			anyway.
+ * @buf_finish_for_cpu:	called before every dequeue of the buffer back to
+ *			userspace; at this stage the contents of the buffer is
+ *			accessible to the CPU. Drivers may perform any
+ *			operations required before userspace accesses the
+ *			buffer; optional.
+ *			The buffer state can be one of the following: DONE and
  *			ERROR occur while streaming is in progress, and the
  *			PREPARED state occurs when the queue has been canceled
  *			and all pending buffers are being returned to their
@@ -323,8 +351,10 @@ struct vb2_ops {
 	void (*wait_finish)(struct vb2_queue *q);
 
 	int (*buf_init)(struct vb2_buffer *vb);
+	int (*buf_prepare_for_cpu)(struct vb2_buffer *vb);
 	int (*buf_prepare)(struct vb2_buffer *vb);
 	void (*buf_finish)(struct vb2_buffer *vb);
+	void (*buf_finish_for_cpu)(struct vb2_buffer *vb);
 	void (*buf_cleanup)(struct vb2_buffer *vb);
 
 	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
-- 
2.1.0

