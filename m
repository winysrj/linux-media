Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45844 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759720Ab2JYPp7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 11:45:59 -0400
Date: Thu, 25 Oct 2012 17:45:49 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: kernel@pengutronix.de, g.liakhovetski@gmx.de,
	mchehab@infradead.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, javier.martin@vista-silicon.com
Subject: Re: [PATCH 1/2] ARM: clk-imx27: Add missing clock for mx2-camera
Message-ID: <20121025154549.GS24458@pengutronix.de>
References: <1349473981-15084-1-git-send-email-fabio.estevam@freescale.com>
 <1349473981-15084-2-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349473981-15084-2-git-send-email-fabio.estevam@freescale.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 05, 2012 at 06:53:01PM -0300, Fabio Estevam wrote:
> During the clock conversion for mx27 the "per4_gate" clock was missed to get
> registered as a dependency of mx2-camera driver.
> 
> In the old mx27 clock driver we used to have:
> 
> DEFINE_CLOCK1(csi_clk, 0, NULL, 0, parent, &csi_clk1, &per4_clk);
> 
> ,so does the same in the new clock driver.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

I'm fine with merging this through the media tree.

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  arch/arm/mach-imx/clk-imx27.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
> index 3b6b640..5ef0f08 100644
> --- a/arch/arm/mach-imx/clk-imx27.c
> +++ b/arch/arm/mach-imx/clk-imx27.c
> @@ -224,6 +224,7 @@ int __init mx27_clocks_init(unsigned long fref)
>  	clk_register_clkdev(clk[lcdc_ipg_gate], "ipg", "imx-fb.0");
>  	clk_register_clkdev(clk[lcdc_ahb_gate], "ahb", "imx-fb.0");
>  	clk_register_clkdev(clk[csi_ahb_gate], "ahb", "mx2-camera.0");
> +	clk_register_clkdev(clk[per4_gate], "per", "mx2-camera.0");
>  	clk_register_clkdev(clk[usb_div], "per", "fsl-usb2-udc");
>  	clk_register_clkdev(clk[usb_ipg_gate], "ipg", "fsl-usb2-udc");
>  	clk_register_clkdev(clk[usb_ahb_gate], "ahb", "fsl-usb2-udc");
> -- 
> 1.7.9.5
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
