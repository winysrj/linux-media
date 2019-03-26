Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB59CC4360F
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 07:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 965D920857
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 07:44:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Z6v0XXqM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbfCZHod (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 03:44:33 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45747 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfCZHod (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 03:44:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id e24so6838256pfi.12
        for <linux-media@vger.kernel.org>; Tue, 26 Mar 2019 00:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=guX9JjzludzjpfbhyDia6d8Kx5PRCAeJ16z/HP1EEq8=;
        b=Z6v0XXqM7DONOBaYbfDIEbQF39dWcHODW3NiueK5leRqOl31GAH3JjWOtt5LUV58Wn
         SEksRJkRoXrHkTuur7PzDZekWyCXNpjPgMtaInVdGo+1XuXVBtSMezQfxsEUasvUC8yW
         pb0w+3/lBkkJvXQqJ0Mfb7e47wM46xol6Qo6I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=guX9JjzludzjpfbhyDia6d8Kx5PRCAeJ16z/HP1EEq8=;
        b=NZbCaw4r/vYhsnDh5ZIEqYE4rMbOL5+WtBzNO1PBMbwqhsQzjSnLWHyZQqX5FFX+LX
         cz1JR7R0L3pYmkbuFToNWhSLcx1Rf72Z/moLnuVuDogSrU9CkLvWCemdn9XuV76YidIB
         ZG9AgVWggtHdRrRJlZaFHH6F3EiH+r8lXRrikgvzen+P0H9I+0+aSiRH8HPe0fCiyc/U
         j3Ng/s8bFKAsJcGq4l0G0IaRNRTYkPtCQTc3aqkJp0hQHZ8bAkRU46iUtI0y2uKg7qaC
         n41xRTshIwr9XPIhOBjkH40osWiQobMCZMC8cmg7R7Uk3BcWG2KaFMY5U/+pBUD8pJcg
         7t7w==
X-Gm-Message-State: APjAAAU+fUCyk5MNs9FDYGzXp53clECCSvz5p8zY8cy+nm71q2W60RzK
        Ii0HmxoMPCjW7ym/LCzOZNIg9Q==
X-Google-Smtp-Source: APXvYqyaJId/+xlnGKhyV500nOy9o4V1J2JSBRH2FN7nRJEBNWH3MDDTL/+Rtka8ilCknE+BJPh64w==
X-Received: by 2002:a62:e502:: with SMTP id n2mr28662586pff.242.1553586272232;
        Tue, 26 Mar 2019 00:44:32 -0700 (PDT)
Received: from acourbot.tok.corp.google.com ([2401:fa00:4:4:9712:8cf1:d0f:7d33])
        by smtp.gmail.com with ESMTPSA id n9sm19716753pff.43.2019.03.26.00.44.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Mar 2019 00:44:31 -0700 (PDT)
From:   Alexandre Courbot <acourbot@chromium.org>
To:     Ezequiel Garcia <ezequiel@collabora.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH] media: mtk-vcodec: fix access to incorrect planes member
Date:   Tue, 26 Mar 2019 16:44:23 +0900
Message-Id: <20190326074423.123864-1-acourbot@chromium.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Commit 0650a91499e0 ("media: mtk-vcodec: Correct return type for mem2mem
buffer helpers") fixed the return types for mem2mem buffer helper
functions by changing a few local variables from vb2_buffer to
vb2_v4l2_buffer. However, it left a few accesses to vb2_buffer::planes
as-is, accidentally turning them into accesses to
vb2_v4l2_buffer::planes and resulting in values being read from/written
to the wrong place.

Fix this by inserting vb2_buf into these accesses so they mimic their
original behavior.

Fixes: 0650a91499e0 ("media: mtk-vcodec: Correct return type for mem2mem buffer helpers")

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |  4 ++--
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index a85c7cc8328e..e20b340855e7 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -388,7 +388,7 @@ static void mtk_vdec_worker(struct work_struct *work)
 	}
 	buf.va = vb2_plane_vaddr(&src_buf->vb2_buf, 0);
 	buf.dma_addr = vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
-	buf.size = (size_t)src_buf->planes[0].bytesused;
+	buf.size = (size_t)src_buf->vb2_buf.planes[0].bytesused;
 	if (!buf.va) {
 		v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
 		mtk_v4l2_err("[%d] id=%d src_addr is NULL!!",
@@ -1155,7 +1155,7 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 
 	src_mem.va = vb2_plane_vaddr(&src_buf->vb2_buf, 0);
 	src_mem.dma_addr = vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
-	src_mem.size = (size_t)src_buf->planes[0].bytesused;
+	src_mem.size = (size_t)src_buf->vb2_buf.planes[0].bytesused;
 	mtk_v4l2_debug(2,
 			"[%d] buf id=%d va=%p dma=%pad size=%zx",
 			ctx->id, src_buf->vb2_buf.index,
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index c6b48b5925fb..50351adafc47 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -894,7 +894,7 @@ static void vb2ops_venc_stop_streaming(struct vb2_queue *q)
 
 	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		while ((dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx))) {
-			dst_buf->planes[0].bytesused = 0;
+			dst_buf->vb2_buf.planes[0].bytesused = 0;
 			v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
 		}
 	} else {
@@ -947,7 +947,7 @@ static int mtk_venc_encode_header(void *priv)
 
 	bs_buf.va = vb2_plane_vaddr(&dst_buf->vb2_buf, 0);
 	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
-	bs_buf.size = (size_t)dst_buf->planes[0].length;
+	bs_buf.size = (size_t)dst_buf->vb2_buf.planes[0].length;
 
 	mtk_v4l2_debug(1,
 			"[%d] buf id=%d va=0x%p dma_addr=0x%llx size=%zu",
@@ -976,7 +976,7 @@ static int mtk_venc_encode_header(void *priv)
 	}
 
 	ctx->state = MTK_STATE_HEADER;
-	dst_buf->planes[0].bytesused = enc_result.bs_size;
+	dst_buf->vb2_buf.planes[0].bytesused = enc_result.bs_size;
 	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
 
 	return 0;
@@ -1107,12 +1107,12 @@ static void mtk_venc_worker(struct work_struct *work)
 
 	if (ret) {
 		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
-		dst_buf->planes[0].bytesused = 0;
+		dst_buf->vb2_buf.planes[0].bytesused = 0;
 		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
 		mtk_v4l2_err("venc_if_encode failed=%d", ret);
 	} else {
 		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
-		dst_buf->planes[0].bytesused = enc_result.bs_size;
+		dst_buf->vb2_buf.planes[0].bytesused = enc_result.bs_size;
 		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
 		mtk_v4l2_debug(2, "venc_if_encode bs size=%d",
 				 enc_result.bs_size);
-- 
2.21.0.392.gf8f6787159e-goog

