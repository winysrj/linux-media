Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10923C04EB9
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 00:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C803B2082B
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 00:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544054474;
	bh=hSOJLCXrSe39z45Mu9m9NVbpUfr/RSAVGJHHev0yLIE=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=uD5ljoqeO0rwPrAks4iwITym5iKDUqfHY13OV541TrRK+2Z67GVmj7G94FyORR7rZ
	 xBecw+A7UeJYopcYJ7ZT63U3y3iIv8jd3hCgJr6fOhroQdriERTIr+NulLVXxoAtbB
	 BzkUWUo0KOX5FKBx+tZO/i8+t/Mtcx3J89yBqukM=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C803B2082B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbeLFABO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 19:01:14 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39976 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728156AbeLFABO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 19:01:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DkkCvHPCTn4SV4a8gLP+jx/EiFc3+tjB7UjArIrnJ6k=; b=KHlwEJktIIcKs/jxkmKB9z3SV
        cFy4TVYxGKprGPocrnDymNPLa72LJPK81NEFcZfbsW2F5tF4htDnPNh9q0oMpj4RsdTNViGVk4mQP
        qFoY141EKGt7CIFxhKmyDBdmd70TX/O8qlycX1GJdU0L2m2MtzY02eU3xSnQTBRJ0HDSRSyoJ+KcS
        aigapL8asabu3IJhx/hx+tdywkwd0zns1/7fcFH2b+uKwMSSTUjL3iJWVM7617zFqOQsrZweCZxTt
        fEU3iyeeECsjnWTQkrDuUV5M3TDZOLpqjJtJY2hzfS6qvSSTvdwHCH3er6IT15mTvfIByZ4tM5umD
        GsNBCoTww==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUh6O-00062X-4Q; Thu, 06 Dec 2018 00:01:12 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gUh6L-000ALf-VL; Wed, 05 Dec 2018 19:01:09 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH v2] media: rockchip vpu: remove some unused vars
Date:   Wed,  5 Dec 2018 19:01:09 -0500
Message-Id: <10b532d7f12ef0718028a3ecb4f00974ebd80c4c.1544054436.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

As complained by gcc:

	drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c: In function 'rk3288_vpu_jpeg_enc_set_qtable':
	drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c:70:10: warning: variable 'chroma_qtable_p' set but not used [-Wunused-but-set-variable]
	  __be32 *chroma_qtable_p;
	          ^~~~~~~~~~~~~~~
	drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c:69:10: warning: variable 'luma_qtable_p' set but not used [-Wunused-but-set-variable]
	  __be32 *luma_qtable_p;
	          ^~~~~~~~~~~~~
	drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c: In function 'rk3399_vpu_jpeg_enc_set_qtable':
	drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c:101:10: warning: variable 'chroma_qtable_p' set but not used [-Wunused-but-set-variable]
	  __be32 *chroma_qtable_p;
	          ^~~~~~~~~~~~~~~
	drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c:100:10: warning: variable 'luma_qtable_p' set but not used [-Wunused-but-set-variable]
	  __be32 *luma_qtable_p;
	          ^~~~~~~~~~~~~
	drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c: In function 'rockchip_vpu_queue_setup':
	drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c:522:33: warning: variable 'vpu_fmt' set but not used [-Wunused-but-set-variable]
	  const struct rockchip_vpu_fmt *vpu_fmt;
	                                 ^~~~~~~
	drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c: In function 'rockchip_vpu_buf_prepare':
	drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c:560:33: warning: variable 'vpu_fmt' set but not used [-Wunused-but-set-variable]
	  const struct rockchip_vpu_fmt *vpu_fmt;
	                                 ^~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c | 5 -----
 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c | 5 -----
 drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c       | 6 ------
 3 files changed, 16 deletions(-)

diff --git a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
index e27c10855de5..5282236d1bb1 100644
--- a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
+++ b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
@@ -66,13 +66,8 @@ rk3288_vpu_jpeg_enc_set_qtable(struct rockchip_vpu_dev *vpu,
 			       unsigned char *luma_qtable,
 			       unsigned char *chroma_qtable)
 {
-	__be32 *luma_qtable_p;
-	__be32 *chroma_qtable_p;
 	u32 reg, i;
 
-	luma_qtable_p = (__be32 *)luma_qtable;
-	chroma_qtable_p = (__be32 *)chroma_qtable;
-
 	for (i = 0; i < VEPU_JPEG_QUANT_TABLE_COUNT; i++) {
 		reg = get_unaligned_be32(&luma_qtable[i]);
 		vepu_write_relaxed(vpu, reg, VEPU_REG_JPEG_LUMA_QUAT(i));
diff --git a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
index 5f75e4d11d76..dbc86d95fe3b 100644
--- a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
+++ b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
@@ -97,13 +97,8 @@ rk3399_vpu_jpeg_enc_set_qtable(struct rockchip_vpu_dev *vpu,
 			       unsigned char *luma_qtable,
 			       unsigned char *chroma_qtable)
 {
-	__be32 *luma_qtable_p;
-	__be32 *chroma_qtable_p;
 	u32 reg, i;
 
-	luma_qtable_p = (__be32 *)luma_qtable;
-	chroma_qtable_p = (__be32 *)chroma_qtable;
-
 	for (i = 0; i < VEPU_JPEG_QUANT_TABLE_COUNT; i++) {
 		reg = get_unaligned_be32(&luma_qtable[i]);
 		vepu_write_relaxed(vpu, reg, VEPU_REG_JPEG_LUMA_QUAT(i));
diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
index 038a7136d5d1..ab0fb2053620 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
@@ -519,17 +519,14 @@ rockchip_vpu_queue_setup(struct vb2_queue *vq,
 			 struct device *alloc_devs[])
 {
 	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vq);
-	const struct rockchip_vpu_fmt *vpu_fmt;
 	struct v4l2_pix_format_mplane *pixfmt;
 	int i;
 
 	switch (vq->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-		vpu_fmt = ctx->vpu_dst_fmt;
 		pixfmt = &ctx->dst_fmt;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		vpu_fmt = ctx->vpu_src_fmt;
 		pixfmt = &ctx->src_fmt;
 		break;
 	default:
@@ -557,7 +554,6 @@ static int rockchip_vpu_buf_prepare(struct vb2_buffer *vb)
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vq);
-	const struct rockchip_vpu_fmt *vpu_fmt;
 	struct v4l2_pix_format_mplane *pixfmt;
 	unsigned int sz;
 	int ret = 0;
@@ -565,11 +561,9 @@ static int rockchip_vpu_buf_prepare(struct vb2_buffer *vb)
 
 	switch (vq->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-		vpu_fmt = ctx->vpu_dst_fmt;
 		pixfmt = &ctx->dst_fmt;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		vpu_fmt = ctx->vpu_src_fmt;
 		pixfmt = &ctx->src_fmt;
 
 		if (vbuf->field == V4L2_FIELD_ANY)
-- 
2.19.1

