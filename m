Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:34397 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752577AbdCMTUw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 15:20:52 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC 03/10] [media] vb2: add in-fence support to QBUF
Date: Mon, 13 Mar 2017 16:20:28 -0300
Message-Id: <20170313192035.29859-4-gustavo@padovan.org>
In-Reply-To: <20170313192035.29859-1-gustavo@padovan.org>
References: <20170313192035.29859-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Receive in-fence from userspace and support for waiting on them
before queueing the buffer for the driver.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/Kconfig                    |  1 +
 drivers/media/v4l2-core/videobuf2-core.c | 24 ++++++++++++++++++++----
 drivers/media/v4l2-core/videobuf2-v4l2.c | 14 +++++++++++++-
 include/media/videobuf2-core.h           |  7 ++++++-
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 3512316..7c5a0e0 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -5,6 +5,7 @@
 menuconfig MEDIA_SUPPORT
 	tristate "Multimedia support"
 	depends on HAS_IOMEM
+	select SYNC_FILE
 	help
 	  If you want to use Webcams, Video grabber devices and/or TV devices
 	  enable this option and other options below.
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 0e30fcd..e0e7109 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1400,7 +1400,18 @@ static int __vb2_core_qbuf(struct vb2_buffer *vb, struct vb2_queue *q)
 	return 0;
 }
 
-int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
+static void vb2_qbuf_fence_cb(struct dma_fence *f, struct dma_fence_cb *cb)
+{
+	struct vb2_buffer *vb = container_of(cb, struct vb2_buffer, fence_cb);
+
+	dma_fence_put(vb->in_fence);
+	vb->in_fence = NULL;
+
+	__vb2_core_qbuf(vb, vb->vb2_queue);
+}
+
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
+		  struct dma_fence *fence)
 {
 	struct vb2_buffer *vb;
 	int ret;
@@ -1432,6 +1443,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	if (pb)
 		call_void_bufop(q, fill_user_buffer, vb, pb);
 
+	vb->in_fence = fence;
+	if (fence && !dma_fence_add_callback(fence, &vb->fence_cb,
+					     vb2_qbuf_fence_cb))
+			return 0;
+
 	return __vb2_core_qbuf(vb, q);
 }
 EXPORT_SYMBOL_GPL(vb2_core_qbuf);
@@ -2246,7 +2262,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 		 * Queue all buffers.
 		 */
 		for (i = 0; i < q->num_buffers; i++) {
-			ret = vb2_core_qbuf(q, i, NULL);
+			ret = vb2_core_qbuf(q, i, NULL, NULL);
 			if (ret)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
@@ -2425,7 +2441,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 
 		if (copy_timestamp)
 			b->timestamp = ktime_get_ns();
-		ret = vb2_core_qbuf(q, index, NULL);
+		ret = vb2_core_qbuf(q, index, NULL, NULL);
 		dprintk(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
 			return ret;
@@ -2528,7 +2544,7 @@ static int vb2_thread(void *data)
 		if (copy_timestamp)
 			vb->timestamp = ktime_get_ns();;
 		if (!threadio->stop)
-			ret = vb2_core_qbuf(q, vb->index, NULL);
+			ret = vb2_core_qbuf(q, vb->index, NULL, NULL);
 		call_void_qop(q, wait_prepare, q);
 		if (ret || threadio->stop)
 			break;
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index d23c1bf..c164aa0 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -23,6 +23,7 @@
 #include <linux/sched.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
+#include <linux/sync_file.h>
 
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
@@ -557,6 +558,7 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
+	struct dma_fence *fence = NULL;
 	int ret;
 
 	if (vb2_fileio_is_active(q)) {
@@ -565,7 +567,17 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	}
 
 	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
-	return ret ? ret : vb2_core_qbuf(q, b->index, b);
+
+	if (b->flags & V4L2_BUF_FLAG_IN_FENCE) {
+		if (b->memory != VB2_MEMORY_DMABUF)
+			return -EINVAL;
+
+		fence = sync_file_get_fence(b->fence_fd);
+		if (!fence)
+			return -EINVAL;
+	}
+
+	return ret ? ret : vb2_core_qbuf(q, b->index, b, fence);
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index ac5898a..fe2de99 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -16,6 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/poll.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-fence.h>
 
 #define VB2_MAX_FRAME	(32)
 #define VB2_MAX_PLANES	(8)
@@ -259,6 +260,9 @@ struct vb2_buffer {
 
 	struct list_head	queued_entry;
 	struct list_head	done_entry;
+
+	struct dma_fence	*in_fence;
+	struct dma_fence_cb	fence_cb;
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
 	 * Counters for how often these buffer-related ops are
@@ -727,7 +731,8 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
  * The return values from this function are intended to be directly returned
  * from vidioc_qbuf handler in driver.
  */
-int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
+		  struct dma_fence *fence);
 
 /**
  * vb2_core_dqbuf() - Dequeue a buffer to the userspace
-- 
2.9.3
