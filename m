Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:34449 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbZHAMcd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2009 08:32:33 -0400
Message-ID: <4A7435DD.8070801@gmail.com>
Date: Sat, 01 Aug 2009 14:32:29 +0200
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: frank@zago.net, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/10] drivers/media/video/gspca: introduce missing kfree
References: <Pine.LNX.4.64.0908011053140.23408@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0908011053140.23408@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Error handling code following a kmalloc should free the allocated data.
> 
> The semantic match that finds the problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> statement S;
> expression E;
> identifier f,f1,l;
> position p1,p2;
> expression *ptr != NULL;
> @@
> 
> x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
> ...
> if (x == NULL) S
> <... when != x
>      when != if (...) { <+...x...+> }
> (
> x->f1 = E
> |
>  (x->f1 == NULL || ...)
> |
>  f(...,x->f1,...)
> )
> ...>
> (
>  return \(0\|<+...x...+>\|ptr\);
> |
>  return@p2 ...;
> )
> 
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> 
> print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Erik Andrén <erik.andren@gmail.com>
> ---
>  drivers/media/video/gspca/m5602/m5602_s5k83a.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/gspca/m5602/m5602_s5k83a.c b/drivers/media/video/gspca/m5602/m5602_s5k83a.c
> index 7127321..6b89f33 100644
> --- a/drivers/media/video/gspca/m5602/m5602_s5k83a.c
> +++ b/drivers/media/video/gspca/m5602/m5602_s5k83a.c
> @@ -178,8 +178,10 @@ sensor_found:
>  
>  	sens_priv->settings =
>  	kmalloc(sizeof(s32)*ARRAY_SIZE(s5k83a_ctrls), GFP_KERNEL);
> -	if (!sens_priv->settings)
> +	if (!sens_priv->settings) {
> +		kfree(sens_priv);
>  		return -ENOMEM;
> +	}
>  
>  	sd->gspca_dev.cam.cam_mode = s5k83a_modes;
>  	sd->gspca_dev.cam.nmodes = ARRAY_SIZE(s5k83a_modes);
> --

Is this patch already merged into a tree that will be merged in the
upstream one or should the v4l-dvb tree merge it?

Best regards,
Erik

> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
