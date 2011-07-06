Return-path: <mchehab@localhost>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58262 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1GFVq0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 17:46:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/3] s5p-csis: Handle all available power supplies
Date: Wed, 6 Jul 2011 23:47:01 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
References: <1309972421-29690-1-git-send-email-s.nawrocki@samsung.com> <1309972421-29690-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1309972421-29690-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107062347.01766.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi Sylwester,

On Wednesday 06 July 2011 19:13:39 Sylwester Nawrocki wrote:
> On the SoCs this driver is intended to support the are three
> separate pins to supply the MIPI-CSIS subsystem: 1.1V or 1.2V,
> 1.8V and power supply for an internal PLL.
> This patch adds support for two separate voltage supplies
> to cover properly board configurations where PMIC requires
> to configure independently each external supply of the MIPI-CSI
> device. The 1.8V and PLL supply are assigned a single "vdd18"
> regulator supply as it seems more reasonable than creating
> separate regulator supplies for them.
> 
> Reported-by: HeungJun Kim <riverful.kim@samsung.com>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/s5p-fimc/mipi-csis.c |   42
> +++++++++++++++++------------ 1 files changed, 25 insertions(+), 17
> deletions(-)
> 
> diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c
> b/drivers/media/video/s5p-fimc/mipi-csis.c index ef056d6..4a529b4 100644
> --- a/drivers/media/video/s5p-fimc/mipi-csis.c
> +++ b/drivers/media/video/s5p-fimc/mipi-csis.c
> @@ -81,6 +81,12 @@ static char *csi_clock_name[] = {
>  };
>  #define NUM_CSIS_CLOCKS	ARRAY_SIZE(csi_clock_name)
> 
> +static const char * const csis_supply_name[] = {
> +	"vdd11", /* 1.1V or 1.2V (s5pc100) MIPI CSI suppply */
> +	"vdd18", /* VDD 1.8V and MIPI CSI PLL supply */
> +};
> +#define CSIS_NUM_SUPPLIES ARRAY_SIZE(csis_supply_name)
> +
>  enum {
>  	ST_POWERED	= 1,
>  	ST_STREAMING	= 2,
> @@ -109,9 +115,9 @@ struct csis_state {
>  	struct platform_device *pdev;
>  	struct resource *regs_res;
>  	void __iomem *regs;
> +	struct regulator_bulk_data supply[CSIS_NUM_SUPPLIES];

I would have called this supplies, but that's nitpicking. Otherwise the patch 
looks good to me.

>  	struct clk *clock[NUM_CSIS_CLOCKS];
>  	int irq;
> -	struct regulator *supply;
>  	u32 flags;
>  	const struct csis_pix_format *csis_fmt;
>  	struct v4l2_mbus_framefmt format;
> @@ -460,6 +466,7 @@ static int __devinit s5pcsis_probe(struct
> platform_device *pdev) struct resource *regs_res;
>  	struct csis_state *state;
>  	int ret = -ENOMEM;
> +	int i;
> 
>  	state = kzalloc(sizeof(*state), GFP_KERNEL);
>  	if (!state)
> @@ -519,13 +526,14 @@ static int __devinit s5pcsis_probe(struct
> platform_device *pdev) goto e_clkput;
>  	}
> 
> +	for (i = 0; i < CSIS_NUM_SUPPLIES; i++)
> +		state->supply[i].supply = csis_supply_name[i];
> +
>  	if (!pdata->fixed_phy_vdd) {
> -		state->supply = regulator_get(&pdev->dev, "vdd");
> -		if (IS_ERR(state->supply)) {
> -			ret = PTR_ERR(state->supply);
> -			state->supply = NULL;
> +		ret = regulator_bulk_get(&pdev->dev, CSIS_NUM_SUPPLIES,
> +					 state->supply);
> +		if (ret)
>  			goto e_clkput;
> -		}
>  	}
> 
>  	ret = request_irq(state->irq, s5pcsis_irq_handler, 0,
> @@ -561,8 +569,7 @@ static int __devinit s5pcsis_probe(struct
> platform_device *pdev) e_irqfree:
>  	free_irq(state->irq, state);
>  e_regput:
> -	if (state->supply)
> -		regulator_put(state->supply);
> +	regulator_bulk_free(CSIS_NUM_SUPPLIES, state->supply);
>  e_clkput:
>  	clk_disable(state->clock[CSIS_CLK_MUX]);
>  	s5pcsis_clk_put(state);
> @@ -592,8 +599,9 @@ static int s5pcsis_suspend(struct device *dev)
>  		ret = pdata->phy_enable(state->pdev, false);
>  		if (ret)
>  			goto unlock;
> -		if (state->supply) {
> -			ret = regulator_disable(state->supply);
> +		if (!pdata->fixed_phy_vdd) {
> +			ret = regulator_bulk_disable(CSIS_NUM_SUPPLIES,
> +						     state->supply);
>  			if (ret)
>  				goto unlock;
>  		}
> @@ -622,16 +630,17 @@ static int s5pcsis_resume(struct device *dev)
>  		goto unlock;
> 
>  	if (!(state->flags & ST_POWERED)) {
> -		if (state->supply)
> -			ret = regulator_enable(state->supply);
> +		if (!pdata->fixed_phy_vdd)
> +			ret = regulator_bulk_enable(CSIS_NUM_SUPPLIES,
> +						    state->supply);
>  		if (ret)
>  			goto unlock;
> -
>  		ret = pdata->phy_enable(state->pdev, true);
>  		if (!ret) {
>  			state->flags |= ST_POWERED;
> -		} else if (state->supply) {
> -			regulator_disable(state->supply);
> +		} else if (!pdata->fixed_phy_vdd) {
> +			regulator_bulk_disable(CSIS_NUM_SUPPLIES,
> +					       state->supply);
>  			goto unlock;
>  		}
>  		clk_enable(state->clock[CSIS_CLK_GATE]);
> @@ -679,8 +688,7 @@ static int __devexit s5pcsis_remove(struct
> platform_device *pdev) pm_runtime_set_suspended(&pdev->dev);
> 
>  	s5pcsis_clk_put(state);
> -	if (state->supply)
> -		regulator_put(state->supply);
> +	regulator_bulk_free(CSIS_NUM_SUPPLIES, state->supply);
> 
>  	media_entity_cleanup(&state->sd.entity);
>  	free_irq(state->irq, state);

-- 
Regards,

Laurent Pinchart
