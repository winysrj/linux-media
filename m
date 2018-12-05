Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB24C04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 23:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 246EF20892
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 23:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544054107;
	bh=GyeB+cjHgg3GMH5qVpCzarc3Pqm+2MuTh/FJZoU7+8U=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=fCyJYpOnP4gYiO3y6fxBvM2syeb9iQJbVnzoVi3aOrWnfxnTRiX1vnOJCIcYtgnF0
	 od7e2KdGhEeLWZHxYLNT2z8ReyjcTu6u2bdjuBtsbsnXj/etGMxEMKRJ5dOVU+VnH9
	 jXC2hxzv2IHBBXg5Bk8izJmJgHUX8Vm+zh09c4ic=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 246EF20892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbeLEXzF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 18:55:05 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38136 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728546AbeLEXzE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 18:55:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=07Wf3i8Q02UTVt/5kyanDLlzFDkIvOJMhg7Oa9JOnVY=; b=EHNB9z3upyWHD0DyJtcm1a1Qd
        dBOLgsmuMWDcsQa9MX5UEox+Y+an5LilyE/QZyG2iM+/GrgjxmVBeRYX30v02aPJhIjbVZm2QGcqU
        dxZokuMhiywwYOWCbTcyd/nKR5K4ypOZM/8jhWjEpIV4p2LEWuFODCegB8uFasbCjMo40z6krBUf0
        7k2cnkQHdt5KaMa1D0HKYt+Og3vPNUrY8sT57bzV33gZipY2ZuieJU68nN9mDUR3zssjTyWxUgrU6
        DsWhwDr2t5FfxdAzHCyTySVuYs/r/uYPN/c8Kj7j9fgtIQp+vtA/FWn69XY84xcrjlpOhSM7EQXBw
        +Ty48igOg==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUh0P-0002jZ-41; Wed, 05 Dec 2018 23:55:01 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gUh0L-0002JL-KH; Wed, 05 Dec 2018 18:54:57 -0500
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
Subject: [PATCH] media: rockchip vpu: remove some unused vars
Date:   Wed,  5 Dec 2018 18:54:54 -0500
Message-Id: <be7a207dc092e2d1b80cfdd2e5971e4641cb30c9.1544054086.git.mchehab+samsung@kernel.org>
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
 1 file changed, 5 deletions(-)

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
-- 
2.19.1

