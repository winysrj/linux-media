Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47160 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751145AbdEaOUC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 10:20:02 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id C456220D78
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 17:18:43 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] vb2: Move cache synchronisation from buffer done to dqbuf handler
Date: Wed, 31 May 2017 17:17:27 +0300
Message-Id: <1496240247-25936-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1496240247-25936-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1496240247-25936-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cache synchronisation may be a time consuming operation and thus not
best performed in an interrupt which is a typical context for
vb2_buffer_done() calls. This may consume up to tens of ms on some
machines, depending on the buffer size.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 3107e21..ce00f0b 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -889,7 +889,6 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned long flags;
-	unsigned int plane;
 
 	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
 		return;
@@ -910,10 +909,6 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	dprintk(4, "done processing on buffer %d, state: %d\n",
 			vb->index, state);
 
-	/* sync buffers */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
-
 	spin_lock_irqsave(&q->done_lock, flags);
 	if (state == VB2_BUF_STATE_QUEUED ||
 	    state == VB2_BUF_STATE_REQUEUEING) {
@@ -1573,6 +1568,10 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 
 	vb->state = VB2_BUF_STATE_DEQUEUED;
 
+	/* sync buffers */
+	for (i = 0; i < vb->num_planes; ++i)
+		call_void_memop(vb, finish, vb->planes[i].mem_priv);
+
 	/* unmap DMABUF buffer */
 	if (q->memory == VB2_MEMORY_DMABUF)
 		for (i = 0; i < vb->num_planes; ++i) {
-- 
2.7.4
