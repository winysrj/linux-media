Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39444 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab1EEOCQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 10:02:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH] OMAP3: ISP: Fix unbalanced use of omap3isp_get().
Date: Thu, 5 May 2011 16:02:49 +0200
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
References: <1304603588-3178-1-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1304603588-3178-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105051602.49814.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

On Thursday 05 May 2011 15:53:08 Javier Martin wrote:
> Do not use omap3isp_get() when what we really want to do is just
> enable clocks, since omap3isp_get() has additional, unwanted, side
> effects as an increase of the counter.
> 
> This prevented omap3isp of working with Beagleboard xM and it has
> been tested only with that platform + mt9p031 sensor.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/video/omap3isp/isp.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/isp.c
> b/drivers/media/video/omap3isp/isp.c index 472a693..ca0831f 100644
> --- a/drivers/media/video/omap3isp/isp.c
> +++ b/drivers/media/video/omap3isp/isp.c
> @@ -85,9 +85,11 @@ module_param(autoidle, int, 0444);
>  MODULE_PARM_DESC(autoidle, "Enable OMAP3ISP AUTOIDLE support");
> 
>  static void isp_save_ctx(struct isp_device *isp);
> -
>  static void isp_restore_ctx(struct isp_device *isp);
> 
> +static int isp_enable_clocks(struct isp_device *isp);
> +static void isp_disable_clocks(struct isp_device *isp);
> +
>  static const struct isp_res_mapping isp_res_maps[] = {
>  	{
>  		.isp_rev = ISP_REVISION_2_0,
> @@ -239,10 +241,10 @@ static u32 isp_set_xclk(struct isp_device *isp, u32
> xclk, u8 xclksel)
> 
>  	/* Do we go from stable whatever to clock? */
>  	if (divisor >= 2 && isp->xclk_divisor[xclksel - 1] < 2)
> -		omap3isp_get(isp);
> +		isp_enable_clocks(isp);

This won't work. Let's assume the following sequence of events:

- Userspace opens the sensor subdev device node
- The sensor driver calls to board code to turn the sensor clock on
- Board code calls to the ISP driver to turn XCLK on
- The ISP driver calls isp_enable_clocks()
...
- Userspace opens an ISP video device node
- The ISP driver calls isp_get(), incrementing the reference count
- Userspace closes the ISP video device node
- The ISP driver calls isp_put(), decrementing the reference count
- The reference count reaches 0, the ISP driver calls isp_disable_clocks()

The sensor will then loose its clock, even though the sensor subdev device 
node is still opened.

Could you please explain why the existing code doesn't work on your hardware ?

>  	/* Stopping the clock. */
>  	else if (divisor < 2 && isp->xclk_divisor[xclksel - 1] >= 2)
> -		omap3isp_put(isp);
> +		isp_disable_clocks(isp);
> 
>  	isp->xclk_divisor[xclksel - 1] = divisor;

-- 
Regards,

Laurent Pinchart
