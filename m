Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34205 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab2JIMxY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 08:53:24 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so4712656wgb.1
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 05:53:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349473981-15084-2-git-send-email-fabio.estevam@freescale.com>
References: <1349473981-15084-1-git-send-email-fabio.estevam@freescale.com>
	<1349473981-15084-2-git-send-email-fabio.estevam@freescale.com>
Date: Tue, 9 Oct 2012 14:53:23 +0200
Message-ID: <CACKLOr0wEzzb8vzqexePPG8nDkPOTgPRzPaMXoM1JFF2QADVSg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: clk-imx27: Add missing clock for mx2-camera
From: javier Martin <javier.martin@vista-silicon.com>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: kernel@pengutronix.de, g.liakhovetski@gmx.de,
	mchehab@infradead.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5 October 2012 23:53, Fabio Estevam <fabio.estevam@freescale.com> wrote:
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
> ---
>  arch/arm/mach-imx/clk-imx27.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
> index 3b6b640..5ef0f08 100644
> --- a/arch/arm/mach-imx/clk-imx27.c
> +++ b/arch/arm/mach-imx/clk-imx27.c
> @@ -224,6 +224,7 @@ int __init mx27_clocks_init(unsigned long fref)
>         clk_register_clkdev(clk[lcdc_ipg_gate], "ipg", "imx-fb.0");
>         clk_register_clkdev(clk[lcdc_ahb_gate], "ahb", "imx-fb.0");
>         clk_register_clkdev(clk[csi_ahb_gate], "ahb", "mx2-camera.0");
> +       clk_register_clkdev(clk[per4_gate], "per", "mx2-camera.0");
>         clk_register_clkdev(clk[usb_div], "per", "fsl-usb2-udc");
>         clk_register_clkdev(clk[usb_ipg_gate], "ipg", "fsl-usb2-udc");
>         clk_register_clkdev(clk[usb_ahb_gate], "ahb", "fsl-usb2-udc");
> --
> 1.7.9.5
>
>

Tested-by: Javier Martin <javier.martin@vista-silicon.com>

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
