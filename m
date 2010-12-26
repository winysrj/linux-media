Return-path: <mchehab@gaivota>
Received: from casper.infradead.org ([85.118.1.10]:54045 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab0LZA62 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Dec 2010 19:58:28 -0500
Message-ID: <4D16932D.7030902@infradead.org>
Date: Sat, 25 Dec 2010 22:58:21 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l: soc-camera: fix multiple simultaneous user case
References: <Pine.LNX.4.64.1012252201520.5248@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1012252201520.5248@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 25-12-2010 19:29, Guennadi Liakhovetski escreveu:
> A recent patch has introduced a regression, whereby a second open of an
> soc-camera video device breaks the running capture. This patch fixes this bug
> by guaranteeing, that video buffers get initialised only during the first open
> of the device node.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> Mauro, please, let's try to get it in 2.6.37, or we'll have to push it to 
> stable after 2.6.37 is out. I'm just posting it quickly and will push it 
> to linuxtv.org like tomorrow or on Monday...

Ok, I've applied it and sent it today to my linux-next tree. Stephen will only 
pull from it at Dec, 27/28, likely in time for the last pull request for .37.

Cheers,
Mauro
> 
>  drivers/media/video/soc_camera.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index 335120c..052bd6d 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -405,13 +405,13 @@ static int soc_camera_open(struct file *file)
>  		ret = soc_camera_set_fmt(icd, &f);
>  		if (ret < 0)
>  			goto esfmt;
> +
> +		ici->ops->init_videobuf(&icd->vb_vidq, icd);
>  	}
>  
>  	file->private_data = icd;
>  	dev_dbg(&icd->dev, "camera device open\n");
>  
> -	ici->ops->init_videobuf(&icd->vb_vidq, icd);
> -
>  	mutex_unlock(&icd->video_lock);
>  
>  	return 0;

