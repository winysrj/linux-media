Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37300 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752252AbZAYBuV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jan 2009 20:50:21 -0500
Date: Sun, 25 Jan 2009 02:50:34 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] ov772x: add support S_CROP operation.
In-Reply-To: <uskna4qh8.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0901250245440.4969@axis700.grange>
References: <uskna4qh8.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 23 Jan 2009, Kuninori Morimoto wrote:

> ov772x_set_fmt had returned NULL when pixfmt is 0,
> although it mean only geometry change.
> This patch modify this problem.
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/ov772x.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 681a11b..30eb80e 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -792,12 +792,15 @@ static int ov772x_set_fmt(struct soc_camera_device *icd,
>  
>  	/*
>  	 * select format
> +	 * when pixfmt is 0, only geometry change
>  	 */
> -	priv->fmt = NULL;
> -	for (i = 0; i < ARRAY_SIZE(ov772x_cfmts); i++) {
> -		if (pixfmt == ov772x_cfmts[i].fourcc) {
> -			priv->fmt = ov772x_cfmts + i;
> -			break;
> +	if (pixfmt) {
> +		priv->fmt = NULL;
> +		for (i = 0; i < ARRAY_SIZE(ov772x_cfmts); i++) {
> +			if (pixfmt == ov772x_cfmts[i].fourcc) {
> +				priv->fmt = ov772x_cfmts + i;
> +				break;
> +			}
>  		}
>  	}
>  	if (!priv->fmt)

Have you tested with v4l-dvb/v4l2-apps/test/capture_example.c? I think it 
wouldn't work, because it first calls S_CROP, and then S_FMT, and even 
with this your patch you'd fail S_CROP if S_FMT hadn't been called before 
(priv->fmt == NULL). Am I right? 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
