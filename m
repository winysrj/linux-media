Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60566 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751359AbZC3Nok (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 09:44:40 -0400
Date: Mon, 30 Mar 2009 15:44:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4] ov772x: add edge contrl support
In-Reply-To: <ufxgvqld8.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0903301534430.4455@axis700.grange>
References: <ufxgvqld8.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 30 Mar 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
> v3 -> v4
> 
> o comment fix
> o change edge ctrl setting order
> o considered edge auto control mode and manual control mode
> o add DSP auto register comment

Ok, I understand more now. So, this edge (which I still don't know what it 
actually does. Some sort of contrast?) can function in either automatic or 
in manual mode. In Automatic mode you set lower and upper points in 
registers EDGE2 and EDGE3, in manual mode you set strength and threshold 
in registers EDGE0 and EDGE1. So, just one more question:

> 
>  drivers/media/video/ov772x.c |   52 ++++++++++++++++++++++++++++++++++++++---
>  include/media/ov772x.h       |   25 ++++++++++++++++++++
>  2 files changed, 73 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 34c9819..182daa5 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -169,11 +169,11 @@
>  #define GAM15       0x8C /* Gamma Curve 15th segment input end point */
>  #define SLOP        0x8D /* Gamma curve highest segment slope */
>  #define DNSTH       0x8E /* De-noise threshold */
> -#define EDGE0       0x8F /* Edge enhancement control 0 */
> -#define EDGE1       0x90 /* Edge enhancement control 1 */
> +#define EDGE0       0x8F /* Edge strength  control when manual mode */
> +#define EDGE1       0x90 /* Edge threshold control when manual mode */
>  #define DNSOFF      0x91 /* Auto De-noise threshold control */
> -#define EDGE2       0x92 /* Edge enhancement strength low  point control */
> -#define EDGE3       0x93 /* Edge enhancement strength high point control */
> +#define EDGE2       0x92 /* Edge strength upper limit when Auto mode */
> +#define EDGE3       0x93 /* Edge strength lower limit when Auto mode */
>  #define MTX1        0x94 /* Matrix coefficient 1 */
>  #define MTX2        0x95 /* Matrix coefficient 2 */
>  #define MTX3        0x96 /* Matrix coefficient 3 */
> @@ -358,6 +358,14 @@
>  #define VOSZ_VGA        0xF0
>  #define VOSZ_QVGA       0x78
>  
> +/* DSPAUTO (DSP Auto Function ON/OFF Control) */
> +#define AWB_ACTRL       0x80 /* AWB auto threshold control */
> +#define DENOISE_ACTRL   0x40 /* De-noise auto threshold control */
> +#define EDGE_ACTRL      0x20 /* Edge enhancement auto strength control */
> +#define UV_ACTRL        0x10 /* UV adjust auto slope control */
> +#define SCAL0_ACTRL     0x08 /* Auto scaling factor control */
> +#define SCAL1_2_ACTRL   0x04 /* Auto scaling factor control */
> +
>  /*
>   * ID
>   */
> @@ -816,6 +824,42 @@ static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
>  	ov772x_reset(priv->client);
>  
>  	/*
> +	 * set Edge Ctrl
> +	 */
> +	if (priv->info->flags & OV772X_FLAG_MAN_EDGE) {
> +		/*
> +		 * Edge auto strength is set by default.
> +		 * Remove this bit when manual strength.
> +		 */
> +		ret = ov772x_mask_set(priv->client, DSPAUTO,
> +				      EDGE_ACTRL, 0x00);
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +
> +		ret = ov772x_mask_set(priv->client, EDGE1, 0x0F,
> +				      priv->info->edgectrl.reg_b);
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +
> +		ret = ov772x_mask_set(priv->client, EDGE0, 0x1F,
> +				      priv->info->edgectrl.reg_a);
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +
> +	} else if (priv->info->edgectrl.reg_a > priv->info->edgectrl.reg_b) {
> +
> +		ret = ov772x_mask_set(priv->client, EDGE2, 0xFF,
> +				      priv->info->edgectrl.reg_a);
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +
> +		ret = ov772x_mask_set(priv->client, EDGE3, 0xFF,
> +				      priv->info->edgectrl.reg_b);
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +	}
> +
> +	/*
>  	 * set size format
>  	 */
>  	ret = ov772x_write_array(priv->client, priv->win->regs);
> diff --git a/include/media/ov772x.h b/include/media/ov772x.h
> index 57db48d..75d1f15 100644
> --- a/include/media/ov772x.h
> +++ b/include/media/ov772x.h
> @@ -16,11 +16,36 @@
>  /* for flags */
>  #define OV772X_FLAG_VFLIP     0x00000001 /* Vertical flip image */
>  #define OV772X_FLAG_HFLIP     0x00000002 /* Horizontal flip image */
> +#define OV772X_FLAG_MAN_EDGE  0x00000004 /* Manual edge control (default Auto) */
>  
> +/*
> + * for Edge ctrl
> + *
> + * if OV772X_FLAG_MAN_EDGE
> + *    reg_a : strength
> + *    reg_b : threshold
> + * else (Auto Edge Control)
> + *    reg_a : strength upper limit
> + *    reg_b : strength lower limit
> + */
> +struct ov772x_edge_ctrl {
> +	unsigned char reg_a;
> +	unsigned char reg_b;
> +};
> +
> +#define OV772X_EDGECTRL(a, b) \
> +	{.reg_a = (a),        \
> +	 .reg_b = (b),        \
> +	}

Isn't this confusing? You use reg_a and reg_b for two different roles 
depending on the automatic setting. Wouldn't it be better to have upper, 
lower, threshold, strength as you had in earlier versions and just use the 
registers that you need for one or another mode? Your struct will anyway 
be 4 bytes aligned, so, you don't lose a single byte:-) This way you can 
define all four values in your platform code, and, maybe even dynamically 
switch between manual and automatic, if we find a suitable control for it 
or create a new one.

If you accept this change then please also reformat the above define to

+#define OV772X_EDGECTRL(strength, threshold, upper, lower)	\
+{								\
+	.strength	= (strength),				\
+	.threshold	= (threshold),				\
+	.upper		= (upper),				\
+	.lower		= (lower),				\
+}

or similar.

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
