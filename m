Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:10761 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027AbaIDCcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 22:32:41 -0400
From: Zhaowei Yuan <zhaowei.yuan@samsung.com>
To: linux-media@vger.kernel.org, k.debski@samsung.com,
	m.chehab@samsung.com, kyungmin.park@samsung.com,
	jtp.park@samsung.com
Cc: linux-samsung-soc@vger.kernel.org
Subject: [PATCH] [media] s5p_mfc: unify variable naming style
Date: Thu, 04 Sep 2014 10:28:43 +0800
Message-id: <1409797723-2670-1-git-send-email-zhaowei.yuan@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Variable frame_size represents the size of plane luminance
here, not just frame size, its naming style should be unified
as frame_size_ch and frame_size_mv.

Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 58ec7bb..94023db 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -377,7 +377,7 @@ static int s5p_mfc_set_dec_stream_buffer_v5(struct s5p_mfc_ctx *ctx,
 /* Set decoding frame buffer */
 static int s5p_mfc_set_dec_frame_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
-	unsigned int frame_size, i;
+	unsigned int frame_size_lu, i;
 	unsigned int frame_size_ch, frame_size_mv;
 	struct s5p_mfc_dev *dev = ctx->dev;
 	unsigned int dpb;
@@ -465,10 +465,10 @@ static int s5p_mfc_set_dec_frame_buffer_v5(struct s5p_mfc_ctx *ctx)
 			ctx->codec_mode);
 		return -EINVAL;
 	}
-	frame_size = ctx->luma_size;
+	frame_size_lu = ctx->luma_size;
 	frame_size_ch = ctx->chroma_size;
 	frame_size_mv = ctx->mv_size;
-	mfc_debug(2, "Frm size: %d ch: %d mv: %d\n", frame_size, frame_size_ch,
+	mfc_debug(2, "Frm size: %d ch: %d mv: %d\n", frame_size_lu, frame_size_ch,
 								frame_size_mv);
 	for (i = 0; i < ctx->total_dpb_count; i++) {
 		/* Bank2 */
@@ -496,7 +496,7 @@ static int s5p_mfc_set_dec_frame_buffer_v5(struct s5p_mfc_ctx *ctx)
 		mfc_debug(2, "Not enough memory has been allocated\n");
 		return -ENOMEM;
 	}
-	s5p_mfc_write_info_v5(ctx, frame_size, ALLOC_LUMA_DPB_SIZE);
+	s5p_mfc_write_info_v5(ctx, frame_size_lu, ALLOC_LUMA_DPB_SIZE);
 	s5p_mfc_write_info_v5(ctx, frame_size_ch, ALLOC_CHROMA_DPB_SIZE);
 	if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC)
 		s5p_mfc_write_info_v5(ctx, frame_size_mv, ALLOC_MV_SIZE);
--
1.7.9.5

