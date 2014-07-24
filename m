Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:21571
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754861AbaGWD5E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 23:57:04 -0400
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH] v4l2: don't warn before we release buffer
Date: Thu, 24 Jul 2014 11:53:31 +0800
Message-ID: <1406174011-13600-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In fact we only need to give a warning if the driver still use the
buffer after we release all queued buffers.

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7c4489c..fa5dd73 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2112,7 +2112,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	if (q->start_streaming_called)
 		call_void_qop(q, stop_streaming, q);
 
-	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
+	if (atomic_read(&q->owned_by_drv_count)) {
 		for (i = 0; i < q->num_buffers; ++i)
 			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
 				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
-- 
1.7.9.5

