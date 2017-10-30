Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.148.231]:23758 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750750AbdJ3ESt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Oct 2017 00:18:49 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 9C4193392150
        for <linux-media@vger.kernel.org>; Sun, 29 Oct 2017 23:18:48 -0500 (CDT)
Date: Sun, 29 Oct 2017 23:18:47 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] st-hva: hva-h264: use swap macro in hva_h264_encode
Message-ID: <20171030041847.GA24745@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make use of the swap macro and remove unnecessary variable tmp_frame.
This makes the code easier to read and maintain.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/platform/sti/hva/hva-h264.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/platform/sti/hva/hva-h264.c b/drivers/media/platform/sti/hva/hva-h264.c
index e6f247a..a7e5eed 100644
--- a/drivers/media/platform/sti/hva/hva-h264.c
+++ b/drivers/media/platform/sti/hva/hva-h264.c
@@ -999,7 +999,6 @@ static int hva_h264_encode(struct hva_ctx *pctx, struct hva_frame *frame,
 {
 	struct hva_h264_ctx *ctx = (struct hva_h264_ctx *)pctx->priv;
 	struct hva_h264_task *task = (struct hva_h264_task *)ctx->task->vaddr;
-	struct hva_buffer *tmp_frame;
 	u32 stuffing_bytes = 0;
 	int ret = 0;
 
@@ -1023,9 +1022,7 @@ static int hva_h264_encode(struct hva_ctx *pctx, struct hva_frame *frame,
 				       &stream->bytesused);
 
 	/* switch reference & reconstructed frame */
-	tmp_frame = ctx->ref_frame;
-	ctx->ref_frame = ctx->rec_frame;
-	ctx->rec_frame = tmp_frame;
+	swap(ctx->ref_frame, ctx->rec_frame);
 
 	return 0;
 err:
-- 
2.7.4
