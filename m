Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:37074 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751725AbdIABv0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 21:51:26 -0400
Received: by mail-qt0-f195.google.com with SMTP id x29so1000613qtc.4
        for <linux-media@vger.kernel.org>; Thu, 31 Aug 2017 18:51:26 -0700 (PDT)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v2 12/14] [media] vb2: add infrastructure to support out-fences
Date: Thu, 31 Aug 2017 22:50:39 -0300
Message-Id: <20170901015041.7757-13-gustavo@padovan.org>
In-Reply-To: <20170901015041.7757-1-gustavo@padovan.org>
References: <20170901015041.7757-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Add vb2_setup_out_fence() and the needed members to struct vb2_buffer.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 31 +++++++++++++++++++++++++++++++
 include/media/videobuf2-core.h           |  5 +++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index bbbae0eed567..2b9ba3dc23f0 100644
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
@@ -1317,6 +1320,34 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 }
 EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
 
+int vb2_setup_out_fence(struct vb2_queue *q, unsigned int index)
+{
+	struct vb2_buffer *vb = q->bufs[index];
+
+	vb->out_fence_fd = get_unused_fd_flags(O_CLOEXEC);
+	if (vb->out_fence_fd < 0)
+		return vb->out_fence_fd;
+
+	vb->out_fence = vb2_fence_alloc();
+	if (!vb->out_fence)
+		goto err;
+
+	vb->sync_file = sync_file_create(vb->out_fence);
+	if (!vb->sync_file) {
+		dma_fence_put(vb->out_fence);
+		vb->out_fence = NULL;
+		goto err;
+	}
+
+	return 0;
+
+err:
+	put_unused_fd(vb->out_fence_fd);
+	vb->out_fence_fd = -1;
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(vb2_setup_out_fence);
+
 /**
  * vb2_start_streaming() - Attempt to start streaming.
  * @q:		videobuf2 queue
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index ad419f7204a2..bf2f0499c737 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -263,6 +263,10 @@ struct vb2_buffer {
 
 	struct dma_fence	*in_fence;
 	struct dma_fence_cb	fence_cb;
+
+	struct dma_fence	*out_fence;
+	struct sync_file	*sync_file;
+	int			out_fence_fd;
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
 	 * Counters for how often these buffer-related ops are
@@ -730,6 +734,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
  */
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
 
+int vb2_setup_out_fence(struct vb2_queue *q, unsigned int index);
 /**
  * vb2_core_qbuf() - Queue a buffer from userspace
  *
-- 
2.13.5
