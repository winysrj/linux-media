Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BDBCC43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 16:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC20A21903
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 16:57:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="fDLaDDeM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388573AbeLUQ47 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 21 Dec 2018 11:56:59 -0500
Received: from vps.xff.cz ([195.181.215.36]:42442 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388011AbeLUQ47 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Dec 2018 11:56:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1545411416; bh=gyy90YjTZtqrSOOiV5GFYEb87e0T/+Q/+2syiV6jq0E=;
        h=From:To:Cc:Subject:Date:From;
        b=fDLaDDeMEHt172NdlEwyk80ZqrsmA+nw4cNTvY4efjX7HpXLzOmEHLTWDJtwublUx
         lDc7D/DPLVpRQRMl34FxGgE3d78m7mEVK6Md9GkS0+KVFNyVWhJfX2FqzAgshXCY9e
         eE0DWl1I2moumvrw3aGXkZBb9BdU2nyUloVuxZZs=
From:   megous@megous.com
To:     dev@linux-sunxi.org
Cc:     Ondrej Jirman <megous@megous.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-media@vger.kernel.org (open list:ALLWINNER VPU DRIVER),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Allwinner
        sunXi SoC support), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] media: sunxi: cedrus: Fix missing error message context
Date:   Fri, 21 Dec 2018 17:56:41 +0100
Message-Id: <20181221165641.16207-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

When cedrus_hw_probe is called, v4l2_dev is not yet initialized.
Use dev_err instead.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 .../staging/media/sunxi/cedrus/cedrus_hw.c    | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
index 300339fee1bc..0acf219a8c91 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
@@ -157,14 +157,14 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
 
 	irq_dec = platform_get_irq(dev->pdev, 0);
 	if (irq_dec <= 0) {
-		v4l2_err(&dev->v4l2_dev, "Failed to get IRQ\n");
+		dev_err(dev->dev, "Failed to get IRQ\n");
 
 		return irq_dec;
 	}
 	ret = devm_request_irq(dev->dev, irq_dec, cedrus_irq,
 			       0, dev_name(dev->dev), dev);
 	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to request IRQ\n");
+		dev_err(dev->dev, "Failed to request IRQ\n");
 
 		return ret;
 	}
@@ -182,21 +182,21 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
 
 	ret = of_reserved_mem_device_init(dev->dev);
 	if (ret && ret != -ENODEV) {
-		v4l2_err(&dev->v4l2_dev, "Failed to reserve memory\n");
+		dev_err(dev->dev, "Failed to reserve memory\n");
 
 		return ret;
 	}
 
 	ret = sunxi_sram_claim(dev->dev);
 	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to claim SRAM\n");
+		dev_err(dev->dev, "Failed to claim SRAM\n");
 
 		goto err_mem;
 	}
 
 	dev->ahb_clk = devm_clk_get(dev->dev, "ahb");
 	if (IS_ERR(dev->ahb_clk)) {
-		v4l2_err(&dev->v4l2_dev, "Failed to get AHB clock\n");
+		dev_err(dev->dev, "Failed to get AHB clock\n");
 
 		ret = PTR_ERR(dev->ahb_clk);
 		goto err_sram;
@@ -204,7 +204,7 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
 
 	dev->mod_clk = devm_clk_get(dev->dev, "mod");
 	if (IS_ERR(dev->mod_clk)) {
-		v4l2_err(&dev->v4l2_dev, "Failed to get MOD clock\n");
+		dev_err(dev->dev, "Failed to get MOD clock\n");
 
 		ret = PTR_ERR(dev->mod_clk);
 		goto err_sram;
@@ -212,7 +212,7 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
 
 	dev->ram_clk = devm_clk_get(dev->dev, "ram");
 	if (IS_ERR(dev->ram_clk)) {
-		v4l2_err(&dev->v4l2_dev, "Failed to get RAM clock\n");
+		dev_err(dev->dev, "Failed to get RAM clock\n");
 
 		ret = PTR_ERR(dev->ram_clk);
 		goto err_sram;
@@ -220,7 +220,7 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
 
 	dev->rstc = devm_reset_control_get(dev->dev, NULL);
 	if (IS_ERR(dev->rstc)) {
-		v4l2_err(&dev->v4l2_dev, "Failed to get reset control\n");
+		dev_err(dev->dev, "Failed to get reset control\n");
 
 		ret = PTR_ERR(dev->rstc);
 		goto err_sram;
@@ -229,7 +229,7 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
 	res = platform_get_resource(dev->pdev, IORESOURCE_MEM, 0);
 	dev->base = devm_ioremap_resource(dev->dev, res);
 	if (IS_ERR(dev->base)) {
-		v4l2_err(&dev->v4l2_dev, "Failed to map registers\n");
+		dev_err(dev->dev, "Failed to map registers\n");
 
 		ret = PTR_ERR(dev->base);
 		goto err_sram;
@@ -237,35 +237,35 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
 
 	ret = clk_set_rate(dev->mod_clk, CEDRUS_CLOCK_RATE_DEFAULT);
 	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to set clock rate\n");
+		dev_err(dev->dev, "Failed to set clock rate\n");
 
 		goto err_sram;
 	}
 
 	ret = clk_prepare_enable(dev->ahb_clk);
 	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to enable AHB clock\n");
+		dev_err(dev->dev, "Failed to enable AHB clock\n");
 
 		goto err_sram;
 	}
 
 	ret = clk_prepare_enable(dev->mod_clk);
 	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to enable MOD clock\n");
+		dev_err(dev->dev, "Failed to enable MOD clock\n");
 
 		goto err_ahb_clk;
 	}
 
 	ret = clk_prepare_enable(dev->ram_clk);
 	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to enable RAM clock\n");
+		dev_err(dev->dev, "Failed to enable RAM clock\n");
 
 		goto err_mod_clk;
 	}
 
 	ret = reset_control_reset(dev->rstc);
 	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to apply reset\n");
+		dev_err(dev->dev, "Failed to apply reset\n");
 
 		goto err_ram_clk;
 	}
-- 
2.20.1

