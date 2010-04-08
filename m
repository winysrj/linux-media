Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37629 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933733Ab0DHWsa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Apr 2010 18:48:30 -0400
Date: Fri, 9 Apr 2010 00:48:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
cc: linuxtv-commits@linuxtv.org, Dan Carpenter <error27@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [git:v4l-dvb/master] V4L/DVB: video: comparing unsigned with
 negative 0
In-Reply-To: <E1Nzzyh-0005qv-2x@www.linuxtv.org>
Message-ID: <Pine.LNX.4.64.1004090044150.4621@axis700.grange>
References: <E1Nzzyh-0005qv-2x@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 8 Apr 2010, Mauro Carvalho Chehab wrote:

> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/v4l-dvb.git tree:

Yes, I was going to push this via my tree, but that's even going to be 
faster this way, I forgot, that I can now just ack patches and ask you to 
apply them directly, thanks for picking it up, Mauro! I'm not sure, what's 
meant by "queued" here, but we also want this for "fixes," right? And if 
it's not too late, here goes

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> Subject: V4L/DVB: video: comparing unsigned with negative 0
> Author:  Dan Carpenter <error27@gmail.com>
> Date:    Wed Apr 7 06:41:14 2010 -0300
> 
> soc_mbus_bytes_per_line() returns -EINVAL on error but we store it in an
> unsigned int so the test for less than zero doesn't work.  I think it
> always returns "small" positive values so we can just cast it to int
> here.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  drivers/media/video/sh_mobile_ceu_camera.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/v4l-dvb.git?a=commitdiff;h=ec1e4eee7561bfdd99ef9e212fdb24aab2b224e4
> 
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index cb34e74..a504fa6 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -1632,7 +1632,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
>  	height = pix->height;
>  
>  	pix->bytesperline = soc_mbus_bytes_per_line(width, xlate->host_fmt);
> -	if (pix->bytesperline < 0)
> +	if ((int)pix->bytesperline < 0)
>  		return pix->bytesperline;
>  	pix->sizeimage = height * pix->bytesperline;
>  
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
