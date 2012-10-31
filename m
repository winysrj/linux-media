Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45568 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2JaL4r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 07:56:47 -0400
Date: Wed, 31 Oct 2012 09:56:32 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: <g.liakhovetski@gmx.de>, <kernel@pengutronix.de>,
	<gcembed@gmail.com>, <javier.martin@vista-silicon.com>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/2] ARM: clk-imx27: Add missing clock for mx2-camera
Message-ID: <20121031095632.536d9362@infradead.org>
In-Reply-To: <1351598606-8485-1-git-send-email-fabio.estevam@freescale.com>
References: <1351598606-8485-1-git-send-email-fabio.estevam@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 30 Oct 2012 10:03:25 -0200
Fabio Estevam <fabio.estevam@freescale.com> escreveu:

> During the clock conversion for mx27 the "per4_gate" clock was missed to get
> registered as a dependency of mx2-camera driver.
> 
> In the old mx27 clock driver we used to have:
> 
> DEFINE_CLOCK1(csi_clk, 0, NULL, 0, parent, &csi_clk1, &per4_clk);
> 
> ,so does the same in the new clock driver
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

As it seems that those patches depend on some patches at the arm tree,
the better is to merge them via -arm tree.

So,

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> ---
> Changes since v3:
> - Use imx27-camera.0 instead of mx2-camera.0, due to recent changes in the
> imx27 clock (commit 27b76486a3: media: mx2_camera: remove cpu_is_xxx by using platform_device_id)
> 
>  arch/arm/mach-imx/clk-imx27.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
> index 585ab25..2880bd9 100644
> --- a/arch/arm/mach-imx/clk-imx27.c
> +++ b/arch/arm/mach-imx/clk-imx27.c
> @@ -224,6 +224,7 @@ int __init mx27_clocks_init(unsigned long fref)
>  	clk_register_clkdev(clk[lcdc_ipg_gate], "ipg", "imx21-fb.0");
>  	clk_register_clkdev(clk[lcdc_ahb_gate], "ahb", "imx21-fb.0");
>  	clk_register_clkdev(clk[csi_ahb_gate], "ahb", "imx27-camera.0");
> +	clk_register_clkdev(clk[per4_gate], "per", "imx27-camera.0");
>  	clk_register_clkdev(clk[usb_div], "per", "fsl-usb2-udc");
>  	clk_register_clkdev(clk[usb_ipg_gate], "ipg", "fsl-usb2-udc");
>  	clk_register_clkdev(clk[usb_ahb_gate], "ahb", "fsl-usb2-udc");




Cheers,
Mauro
