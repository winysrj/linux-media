Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759908Ab0ECXrR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 May 2010 19:47:17 -0400
Message-ID: <4BDF6061.9040603@redhat.com>
Date: Mon, 03 May 2010 20:46:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: sensoray-dev <linux-dev@sensoray.com>
CC: linux-media@vger.kernel.org
Subject: Re: s2255drv: V4L2_MODE_HIGHQUALITY fix
References: <tkrat.001f6db5e6ea287d@sensoray.com>
In-Reply-To: <tkrat.001f6db5e6ea287d@sensoray.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

sensoray-dev wrote:
> # HG changeset patch
> # User Dean Anderson <linux-dev@sensoray.com>
> # Date 1271371685 25200
> # Node ID fae20d178e2cc96d75a43c50e0f84140022091a3
> # Parent  f12b3074bb02dbb9b9d5af3aa816bd53e6b61dd1
> s2255drv: V4L2 mode high quality fix
> 
> From: Dean Anderson <linux-dev@sensoray.com>
> 
> fix for last patch in case it is applied. submitted incorrect patch (channel/stream).
> 
> Priority: high

Sorry, but it doesn't apply.

> 
> Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
> 
> diff -r f12b3074bb02 -r fae20d178e2c linux/drivers/media/video/s2255drv.c
> --- a/linux/drivers/media/video/s2255drv.c	Thu Apr 15 15:40:56 2010 -0700
> +++ b/linux/drivers/media/video/s2255drv.c	Thu Apr 15 15:48:05 2010 -0700
> @@ -1660,7 +1660,7 @@
>  	}
>  	mode.fdec = fdec;
>  	sp->parm.capture.timeperframe.denominator = def_dem;
> -	stream->cap_parm = sp->parm.capture;
> +	channel->cap_parm = sp->parm.capture;
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
