Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17253C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 19:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC2D4206BA
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 19:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553713511;
	bh=6GCmXDMeBBR5aorIsRw42oYDZ6t+lVypGA5FDbFg08w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Bdcyf3THniiSr2yAr3P+vz5yEEHAgsadW67UW27lTGWRUvIl4CQmg2IFtMEgqoCqM
	 I7BO73DJJGooBqv5SUfUbwqE8zAz5pqb3Avo0tCJMalkSo2KEygTaHkhnOGjwzQPAS
	 JsSo+p2eX+ib67oBdGNSLoMarkJFN+8eiZiNpRgM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389413AbfC0TFG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 15:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389294AbfC0SM4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 14:12:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A0D62186A;
        Wed, 27 Mar 2019 18:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710376;
        bh=6GCmXDMeBBR5aorIsRw42oYDZ6t+lVypGA5FDbFg08w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2YD5bGKDjotaSTxmSFikKP5wrweOCBEai7+2Cy+3MJTg+14GIuPETbya2FndEVUi
         gcR6pwuZx+tsR5g7K+fFMBzeXCqcGB7s5xCTmQBjSnqzb+7/FyqFSOS13yZ1ghMjBm
         Khuy7DV2lEUfRkllrOZfaq3HgD5x2PXno3jgfSos=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 087/192] media: rockchip/rga: Correct return type for mem2mem buffer helpers
Date:   Wed, 27 Mar 2019 14:08:39 -0400
Message-Id: <20190327181025.13507-87-sashal@kernel.org>
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

[ Upstream commit da2d3a4e4adabc6ccfb100bc9abd58ee9cd6c4b7 ]

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
 drivers/media/platform/rockchip/rga/rga.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index ab5a6f95044a..86a76f35a9a1 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -43,7 +43,7 @@ static void device_run(void *prv)
 {
 	struct rga_ctx *ctx = prv;
 	struct rockchip_rga *rga = ctx->rga;
-	struct vb2_buffer *src, *dst;
+	struct vb2_v4l2_buffer *src, *dst;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rga->ctrl_lock, flags);
@@ -53,8 +53,8 @@ static void device_run(void *prv)
 	src = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 
-	rga_buf_map(src);
-	rga_buf_map(dst);
+	rga_buf_map(&src->vb2_buf);
+	rga_buf_map(&dst->vb2_buf);
 
 	rga_hw_start(rga);
 
-- 
2.19.1

