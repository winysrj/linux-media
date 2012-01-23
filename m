Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45383 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2AWNvh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 08:51:37 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LY900GOH7U0WH60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:36 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LY900GKW7TZU2@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:36 +0000 (GMT)
Date: Mon, 23 Jan 2012 14:51:11 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 06/10] v4l: vb2: add buffer exporting via dmabuf
In-reply-to: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Cc: sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	pawel@osciak.com
Message-id: <1327326675-8431-7-git-send-email-t.stanislaws@samsung.com>
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds extension to videobuf2-core. It allow to export a mmap buffer
as a file descriptor.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-core.c |   60 ++++++++++++++++++++++++++++++++++
 include/media/videobuf2-core.h       |    2 +
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 59bb1bc..29cf6ed 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1522,6 +1522,66 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 }
 EXPORT_SYMBOL_GPL(vb2_dqbuf);
 
+static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
+			unsigned int *_buffer, unsigned int *_plane);
+
+/**
+ * vb2_expbuf() - Export a buffer as a file descriptor
+ * @q:		videobuf2 queue
+ * @b:		buffer structure passed from userspace to vidioc_expbuf handler
+ *		in driver
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_expbuf handler in driver.
+ */
+int vb2_expbuf(struct vb2_queue *q, unsigned int offset)
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
+	ret = __find_plane_by_offset(q, offset, &buffer, &plane);
+	if (ret) {
+		dprintk(1, "invalid offset %d\n", offset);
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
+	if (ret < 0)
+		dprintk(3, "buffer %d, plane %d failed to export (%d)\n",
+			buffer, plane, ret);
+	else
+		dprintk(3, "buffer %d, plane %d exported as %d descriptor\n",
+			buffer, plane, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vb2_expbuf);
+
 /**
  * __vb2_queue_cancel() - cancel and stop (pause) streaming
  *
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 412c6a4..3d43954 100644
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
+int vb2_expbuf(struct vb2_queue *q, unsigned int offset);
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
 
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
-- 
1.7.5.4

