Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35258 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751351AbdIABuy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 21:50:54 -0400
Received: by mail-qt0-f196.google.com with SMTP id u11so1008659qtu.2
        for <linux-media@vger.kernel.org>; Thu, 31 Aug 2017 18:50:54 -0700 (PDT)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v2 02/14] [media] vb2: check earlier if stream can be started
Date: Thu, 31 Aug 2017 22:50:29 -0300
Message-Id: <20170901015041.7757-3-gustavo@padovan.org>
In-Reply-To: <20170901015041.7757-1-gustavo@padovan.org>
References: <20170901015041.7757-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

To support explicit synchronization we need to run all operations that can
fail before we queue the buffer to the driver. With fences the queueing
will be delayed if the fence is not signaled yet and it will be better if
such callback do not fail.

For that we move the vb2_start_streaming() before the queuing for the
buffer may happen.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index cb115ba6a1d2..60f8b582396a 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1399,29 +1399,27 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	trace_vb2_qbuf(q, vb);
 
 	/*
-	 * If already streaming, give the buffer to driver for processing.
-	 * If not, the buffer will be given to driver on next streamon.
-	 */
-	if (q->start_streaming_called)
-		__enqueue_in_driver(vb);
-
-	/* Fill buffer information for the userspace */
-	if (pb)
-		call_void_bufop(q, fill_user_buffer, vb, pb);
-
-	/*
 	 * If streamon has been called, and we haven't yet called
 	 * start_streaming() since not enough buffers were queued, and
 	 * we now have reached the minimum number of queued buffers,
 	 * then we can finally call start_streaming().
+	 *
+	 * If already streaming, give the buffer to driver for processing.
+	 * If not, the buffer will be given to driver on next streamon.
 	 */
 	if (q->streaming && !q->start_streaming_called &&
 	    q->queued_count >= q->min_buffers_needed) {
 		ret = vb2_start_streaming(q);
 		if (ret)
 			return ret;
+	} else if (q->start_streaming_called) {
+		__enqueue_in_driver(vb);
 	}
 
+	/* Fill buffer information for the userspace */
+	if (pb)
+		call_void_bufop(q, fill_user_buffer, vb, pb);
+
 	dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
 	return 0;
 }
-- 
2.13.5
