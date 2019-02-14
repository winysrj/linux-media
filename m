Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A082C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 09:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E770E222A4
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 09:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438035AbfBNJoR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 04:44:17 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:52937 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395218AbfBNJoQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 04:44:16 -0500
X-Originating-IP: 90.88.30.68
Received: from localhost.localdomain (aaubervilliers-681-1-89-68.w90-88.abo.wanadoo.fr [90.88.30.68])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 84C1924000A;
        Thu, 14 Feb 2019 09:44:11 +0000 (UTC)
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH] media: cedrus: mpeg2: Use v4l2_m2m_get_vq helper for capture queue
Date:   Thu, 14 Feb 2019 10:44:03 +0100
Message-Id: <20190214094403.18943-1-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Since there's a v4l2_m2m_get_vq helper, use it instead of accessing the
queue directly, which slightly increases readability.

Also reformat the code using the queue a bit while at it.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
index cb45fda9aaeb..13c34927bad5 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
@@ -82,7 +82,7 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
 	dma_addr_t fwd_luma_addr, fwd_chroma_addr;
 	dma_addr_t bwd_luma_addr, bwd_chroma_addr;
 	struct cedrus_dev *dev = ctx->dev;
-	struct vb2_queue *cap_q = &ctx->fh.m2m_ctx->cap_q_ctx.q;
+	struct vb2_queue *vq;
 	const u8 *matrix;
 	int forward_idx;
 	int backward_idx;
@@ -159,17 +159,17 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
 	cedrus_write(dev, VE_DEC_MPEG_PICBOUNDSIZE, reg);
 
 	/* Forward and backward prediction reference buffers. */
-	forward_idx = vb2_find_timestamp(cap_q,
-					 slice_params->forward_ref_ts, 0);
 
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+
+	forward_idx = vb2_find_timestamp(vq, slice_params->forward_ref_ts, 0);
 	fwd_luma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 0);
 	fwd_chroma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 1);
 
 	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_LUMA_ADDR, fwd_luma_addr);
 	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_CHROMA_ADDR, fwd_chroma_addr);
 
-	backward_idx = vb2_find_timestamp(cap_q,
-					  slice_params->backward_ref_ts, 0);
+	backward_idx = vb2_find_timestamp(vq, slice_params->backward_ref_ts, 0);
 	bwd_luma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 0);
 	bwd_chroma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 1);
 
-- 
2.20.1

