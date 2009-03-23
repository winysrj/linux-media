Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60346 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754846AbZCWJ5Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 05:57:25 -0400
Date: Mon, 23 Mar 2009 10:57:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] ov772x: add edge contrl support
In-Reply-To: <u4oxk1sf3.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0903231054470.4871@axis700.grange>
References: <u4oxk1sf3.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Mar 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
> I used flags to judge though
> I said I use edge_threshold un-used 4 bit.
> 
> v1 -> v2
> o add struct ov772x_edge_ctrl
> o add new flags
> 
>  drivers/media/video/ov772x.c |   31 +++++++++++++++++++++++++++++++
>  include/media/ov772x.h       |   26 +++++++++++++++++++++++---
>  2 files changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 34c9819..ae832e6 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -816,6 +816,37 @@ static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
>  	ov772x_reset(priv->client);
>  
>  	/*
> +	 * set Edge Ctrl
> +	 */
> +	if (priv->info->flags & OV772X_FLAG_EDGE_STRENGTH) {
> +		ret = ov772x_mask_set(priv->client, EDGE0, 0x1F,
> +				      priv->info->edgectrl.strength);
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +	}
> +
> +	if (priv->info->flags & OV772X_FLAG_EDGE_THRESHOLD) {
> +		ret = ov772x_mask_set(priv->client, EDGE1, 0x0F,
> +				      priv->info->edgectrl.threshold);
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +	}
> +
> +	if (priv->info->flags & OV772X_FLAG_EDGE_LOW) {
> +		ret = ov772x_mask_set(priv->client, EDGE2, 0xFF,
> +				      priv->info->edgectrl.low);
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +	}
> +
> +	if (priv->info->flags & OV772X_FLAG_EDGE_HIGH) {
> +		ret = ov772x_mask_set(priv->client, EDGE3, 0xFF,
> +				      priv->info->edgectrl.high);
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +	}

No idea, does it really make sense to set low edge without setting high? 
or to set threshold without strength?

> +
> +	/*
>  	 * set size format
>  	 */
>  	ret = ov772x_write_array(priv->client, priv->win->regs);
> diff --git a/include/media/ov772x.h b/include/media/ov772x.h
> index 57db48d..c5051c7 100644
> --- a/include/media/ov772x.h
> +++ b/include/media/ov772x.h
> @@ -13,14 +13,34 @@
>  
>  #include <media/soc_camera.h>
>  
> -/* for flags */
> -#define OV772X_FLAG_VFLIP     0x00000001 /* Vertical flip image */
> -#define OV772X_FLAG_HFLIP     0x00000002 /* Horizontal flip image */
> +/*
> + * for flags
> + */
> +#define OV772X_FLAG_VFLIP		(1 << 0) /* Vertical flip image */
> +#define OV772X_FLAG_HFLIP		(1 << 1) /* Horizontal flip image */
> +#define OV772X_FLAG_EDGE_STRENGTH	(1 << 2) /* Edge Ctrl strength */
> +#define OV772X_FLAG_EDGE_THRESHOLD	(1 << 3) /* Edge ctrl threshold */
> +#define OV772X_FLAG_EDGE_LOW		(1 << 4) /* Edge ctrl low */
> +#define OV772X_FLAG_EDGE_HIGH		(1 << 5) /* Edge ctrl high */
>  
> +/*
> + * for Edge ctrl
> + */

Please, explain in the comment what this edge controls are good for, at 
least approximately, so people without the datasheet have a chance to 
understand what's going on here.

> +struct ov772x_edge_ctrl {
> +	unsigned char strength;  /* strength control */
> +	unsigned char threshold; /* threshold control */
> +	unsigned char low;       /* strength Low point control */
> +	unsigned char high;      /* strength High point control */
> +};
> +
> +/*
> + * ov772x camera info
> + */
>  struct ov772x_camera_info {
>  	unsigned long          buswidth;
>  	unsigned long          flags;
>  	struct soc_camera_link link;
> +	struct ov772x_edge_ctrl edgectrl;
>  };
>  
>  #endif /* __OV772X_H__ */
> -- 
> 1.5.6.3
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
