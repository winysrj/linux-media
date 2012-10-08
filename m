Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54934 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2JHUdS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 16:33:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linux-media@vger.kernel.org,
	Tony Lindgren <tony@atomide.com>
Subject: Re: [git:v4l-dvb/for_v3.7] [media] omap3isp: Replace cpu_is_omap3630() with ISP revision check
Date: Mon, 08 Oct 2012 22:33:59 +0200
Message-ID: <1525824.Ct8mi0Nuxy@avalon>
In-Reply-To: <E1TKWPT-000144-3I@www.linuxtv.org>
References: <E1TKWPT-000144-3I@www.linuxtv.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

On Saturday 06 October 2012 17:31:58 Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following
> patch were queued at the http://git.linuxtv.org/media_tree.git tree:

Please don't. I haven't even sent a pull request for that patch. I don't 
consider it as being ready yet, as Sakari pointed out we need to investigate 
whether the right fix shouldn't be at the OMAP3 clocks level instead.

> Subject: [media] omap3isp: Replace cpu_is_omap3630() with ISP revision check
> Author:  Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Date:    Thu Sep 27 10:38:18 2012 -0300
> 
> Drivers must not rely on cpu_is_omap* macros (they will soon become
> private). Use the ISP revision instead to identify the hardware.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  drivers/media/platform/omap3isp/isp.c |   25 ++++++++++++++++---------
>  1 files changed, 16 insertions(+), 9 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=947c48086623d9ca2207dd0
> 434bd58458af4ba86
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index d7aa513..6034dca 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -1345,10 +1345,7 @@ static int isp_enable_clocks(struct isp_device *isp)
>  	 * has to be twice of what is set on OMAP3430 to get
>  	 * the required value for cam_mclk
>  	 */
> -	if (cpu_is_omap3630())
> -		divisor = 1;
> -	else
> -		divisor = 2;
> +	divisor = isp->revision == ISP_REVISION_15_0 ? 1 : 2;
> 
>  	r = clk_enable(isp->clock[ISP_CLK_CAM_ICK]);
>  	if (r) {
> @@ -2093,7 +2090,11 @@ static int __devinit isp_probe(struct platform_device
> *pdev) isp->isp_csiphy1.vdd = regulator_get(&pdev->dev, "VDD_CSIPHY1");
> isp->isp_csiphy2.vdd = regulator_get(&pdev->dev, "VDD_CSIPHY2");
> 
> -	/* Clocks */
> +	/* Clocks
> +	 *
> +	 * The ISP clock tree is revision-dependent. We thus need to enable ICLK
> +	 * manually to read the revision before calling __omap3isp_get().
> +	 */
>  	ret = isp_map_mem_resource(pdev, isp, OMAP3_ISP_IOMEM_MAIN);
>  	if (ret < 0)
>  		goto error;
> @@ -2102,6 +2103,16 @@ static int __devinit isp_probe(struct platform_device
> *pdev) if (ret < 0)
>  		goto error;
> 
> +	ret = clk_enable(isp->clock[ISP_CLK_CAM_ICK]);
> +	if (ret < 0)
> +		goto error;
> +
> +	isp->revision = isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_REVISION);
> +	dev_info(isp->dev, "Revision %d.%d found\n",
> +		 (isp->revision & 0xf0) >> 4, isp->revision & 0x0f);
> +
> +	clk_disable(isp->clock[ISP_CLK_CAM_ICK]);
> +
>  	if (__omap3isp_get(isp, false) == NULL) {
>  		ret = -ENODEV;
>  		goto error;
> @@ -2112,10 +2123,6 @@ static int __devinit isp_probe(struct platform_device
> *pdev) goto error_isp;
> 
>  	/* Memory resources */
> -	isp->revision = isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_REVISION);
> -	dev_info(isp->dev, "Revision %d.%d found\n",
> -		 (isp->revision & 0xf0) >> 4, isp->revision & 0x0f);
> -
>  	for (m = 0; m < ARRAY_SIZE(isp_res_maps); m++)
>  		if (isp->revision == isp_res_maps[m].isp_rev)
>  			break;
-- 
Regards,

Laurent Pinchart

