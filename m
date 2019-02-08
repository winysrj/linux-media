Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C5EC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C802084D
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfBHQVa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 11:21:30 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55426 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfBHQVa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 11:21:30 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id F0F1B263995
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 02/10] mtk-mdp: Correct return type for mem2mem buffer helpers
Date:   Fri,  8 Feb 2019 13:17:40 -0300
Message-Id: <20190208161748.5862-3-ezequiel@collabora.com>
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
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
index 51a13466261e..7d15c06e9db9 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
@@ -473,20 +473,17 @@ static void mtk_mdp_prepare_addr(struct mtk_mdp_ctx *ctx,
 static void mtk_mdp_m2m_get_bufs(struct mtk_mdp_ctx *ctx)
 {
 	struct mtk_mdp_frame *s_frame, *d_frame;
-	struct vb2_buffer *src_vb, *dst_vb;
 	struct vb2_v4l2_buffer *src_vbuf, *dst_vbuf;
 
 	s_frame = &ctx->s_frame;
 	d_frame = &ctx->d_frame;
 
-	src_vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
-	mtk_mdp_prepare_addr(ctx, src_vb, s_frame, &s_frame->addr);
+	src_vbuf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	mtk_mdp_prepare_addr(ctx, &src_vbuf->vb2_buf, s_frame, &s_frame->addr);
 
-	dst_vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
-	mtk_mdp_prepare_addr(ctx, dst_vb, d_frame, &d_frame->addr);
+	dst_vbuf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	mtk_mdp_prepare_addr(ctx, &dst_vbuf->vb2_buf, d_frame, &d_frame->addr);
 
-	src_vbuf = to_vb2_v4l2_buffer(src_vb);
-	dst_vbuf = to_vb2_v4l2_buffer(dst_vb);
 	dst_vbuf->vb2_buf.timestamp = src_vbuf->vb2_buf.timestamp;
 }
 
@@ -494,17 +491,14 @@ static void mtk_mdp_process_done(void *priv, int vb_state)
 {
 	struct mtk_mdp_dev *mdp = priv;
 	struct mtk_mdp_ctx *ctx;
-	struct vb2_buffer *src_vb, *dst_vb;
-	struct vb2_v4l2_buffer *src_vbuf = NULL, *dst_vbuf = NULL;
+	struct vb2_v4l2_buffer *src_vbuf, *dst_vbuf;
 
 	ctx = v4l2_m2m_get_curr_priv(mdp->m2m_dev);
 	if (!ctx)
 		return;
 
-	src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
-	src_vbuf = to_vb2_v4l2_buffer(src_vb);
-	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
-	dst_vbuf = to_vb2_v4l2_buffer(dst_vb);
+	src_vbuf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+	dst_vbuf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 
 	dst_vbuf->vb2_buf.timestamp = src_vbuf->vb2_buf.timestamp;
 	dst_vbuf->timecode = src_vbuf->timecode;
-- 
2.20.1

