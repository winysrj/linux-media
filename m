Return-Path: <SRS0=3Wpa=PB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3373CC43387
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 08:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3D142173C
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 08:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbeLXIk5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 24 Dec 2018 03:40:57 -0500
Received: from mail.bootlin.com ([62.4.15.54]:58262 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbeLXIk5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Dec 2018 03:40:57 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id F33F120A46; Mon, 24 Dec 2018 09:40:54 +0100 (CET)
Received: from aptenodytes (aaubervilliers-681-1-38-38.w90-88.abo.wanadoo.fr [90.88.157.38])
        by mail.bootlin.com (Postfix) with ESMTPSA id AD6342070E;
        Mon, 24 Dec 2018 09:40:54 +0100 (CET)
Message-ID: <5aaf26b5efe051fcd6dd2c6514a13a9bbe545e3d.camel@bootlin.com>
Subject: Re: [PATCH] media: sunxi: cedrus: Fix missing error message context
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     megous@megous.com, dev@linux-sunxi.org
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        "open list:ALLWINNER VPU DRIVER" <linux-media@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "moderated list:ARM/Allwinner sunXi SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 24 Dec 2018 09:40:54 +0100
In-Reply-To: <20181221165641.16207-1-megous@megous.com>
References: <20181221165641.16207-1-megous@megous.com>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Fri, 2018-12-21 at 17:56 +0100, megous@megous.com wrote:
> From: Ondrej Jirman <megous@megous.com>
> 
> When cedrus_hw_probe is called, v4l2_dev is not yet initialized.
> Use dev_err instead.

Good catch and thanks for the patch!

Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> Signed-off-by: Ondrej Jirman <megous@megous.com>
> ---
>  .../staging/media/sunxi/cedrus/cedrus_hw.c    | 28 +++++++++----------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
> index 300339fee1bc..0acf219a8c91 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
> @@ -157,14 +157,14 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
>  
>  	irq_dec = platform_get_irq(dev->pdev, 0);
>  	if (irq_dec <= 0) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to get IRQ\n");
> +		dev_err(dev->dev, "Failed to get IRQ\n");
>  
>  		return irq_dec;
>  	}
>  	ret = devm_request_irq(dev->dev, irq_dec, cedrus_irq,
>  			       0, dev_name(dev->dev), dev);
>  	if (ret) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to request IRQ\n");
> +		dev_err(dev->dev, "Failed to request IRQ\n");
>  
>  		return ret;
>  	}
> @@ -182,21 +182,21 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
>  
>  	ret = of_reserved_mem_device_init(dev->dev);
>  	if (ret && ret != -ENODEV) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to reserve memory\n");
> +		dev_err(dev->dev, "Failed to reserve memory\n");
>  
>  		return ret;
>  	}
>  
>  	ret = sunxi_sram_claim(dev->dev);
>  	if (ret) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to claim SRAM\n");
> +		dev_err(dev->dev, "Failed to claim SRAM\n");
>  
>  		goto err_mem;
>  	}
>  
>  	dev->ahb_clk = devm_clk_get(dev->dev, "ahb");
>  	if (IS_ERR(dev->ahb_clk)) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to get AHB clock\n");
> +		dev_err(dev->dev, "Failed to get AHB clock\n");
>  
>  		ret = PTR_ERR(dev->ahb_clk);
>  		goto err_sram;
> @@ -204,7 +204,7 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
>  
>  	dev->mod_clk = devm_clk_get(dev->dev, "mod");
>  	if (IS_ERR(dev->mod_clk)) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to get MOD clock\n");
> +		dev_err(dev->dev, "Failed to get MOD clock\n");
>  
>  		ret = PTR_ERR(dev->mod_clk);
>  		goto err_sram;
> @@ -212,7 +212,7 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
>  
>  	dev->ram_clk = devm_clk_get(dev->dev, "ram");
>  	if (IS_ERR(dev->ram_clk)) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to get RAM clock\n");
> +		dev_err(dev->dev, "Failed to get RAM clock\n");
>  
>  		ret = PTR_ERR(dev->ram_clk);
>  		goto err_sram;
> @@ -220,7 +220,7 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
>  
>  	dev->rstc = devm_reset_control_get(dev->dev, NULL);
>  	if (IS_ERR(dev->rstc)) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to get reset control\n");
> +		dev_err(dev->dev, "Failed to get reset control\n");
>  
>  		ret = PTR_ERR(dev->rstc);
>  		goto err_sram;
> @@ -229,7 +229,7 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
>  	res = platform_get_resource(dev->pdev, IORESOURCE_MEM, 0);
>  	dev->base = devm_ioremap_resource(dev->dev, res);
>  	if (IS_ERR(dev->base)) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to map registers\n");
> +		dev_err(dev->dev, "Failed to map registers\n");
>  
>  		ret = PTR_ERR(dev->base);
>  		goto err_sram;
> @@ -237,35 +237,35 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
>  
>  	ret = clk_set_rate(dev->mod_clk, CEDRUS_CLOCK_RATE_DEFAULT);
>  	if (ret) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to set clock rate\n");
> +		dev_err(dev->dev, "Failed to set clock rate\n");
>  
>  		goto err_sram;
>  	}
>  
>  	ret = clk_prepare_enable(dev->ahb_clk);
>  	if (ret) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to enable AHB clock\n");
> +		dev_err(dev->dev, "Failed to enable AHB clock\n");
>  
>  		goto err_sram;
>  	}
>  
>  	ret = clk_prepare_enable(dev->mod_clk);
>  	if (ret) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to enable MOD clock\n");
> +		dev_err(dev->dev, "Failed to enable MOD clock\n");
>  
>  		goto err_ahb_clk;
>  	}
>  
>  	ret = clk_prepare_enable(dev->ram_clk);
>  	if (ret) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to enable RAM clock\n");
> +		dev_err(dev->dev, "Failed to enable RAM clock\n");
>  
>  		goto err_mod_clk;
>  	}
>  
>  	ret = reset_control_reset(dev->rstc);
>  	if (ret) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to apply reset\n");
> +		dev_err(dev->dev, "Failed to apply reset\n");
>  
>  		goto err_ram_clk;
>  	}
-- 
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

