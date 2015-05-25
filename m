Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:56316 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbbEYPP0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 11:15:26 -0400
Date: Mon, 25 May 2015 17:15:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: William Towle <william.towle@codethink.co.uk>
cc: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, hverkuil@xs4all.nl,
	rob.taylor@codethink.co.uk
Subject: Re: [PATCH 17/20] media: adv7604: Support V4L_FIELD_INTERLACED
In-Reply-To: <1432139980-12619-18-git-send-email-william.towle@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1505251714420.26358@axis700.grange>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
 <1432139980-12619-18-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 May 2015, William Towle wrote:

> When hardware reports interlaced input, correctly set field to
> V4L_FIELD_INTERLACED ini adv76xx_fill_format.
> 
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> Reviewed-by: William Towle <william.towle@codethink.co.uk>
> ---
>  drivers/media/i2c/adv7604.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 4bde3e1..d77ee1f 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -1791,7 +1791,12 @@ static void adv76xx_fill_format(struct adv76xx_state *state,
>  
>  	format->width = state->timings.bt.width;
>  	format->height = state->timings.bt.height;
> -	format->field = V4L2_FIELD_NONE;
> +
> +	if (state->timings.bt.interlaced)
> +		format->field= V4L2_FIELD_INTERLACED;
> +	else
> +		format->field= V4L2_FIELD_NONE;
> +

A space before "=" please.

Thanks
Guennadi

>  	format->colorspace = V4L2_COLORSPACE_SRGB;
>  
>  	if (state->timings.bt.flags & V4L2_DV_FL_IS_CE_VIDEO)
> -- 
> 1.7.10.4
> 
