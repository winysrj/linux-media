Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39926 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263AbaEIPcO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 11:32:14 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] vb2: fix num_buffers calculation if req->count > VIDEO_MAX_FRAMES
Date: Fri,  9 May 2014 17:32:10 +0200
Message-Id: <1399649530-20885-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/videobuf2-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 40024d7..4d4f6ba 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -905,7 +905,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	 * Make sure the requested values and current defaults are sane.
 	 */
 	num_buffers = min_t(unsigned int, req->count, VIDEO_MAX_FRAME);
-	num_buffers = max_t(unsigned int, req->count, q->min_buffers_needed);
+	num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
 	memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
 	q->memory = req->memory;
-- 
2.0.0.rc0

