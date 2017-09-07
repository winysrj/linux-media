Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35406 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756029AbdIGSnX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 14:43:23 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v3 13/15] [media] vb2: add infrastructure to support out-fences
Date: Thu,  7 Sep 2017 15:42:24 -0300
Message-Id: <20170907184226.27482-14-gustavo@padovan.org>
In-Reply-To: <20170907184226.27482-1-gustavo@padovan.org>
References: <20170907184226.27482-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Add vb2_setup_out_fence() and the needed members to struct vb2_buffer.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 55 ++++++++++++++++++++++++++++++++
 include/media/videobuf2-core.h           | 34 ++++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index bbbae0eed567..34adf1916194 100644
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
@@ -1317,6 +1320,58 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 }
 EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
 
+int vb2_setup_out_fence(struct vb2_queue *q)
+{
+	struct vb2_fence *fence;
+
+	fence = kzalloc(sizeof(*fence), GFP_KERNEL);
+	if (!fence)
+		return -ENOMEM;
+
+	fence->out_fence_fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fence->out_fence_fd < 0) {
+		kfree(fence);
+		return fence->out_fence_fd;
+	}
+
+	fence->out_fence = vb2_fence_alloc();
+	if (!fence->out_fence)
+		goto err_fence;
+
+	fence->sync_file = sync_file_create(fence->out_fence);
+	if (!fence->sync_file) {
+		dma_fence_put(fence->out_fence);
+		goto err_fence;
+	}
+
+	spin_lock(&q->out_fence_lock);
+	list_add_tail(&fence->entry, &q->out_fence_list);
+	spin_unlock(&q->out_fence_lock);
+
+	return 0;
+
+err_fence:
+	kfree(fence);
+	put_unused_fd(fence->out_fence_fd);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(vb2_setup_out_fence);
+
+void vb2_cleanup_out_fence(struct vb2_queue *q)
+{
+	struct vb2_fence *fence;
+
+	spin_lock(&q->out_fence_lock);
+	fence = list_last_entry(&q->out_fence_list,
+				    struct vb2_fence, entry);
+	put_unused_fd(fence->out_fence_fd);
+	fput(fence->sync_file->file);
+	list_del(&fence->entry);
+	spin_unlock(&q->out_fence_lock);
+	kfree(fence);
+}
+EXPORT_SYMBOL_GPL(vb2_cleanup_out_fence);
+
 /**
  * vb2_start_streaming() - Attempt to start streaming.
  * @q:		videobuf2 queue
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 20099dc22f26..84e5e7216a1e 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -427,6 +427,24 @@ struct vb2_buf_ops {
 	void (*buffer_queued)(struct vb2_buffer *vb);
 };
 
+/*
+ * struct vb2_fence - storage for fence data before queueing to the driver.
+ *
+ * @out_fence_fd:	the fd where to install the sync_file
+ * @out_fence:		the fence associated to the sync_file
+ * @sync_file:		the sync_file to be shared with userspace via the
+ *			out_fence_fd
+ * @files:		stores files struct for cleanup purposes
+ * @entry:		the list head element for the out_fence_list
+ */
+struct vb2_fence {
+	int out_fence_fd;
+	struct dma_fence *out_fence;
+	struct sync_file *sync_file;
+	struct files_struct *files;
+	struct list_head entry;
+};
+
 /**
  * struct vb2_queue - a videobuf queue
  *
@@ -734,6 +752,22 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
 
 /**
+ * vb2_setup_out_fence() - setup new out-fence
+ * @q:		The vb2_queue where to setup it
+ *
+ * Setup the file descriptor, the fence and the sync_file for the next
+ * buffer to be queued and add everything to the tail of the q->out_fence_list.
+ */
+int vb2_setup_out_fence(struct vb2_queue *q);
+
+/**
+ * vb2_cleanup_out_fence() - cleanup out-fence
+ * @q:		The vb2_queue to use for cleanup
+ *
+ * Clean up the last fence on the list. Used only when QBUF fails.
+ */
+void vb2_cleanup_out_fence(struct vb2_queue *q);
+/**
  * vb2_core_qbuf() - Queue a buffer from userspace
  *
  * @q:		videobuf2 queue
-- 
2.13.5
