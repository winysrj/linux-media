Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:34489 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753498AbdCMTVJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 15:21:09 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC 09/10] [media] vb2: add infrastructure to support out-fences
Date: Mon, 13 Mar 2017 16:20:34 -0300
Message-Id: <20170313192035.29859-10-gustavo@padovan.org>
In-Reply-To: <20170313192035.29859-1-gustavo@padovan.org>
References: <20170313192035.29859-1-gustavo@padovan.org>
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
index d9cb777..54b1404 100644
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
 #include <media/v4l2-event.h>
 #include <media/v4l2-mc.h>
 
@@ -1315,6 +1318,34 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
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
index fe2de99..efdc390 100644
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
@@ -710,6 +714,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
  */
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
 
+int vb2_setup_out_fence(struct vb2_queue *q, unsigned int index);
 /**
  * vb2_core_qbuf() - Queue a buffer from userspace
  *
-- 
2.9.3
