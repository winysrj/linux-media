Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47773 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754642AbZCXJ1Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 05:27:25 -0400
Date: Tue, 24 Mar 2009 10:27:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3] ov772x: add edge contrl support
In-Reply-To: <uvdpzuw4t.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0903241019030.4451@axis700.grange>
References: <uvdpzuw4t.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 24 Mar 2009, Kuninori Morimoto wrote:

> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
> v2 -> v3
> o use edgectrl.strength for judge
> 
> Sorry for my miss-understanding.
> This patch use edgectrl.strength for judgement.
> And the explain in the comment has all.
> My datasheet doesn't have details more than this explain.
> 
>  drivers/media/video/ov772x.c |   25 +++++++++++++++++++++++++
>  include/media/ov772x.h       |   21 +++++++++++++++++++++
>  2 files changed, 46 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 34c9819..3226c43 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -816,6 +816,31 @@ static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
>  	ov772x_reset(priv->client);
>  
>  	/*
> +	 * set Edge Ctrl
> +	 */
> +	if (priv->info->edgectrl.strength) {
> +		ret = ov772x_mask_set(priv->client, EDGE0, 0x1F,
> +				      priv->info->edgectrl.strength);
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;

Whatever this "edge" does, isn't it so, that "threshold," "upper," and 
"lower" parameters configure it and "strength" actually enforces the 
changes? Say, if strength == 0, edge control is off, and as soon as you 
switch it to != 0, it is on with all the configured parameters? If my 
guess is right, wouldn't it make sense to first configure parameters and 
then set strength? If you agree, I'll just swap them when committing, so, 
you don't have to resend. Just please either confirm that you agree, or 
explain why I am wrong.

> +
> +		ret = ov772x_mask_set(priv->client, EDGE1, 0x0F,
> +				      priv->info->edgectrl.threshold);
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +
> +		ret = ov772x_mask_set(priv->client, EDGE2, 0xFF,
> +				      priv->info->edgectrl.upper);
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +
> +		ret = ov772x_mask_set(priv->client, EDGE3, 0xFF,
> +				      priv->info->edgectrl.lower);
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +	}
> +
> +	/*
>  	 * set size format
>  	 */
>  	ret = ov772x_write_array(priv->client, priv->win->regs);
> diff --git a/include/media/ov772x.h b/include/media/ov772x.h
> index 57db48d..cfdd80e 100644
> --- a/include/media/ov772x.h
> +++ b/include/media/ov772x.h
> @@ -17,10 +17,31 @@
>  #define OV772X_FLAG_VFLIP     0x00000001 /* Vertical flip image */
>  #define OV772X_FLAG_HFLIP     0x00000002 /* Horizontal flip image */
>  
> +/*
> + * for Edge ctrl
> + */
> +struct ov772x_edge_ctrl {
> +	unsigned char strength;  /* strength control */
> +	unsigned char threshold; /* threshold detection */
> +	unsigned char upper;     /* strength upper limit */
> +	unsigned char lower;     /* strength lower limit */
> +};
> +
> +#define OV772X_EDGECTRL(s, t, u, l) \
> +	{.strength  = (s & 0x1F),\
> +	 .threshold = (t & 0x0F),\
> +	 .upper     = (u & 0xFF),\
> +	 .lower     = (l & 0xFF),\
> +	}

If you don't mind, I'll reformat this slightly to

+#define OV772X_EDGECTRL(s, t, u, l)	\
+{					\
+	.strength	= (s & 0x1F),	\
+	.threshold	= (t & 0x0F),	\
+	.upper		= (u & 0xFF),	\
+	.lower		= (l & 0xFF),	\
+}

when applying, ok?

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

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
