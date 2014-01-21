Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60477 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbaAULSN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jan 2014 06:18:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] media: i2c: mt9p031: Check return value of clk_prepare_enable/clk_set_rate
Date: Tue, 21 Jan 2014 12:18:58 +0100
Message-ID: <4346570.zM53heUM7x@avalon>
In-Reply-To: <1390281657-7185-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1390281657-7185-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thank you for the patch.

On Tuesday 21 January 2014 10:50:57 Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> clk_set_rate(), clk_prepare_enable() functions can fail, so check the return
> values to avoid surprises.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  Changes for v2:
>  1: Called regulator_bulk_disable() in the error path
> 
>  drivers/media/i2c/mt9p031.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index e5ddf47..05278f5 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -222,12 +222,15 @@ static int mt9p031_clk_setup(struct mt9p031 *mt9p031)
> 
>  	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
>  	struct mt9p031_platform_data *pdata = mt9p031->pdata;
> +	int ret;
> 
>  	mt9p031->clk = devm_clk_get(&client->dev, NULL);
>  	if (IS_ERR(mt9p031->clk))
>  		return PTR_ERR(mt9p031->clk);
> 
> -	clk_set_rate(mt9p031->clk, pdata->ext_freq);
> +	ret = clk_set_rate(mt9p031->clk, pdata->ext_freq);
> +	if (ret < 0)
> +		return ret;
> 
>  	mt9p031->pll.ext_clock = pdata->ext_freq;
>  	mt9p031->pll.pix_clock = pdata->target_freq;
> @@ -286,8 +289,14 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
>  		return ret;
> 
>  	/* Emable clock */
> -	if (mt9p031->clk)
> -		clk_prepare_enable(mt9p031->clk);
> +	if (mt9p031->clk) {
> +		ret = clk_prepare_enable(mt9p031->clk);
> +		if (ret) {
> +			regulator_bulk_disable(ARRAY_SIZE(mt9p031->regulators),
> +					       mt9p031->regulators);
> +			return ret;
> +		}
> +	}
> 
>  	/* Now RESET_BAR must be high */
>  	if (gpio_is_valid(mt9p031->reset)) {

-- 
Regards,

Laurent Pinchart

