Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:48070 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753431AbdJTVvL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 17:51:11 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC v4 15/17] [media] vb2: add infrastructure to support out-fences
Date: Fri, 20 Oct 2017 19:50:10 -0200
Message-Id: <20171020215012.20646-16-gustavo@padovan.org>
In-Reply-To: <20171020215012.20646-1-gustavo@padovan.org>
References: <20171020215012.20646-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Add vb2_setup_out_fence() and the needed members to struct vb2_buffer.

v2:	- change it to reflect fd_install at DQEVENT
	- add fence context for out-fences

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 31 +++++++++++++++++++++++++++++++
 include/media/videobuf2-core.h           | 20 ++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 78f369dba3e3..c7ba67bda5ac 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -23,8 +23,11 @@
 #include <linux/sched.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
+#include <linux/sync_file.h>
+#include <linux/dma-fence.h>
 
 #include <media/videobuf2-core.h>
+#include <media/videobuf2-fence.h>
 #include <media/v4l2-mc.h>
 
 #include <trace/events/vb2.h>
@@ -1316,6 +1319,34 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 }
 EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
 
+int vb2_setup_out_fence(struct vb2_queue *q, unsigned int index)
+{
+	struct vb2_buffer *vb;
+	struct dma_fence *fence;
+
+	vb = q->bufs[index];
+
+	vb->out_fence_fd = get_unused_fd_flags(O_CLOEXEC);
+
+	fence = vb2_fence_alloc(q->out_fence_context);
+	if (!fence) {
+		put_unused_fd(vb->out_fence_fd);
+		return -ENOMEM;
+	}
+
+	vb->sync_file = sync_file_create(fence);
+	if (!vb->sync_file) {
+		dma_fence_put(fence);
+		put_unused_fd(vb->out_fence_fd);
+		return -ENOMEM;
+	}
+
+	vb->out_fence = dma_fence_get(fence);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_setup_out_fence);
+
 /**
  * vb2_start_streaming() - Attempt to start streaming.
  * @q:		videobuf2 queue
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 624ca2dce9ea..1925ede73804 100644
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
@@ -518,6 +526,7 @@ struct vb2_buf_ops {
  * @ordered_in_vb2: set by the driver to tell vb2 te guarantee the order
  *		of buffer queue from userspace with QBUF() until they are
  *		queued to the driver.
+ * @out_fence_context: the fence context for the out fences
  * @last_fence:	last in-fence received. Used to keep ordering.
  * @fileio:	file io emulator internal data, used only if emulator is active
  * @threadio:	thread io internal data, used only if thread is active
@@ -574,6 +583,7 @@ struct vb2_queue {
 	unsigned int			ordered_in_driver:1;
 	unsigned int			ordered_in_vb2:1;
 
+	u64				out_fence_context;
 	struct dma_fence		*last_fence;
 
 	struct vb2_fileio_data		*fileio;
@@ -745,6 +755,16 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
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
