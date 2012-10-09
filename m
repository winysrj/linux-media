Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59569 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab2JINFo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 09:05:44 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so4721942wgb.1
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 06:05:43 -0700 (PDT)
Message-ID: <507420E3.2010902@gmail.com>
Date: Tue, 09 Oct 2012 15:04:35 +0200
From: =?UTF-8?B?R2HDq3RhbiBDYXJsaWVy?= <gcembed@gmail.com>
MIME-Version: 1.0
To: Fabio Estevam <fabio.estevam@freescale.com>
CC: kernel@pengutronix.de, g.liakhovetski@gmx.de,
	mchehab@infradead.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, javier.martin@vista-silicon.com
Subject: Re: [PATCH 1/2] ARM: clk-imx27: Add missing clock for mx2-camera
References: <1349473981-15084-1-git-send-email-fabio.estevam@freescale.com> <1349473981-15084-2-git-send-email-fabio.estevam@freescale.com>
In-Reply-To: <1349473981-15084-2-git-send-email-fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
On 10/05/2012 11:53 PM, Fabio Estevam wrote:
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
>   arch/arm/mach-imx/clk-imx27.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
> index 3b6b640..5ef0f08 100644
> --- a/arch/arm/mach-imx/clk-imx27.c
> +++ b/arch/arm/mach-imx/clk-imx27.c
> @@ -224,6 +224,7 @@ int __init mx27_clocks_init(unsigned long fref)
>   	clk_register_clkdev(clk[lcdc_ipg_gate], "ipg", "imx-fb.0");
>   	clk_register_clkdev(clk[lcdc_ahb_gate], "ahb", "imx-fb.0");
>   	clk_register_clkdev(clk[csi_ahb_gate], "ahb", "mx2-camera.0");
> +	clk_register_clkdev(clk[per4_gate], "per", "mx2-camera.0");
>   	clk_register_clkdev(clk[usb_div], "per", "fsl-usb2-udc");
>   	clk_register_clkdev(clk[usb_ipg_gate], "ipg", "fsl-usb2-udc");
>   	clk_register_clkdev(clk[usb_ahb_gate], "ahb", "fsl-usb2-udc");
>
I only test detection at kernel boot not streaming using Gstreamer due 
to lack of time.

On imx27_3ds board with ov2640 sensor:
ov2640 0-0030: ov2640 Product ID 26:42 Manufacturer ID 7f:a2
mx2-camera mx2-camera.0: MX2 Camera (CSI) driver probed, clock 
frequency: 44333333

On clone imx27_3ds board with mt9v111 sensor (draft driver):
mt9v111 0-0048: Detected a MT9V111 chip ID 823a
mx2-camera mx2-camera.0: MX2 Camera (CSI) driver probed, clock 
frequency: 44333333

Tested-by: Gaëtan Carlier <gcembed@gmail.com>
