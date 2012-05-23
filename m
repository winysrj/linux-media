Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45664 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2EWNHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 09:07:49 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4H00EPN8D0GP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:05:25 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H0099B8GUIP@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:07:43 +0100 (BST)
Date: Wed, 23 May 2012 15:07:26 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 03/12] v4l: vb2: add buffer exporting via dmabuf
In-reply-to: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337778455-27912-4-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds extension to videobuf2-core. It allow to export a mmap buffer
as a file descriptor.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-core.c |   67 ++++++++++++++++++++++++++++++++++
 include/media/videobuf2-core.h       |    2 +
 2 files changed, 69 insertions(+)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index d60ed25..923165a 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1730,6 +1730,73 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 }
 
 /**
+ * vb2_expbuf() - Export a buffer as a file descriptor
+ * @q:		videobuf2 queue
+ * @eb:		export buffer structure passed from userspace to vidioc_expbuf
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
+	if (eb->flags & ~O_CLOEXEC) {
+		dprintk(1, "Queue does support only O_CLOEXEC flag\n");
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
+	ret = dma_buf_fd(dbuf, eb->flags);
+	if (ret < 0) {
+		dprintk(3, "buffer %d, plane %d failed to export (%d)\n",
+			buffer, plane, ret);
+		dma_buf_put(dbuf);
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
+/**
  * vb2_mmap() - map video buffers into application address space
  * @q:		videobuf2 queue
  * @vma:	vma passed to the mmap file operation handler in the driver
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index d079f92..fe01f95 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -81,6 +81,7 @@ struct vb2_fileio_data;
 struct vb2_mem_ops {
 	void		*(*alloc)(void *alloc_ctx, unsigned long size);
 	void		(*put)(void *buf_priv);
+	struct dma_buf *(*get_dmabuf)(void *buf_priv);
 
 	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
 					unsigned long size, int write);
@@ -350,6 +351,7 @@ int vb2_queue_init(struct vb2_queue *q);
 void vb2_queue_release(struct vb2_queue *q);
 
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
 
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
-- 
1.7.9.5

