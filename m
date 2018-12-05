Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76148C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 18:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C1E820989
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 18:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544035414;
	bh=eyVT7i40OK9jfq5WyZR7Wd2SmCIeNMT0n/mtC6eqpOE=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=sD4/Jwhs7cM+tKAiwymsLZ1d+87cYoTOBP0t2E1ub841Qx79k9L06BQsDh8MHz9un
	 RYiqCcKk+a9VqeF8PfgW6pw4zBmiOgepFXJ/RALWtU06b5PSP6xtdmF/oUZVhqh6fs
	 8lPfM5R9IrXa63bQh5JrpCz6tnMe80mye4mNG8pA=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C1E820989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbeLESnd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 13:43:33 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:37686 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbeLESnd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 13:43:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iTjZGQfGMO4SG3MJPEtex8P6/L8JO19TW9RUFQF6Vdk=; b=WF5nP2PS8y6f8HCjzDkKmxsi1
        0tBs/o826CpmAMjEcAA/iBoMf90nqhfPBkoWMwAVoKNAa4/BDHOMorZLAvIqcjNH5xvhalZ60YHZU
        CTPcGuOmyw9x9uRTd4Ub/KgdYfcJ/cSLloiXuols/QVy9Q1VCwQLSofhAmtoCovbeG+HPmdaSnStP
        JDcFhH4xIaKGyXZG69Dc5OJdbVZNb7jKx+dhdDRjihrs3uaRz132flrMxhSHFWXR4MdrZ5YD/vDKS
        3RkoMYbnkKuwtrYm7W2wNzAyC48lOwsiSl92n/tfar4SNEnaj7oEe1IffUpvdPnKoUw2VCo6HGwFo
        frI9DTi8A==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUc8v-0007zg-LU; Wed, 05 Dec 2018 18:43:32 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gUc8r-0004iE-6p; Wed, 05 Dec 2018 13:43:25 -0500
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
Subject: [PATCH] media: rockchip/vpu: fix a few alignments
Date:   Wed,  5 Dec 2018 13:43:24 -0500
Message-Id: <bcebf81255a71b34541bc00bcb505e815193f0be.1544035391.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

As reported by checkpatch.pl, some function calls have a wrong
alignment.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c | 4 ++--
 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
index 8919151e1631..e27c10855de5 100644
--- a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
+++ b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
@@ -106,8 +106,8 @@ void rk3288_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx)
 	rk3288_vpu_set_src_img_ctrl(vpu, ctx);
 	rk3288_vpu_jpeg_enc_set_buffers(vpu, ctx, src_buf);
 	rk3288_vpu_jpeg_enc_set_qtable(vpu,
-		rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
-		rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 1));
+				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
+				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 1));
 
 	reg = VEPU_REG_AXI_CTRL_OUTPUT_SWAP16
 		| VEPU_REG_AXI_CTRL_INPUT_SWAP16
diff --git a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
index 8afa2162bf9f..5f75e4d11d76 100644
--- a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
+++ b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
@@ -137,8 +137,8 @@ void rk3399_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx)
 	rk3399_vpu_set_src_img_ctrl(vpu, ctx);
 	rk3399_vpu_jpeg_enc_set_buffers(vpu, ctx, src_buf);
 	rk3399_vpu_jpeg_enc_set_qtable(vpu,
-			rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
-			rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 1));
+				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
+				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 1));
 
 	reg = VEPU_REG_OUTPUT_SWAP32
 		| VEPU_REG_OUTPUT_SWAP16
-- 
2.19.1

