Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4663 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaC1Lnc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 07:43:32 -0400
Message-ID: <5335605D.5070106@xs4all.nl>
Date: Fri, 28 Mar 2014 12:43:25 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Pawel Osciak <pawel@osciak.com>
Subject: [PATCHv2 for v3.15] vb2: call finish() memop for prepared/queued
 buffers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This supersedes "[PATCH for v3.15] vb2: call __buf_finish_memory for
prepared/queued buffers". I realized that that patch was for an internal
git branch and didn't apply to the master branch. The fix is the same,
though.

v4l2-compliance reports unbalanced prepare/finish memops in the case
where buffers are queued, streamon is never called and then reqbufs()
is called that has to cancel any queued buffers.

When canceling a queue the finish() memop should be called for all
buffers in the state 'PREPARED' or 'QUEUED' to ensure the prepare() and
finish() memops are balanced.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index f9059bb..cc1bd5a 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1063,6 +1063,15 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
 }
 EXPORT_SYMBOL_GPL(vb2_plane_cookie);
 
+static void vb2_buffer_finish(struct vb2_buffer *vb)
+{
+	unsigned plane;
+
+	/* sync buffers */
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		call_memop(vb, finish, vb->planes[plane].mem_priv);
+}
+
 /**
  * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
  * @vb:		vb2_buffer returned from the driver
@@ -1086,7 +1095,6 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned long flags;
-	unsigned int plane;
 
 	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
 		return;
@@ -1111,8 +1119,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 			vb->v4l2_buf.index, state);
 
 	/* sync buffers */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_memop(vb, finish, vb->planes[plane].mem_priv);
+	vb2_buffer_finish(vb);
 
 	/* Add the buffer to the done buffers list */
 	spin_lock_irqsave(&q->done_lock, flags);
@@ -2041,6 +2048,9 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 		struct vb2_buffer *vb = q->bufs[i];
 
 		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+			if (vb->state == VB2_BUF_STATE_QUEUED ||
+			    vb->state == VB2_BUF_STATE_PREPARED)
+				vb2_buffer_finish(vb);
 			vb->state = VB2_BUF_STATE_PREPARED;
 			call_vb_qop(vb, buf_finish, vb);
 		}
-- 
1.9.0

