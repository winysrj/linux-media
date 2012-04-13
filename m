Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63599 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab2DMPsL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Apr 2012 11:48:11 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2F00CGID7ZD4@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 13 Apr 2012 16:48:02 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2F005JOD84XW@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 13 Apr 2012 16:48:05 +0100 (BST)
Date: Fri, 13 Apr 2012 17:47:51 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH v4 09/14] v4l: vb2: add prepare/finish callbacks to allocators
In-reply-to: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com
Message-id: <1334332076-28489-10-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

This patch adds support for prepare/finish callbacks in VB2 allocators. These
callback are used for buffer flushing.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf2-core.c |   11 +++++++++++
 include/media/videobuf2-core.h       |    7 +++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index d26b1cc..b431dc6 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -842,6 +842,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned long flags;
+	unsigned int plane;
 
 	if (vb->state != VB2_BUF_STATE_ACTIVE)
 		return;
@@ -852,6 +853,10 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	dprintk(4, "Done processing on buffer %d, state: %d\n",
 			vb->v4l2_buf.index, vb->state);
 
+	/* sync buffers */
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		call_memop(q, finish, vb->planes[plane].mem_priv);
+
 	/* Add the buffer to the done buffers list */
 	spin_lock_irqsave(&q->done_lock, flags);
 	vb->state = state;
@@ -1134,9 +1139,15 @@ err:
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
index 859bbaf..d079f92 100644
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
1.7.5.4

