Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:56842 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753343AbdJTVvA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 17:51:00 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC v4 11/17] [media] vb2: check earlier if stream can be started
Date: Fri, 20 Oct 2017 19:50:06 -0200
Message-Id: <20171020215012.20646-12-gustavo@padovan.org>
In-Reply-To: <20171020215012.20646-1-gustavo@padovan.org>
References: <20171020215012.20646-1-gustavo@padovan.org>
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
2.13.6
