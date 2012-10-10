Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:48692 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab2JJOxC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 10:53:02 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBO00B8EMODK980@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 23:53:01 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBO002YDME0EC70@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 23:53:00 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: [PATCHv10 09/26] v4l: vb2: add prepare/finish callbacks to allocators
Date: Wed, 10 Oct 2012 16:46:28 +0200
Message-id: <1349880405-26049-10-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

This patch adds support for prepare/finish callbacks in VB2 allocators. These
callback are used for buffer flushing.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |   11 +++++++++++
 include/media/videobuf2-core.h           |    7 +++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index a51dad6..613dea1 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -844,6 +844,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned long flags;
+	unsigned int plane;
 
 	if (vb->state != VB2_BUF_STATE_ACTIVE)
 		return;
@@ -854,6 +855,10 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	dprintk(4, "Done processing on buffer %d, state: %d\n",
 			vb->v4l2_buf.index, vb->state);
 
+	/* sync buffers */
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		call_memop(q, finish, vb->planes[plane].mem_priv);
+
 	/* Add the buffer to the done buffers list */
 	spin_lock_irqsave(&q->done_lock, flags);
 	vb->state = state;
@@ -1136,9 +1141,15 @@ err:
 static void __enqueue_in_driver(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int plane;
 
 	vb->state = VB2_BUF_STATE_ACTIVE;
 	atomic_inc(&q->queued_count);
+
+	/* sync buffers */
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		call_memop(q, prepare, vb->planes[plane].mem_priv);
+
 	q->ops->buf_queue(vb);
 }
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 689ae4a..24b9c90 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -56,6 +56,10 @@ struct vb2_fileio_data;
  *		dmabuf
  * @unmap_dmabuf: releases access control to the dmabuf - allocator is notified
  *		  that this driver is done using the dmabuf for now
+ * @prepare:	called every time the buffer is passed from userspace to the
+ *		driver, useful for cache synchronisation, optional
+ * @finish:	called every time the buffer is passed back from the driver
+ *		to the userspace, also optional
  * @vaddr:	return a kernel virtual address to a given memory buffer
  *		associated with the passed private structure or NULL if no
  *		such mapping exists
@@ -82,6 +86,9 @@ struct vb2_mem_ops {
 					unsigned long size, int write);
 	void		(*put_userptr)(void *buf_priv);
 
+	void		(*prepare)(void *buf_priv);
+	void		(*finish)(void *buf_priv);
+
 	void		*(*attach_dmabuf)(void *alloc_ctx, struct dma_buf *dbuf,
 				unsigned long size, int write);
 	void		(*detach_dmabuf)(void *buf_priv);
-- 
1.7.9.5

