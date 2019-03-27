Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7495DC10F00
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 19:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BD5A204FD
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 19:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553713527;
	bh=A5//DwjMM/8YR4wegUV+QJa9ubalnjJKgN4qLQl2+fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sA8mYB9mcuk7zzpV1RtfSzyTHB/YbuT0LIx7dbPlg47ZLZ6nCEisNsAsql0cwa0Yt
	 1MPX3cXuDJ1aR60SVif6FVgvPFqRTGuVi5lv3q8QO5F6QvrLSOiMVzKhiz9vqtctn0
	 w9Nv/06tSUWGU7Wwrcbmw/wJ1gPjKzGEJb3AwLWM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389493AbfC0TFN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 15:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387871AbfC0SMz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 14:12:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED05D2183E;
        Wed, 27 Mar 2019 18:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710374;
        bh=A5//DwjMM/8YR4wegUV+QJa9ubalnjJKgN4qLQl2+fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcncQ8TKUqhfjXdcotwl7oPN4tg/k21LQ2fRPfElvxRw9xQ4/jG5Jd/444qo9IfSp
         F0dvzKvJgTUYU9bOWxATTjCdDUhJzTOgZzSaoypZSMaOWIoYFo4hyxZ9rHicOHKGwj
         AhXDPs1Uc0FEMaju+A7RcGi9O9ipdh6GjjKw58XA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 086/192] media: s5p-jpeg: Correct return type for mem2mem buffer helpers
Date:   Wed, 27 Mar 2019 14:08:38 -0400
Message-Id: <20190327181025.13507-86-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327181025.13507-1-sashal@kernel.org>
References: <20190327181025.13507-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit 4a88f89885c7cf65c62793f385261a6e3315178a ]

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
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 38 ++++++++++-----------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 04fd2e0493c0..29daecf8de7d 100644
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
 
@@ -2072,15 +2072,15 @@ static void s5p_jpeg_device_run(void *priv)
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
@@ -2153,7 +2153,7 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
 	struct s5p_jpeg_fmt *fmt;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	struct s5p_jpeg_addr jpeg_addr = {};
 	u32 pix_size, padding_bytes = 0;
 
@@ -2172,7 +2172,7 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 		vb = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	}
 
-	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 
 	if (fmt->colplanes == 2) {
 		jpeg_addr.cb = jpeg_addr.y + pix_size - padding_bytes;
@@ -2190,7 +2190,7 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 static void exynos4_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int jpeg_addr = 0;
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
@@ -2198,7 +2198,7 @@ static void exynos4_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 	else
 		vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
-	jpeg_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	if (jpeg->variant->version == SJPEG_EXYNOS5433 &&
 	    ctx->mode == S5P_JPEG_DECODE)
 		jpeg_addr += ctx->out_q.sos;
@@ -2314,7 +2314,7 @@ static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
 	struct s5p_jpeg_fmt *fmt;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	struct s5p_jpeg_addr jpeg_addr = {};
 	u32 pix_size;
 
@@ -2328,7 +2328,7 @@ static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 		fmt = ctx->cap_q.fmt;
 	}
 
-	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 
 	if (fmt->colplanes == 2) {
 		jpeg_addr.cb = jpeg_addr.y + pix_size;
@@ -2346,7 +2346,7 @@ static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 static void exynos3250_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int jpeg_addr = 0;
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
@@ -2354,7 +2354,7 @@ static void exynos3250_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 	else
 		vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
-	jpeg_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	exynos3250_jpeg_jpgadr(jpeg->regs, jpeg_addr);
 }
 
-- 
2.19.1

