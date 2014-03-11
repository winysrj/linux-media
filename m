Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:59348 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbaCKWwX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 18:52:23 -0400
Received: by mail-qc0-f202.google.com with SMTP id m20so1228268qcx.1
        for <linux-media@vger.kernel.org>; Tue, 11 Mar 2014 15:52:22 -0700 (PDT)
From: John Sheu <sheu@google.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, k.debski@samsung.com, posciak@google.com,
	arun.m@samsung.com, kgene.kim@samsung.com,
	John Sheu <sheu@google.com>
Subject: [PATCH 1/4] s5p-mfc: fix encoder crash after VIDIOC_STREAMOFF
Date: Tue, 11 Mar 2014 15:52:02 -0700
Message-Id: <1394578325-11298-2-git-send-email-sheu@google.com>
In-Reply-To: <1394578325-11298-1-git-send-email-sheu@google.com>
References: <1394578325-11298-1-git-send-email-sheu@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_STREAMOFF clears the encoder's destination queue -- routines run
from the interrupt handler cannot assume that the queue is non-empty.

Signed-off-by: John Sheu <sheu@google.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index df83cd15..04236229 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -772,13 +772,16 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 
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
 
@@ -883,8 +886,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
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
1.9.0.279.gdc9e3eb

