Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:13092 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422817Ab2KNNEv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 08:04:51 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDH00GYQB01BM50@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Nov 2012 22:04:49 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MDH004O6AZ4KYB0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Nov 2012 22:04:49 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, arun.m@samsung.com,
	arun.kk@samsung.com
Subject: [PATCH] [media] s5p-mfc: Handle multi-frame input buffer
Date: Wed, 14 Nov 2012 18:56:45 +0530
Message-id: <1352899605-12043-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When one input buffer has multiple frames, it should be fed
again to the hardware with the remaining bytes. Removed the
check for P frame in this scenario as this condition can come with
all frame types.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: ARUN MANKUZHI <arun.m@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 0ca8dbb..d3cd738 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -382,11 +382,8 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 		ctx->consumed_stream += s5p_mfc_hw_call(dev->mfc_ops,
 						get_consumed_stream, dev);
 		if (ctx->codec_mode != S5P_MFC_CODEC_H264_DEC &&
-			s5p_mfc_hw_call(dev->mfc_ops,
-				get_dec_frame_type, dev) ==
-					S5P_FIMV_DECODE_FRAME_P_FRAME
-					&& ctx->consumed_stream + STUFF_BYTE <
-					src_buf->b->v4l2_planes[0].bytesused) {
+			ctx->consumed_stream + STUFF_BYTE <
+			src_buf->b->v4l2_planes[0].bytesused) {
 			/* Run MFC again on the same buffer */
 			mfc_debug(2, "Running again the same buffer\n");
 			ctx->after_packed_pb = 1;
-- 
1.7.0.4

