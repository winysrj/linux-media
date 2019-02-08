Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBDFC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49F2A2084D
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfBHQVk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 11:21:40 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55444 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727325AbfBHQVk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 11:21:40 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id B3C5027F6B8
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 07/10] s5p-jpeg: Correct return type for mem2mem buffer helpers
Date:   Fri,  8 Feb 2019 13:17:45 -0300
Message-Id: <20190208161748.5862-8-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208161748.5862-1-ezequiel@collabora.com>
References: <20190208161748.5862-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Fix the assigned type of mem2mem buffer handling API.
Namely, these functions:

 v4l2_m2m_next_buf
 v4l2_m2m_last_buf
 v4l2_m2m_buf_remove
 v4l2_m2m_next_src_buf
 v4l2_m2m_next_dst_buf
 v4l2_m2m_last_src_buf
 v4l2_m2m_last_dst_buf
 v4l2_m2m_src_buf_remove
 v4l2_m2m_dst_buf_remove

return a struct vb2_v4l2_buffer, and not a struct vb2_buffer.

Fixing this is necessary to fix the mem2mem buffer handling API,
changing the return to the correct struct vb2_v4l2_buffer instead
of a void pointer.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 38 ++++++++++-----------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 0a23b2d19e14..8cc730eccb6c 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -793,14 +793,14 @@ static void skip(struct s5p_jpeg_buffer *buf, long len);
 static void exynos4_jpeg_parse_decode_h_tbl(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	struct vb2_v4l2_buffer *vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	struct s5p_jpeg_buffer jpeg_buffer;
 	unsigned int word;
 	int c, x, components;
 
 	jpeg_buffer.size = 2; /* Ls */
 	jpeg_buffer.data =
-		(unsigned long)vb2_plane_vaddr(vb, 0) + ctx->out_q.sos + 2;
+		(unsigned long)vb2_plane_vaddr(&vb->vb2_buf, 0) + ctx->out_q.sos + 2;
 	jpeg_buffer.curr = 0;
 
 	word = 0;
@@ -830,14 +830,14 @@ static void exynos4_jpeg_parse_decode_h_tbl(struct s5p_jpeg_ctx *ctx)
 static void exynos4_jpeg_parse_huff_tbl(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	struct vb2_v4l2_buffer *vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	struct s5p_jpeg_buffer jpeg_buffer;
 	unsigned int word;
 	int c, i, n, j;
 
 	for (j = 0; j < ctx->out_q.dht.n; ++j) {
 		jpeg_buffer.size = ctx->out_q.dht.len[j];
-		jpeg_buffer.data = (unsigned long)vb2_plane_vaddr(vb, 0) +
+		jpeg_buffer.data = (unsigned long)vb2_plane_vaddr(&vb->vb2_buf, 0) +
 				   ctx->out_q.dht.marker[j];
 		jpeg_buffer.curr = 0;
 
@@ -889,13 +889,13 @@ static void exynos4_jpeg_parse_huff_tbl(struct s5p_jpeg_ctx *ctx)
 static void exynos4_jpeg_parse_decode_q_tbl(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	struct vb2_v4l2_buffer *vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	struct s5p_jpeg_buffer jpeg_buffer;
 	int c, x, components;
 
 	jpeg_buffer.size = ctx->out_q.sof_len;
 	jpeg_buffer.data =
-		(unsigned long)vb2_plane_vaddr(vb, 0) + ctx->out_q.sof;
+		(unsigned long)vb2_plane_vaddr(&vb->vb2_buf, 0) + ctx->out_q.sof;
 	jpeg_buffer.curr = 0;
 
 	skip(&jpeg_buffer, 5); /* P, Y, X */
@@ -920,14 +920,14 @@ static void exynos4_jpeg_parse_decode_q_tbl(struct s5p_jpeg_ctx *ctx)
 static void exynos4_jpeg_parse_q_tbl(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	struct vb2_v4l2_buffer *vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	struct s5p_jpeg_buffer jpeg_buffer;
 	unsigned int word;
 	int c, i, j;
 
 	for (j = 0; j < ctx->out_q.dqt.n; ++j) {
 		jpeg_buffer.size = ctx->out_q.dqt.len[j];
-		jpeg_buffer.data = (unsigned long)vb2_plane_vaddr(vb, 0) +
+		jpeg_buffer.data = (unsigned long)vb2_plane_vaddr(&vb->vb2_buf, 0) +
 				   ctx->out_q.dqt.marker[j];
 		jpeg_buffer.curr = 0;
 
@@ -2075,15 +2075,15 @@ static void s5p_jpeg_device_run(void *priv)
 {
 	struct s5p_jpeg_ctx *ctx = priv;
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	unsigned long src_addr, dst_addr, flags;
 
 	spin_lock_irqsave(&ctx->jpeg->slock, flags);
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
-	src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	src_addr = vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
 
 	s5p_jpeg_reset(jpeg->regs);
 	s5p_jpeg_poweron(jpeg->regs);
@@ -2156,7 +2156,7 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
 	struct s5p_jpeg_fmt *fmt;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	struct s5p_jpeg_addr jpeg_addr = {};
 	u32 pix_size, padding_bytes = 0;
 
@@ -2175,7 +2175,7 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 		vb = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	}
 
-	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 
 	if (fmt->colplanes == 2) {
 		jpeg_addr.cb = jpeg_addr.y + pix_size - padding_bytes;
@@ -2193,7 +2193,7 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 static void exynos4_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int jpeg_addr = 0;
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
@@ -2201,7 +2201,7 @@ static void exynos4_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 	else
 		vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
-	jpeg_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	if (jpeg->variant->version == SJPEG_EXYNOS5433 &&
 	    ctx->mode == S5P_JPEG_DECODE)
 		jpeg_addr += ctx->out_q.sos;
@@ -2317,7 +2317,7 @@ static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
 	struct s5p_jpeg_fmt *fmt;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	struct s5p_jpeg_addr jpeg_addr = {};
 	u32 pix_size;
 
@@ -2331,7 +2331,7 @@ static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 		fmt = ctx->cap_q.fmt;
 	}
 
-	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 
 	if (fmt->colplanes == 2) {
 		jpeg_addr.cb = jpeg_addr.y + pix_size;
@@ -2349,7 +2349,7 @@ static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 static void exynos3250_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int jpeg_addr = 0;
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
@@ -2357,7 +2357,7 @@ static void exynos3250_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 	else
 		vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
-	jpeg_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	exynos3250_jpeg_jpgadr(jpeg->regs, jpeg_addr);
 }
 
-- 
2.20.1

