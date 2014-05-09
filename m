Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39933 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbaEIPcX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 11:32:23 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] vb2: drop queued buffers while q->start_streaming_called is still set
Date: Fri,  9 May 2014 17:32:20 +0200
Message-Id: <1399649540-20943-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Otherwise yet another warning will trigger in vb2_buffer_done.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/videobuf2-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 4d4f6ba..bdca528 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2088,8 +2088,6 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	if (q->start_streaming_called)
 		call_void_qop(q, stop_streaming, q);
 	q->streaming = 0;
-	q->start_streaming_called = 0;
-	q->queued_count = 0;
 
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
 		for (i = 0; i < q->num_buffers; ++i)
@@ -2098,6 +2096,8 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 		/* Must be zero now */
 		WARN_ON(atomic_read(&q->owned_by_drv_count));
 	}
+	q->start_streaming_called = 0;
+	q->queued_count = 0;
 
 	/*
 	 * Remove all buffers from videobuf's list...
-- 
2.0.0.rc0

