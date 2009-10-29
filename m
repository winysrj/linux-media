Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbZJ2N2T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 09:28:19 -0400
Date: Thu, 29 Oct 2009 11:28:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-media@vger.kernel.org,
	Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCH 2/2] atoi: Drop custom atoi from drivers/video/modedb.c
Message-ID: <20091029112813.752dfcf4@pedra.chehab.org>
In-Reply-To: <1253789890-31262-2-git-send-email-andy.shevchenko@gmail.com>
References: <1253789890-31262-1-git-send-email-andy.shevchenko@gmail.com>
	<1253789890-31262-2-git-send-email-andy.shevchenko@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

You send this patch to the wrong ML. Somebody's else maintain drivers/video.

Btw, it would be better to use strict_atoi instead of simple_atoi.

The same comment applies to pwc patch you sent at the same series, but,
as it is better to use simple_atoi, instead of having their own implementation,
I've merged it.

Cheers,
Mauro.

Em Thu, 24 Sep 2009 13:58:10 +0300
Andy Shevchenko <andy.shevchenko@gmail.com> escreveu:

> From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> 
> Kernel has simple_strtol() implementation which could be used as atoi().
> 
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> ---
>  drivers/video/modedb.c |   24 +++++-------------------
>  1 files changed, 5 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
> index 34e4e79..0129f1b 100644
> --- a/drivers/video/modedb.c
> +++ b/drivers/video/modedb.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/module.h>
>  #include <linux/fb.h>
> +#include <linux/kernel.h>
>  
>  #undef DEBUG
>  
> @@ -402,21 +403,6 @@ const struct fb_videomode vesa_modes[] = {
>  EXPORT_SYMBOL(vesa_modes);
>  #endif /* CONFIG_FB_MODE_HELPERS */
>  
> -static int my_atoi(const char *name)
> -{
> -    int val = 0;
> -
> -    for (;; name++) {
> -	switch (*name) {
> -	    case '0' ... '9':
> -		val = 10*val+(*name-'0');
> -		break;
> -	    default:
> -		return val;
> -	}
> -    }
> -}
> -
>  /**
>   *	fb_try_mode - test a video mode
>   *	@var: frame buffer user defined part of display
> @@ -539,7 +525,7 @@ int fb_find_mode(struct fb_var_screeninfo *var,
>  		    namelen = i;
>  		    if (!refresh_specified && !bpp_specified &&
>  			!yres_specified) {
> -			refresh = my_atoi(&name[i+1]);
> +			refresh = simple_strtol(&name[i+1], NULL, 10);
>  			refresh_specified = 1;
>  			if (cvt || rb)
>  			    cvt = 0;
> @@ -549,7 +535,7 @@ int fb_find_mode(struct fb_var_screeninfo *var,
>  		case '-':
>  		    namelen = i;
>  		    if (!bpp_specified && !yres_specified) {
> -			bpp = my_atoi(&name[i+1]);
> +			bpp = simple_strtol(&name[i+1], NULL, 10);
>  			bpp_specified = 1;
>  			if (cvt || rb)
>  			    cvt = 0;
> @@ -558,7 +544,7 @@ int fb_find_mode(struct fb_var_screeninfo *var,
>  		    break;
>  		case 'x':
>  		    if (!yres_specified) {
> -			yres = my_atoi(&name[i+1]);
> +			yres = simple_strtol(&name[i+1], NULL, 10);
>  			yres_specified = 1;
>  		    } else
>  			goto done;
> @@ -586,7 +572,7 @@ int fb_find_mode(struct fb_var_screeninfo *var,
>  	    }
>  	}
>  	if (i < 0 && yres_specified) {
> -	    xres = my_atoi(name);
> +	    xres = simple_strtol(name, NULL, 10);
>  	    res_specified = 1;
>  	}
>  done:


-- 

Cheers,
Mauro
