Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:62844 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab2HNPhk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 11:37:40 -0400
Received: from epcpsbgm2.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8R005TS4QR2TE0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:37:39 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8R004J44MBC810@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:37:39 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de, dmitriyz@google.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
Subject: [PATCHv8 19/26] v4l: vb2: add buffer exporting via dmabuf
Date: Tue, 14 Aug 2012 17:34:49 +0200
Message-id: <1344958496-9373-20-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds extension to videobuf2-core. It allow to export a mmap buffer
as a file descriptor.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf2-core.c |   67 ++++++++++++++++++++++++++++++++++
 include/media/videobuf2-core.h       |    2 +
 2 files changed, 69 insertions(+)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index aed21e4..61354ec 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1743,6 +1743,73 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
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
index c306fec..b034424 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -81,6 +81,7 @@ struct vb2_fileio_data;
 struct vb2_mem_ops {
 	void		*(*alloc)(void *alloc_ctx, unsigned long size);
 	void		(*put)(void *buf_priv);
+	struct dma_buf *(*get_dmabuf)(void *buf_priv);
 
 	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
 					unsigned long size, int write);
@@ -363,6 +364,7 @@ int vb2_queue_init(struct vb2_queue *q);
 void vb2_queue_release(struct vb2_queue *q);
 
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
 
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
-- 
1.7.9.5

