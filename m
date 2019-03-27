Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB92C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 19:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DBED206C0
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 19:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553714662;
	bh=hKjVv6VHntGbB4pdgikxy5NK6H7Oij6CRbuX/3IyRt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gK3yaWFwBK0bO4zexH/e8I2rBSXL1DK+zgdb7HQ5e6Ykp4cWUGLvNqHG4V+MVF7Yh
	 562V9W3p1az/Xj3kTug2VO3xl5IM0pgAJ5IG7A7Z1nei1OWD8jkdH2SYdC8vbghtbw
	 78UJZPNk7glcyQM0LI7J/WttWV0Suu4f3q4NwqI0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387785AbfC0SFw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:05:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731498AbfC0SFv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 14:05:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67A852063F;
        Wed, 27 Mar 2019 18:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553709950;
        bh=hKjVv6VHntGbB4pdgikxy5NK6H7Oij6CRbuX/3IyRt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsmZa/lK1C5h5NnCH3p9ssK+QGSKp7EKJ0Bw4dKZOHQoFR7WXMYegKEqot/tm8v+W
         yMoiFpj/qjipBKB+JQxhl/IVmZruIKzvmI3SNmxmAl5WXwXYy0zLGGWSA3H75gVRQz
         uHjvJ4L/jBHVXvZ0m3+n68Ji2KMtpb2tJIM/u/Hg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.0 126/262] media: rockchip/vpu: Correct return type for mem2mem buffer helpers
Date:   Wed, 27 Mar 2019 13:59:41 -0400
Message-Id: <20190327180158.10245-126-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit 29701c3612fa025d5e8dc64c7a4ae8dc4763912e ]

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
 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c | 6 +++---
 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
index 5282236d1bb1..06daea66fb49 100644
--- a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
+++ b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
@@ -80,7 +80,7 @@ rk3288_vpu_jpeg_enc_set_qtable(struct rockchip_vpu_dev *vpu,
 void rk3288_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx)
 {
 	struct rockchip_vpu_dev *vpu = ctx->dev;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct rockchip_vpu_jpeg_ctx jpeg_ctx;
 	u32 reg;
 
@@ -88,7 +88,7 @@ void rk3288_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx)
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 
 	memset(&jpeg_ctx, 0, sizeof(jpeg_ctx));
-	jpeg_ctx.buffer = vb2_plane_vaddr(dst_buf, 0);
+	jpeg_ctx.buffer = vb2_plane_vaddr(&dst_buf->vb2_buf, 0);
 	jpeg_ctx.width = ctx->dst_fmt.width;
 	jpeg_ctx.height = ctx->dst_fmt.height;
 	jpeg_ctx.quality = ctx->jpeg_quality;
@@ -99,7 +99,7 @@ void rk3288_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx)
 			   VEPU_REG_ENC_CTRL);
 
 	rk3288_vpu_set_src_img_ctrl(vpu, ctx);
-	rk3288_vpu_jpeg_enc_set_buffers(vpu, ctx, src_buf);
+	rk3288_vpu_jpeg_enc_set_buffers(vpu, ctx, &src_buf->vb2_buf);
 	rk3288_vpu_jpeg_enc_set_qtable(vpu,
 				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
 				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 1));
diff --git a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
index dbc86d95fe3b..3d438797692e 100644
--- a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
+++ b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
@@ -111,7 +111,7 @@ rk3399_vpu_jpeg_enc_set_qtable(struct rockchip_vpu_dev *vpu,
 void rk3399_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx)
 {
 	struct rockchip_vpu_dev *vpu = ctx->dev;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct rockchip_vpu_jpeg_ctx jpeg_ctx;
 	u32 reg;
 
@@ -119,7 +119,7 @@ void rk3399_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx)
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 
 	memset(&jpeg_ctx, 0, sizeof(jpeg_ctx));
-	jpeg_ctx.buffer = vb2_plane_vaddr(dst_buf, 0);
+	jpeg_ctx.buffer = vb2_plane_vaddr(&dst_buf->vb2_buf, 0);
 	jpeg_ctx.width = ctx->dst_fmt.width;
 	jpeg_ctx.height = ctx->dst_fmt.height;
 	jpeg_ctx.quality = ctx->jpeg_quality;
@@ -130,7 +130,7 @@ void rk3399_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx)
 			   VEPU_REG_ENCODE_START);
 
 	rk3399_vpu_set_src_img_ctrl(vpu, ctx);
-	rk3399_vpu_jpeg_enc_set_buffers(vpu, ctx, src_buf);
+	rk3399_vpu_jpeg_enc_set_buffers(vpu, ctx, &src_buf->vb2_buf);
 	rk3399_vpu_jpeg_enc_set_qtable(vpu,
 				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
 				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 1));
-- 
2.19.1

