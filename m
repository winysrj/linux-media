Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44212 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaGaP2K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 11:28:10 -0400
Message-ID: <1406820489.16697.61.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 02/28] gpu: ipu-v3: Add ipu_get_num()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 31 Jul 2014 17:28:09 +0200
In-Reply-To: <1403744755-24944-3-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
	 <1403744755-24944-3-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Mittwoch, den 25.06.2014, 18:05 -0700 schrieb Steve Longerbeam:
> Adds of-alias id to ipu_soc and retrieve with ipu_get_num().
> 
> ipu_get_num() is used to select inputs to CSI units in IOMUXC.
> It is also used to select an SMFC channel for video capture.

I still don't see the use of this. The IOMUXC multiplexing will be
handled outside of the IPU driver, and why would SMFC channel allocation
be different for the two IPUs? I'd say let's drop this for now.

regards
Philipp

> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/gpu/ipu-v3/ipu-common.c |    8 ++++++++
>  drivers/gpu/ipu-v3/ipu-prv.h    |    1 +
>  include/video/imx-ipu-v3.h      |    5 +++++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
> index 04e7b2e..a92f48b 100644
> --- a/drivers/gpu/ipu-v3/ipu-common.c
> +++ b/drivers/gpu/ipu-v3/ipu-common.c
> @@ -55,6 +55,12 @@ static inline void ipu_idmac_write(struct ipu_soc *ipu, u32 value,
>  	writel(value, ipu->idmac_reg + offset);
>  }
>  
> +int ipu_get_num(struct ipu_soc *ipu)
> +{
> +	return ipu->id;
> +}
> +EXPORT_SYMBOL_GPL(ipu_get_num);
> +
>  void ipu_srm_dp_sync_update(struct ipu_soc *ipu)
>  {
>  	u32 val;
> @@ -1205,6 +1211,7 @@ static int ipu_probe(struct platform_device *pdev)
>  {
>  	const struct of_device_id *of_id =
>  			of_match_device(imx_ipu_dt_ids, &pdev->dev);
> +	struct device_node *np = pdev->dev.of_node;
>  	struct ipu_soc *ipu;
>  	struct resource *res;
>  	unsigned long ipu_base;
> @@ -1233,6 +1240,7 @@ static int ipu_probe(struct platform_device *pdev)
>  		ipu->channel[i].ipu = ipu;
>  	ipu->devtype = devtype;
>  	ipu->ipu_type = devtype->type;
> +	ipu->id = of_alias_get_id(np, "ipu");
>  
>  	spin_lock_init(&ipu->lock);
>  	mutex_init(&ipu->channel_lock);
> diff --git a/drivers/gpu/ipu-v3/ipu-prv.h b/drivers/gpu/ipu-v3/ipu-prv.h
> index c93f50e..55ae20c 100644
> --- a/drivers/gpu/ipu-v3/ipu-prv.h
> +++ b/drivers/gpu/ipu-v3/ipu-prv.h
> @@ -166,6 +166,7 @@ struct ipu_soc {
>  	void __iomem		*idmac_reg;
>  	struct ipu_ch_param __iomem	*cpmem_base;
>  
> +	int			id;
>  	int			usecount;
>  
>  	struct clk		*clk;
> diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
> index 3e43e22..739d204 100644
> --- a/include/video/imx-ipu-v3.h
> +++ b/include/video/imx-ipu-v3.h
> @@ -93,6 +93,11 @@ int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
>  #define IPU_IRQ_VSYNC_PRE_1		(448 + 15)
>  
>  /*
> + * IPU Common functions
> + */
> +int ipu_get_num(struct ipu_soc *ipu);
> +
> +/*
>   * IPU Image DMA Controller (idmac) functions
>   */
>  struct ipuv3_channel *ipu_idmac_get(struct ipu_soc *ipu, unsigned channel);



