Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79302C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4242520651
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553711734;
	bh=Xa8iLOHJ3fFSi8X7uRQmVnJS7slH+qj31U87NYBFmJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=165tOOKaQJa07yCfNRd2Ur9v+4hpFaFChrRYJZk8ImL8e2n6MbF+VnAyxE2C0TtDa
	 1ugvrqtM2bYfCUwGvv78ktkGtD9pW/2ssbrTCZtxODuA7ytB9ewEGuRpsXCWg9m4Lp
	 j+AX7XQwQJbWDoq/1lZNyX5G07C3YBqA8aHxgARI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391358AbfC0SYT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404008AbfC0SYT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 14:24:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA0642063F;
        Wed, 27 Mar 2019 18:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553711057;
        bh=Xa8iLOHJ3fFSi8X7uRQmVnJS7slH+qj31U87NYBFmJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sVVmkFjFR+kJQ7wal3CF/syQIMkkiHTASRi7jmo3zkpC2vARL6s2HhBUXVbHVOBw6
         QXCkZpvwojxnwCob0kZFO93HJQyKu+KTOVA4xS5zG2oCCmyoHeUynwwXUguYkI/2gB
         S+LUFVNQgmkXR70svDRE2ikO2SIsVWdCTPAvblcQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 32/63] media: s5p-jpeg: Correct return type for mem2mem buffer helpers
Date:   Wed, 27 Mar 2019 14:22:52 -0400
Message-Id: <20190327182323.18577-32-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327182323.18577-1-sashal@kernel.org>
References: <20190327182323.18577-1-sashal@kernel.org>
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
index 9c6fc09b88e0..80c83bba7af3 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -788,14 +788,14 @@ static void skip(struct s5p_jpeg_buffer *buf, long len);
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
@@ -825,14 +825,14 @@ static void exynos4_jpeg_parse_decode_h_tbl(struct s5p_jpeg_ctx *ctx)
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
 
@@ -884,13 +884,13 @@ static void exynos4_jpeg_parse_huff_tbl(struct s5p_jpeg_ctx *ctx)
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
@@ -915,14 +915,14 @@ static void exynos4_jpeg_parse_decode_q_tbl(struct s5p_jpeg_ctx *ctx)
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
 
@@ -2016,15 +2016,15 @@ static void s5p_jpeg_device_run(void *priv)
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
@@ -2097,7 +2097,7 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
 	struct s5p_jpeg_fmt *fmt;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	struct s5p_jpeg_addr jpeg_addr = {};
 	u32 pix_size, padding_bytes = 0;
 
@@ -2116,7 +2116,7 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 		vb = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	}
 
-	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 
 	if (fmt->colplanes == 2) {
 		jpeg_addr.cb = jpeg_addr.y + pix_size - padding_bytes;
@@ -2134,7 +2134,7 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 static void exynos4_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int jpeg_addr = 0;
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
@@ -2142,7 +2142,7 @@ static void exynos4_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 	else
 		vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
-	jpeg_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	if (jpeg->variant->version == SJPEG_EXYNOS5433 &&
 	    ctx->mode == S5P_JPEG_DECODE)
 		jpeg_addr += ctx->out_q.sos;
@@ -2257,7 +2257,7 @@ static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
 	struct s5p_jpeg_fmt *fmt;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	struct s5p_jpeg_addr jpeg_addr = {};
 	u32 pix_size;
 
@@ -2271,7 +2271,7 @@ static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 		fmt = ctx->cap_q.fmt;
 	}
 
-	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 
 	if (fmt->colplanes == 2) {
 		jpeg_addr.cb = jpeg_addr.y + pix_size;
@@ -2289,7 +2289,7 @@ static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 static void exynos3250_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int jpeg_addr = 0;
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
@@ -2297,7 +2297,7 @@ static void exynos3250_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 	else
 		vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
-	jpeg_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	exynos3250_jpeg_jpgadr(jpeg->regs, jpeg_addr);
 }
 
-- 
2.19.1

