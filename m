Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB0A5C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 19:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E583206BA
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 19:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553713493;
	bh=x4e4cF0VITjO1a3FbU9MH97lCyyNWGdK/WbgZgsWYEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Jn5eX6gRDPP1S4T9MtFAC4Sql/P6oYjZwfKTEn6L9jcAvzaeEAIGe1BVH6fbQeZ7Q
	 vxydiBjQz9hX7m5JeHpstVzqw0x/Ax1nfvVSzUgnixymzogOR/Er255kP+QP2B4mKM
	 h7f8iDv2xExrRHhRZ9Ng2noRwY/6REpqXQpirvVs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389313AbfC0SNC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389298AbfC0SNA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 14:13:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EF0121741;
        Wed, 27 Mar 2019 18:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710380;
        bh=x4e4cF0VITjO1a3FbU9MH97lCyyNWGdK/WbgZgsWYEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=INxD3tylWaP0jqHTsHBspfLe8sNrXe0GGhp1CGpDRqbQHQC4qbBTbj20DQ8bgtQlG
         bacevnFG1jCXL53MD/OcgVsX2ndeJpdgMVVoad0BFSvGL+duN1jkzirCOSFx1Zui1c
         +RXILd6GsEzTGwuqplfYYEYGBL7590Fz39okJ824=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 089/192] media: mx2_emmaprp: Correct return type for mem2mem buffer helpers
Date:   Wed, 27 Mar 2019 14:08:41 -0400
Message-Id: <20190327181025.13507-89-sashal@kernel.org>
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

[ Upstream commit 8d20dcefe471763f23ad538369ec65b51993ffff ]

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
 drivers/media/platform/mx2_emmaprp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 64195c4ddeaf..419e1cb10dc6 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -274,7 +274,7 @@ static void emmaprp_device_run(void *priv)
 {
 	struct emmaprp_ctx *ctx = priv;
 	struct emmaprp_q_data *s_q_data, *d_q_data;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct emmaprp_dev *pcdev = ctx->dev;
 	unsigned int s_width, s_height;
 	unsigned int d_width, d_height;
@@ -294,8 +294,8 @@ static void emmaprp_device_run(void *priv)
 	d_height = d_q_data->height;
 	d_size = d_width * d_height;
 
-	p_in = vb2_dma_contig_plane_dma_addr(src_buf, 0);
-	p_out = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	p_in = vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
+	p_out = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
 	if (!p_in || !p_out) {
 		v4l2_err(&pcdev->v4l2_dev,
 			 "Acquiring kernel pointers to buffers failed\n");
-- 
2.19.1

