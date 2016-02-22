Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58405 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755692AbcBVVTx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 16:19:53 -0500
Received: from axis700.grange ([87.79.174.200]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0MdoR7-1aJIcc0rZF-00PejR for
 <linux-media@vger.kernel.org>; Mon, 22 Feb 2016 22:19:51 +0100
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id CDA7A13EC9
	for <linux-media@vger.kernel.org>; Mon, 22 Feb 2016 22:19:49 +0100 (CET)
Date: Mon, 22 Feb 2016 22:19:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L2: fix a confusing function name
Message-ID: <Pine.LNX.4.64.1602222218230.15093@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

is_state_active_or_queued() actually returns true if the buffer's state
is neither active nore queued. Rename it for clarity.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/v4l2-core/videobuf-core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-core.c b/drivers/media/v4l2-core/videobuf-core.c
index 6c02989..def8475 100644
--- a/drivers/media/v4l2-core/videobuf-core.c
+++ b/drivers/media/v4l2-core/videobuf-core.c
@@ -75,7 +75,8 @@ struct videobuf_buffer *videobuf_alloc_vb(struct videobuf_queue *q)
 }
 EXPORT_SYMBOL_GPL(videobuf_alloc_vb);
 
-static int is_state_active_or_queued(struct videobuf_queue *q, struct videobuf_buffer *vb)
+static int state_neither_active_nor_queued(struct videobuf_queue *q,
+					   struct videobuf_buffer *vb)
 {
 	unsigned long flags;
 	bool rc;
@@ -95,7 +96,7 @@ int videobuf_waiton(struct videobuf_queue *q, struct videobuf_buffer *vb,
 	MAGIC_CHECK(vb->magic, MAGIC_BUFFER);
 
 	if (non_blocking) {
-		if (is_state_active_or_queued(q, vb))
+		if (state_neither_active_nor_queued(q, vb))
 			return 0;
 		return -EAGAIN;
 	}
@@ -107,9 +108,10 @@ int videobuf_waiton(struct videobuf_queue *q, struct videobuf_buffer *vb,
 	if (is_ext_locked)
 		mutex_unlock(q->ext_lock);
 	if (intr)
-		ret = wait_event_interruptible(vb->done, is_state_active_or_queued(q, vb));
+		ret = wait_event_interruptible(vb->done,
+					state_neither_active_nor_queued(q, vb));
 	else
-		wait_event(vb->done, is_state_active_or_queued(q, vb));
+		wait_event(vb->done, state_neither_active_nor_queued(q, vb));
 	/* Relock */
 	if (is_ext_locked)
 		mutex_lock(q->ext_lock);
-- 
1.9.3

