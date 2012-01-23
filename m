Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63229 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab2AWNvh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 08:51:37 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LY900A0W7TZVI@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:35 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LY900GK77TYU2@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:35 +0000 (GMT)
Date: Mon, 23 Jan 2012 14:51:08 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 03/10] media: vb2: add prepare/finish callbacks to allocators
In-reply-to: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Cc: sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	pawel@osciak.com
Message-id: <1327326675-8431-4-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf2-core.c |   11 +++++++++++
 include/media/videobuf2-core.h       |    2 ++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 4c3a82e..cb85874 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -836,6 +836,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned long flags;
+	int plane;
 
 	if (vb->state != VB2_BUF_STATE_ACTIVE)
 		return;
@@ -846,6 +847,10 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
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
+	int plane;
 
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
index 35607f7..d8b8171 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -76,6 +76,8 @@ struct vb2_fileio_data;
  */
 struct vb2_mem_ops {
 	void		*(*alloc)(void *alloc_ctx, unsigned long size);
+	void		(*prepare)(void *buf_priv);
+	void		(*finish)(void *buf_priv);
 	void		(*put)(void *buf_priv);
 
 	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
-- 
1.7.5.4

