Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:51039 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab3JIXuh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Oct 2013 19:50:37 -0400
Received: by mail-pa0-f73.google.com with SMTP id kp14so141635pab.4
        for <linux-media@vger.kernel.org>; Wed, 09 Oct 2013 16:50:36 -0700 (PDT)
From: John Sheu <sheu@google.com>
To: linux-media@vger.kernel.org
Cc: John Sheu <sheu@google.com>, m.chehab@samsung.com,
	k.debski@samsung.com, pawel@osciak.com
Subject: [PATCH 2/6] [media] s5p-mfc: fix encoder crash after VIDIOC_STREAMOFF
Date: Wed,  9 Oct 2013 16:49:45 -0700
Message-Id: <1381362589-32237-3-git-send-email-sheu@google.com>
In-Reply-To: <1381362589-32237-1-git-send-email-sheu@google.com>
References: <1381362589-32237-1-git-send-email-sheu@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_STREAMOFF clears the encoder's destination queue -- routines run
from the interrupt handler cannot assume that the queue is non-empty.

Signed-off-by: John Sheu <sheu@google.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 41f5a3c..8b24829 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -714,13 +714,16 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 
 	if (p->seq_hdr_mode == V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE) {
 		spin_lock_irqsave(&dev->irqlock, flags);
-		dst_mb = list_entry(ctx->dst_queue.next,
-				struct s5p_mfc_buf, list);
-		list_del(&dst_mb->list);
-		ctx->dst_queue_cnt--;
-		vb2_set_plane_payload(dst_mb->b, 0,
-			s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size, dev));
-		vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
+		if (!list_empty(&ctx->dst_queue)) {
+			dst_mb = list_entry(ctx->dst_queue.next,
+					struct s5p_mfc_buf, list);
+			list_del(&dst_mb->list);
+			ctx->dst_queue_cnt--;
+			vb2_set_plane_payload(dst_mb->b, 0,
+				s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size,
+						dev));
+			vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
+		}
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	}
 
@@ -825,8 +828,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 		mfc_debug(2, "enc src count: %d, enc ref count: %d\n",
 			  ctx->src_queue_cnt, ctx->ref_queue_cnt);
 	}
-	if (strm_size > 0) {
-		/* at least one more dest. buffers exist always  */
+	if ((ctx->dst_queue_cnt > 0) && (strm_size > 0)) {
 		mb_entry = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf,
 									list);
 		list_del(&mb_entry->list);
-- 
1.8.4

