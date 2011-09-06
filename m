Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55162 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab1IFK1U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 06:27:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH] mt9p031: Do not use PLL if external frequency is the same as target frequency.
Date: Tue, 6 Sep 2011 12:27:18 +0200
Cc: linux-media@vger.kernel.org
References: <1315303380-20698-1-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1315303380-20698-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109061227.18685.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Tuesday 06 September 2011 12:03:00 Javier Martin wrote:
> This patch adds a check to see whether ext_freq and target_freq are equal
> and, if true, PLL won't be used.

Thanks for the patch.

As you're touching PLL code, what about fixing PLL setup by computing 
parameters dynamically instead of using a table of hardcoded values ? :-)

> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/video/mt9p031.c |   18 +++++++++++++++---
>  1 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
> index 5cfa39f..42b5d18 100644
> --- a/drivers/media/video/mt9p031.c
> +++ b/drivers/media/video/mt9p031.c
> @@ -117,6 +117,7 @@ struct mt9p031 {
>  	u16 xskip;
>  	u16 yskip;
> 
> +	bool use_pll;
>  	const struct mt9p031_pll_divs *pll;
> 
>  	/* Registers cache */
> @@ -201,10 +202,16 @@ static int mt9p031_pll_get_divs(struct mt9p031
> *mt9p031) struct i2c_client *client =
> v4l2_get_subdevdata(&mt9p031->subdev); int i;
> 
> +	if (mt9p031->pdata->ext_freq == mt9p031->pdata->target_freq) {
> +		mt9p031->use_pll = false;
> +		return 0;
> +	}
> +
>  	for (i = 0; i < ARRAY_SIZE(mt9p031_divs); i++) {
>  		if (mt9p031_divs[i].ext_freq == mt9p031->pdata->ext_freq &&
>  		  mt9p031_divs[i].target_freq == mt9p031->pdata->target_freq) {
>  			mt9p031->pll = &mt9p031_divs[i];
> +			mt9p031->use_pll = true;
>  			return 0;
>  		}
>  	}
> @@ -385,8 +392,10 @@ static int mt9p031_s_stream(struct v4l2_subdev
> *subdev, int enable) MT9P031_OUTPUT_CONTROL_CEN, 0);
>  		if (ret < 0)
>  			return ret;
> -
> -		return mt9p031_pll_disable(mt9p031);
> +		if (mt9p031->use_pll)
> +			return mt9p031_pll_disable(mt9p031);
> +		else
> +			return 0;
>  	}
> 
>  	ret = mt9p031_set_params(mt9p031);
> @@ -399,7 +408,10 @@ static int mt9p031_s_stream(struct v4l2_subdev
> *subdev, int enable) if (ret < 0)
>  		return ret;
> 
> -	return mt9p031_pll_enable(mt9p031);
> +	if (mt9p031->use_pll)
> +		return mt9p031_pll_enable(mt9p031);
> +	else
> +		return 0;
>  }
> 
>  static int mt9p031_enum_mbus_code(struct v4l2_subdev *subdev,

-- 
Regards,

Laurent Pinchart
