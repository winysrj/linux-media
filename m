Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:21106 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172AbbGCPN6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jul 2015 11:13:58 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@osg.samsung.com
Subject: [PATCH v4 1/1] vb2: Only requeue buffers immediately once streaming is started
Date: Fri,  3 Jul 2015 18:12:21 +0300
Message-Id: <1435936341-27845-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Buffers can be returned back to videobuf2 in driver's streamon handler. In
this case vb2_buffer_done() with buffer state VB2_BUF_STATE_QUEUED will
cause the driver's buf_queue vb2 operation to be called, queueing the same
buffer again only to be returned to videobuf2 using vb2_buffer_done() and so
on.

Add a new buffer state VB2_BUF_STATE_REQUEUEING which, when used as the
state argument to vb2_buffer_done(), will result in buffers queued to the
driver. Using VB2_BUF_STATE_QUEUED will leave the buffer to videobuf2, as it
was before "[media] vb2: allow requeuing buffers while streaming".

Fixes: ce0eff016f72 ("[media] vb2: allow requeuing buffers while streaming")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: stable@vger.kernel.org # for v4.1
---
since v3:

- Added a break at the end of the default case in the switch in
  vb2_buffer_done().

 drivers/media/pci/cobalt/cobalt-irq.c    |  2 +-
 drivers/media/v4l2-core/videobuf2-core.c | 25 +++++++++++++++++--------
 include/media/videobuf2-core.h           |  2 ++
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-irq.c b/drivers/media/pci/cobalt/cobalt-irq.c
index e18f49e..2687cb0 100644
--- a/drivers/media/pci/cobalt/cobalt-irq.c
+++ b/drivers/media/pci/cobalt/cobalt-irq.c
@@ -134,7 +134,7 @@ done:
 	   also know about dropped frames. */
 	cb->vb.v4l2_buf.sequence = s->sequence++;
 	vb2_buffer_done(&cb->vb, (skip || s->unstable_frame) ?
-			VB2_BUF_STATE_QUEUED : VB2_BUF_STATE_DONE);
+			VB2_BUF_STATE_REQUEUEING : VB2_BUF_STATE_DONE);
 }
 
 irqreturn_t cobalt_irq_handler(int irq, void *dev_id)
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 1a096a6..45c571f 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1182,7 +1182,8 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 
 	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
 		    state != VB2_BUF_STATE_ERROR &&
-		    state != VB2_BUF_STATE_QUEUED))
+		    state != VB2_BUF_STATE_QUEUED &&
+		    state != VB2_BUF_STATE_REQUEUEING))
 		state = VB2_BUF_STATE_ERROR;
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -1199,22 +1200,30 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	for (plane = 0; plane < vb->num_planes; ++plane)
 		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
 
-	/* Add the buffer to the done buffers list */
 	spin_lock_irqsave(&q->done_lock, flags);
-	vb->state = state;
-	if (state != VB2_BUF_STATE_QUEUED)
+	if (state == VB2_BUF_STATE_QUEUED ||
+	    state == VB2_BUF_STATE_REQUEUEING) {
+		vb->state = VB2_BUF_STATE_QUEUED;
+	} else {
+		/* Add the buffer to the done buffers list */
 		list_add_tail(&vb->done_entry, &q->done_list);
+		vb->state = state;
+	}
 	atomic_dec(&q->owned_by_drv_count);
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
-	if (state == VB2_BUF_STATE_QUEUED) {
+	switch (state) {
+	case VB2_BUF_STATE_QUEUED:
+		return;
+	case VB2_BUF_STATE_REQUEUEING:
 		if (q->start_streaming_called)
 			__enqueue_in_driver(vb);
 		return;
+	default:
+		/* Inform any processes that may be waiting for buffers */
+		wake_up(&q->done_wq);
+		break;
 	}
-
-	/* Inform any processes that may be waiting for buffers */
-	wake_up(&q->done_wq);
 }
 EXPORT_SYMBOL_GPL(vb2_buffer_done);
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 22a44c2..c192e1b 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -139,6 +139,7 @@ enum vb2_io_modes {
  * @VB2_BUF_STATE_PREPARING:	buffer is being prepared in videobuf
  * @VB2_BUF_STATE_PREPARED:	buffer prepared in videobuf and by the driver
  * @VB2_BUF_STATE_QUEUED:	buffer queued in videobuf, but not in driver
+ * @VB2_BUF_STATE_REQUEUEING:	re-queue a buffer to the driver
  * @VB2_BUF_STATE_ACTIVE:	buffer queued in driver and possibly used
  *				in a hardware operation
  * @VB2_BUF_STATE_DONE:		buffer returned from driver to videobuf, but
@@ -152,6 +153,7 @@ enum vb2_buffer_state {
 	VB2_BUF_STATE_PREPARING,
 	VB2_BUF_STATE_PREPARED,
 	VB2_BUF_STATE_QUEUED,
+	VB2_BUF_STATE_REQUEUEING,
 	VB2_BUF_STATE_ACTIVE,
 	VB2_BUF_STATE_DONE,
 	VB2_BUF_STATE_ERROR,
-- 
2.1.4

