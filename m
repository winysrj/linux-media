Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47006 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaIZKoD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 06:44:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 17/17] smiapp: Decrease link frequency if media bus pixel format BPP requires
Date: Fri, 26 Sep 2014 13:44:03 +0300
Message-ID: <24769200.DuP3evaK0j@avalon>
In-Reply-To: <1410986741-6801-18-git-send-email-sakari.ailus@iki.fi>
References: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi> <1410986741-6801-18-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Wednesday 17 September 2014 23:45:41 Sakari Ailus wrote:
> Decrease the link frequency to the next lower if the user chooses a media
> bus code (BPP) cannot be achieved using the selected link frequency.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/i2c/smiapp/smiapp-core.c |   20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c
> b/drivers/media/i2c/smiapp/smiapp-core.c index 537ca92..ce2c34d 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -286,11 +286,27 @@ static int smiapp_pll_update(struct smiapp_sensor
> *sensor)
> 
>  	pll->binning_horizontal = sensor->binning_horizontal;
>  	pll->binning_vertical = sensor->binning_vertical;
> -	pll->link_freq =
> -		sensor->link_freq->qmenu_int[sensor->link_freq->val];
>  	pll->scale_m = sensor->scale_m;
>  	pll->bits_per_pixel = sensor->csi_format->compressed;
> 
> +	if (!test_bit(sensor->link_freq->val,
> +		      &sensor->valid_link_freqs[
> +			      sensor->csi_format->compressed
> +			      - SMIAPP_COMPRESSED_BASE])) {
> +		/*
> +		 * Setting the link frequency will perform PLL
> +		 * re-calculation already, so skip that.
> +		 */
> +		return __v4l2_ctrl_s_ctrl(
> +			sensor->link_freq,
> +			__ffs(sensor->valid_link_freqs[
> +				      sensor->csi_format->compressed
> +				      - SMIAPP_COMPRESSED_BASE]));

I have an uneasy feeling about this, as smiapp_pll_update is called from the 
link freq s_ctrl handler. Have you double-checked the recursion bounds ?

> +	}
> +
> +	pll->link_freq =
> +		sensor->link_freq->qmenu_int[sensor->link_freq->val];
> +
>  	rval = smiapp_pll_try(sensor, pll);
>  	if (rval < 0)
>  		return rval;

-- 
Regards,

Laurent Pinchart

