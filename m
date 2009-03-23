Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55457 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751412AbZCWHbz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 03:31:55 -0400
Date: Mon, 23 Mar 2009 08:31:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] ov772x: add edge contrl support
In-Reply-To: <uab7c249a.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0903230829510.4476@axis700.grange>
References: <uab7c249a.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Mar 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
> This patch is 1st step for extra settings
> 
>  drivers/media/video/ov772x.c |   34 ++++++++++++++++++++++++++++++++++
>  include/media/ov772x.h       |   25 +++++++++++++++++++++++++
>  2 files changed, 59 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 34c9819..a951327 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -358,6 +358,15 @@
>  #define VOSZ_VGA        0xF0
>  #define VOSZ_QVGA       0x78
>  
> +/* EDGE CTRL
> + * see alse
> + *    ov772x.h :: for Edge ctrl
> + */
> +#define EDGE0CTRL(param) (((param) >> 24) & 0x1F)
> +#define EDGE1CTRL(param) (((param) >> 16) & 0x0F)
> +#define EDGE2CTRL(param) (((param) >>  8) & 0xFF)
> +#define EDGE3CTRL(param) (((param) >>  0) & 0xFF)
> +
>  /*
>   * ID
>   */
> @@ -816,6 +825,31 @@ static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
>  	ov772x_reset(priv->client);
>  
>  	/*
> +	 * set Edge Ctrl if platform has edgectrl
> +	 */
> +	if (priv->info->edgectrl & OV772X_EDGECTRL_ENABLE) {
> +		ret = ov772x_mask_set(priv->client,
> +				EDGE0, 0x1F, EDGE0CTRL(priv->info->edgectrl));
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +
> +		ret = ov772x_mask_set(priv->client,
> +				EDGE1, 0x0F, EDGE1CTRL(priv->info->edgectrl));
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +
> +		ret = ov772x_mask_set(priv->client,
> +				EDGE2, 0xFF, EDGE2CTRL(priv->info->edgectrl));
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +
> +		ret = ov772x_mask_set(priv->client,
> +				EDGE3, 0xFF, EDGE3CTRL(priv->info->edgectrl));
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +	}
> +
> +	/*
>  	 * set size format
>  	 */
>  	ret = ov772x_write_array(priv->client, priv->win->regs);
> diff --git a/include/media/ov772x.h b/include/media/ov772x.h
> index 57db48d..5b083dc 100644
> --- a/include/media/ov772x.h
> +++ b/include/media/ov772x.h
> @@ -17,9 +17,34 @@
>  #define OV772X_FLAG_VFLIP     0x00000001 /* Vertical flip image */
>  #define OV772X_FLAG_HFLIP     0x00000002 /* Horizontal flip image */
>  
> +/*
> + * for Edge ctrl
> + *
> + * strength  : (for EDGE0) Edge enhancement strength control
> + * threshold : (for EDGE1) Edge enhancement threshold control
> + * low       : (for EDGE2) Edge enhancement strength Low point control
> + * high      : (for EDGE3) Edge enhancement strength High point control
> + *
> + * Meaning of edgectrl bit
> + *
> + * Exx0 0000 xxxx 1111 2222 2222 3333 3333
> + *
> + * E: use edgectrl or not (OV772X_EDGECTRL_ENABLE)
> + * 0: for Edge0 ctrl
> + * 1: for Edge1 ctrl
> + * 2: for Edge2 ctrl
> + * 3: for Edge3 ctrl
> + */
> +#define OV772X_EDGECTRL_ENABLE	0x80000000
> +#define OV772X_EDGECTRL(strength, threshold, low, high) \
> +	(OV772X_EDGECTRL_ENABLE | \
> +	 (strength & 0x1F) << 24 | (threshold & 0x0F) << 16 | \
> +	 (low & 0xFF) << 8 | (high & 0xFF) << 0)
> +
>  struct ov772x_camera_info {
>  	unsigned long          buswidth;
>  	unsigned long          flags;
> +	unsigned long          edgectrl;

Wouldn't it be easier to use

	unsigned char	edge_strength;
	unsigned char	edge_threshold;
	unsigned char	edge_low;
	unsigned char	edge_high;

and thus avoid all that shifting?

>  	struct soc_camera_link link;
>  };
>  
> -- 
> 1.5.6.3

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
