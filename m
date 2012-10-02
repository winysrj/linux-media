Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:26377 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab2JBO3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 10:29:00 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MB900FNZS8A6O90@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 23:28:59 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MB9005A7S65K790@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 23:28:58 +0900 (KST)
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
Subject: [PATCHv9 09/25] v4l: vb2: add prepare/finish callbacks to allocators
Date: Tue, 02 Oct 2012 16:27:20 +0200
Message-id: <1349188056-4886-10-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

This patch adds support for prepare/finish callbacks in VB2 allocators. These
callback are used for buffer flushing.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf2-core.c |   11 +++++++++++
 include/media/videobuf2-core.h       |    7 +++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 901bc56..05da3b4 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
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
@@ -1148,9 +1153,15 @@ err:
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
index 84f11f2..c306fec 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -56,6 +56,10 @@ struct vb2_fileio_data;
  *		dmabuf
  * @unmap_dmabuf: releases access control to the dmabuf - allocator is notified
  *		  that this driver is done using the dmabuf for now
+ * @prepare:	called everytime the buffer is passed from userspace to the
+ *		driver, usefull for cache synchronisation, optional
+ * @finish:	called everytime the buffer is passed back from the driver
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

