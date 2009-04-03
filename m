Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43508 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbZDCTTd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 15:19:33 -0400
Date: Fri, 3 Apr 2009 21:19:31 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <lg@denx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] mx3-camera: adapt the clock definition and the
	driver to the new clock naming
Message-ID: <20090403191931.GZ23731@pengutronix.de>
References: <Pine.LNX.4.64.0904021145040.5263@axis700.grange> <20090403082844.GM23731@pengutronix.de> <Pine.LNX.4.64.0904031047040.4729@axis700.grange> <20090403085401.GO23731@pengutronix.de> <Pine.LNX.4.64.0904031321550.4729@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904031321550.4729@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 03, 2009 at 01:26:11PM +0200, Guennadi Liakhovetski wrote:
> With the i.MX31 transition to clkdev clock names have changed, but mistakenly
> the "mx3-camera.0" has been registered with a non-NULL connection ID, which is
> not necessary, since this is the only clock, used by the capture interface
> driver. Fix the clock definition and the driver to use NULL as a connection ID.
> 
> Signed-off-by: Guennadi Liakhovetski <lg@denx.de>

Acked-by Sascha Hauer <s.hauer@pengutronix,de>

> ---
> 
> Clock connection IDs fixed to NULL. Sascha, please, ack.
> 
>  arch/arm/mach-mx3/clock.c        |    2 +-
>  drivers/media/video/mx3_camera.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-mx3/clock.c b/arch/arm/mach-mx3/clock.c
> index ca46f48..9957a11 100644
> --- a/arch/arm/mach-mx3/clock.c
> +++ b/arch/arm/mach-mx3/clock.c
> @@ -533,7 +533,7 @@ static struct clk_lookup lookups[] __initdata = {
>  	_REGISTER_CLOCK(NULL, "kpp", kpp_clk)
>  	_REGISTER_CLOCK("fsl-usb2-udc", "usb", usb_clk1)
>  	_REGISTER_CLOCK("fsl-usb2-udc", "usb_ahb", usb_clk2)
> -	_REGISTER_CLOCK("mx3-camera.0", "csi", csi_clk)
> +	_REGISTER_CLOCK("mx3-camera.0", NULL, csi_clk)
>  	_REGISTER_CLOCK("imx-uart.0", NULL, uart1_clk)
>  	_REGISTER_CLOCK("imx-uart.1", NULL, uart2_clk)
>  	_REGISTER_CLOCK("imx-uart.2", NULL, uart3_clk)
> diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> index 70629e1..c462b81 100644
> --- a/drivers/media/video/mx3_camera.c
> +++ b/drivers/media/video/mx3_camera.c
> @@ -1100,7 +1100,7 @@ static int mx3_camera_probe(struct platform_device *pdev)
>  	}
>  	memset(mx3_cam, 0, sizeof(*mx3_cam));
>  
> -	mx3_cam->clk = clk_get(&pdev->dev, "csi_clk");
> +	mx3_cam->clk = clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(mx3_cam->clk)) {
>  		err = PTR_ERR(mx3_cam->clk);
>  		goto eclkget;
> -- 
> 1.5.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
