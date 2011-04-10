Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:56848 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab1DJQAS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Apr 2011 12:00:18 -0400
Date: Sun, 10 Apr 2011 18:00:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2.6.39] soc_camera: OMAP1: fix missing bytesperline and
 sizeimage initialization
In-Reply-To: <201104090158.04827.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1104101751380.12697@axis700.grange>
References: <201104090158.04827.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Janusz

On Sat, 9 Apr 2011, Janusz Krzysztofik wrote:

> Since commit 0e4c180d3e2cc11e248f29d4c604b6194739d05a, bytesperline and 
> sizeimage memebers of v4l2_pix_format structure have no longer been 
> calculated inside soc_camera_g_fmt_vid_cap(), but rather passed via 
> soc_camera_device structure from a host driver callback invoked by 
> soc_camera_set_fmt().
> 
> OMAP1 camera host driver has never been providing these parameters, so 
> it no longer works correctly. Fix it by adding suitable assignments to 
> omap1_cam_set_fmt().

Thanks for the patch, but now it looks like many soc-camera host drivers 
are re-implementing this very same calculation in different parts of their 
code - in try_fmt, set_fmt, get_fmt. Why don't we unify them all, 
implement this centrally in soc_camera.c and remove all those 
calculations? Could you cook up a patch or maybe several patches - for 
soc_camera.c and all drivers?

Thanks
Guennadi

> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> ---
>  drivers/media/video/omap1_camera.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- linux-2.6.39-rc2/drivers/media/video/omap1_camera.c.orig	2011-04-06 14:30:37.000000000 +0200
> +++ linux-2.6.39-rc2/drivers/media/video/omap1_camera.c	2011-04-09 00:16:36.000000000 +0200
> @@ -1292,6 +1292,12 @@ static int omap1_cam_set_fmt(struct soc_
>  	pix->colorspace  = mf.colorspace;
>  	icd->current_fmt = xlate;
>  
> +	pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
> +						    xlate->host_fmt);
> +	if (pix->bytesperline < 0)
> +		return pix->bytesperline;
> +	pix->sizeimage = pix->height * pix->bytesperline;
> +
>  	return 0;
>  }
>  
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
