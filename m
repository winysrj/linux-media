Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:36997 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab0BTTCU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2010 14:02:20 -0500
Date: Sat, 20 Feb 2010 21:01:36 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l: soc_camera: fix bound checking of mbus_fmt[] index
Message-ID: <20100220190136.GA13389@tarshish>
References: <f9972846401291b8619792d11869510e856ee202.1266472904.git.baruch@tkos.co.il>
 <Pine.LNX.4.64.1002191812490.5860@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1002191812490.5860@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Fri, Feb 19, 2010 at 06:26:06PM +0100, Guennadi Liakhovetski wrote:
> On Thu, 18 Feb 2010, Baruch Siach wrote:
> 
> Thanks for the patch, but I decided to improve it a bit. In fact, the only 
> case my original version was missing was code == V4L2_MBUS_FMT_FIXED, the 
> correct test would be
> 
> (unsigned int)(code - V4L2_MBUS_FMT_FIXED -1) >= ARRAY_SIZE(mbus_fmt)
> 
> but to make it simple we can indeed break this into two tests, the 
> compiler will optimise it for us. So, if you agree, I'll push the version 
> of your patch, attached at the bottom of this mail, for 2.6.33, so, please 
> reply asap...

That's OK by me.

baruch

> > When code <= V4L2_MBUS_FMT_FIXED soc_mbus_get_fmtdesc returns a pointer to
> > mbus_fmt[x], where x < 0. Fix this.
> > 
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---
> >  drivers/media/video/soc_mediabus.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
> > index f8d5c87..a2808e2 100644
> > --- a/drivers/media/video/soc_mediabus.c
> > +++ b/drivers/media/video/soc_mediabus.c
> > @@ -136,6 +136,8 @@ const struct soc_mbus_pixelfmt *soc_mbus_get_fmtdesc(
> >  {
> >  	if ((unsigned int)(code - V4L2_MBUS_FMT_FIXED) > ARRAY_SIZE(mbus_fmt))
> >  		return NULL;
> > +	if ((unsigned int)code <= V4L2_MBUS_FMT_FIXED)
> > +		return NULL;
> >  	return mbus_fmt + code - V4L2_MBUS_FMT_FIXED - 1;
> >  }
> >  EXPORT_SYMBOL(soc_mbus_get_fmtdesc);
> > -- 
> > 1.6.6.1
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 
> 
> From 00109d655b4b8cf25bc68a215966be810e372e87 Mon Sep 17 00:00:00 2001
> From: Baruch Siach <baruch@tkos.co.il>
> Date: Fri, 19 Feb 2010 18:09:25 +0100
> Subject: [PATCH] v4l: soc_camera: fix bound checking of mbus_fmt[] index
> 
> When code <= V4L2_MBUS_FMT_FIXED soc_mbus_get_fmtdesc returns a pointer to
> mbus_fmt[x], where x < 0. Fix this.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/video/soc_mediabus.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
> index f8d5c87..a4c0ef4 100644
> --- a/drivers/media/video/soc_mediabus.c
> +++ b/drivers/media/video/soc_mediabus.c
> @@ -134,7 +134,8 @@ EXPORT_SYMBOL(soc_mbus_bytes_per_line);
>  const struct soc_mbus_pixelfmt *soc_mbus_get_fmtdesc(
>  	enum v4l2_mbus_pixelcode code)
>  {
> -	if ((unsigned int)(code - V4L2_MBUS_FMT_FIXED) > ARRAY_SIZE(mbus_fmt))
> +	if (code - V4L2_MBUS_FMT_FIXED > ARRAY_SIZE(mbus_fmt) ||
> +	    code <= V4L2_MBUS_FMT_FIXED)
>  		return NULL;
>  	return mbus_fmt + code - V4L2_MBUS_FMT_FIXED - 1;
>  }
> -- 
> 1.6.2.4
> 

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
