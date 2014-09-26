Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:64790 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbaIZFAD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 01:00:03 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NCH00737SK2XUD0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Sep 2014 14:00:02 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com, kiran@chromium.org
Subject: [PATCH v2 10/14] [media] s5p-mfc: flush dpbs when resolution changes
Date: Fri, 26 Sep 2014 10:22:18 +0530
Message-id: <1411707142-4881-11-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
References: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While resolution change is detected by MFC, we flush out
older dpbs, send the resolution change event to application,
and then accept further queuing of new src buffers.

Sometimes, we error out during dpb flush because of lack of src
buffers. Since we have not started decoding new resolution yet,
it is simpler to push zero-size buffer until we flush out all dpbs.

This is already been done while handling EOS command, and this patch
extends the same logic to resolution change as well.

Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index c1c12f8..991008a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1537,27 +1537,11 @@ static inline int s5p_mfc_get_new_ctx(struct s5p_mfc_dev *dev)
 static inline void s5p_mfc_run_dec_last_frames(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-	struct s5p_mfc_buf *temp_vb;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->irqlock, flags);
-
-	/* Frames are being decoded */
-	if (list_empty(&ctx->src_queue)) {
-		mfc_debug(2, "No src buffers.\n");
-		spin_unlock_irqrestore(&dev->irqlock, flags);
-		return;
-	}
-	/* Get the next source buffer */
-	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
-	temp_vb->flags |= MFC_BUF_FLAG_USED;
-	s5p_mfc_set_dec_stream_buffer_v6(ctx,
-			vb2_dma_contig_plane_dma_addr(temp_vb->b, 0), 0, 0);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
 
+	s5p_mfc_set_dec_stream_buffer_v6(ctx, 0, 0, 0);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_clean_ctx_int_flags(ctx);
-	s5p_mfc_decode_one_frame_v6(ctx, 1);
+	s5p_mfc_decode_one_frame_v6(ctx, MFC_DEC_LAST_FRAME);
 }
 
 static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
-- 
1.7.9.5

