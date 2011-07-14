Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:54274 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab1GNVJf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 17:09:35 -0400
Date: Thu, 14 Jul 2011 15:09:34 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] videobuf2: call buf_finish() on unprocessed buffers
Message-ID: <20110714150934.74777696@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When user space stops streaming, there may be buffers which have been given
to buf_prepare() and which may or may not have been passed to buf_queue().
The videobuf2 core simply takes those buffers back; if buf_prepare() does
work that needs cleaning up (like setting up a DMA mapping), that cleanup
will not happen.

This patch establishes a simple contract with drivers: buffers given to
buf_prepare() will eventually see a buf_finish() call.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/videobuf2-core.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6ba1461..2ba08ab 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1177,6 +1177,7 @@ EXPORT_SYMBOL_GPL(vb2_streamon);
  */
 static void __vb2_queue_cancel(struct vb2_queue *q)
 {
+	struct vb2_buffer *vb;
 	unsigned int i;
 
 	/*
@@ -1188,13 +1189,18 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	q->streaming = 0;
 
 	/*
-	 * Remove all buffers from videobuf's list...
+	 * Remove all buffers from videobuf's list...  Give the driver
+	 * a chance to clean them up first, though.
 	 */
+	list_for_each_entry(vb, &q->queued_list, queued_entry)
+		call_qop(q, buf_finish, vb);
 	INIT_LIST_HEAD(&q->queued_list);
 	/*
 	 * ...and done list; userspace will not receive any buffers it
 	 * has not already dequeued before initiating cancel.
 	 */
+	list_for_each_entry(vb, &q->done_list, done_entry)
+		call_qop(q, buf_finish, vb);
 	INIT_LIST_HEAD(&q->done_list);
 	wake_up_all(&q->done_wq);
 
-- 
1.7.6

