Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759835Ab0ECXrR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 May 2010 19:47:17 -0400
Message-ID: <4BDF6050.5090207@redhat.com>
Date: Mon, 03 May 2010 20:46:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: sensoray-dev <linux-dev@sensoray.com>
CC: linux-media@vger.kernel.org
Subject: Re: s2255drv: V4L2_MODE_HIGHQUALITY correction
References: <tkrat.ee2f6ea3db309dab@sensoray.com>
In-Reply-To: <tkrat.ee2f6ea3db309dab@sensoray.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

sensoray-dev wrote:
> # HG changeset patch
> # User Dean Anderson <linux-dev@sensoray.com>
> # Date 1271371256 25200
> # Node ID f12b3074bb02dbb9b9d5af3aa816bd53e6b61dd1
> # Parent  bffdebcb994ce8c7e493524087f601f7f1134f09
> s2255drv: fix for V4L2_MODE_HIGHQUALITY
> 
> From: Dean Anderson <linux-dev@sensoray.com>
> 
> V4L2 high quality mode not being saved
> comments about experimental API removed

Sorry, but it doesn't apply.

> 
> Priority: normal
> 
> Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
> 
> diff -r bffdebcb994c -r f12b3074bb02 linux/drivers/media/video/s2255drv.c
> --- a/linux/drivers/media/video/s2255drv.c	Thu Apr 15 08:48:31 2010 -0700
> +++ b/linux/drivers/media/video/s2255drv.c	Thu Apr 15 15:40:56 2010 -0700
> @@ -23,8 +23,6 @@
>   *
>   * -full size, color mode YUYV or YUV422P 1/2 frame rate: all 4 channels
>   *  at once.
> - *  (TODO: Incorporate videodev2 frame rate(FR) enumeration,
> - *  which is currently experimental.)
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -127,7 +125,7 @@
>  #define MASK_COLOR       0x000000ff
>  #define MASK_JPG_QUALITY 0x0000ff00
>  #define MASK_INPUT_TYPE  0x000f0000
> -/* frame decimation. Not implemented by V4L yet(experimental in V4L) */
> +/* frame decimation. */
>  #define FDEC_1		1	/* capture every frame. default */
>  #define FDEC_2		2	/* capture every 2nd frame */
>  #define FDEC_3		3	/* capture every 3rd frame */
> @@ -1662,6 +1660,7 @@
>  	}
>  	mode.fdec = fdec;
>  	sp->parm.capture.timeperframe.denominator = def_dem;
> +	stream->cap_parm = sp->parm.capture;
>  	s2255_set_mode(channel, &mode);
>  	dprintk(4, "%s capture mode, %d timeperframe %d/%d, fdec %d\n",
>  		__func__,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
