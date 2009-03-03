Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42090 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752026AbZCCIHN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2009 03:07:13 -0500
Date: Tue, 3 Mar 2009 09:07:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus <magnus.damm@gmail.com>
Subject: Re: [PATCH] ov772x: Add extra setting method
In-Reply-To: <u63irl9dx.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0903030843090.5059@axis700.grange>
References: <u63irl9dx.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Mar 2009, Kuninori Morimoto wrote:

> This patch add support extra register settings for platform.
> For instance, platform comes to be able to use the
> special setting like lens.
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
[snip]
> @@ -815,6 +808,14 @@ static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
>  	 */
>  	ov772x_reset(priv->client);
>  
> +	/* set extra setting */
> +	if (priv->info->extra) {
> +		ret = ov772x_write_array(priv->client,
> +					 priv->info->extra);
> +		if (ret < 0)
> +			goto ov772x_set_fmt_error;
> +	}
> +
>  	/*
>  	 * set size format
>  	 */

Hm, cannot say this patch makes me specifically happy. This means we let 
the user directly arbitrarily configure our registers. I don't seem to 
have a datasheet for ov772x, so, I cannot judge what registers are 
required for lens configuration, and how many meaningful settings there 
can be. For instance, maybe there are only two variants like 
lens-configuration-A and lens-configuration-B? Then I would just add 
respective flags to platform data. If there are really many variants, 
maybe we can let user-space configure them using VIDIOC_DBG_S_REGISTER? 
Can you maybe explain to me at least approximately what those lens 
settings are doing? Are there any sane defaults that would reasonably work 
with all lenses? In the very worst case, if we decide - no, this is very 
platform specific, and it has to be done in the kernel (why?), I would 
prefer adding elements like

	u32	LENS_CONFIG_1;
	u32	LENS_CONFIG_2;
	...

rather than allowing the platform to arbitrarily mangle our registers?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
