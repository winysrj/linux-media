Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45865 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752855AbZBASHj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2009 13:07:39 -0500
Date: Sun, 1 Feb 2009 19:07:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] tw9910: color format check is added on set_fmt
In-Reply-To: <uwscdm9t7.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0902011907020.17985@axis700.grange>
References: <uwscdm9t7.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 27 Jan 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>

Why is this needed? Do you see any possibility for tw9910 to be called 
with an unsupported format?

Thanks
Guennadi

> ---
>  drivers/media/video/tw9910.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
> index 1a9c6fd..57027c0 100644
> --- a/drivers/media/video/tw9910.c
> +++ b/drivers/media/video/tw9910.c
> @@ -647,6 +647,19 @@ static int tw9910_set_fmt(struct soc_camera_device *icd, __u32 pixfmt,
>  	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
>  	int                 ret  = -EINVAL;
>  	u8                  val;
> +	int                 i;
> +
> +	/*
> +	 * check color format
> +	 */
> +	for (i = 0 ; i < ARRAY_SIZE(tw9910_color_fmt) ; i++) {
> +		if (pixfmt == tw9910_color_fmt[i].fourcc) {
> +			ret = 0;
> +			break;
> +		}
> +	}
> +	if (ret < 0)
> +		goto tw9910_set_fmt_error;
>  
>  	/*
>  	 * select suitable norm
> -- 
> 1.5.6.3
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
