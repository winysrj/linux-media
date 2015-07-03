Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:49947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330AbbGCKVY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jul 2015 06:21:24 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@osg.samsung.com
Subject: [PATCH 1/1] vb2: Only requeue buffers immediately once streaming is started
Date: Fri,  3 Jul 2015 13:20:10 +0300
Message-Id: <1435918810-21180-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Buffers can be returned back to videobuf2 in driver's streamon handler. In
this case vb2_buffer_done() with buffer state VB2_BUF_STATE_QUEUED will
cause the driver's buf_queue vb2 operation to be called, queueing the same
buffer again only to be returned to videobuf2 using vb2_buffer_done() and so
on.

Instead of using q->start_streamin_called to judge whether to return the
buffer to the driver immediately, use q->streaming which is set only after
the driver's start_streaming() vb2 operation is called.

Fixes: ce0eff016f72 ("[media] vb2: allow requeuing buffers while streaming")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: stable@vger.kernel.org # for v4.1
---
 drivers/media/v4l2-core/videobuf2-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 1a096a6..6957078 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1208,7 +1208,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
 	if (state == VB2_BUF_STATE_QUEUED) {
-		if (q->start_streaming_called)
+		if (q->streaming)
 			__enqueue_in_driver(vb);
 		return;
 	}
-- 
2.1.4

