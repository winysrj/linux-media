Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34790 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaDTXzn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Apr 2014 19:55:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l: vb2: Avoid double WARN_ON when stopping streaming
Date: Mon, 21 Apr 2014 01:55:41 +0200
Message-Id: <1398038141-26572-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The __vb2_queue_cancel function marks the queue as not streaming and
then WARNs when buffers are still owned by the driver. It proceeds to
complete all active buffers by calling vb2_buffer_done with the new
buffer state set to VB2_BUF_STATE_ERROR in that case. This triggers
another WARN_ON due to as new state not being VB2_BUF_STATE_QUEUED while
the queue is not streaming.

Check buffer ownership and complete all active buffers before marking
the queue as not streaming to avoid the double WARN_on.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 6ab13b7..ab88c09 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2028,9 +2028,6 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 */
 	if (q->start_streaming_called)
 		call_qop(q, stop_streaming, q);
-	q->streaming = 0;
-	q->start_streaming_called = 0;
-	q->queued_count = 0;
 
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
 		for (i = 0; i < q->num_buffers; ++i)
@@ -2040,6 +2037,10 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 		WARN_ON(atomic_read(&q->owned_by_drv_count));
 	}
 
+	q->streaming = 0;
+	q->start_streaming_called = 0;
+	q->queued_count = 0;
+
 	/*
 	 * Remove all buffers from videobuf's list...
 	 */
-- 
Regards,

Laurent Pinchart

