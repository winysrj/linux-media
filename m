Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36401 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbcL1JrS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Dec 2016 04:47:18 -0500
Received: by mail-wm0-f65.google.com with SMTP id m203so61092206wma.3
        for <linux-media@vger.kernel.org>; Wed, 28 Dec 2016 01:47:17 -0800 (PST)
Subject: Re: [PATCH 1/1] [media] v4l: rcar_fdp1: use %4.4s to format a 4-byte
 string
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20161226133139.3775-1-nicolas.iooss_linux@m4x.org>
Cc: linux-kernel@vger.kernel.org
From: Kieran Bingham <kieran@ksquared.org.uk>
Message-ID: <63afb58e-e588-c3f0-7950-2e2b5dfa453e@bingham.xyz>
Date: Wed, 28 Dec 2016 09:47:15 +0000
MIME-Version: 1.0
In-Reply-To: <20161226133139.3775-1-nicolas.iooss_linux@m4x.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

Thankyou for the patch

This looks like a good catch,

On 26/12/16 13:31, Nicolas Iooss wrote:
> Using %4s to format f->fmt.pix_mp.pixelformat in fdp1_try_fmt() and
> fdp1_s_fmt() may lead to more characters being printed (when the byte
> following field pixelformat is not zero).
> 
> Add ".4" to the format specifier to limit the number of printed
> characters to four. The resulting format specifier "%4.4s" is also used
> by other media drivers to print pixelformat value.
> 
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>

Reviewed-by: Kieran Bingham <kieran@bingham.xyz>

> ---
>  drivers/media/platform/rcar_fdp1.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
> index 674cc1309b43..42f25d241edd 100644
> --- a/drivers/media/platform/rcar_fdp1.c
> +++ b/drivers/media/platform/rcar_fdp1.c
> @@ -1596,7 +1596,7 @@ static int fdp1_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  	else
>  		fdp1_try_fmt_capture(ctx, NULL, &f->fmt.pix_mp);
>  
> -	dprintk(ctx->fdp1, "Try %s format: %4s (0x%08x) %ux%u field %u\n",
> +	dprintk(ctx->fdp1, "Try %s format: %4.4s (0x%08x) %ux%u field %u\n",
>  		V4L2_TYPE_IS_OUTPUT(f->type) ? "output" : "capture",
>  		(char *)&f->fmt.pix_mp.pixelformat, f->fmt.pix_mp.pixelformat,
>  		f->fmt.pix_mp.width, f->fmt.pix_mp.height, f->fmt.pix_mp.field);
> @@ -1671,7 +1671,7 @@ static int fdp1_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  
>  	fdp1_set_format(ctx, &f->fmt.pix_mp, f->type);
>  
> -	dprintk(ctx->fdp1, "Set %s format: %4s (0x%08x) %ux%u field %u\n",
> +	dprintk(ctx->fdp1, "Set %s format: %4.4s (0x%08x) %ux%u field %u\n",
>  		V4L2_TYPE_IS_OUTPUT(f->type) ? "output" : "capture",
>  		(char *)&f->fmt.pix_mp.pixelformat, f->fmt.pix_mp.pixelformat,
>  		f->fmt.pix_mp.width, f->fmt.pix_mp.height, f->fmt.pix_mp.field);
> 

-- 
Regards

Kieran Bingham
