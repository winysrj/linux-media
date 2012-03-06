Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56327 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965129Ab2CFLiT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 06:38:19 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0G003KLOBR18@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:15 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0G00CLQOBRW5@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:15 +0000 (GMT)
Date: Tue, 06 Mar 2012 12:38:06 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFCv2 PATCH 5/9] v4l: vb2: add buffer exporting via dmabuf
In-reply-to: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com
Message-id: <1331033890-10350-6-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds extension to videobuf2-core. It allow to export a mmap buffer
as a file descriptor.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-core.c |   64 ++++++++++++++++++++++++++++++++++
 include/media/videobuf2-core.h       |    2 +
 2 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index e7df560..41c4bf8 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1553,6 +1553,70 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 }
 EXPORT_SYMBOL_GPL(vb2_dqbuf);
 
+static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
+			unsigned int *_buffer, unsigned int *_plane);
+
+/**
+ * vb2_expbuf() - Export a buffer as a file descriptor
+ * @q:		videobuf2 queue
+ * @b:		export buffer structure passed from userspace to vidioc_expbuf
+ *		handler in driver
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_expbuf handler in driver.
+ */
+int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
+{
+	struct vb2_buffer *vb = NULL;
+	struct vb2_plane *vb_plane;
+	unsigned int buffer, plane;
+	int ret;
+	struct dma_buf *dbuf;
+
+	if (q->memory != V4L2_MEMORY_MMAP) {
+		dprintk(1, "Queue is not currently set up for mmap\n");
+		return -EINVAL;
+	}
+
+	if (!q->mem_ops->get_dmabuf) {
+		dprintk(1, "Queue does not support DMA buffer exporting\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Find the plane corresponding to the offset passed by userspace.
+	 */
+	ret = __find_plane_by_offset(q, eb->mem_offset, &buffer, &plane);
+	if (ret) {
+		dprintk(1, "invalid offset %u\n", eb->mem_offset);
+		return ret;
+	}
+
+	vb = q->bufs[buffer];
+	vb_plane = &vb->planes[plane];
+
+	dbuf = call_memop(q, get_dmabuf, vb_plane->mem_priv);
+	if (IS_ERR_OR_NULL(dbuf)) {
+		dprintk(1, "Failed to export buffer %d, plane %d\n",
+			buffer, plane);
+		return -EINVAL;
+	}
+
+	ret = dma_buf_fd(dbuf);
+	if (ret < 0) {
+		dprintk(3, "buffer %d, plane %d failed to export (%d)\n",
+			buffer, plane, ret);
+		return ret;
+	}
+
+	dprintk(3, "buffer %d, plane %d exported as %d descriptor\n",
+		buffer, plane, ret);
+	eb->fd = ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_expbuf);
+
 /**
  * __vb2_queue_cancel() - cancel and stop (pause) streaming
  *
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 412c6a4..548252b 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -79,6 +79,7 @@ struct vb2_mem_ops {
 	void		(*prepare)(void *buf_priv);
 	void		(*finish)(void *buf_priv);
 	void		(*put)(void *buf_priv);
+	struct dma_buf *(*get_dmabuf)(void *buf_priv);
 
 	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
 					unsigned long size, int write);
@@ -348,6 +349,7 @@ int vb2_queue_init(struct vb2_queue *q);
 void vb2_queue_release(struct vb2_queue *q);
 
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
 
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
-- 
1.7.5.4

