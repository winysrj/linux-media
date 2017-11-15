Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:53553 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933235AbdKORLj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 12:11:39 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC v5 09/11] [media] vb2: add infrastructure to support out-fences
Date: Wed, 15 Nov 2017 15:10:55 -0200
Message-Id: <20171115171057.17340-10-gustavo@padovan.org>
In-Reply-To: <20171115171057.17340-1-gustavo@padovan.org>
References: <20171115171057.17340-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Add vb2_setup_out_fence() and the needed members to struct vb2_buffer.

v3:
	- Do not hold yet another ref to the out_fence (Brian Starkey)

v2:	- change it to reflect fd_install at DQEVENT
	- add fence context for out-fences

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 28 ++++++++++++++++++++++++++++
 include/media/videobuf2-core.h           | 20 ++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 26de4c80717d..8b4f0e9bcb36 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -24,8 +24,10 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/dma-fence-array.h>
+#include <linux/sync_file.h>
 
 #include <media/videobuf2-core.h>
+#include <media/videobuf2-fence.h>
 #include <media/v4l2-mc.h>
 
 #include <trace/events/vb2.h>
@@ -1320,6 +1322,32 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 }
 EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
 
+int vb2_setup_out_fence(struct vb2_queue *q, unsigned int index)
+{
+	struct vb2_buffer *vb;
+
+	vb = q->bufs[index];
+
+	vb->out_fence_fd = get_unused_fd_flags(O_CLOEXEC);
+
+	vb->out_fence = vb2_fence_alloc(q->out_fence_context);
+	if (!vb->out_fence) {
+		put_unused_fd(vb->out_fence_fd);
+		return -ENOMEM;
+	}
+
+	vb->sync_file = sync_file_create(vb->out_fence);
+	if (!vb->sync_file) {
+		put_unused_fd(vb->out_fence_fd);
+		dma_fence_put(vb->out_fence);
+		vb->out_fence = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_setup_out_fence);
+
 /**
  * vb2_start_streaming() - Attempt to start streaming.
  * @q:		videobuf2 queue
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 5f48c7be7770..a9b0697bd782 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -259,6 +259,10 @@ struct vb2_buffer {
 	 *			using the buffer (queueing to the driver)
 	 * fence_cb:		fence callback information
 	 * fence_cb_lock:	protect callback signal/remove
+	 * out_fence_fd:	the out_fence_fd to be shared with userspace.
+	 * out_fence:		the out-fence associated with the buffer once
+	 *			it is queued to the driver.
+	 * sync_file:		the sync file to wrap the out fence
 	 */
 	enum vb2_buffer_state	state;
 
@@ -269,6 +273,10 @@ struct vb2_buffer {
 	struct dma_fence_cb	fence_cb;
 	spinlock_t              fence_cb_lock;
 
+	int			out_fence_fd;
+	struct dma_fence	*out_fence;
+	struct sync_file	*sync_file;
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
 	 * Counters for how often these buffer-related ops are
@@ -514,6 +522,7 @@ struct vb2_buf_ops {
  * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
  *		last decoded buffer was already dequeued. Set for capture queues
  *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
+ * @out_fence_context: the fence context for the out fences
  * @last_fence:	last in-fence received. Used to keep ordering.
  * @fileio:	file io emulator internal data, used only if emulator is active
  * @threadio:	thread io internal data, used only if thread is active
@@ -569,6 +578,7 @@ struct vb2_queue {
 	unsigned int			copy_timestamp:1;
 	unsigned int			last_buffer_dequeued:1;
 
+	u64				out_fence_context;
 	struct dma_fence		*last_fence;
 
 	struct vb2_fileio_data		*fileio;
@@ -740,6 +750,16 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
 
 /**
+ * vb2_setup_out_fence() - setup new out-fence
+ * @q:		The vb2_queue where to setup it
+ * @index:	index of the buffer
+ *
+ * Setup the file descriptor, the fence and the sync_file for the next
+ * buffer to be queued and add everything to the tail of the q->out_fence_list.
+ */
+int vb2_setup_out_fence(struct vb2_queue *q, unsigned int index);
+
+/**
  * vb2_core_qbuf() - Queue a buffer from userspace
  *
  * @q:		videobuf2 queue
-- 
2.13.6
