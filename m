Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9A0C10F00
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFBD72147C
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553712159;
	bh=MPeXvPWDNl2rzvzBVR1AX/dqzaRdTDe9j5q8bfyQsXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RRQNpEndsQnpWvGElVGVnsegi9tepcjRvqHn134N+ntBXoIJO9CY+sW60jnxOeEqP
	 bV1MKxfSAQb6IROHfiq6rrnoFKm/0C78sVpoUdzZ6/QZ1yt6dsSgtcpev9+urDm8M1
	 YjrYepdaOutT18h/jt3gFKWcXShZgW3MUinecOUg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391240AbfC0SVw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391235AbfC0SVt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 14:21:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEF71217F5;
        Wed, 27 Mar 2019 18:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710908;
        bh=MPeXvPWDNl2rzvzBVR1AX/dqzaRdTDe9j5q8bfyQsXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMrBGur6d3cKuSKLeT7ky7GNk3Fjc3ddUwrc7/Tw6YiRBGtHdb6AncrcyECv9TNNx
         OI6Cl2HMKnT2jwQwEAIgZfrw8XN+QMpIfll2LbZ9TtOUTwbBqMd+/00HtkNQVNmpdm
         n0K7mdZ1iZPPU1S2gaspeff/LZMtRx+1j/Ovvnbg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 41/87] media: s5p-g2d: Correct return type for mem2mem buffer helpers
Date:   Wed, 27 Mar 2019 14:19:54 -0400
Message-Id: <20190327182040.17444-41-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327182040.17444-1-sashal@kernel.org>
References: <20190327182040.17444-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit 30fa627b32230737bc3f678067e2adfecf956987 ]

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
 drivers/media/platform/s5p-g2d/g2d.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 62c0dec30b59..5f6ccf492111 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -498,7 +498,7 @@ static void device_run(void *prv)
 {
 	struct g2d_ctx *ctx = prv;
 	struct g2d_dev *dev = ctx->dev;
-	struct vb2_buffer *src, *dst;
+	struct vb2_v4l2_buffer *src, *dst;
 	unsigned long flags;
 	u32 cmd = 0;
 
@@ -513,10 +513,10 @@ static void device_run(void *prv)
 	spin_lock_irqsave(&dev->ctrl_lock, flags);
 
 	g2d_set_src_size(dev, &ctx->in);
-	g2d_set_src_addr(dev, vb2_dma_contig_plane_dma_addr(src, 0));
+	g2d_set_src_addr(dev, vb2_dma_contig_plane_dma_addr(&src->vb2_buf, 0));
 
 	g2d_set_dst_size(dev, &ctx->out);
-	g2d_set_dst_addr(dev, vb2_dma_contig_plane_dma_addr(dst, 0));
+	g2d_set_dst_addr(dev, vb2_dma_contig_plane_dma_addr(&dst->vb2_buf, 0));
 
 	g2d_set_rop4(dev, ctx->rop);
 	g2d_set_flip(dev, ctx->flip);
-- 
2.19.1

