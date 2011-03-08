Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:49947 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1CHHTM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 02:19:12 -0500
Date: Tue, 8 Mar 2011 08:19:10 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergio Aguirre <saaguirre@ti.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: soc-camera: Store negotiated buffer settings
In-Reply-To: <1299545388-717-1-git-send-email-saaguirre@ti.com>
Message-ID: <Pine.LNX.4.64.1103080818240.3903@axis700.grange>
References: <1299545388-717-1-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 7 Mar 2011, Sergio Aguirre wrote:

> This fixes the problem in which a host driver
> sets a personalized sizeimage or bytesperline field,
> and gets ignored when doing G_FMT.

Can you tell what that personalised value is? Is it not covered by 
soc_mbus_bytes_per_line()? Maybe something like a JPEG format?

Thanks
Guennadi

> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  drivers/media/video/soc_camera.c |    9 ++++-----
>  include/media/soc_camera.h       |    2 ++
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index a66811b..59dc71d 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -363,6 +363,8 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
>  	icd->user_width		= pix->width;
>  	icd->user_height	= pix->height;
>  	icd->colorspace		= pix->colorspace;
> +	icd->bytesperline	= pix->bytesperline;
> +	icd->sizeimage		= pix->sizeimage;
>  	icd->vb_vidq.field	=
>  		icd->field	= pix->field;
>  
> @@ -608,12 +610,9 @@ static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
>  	pix->height		= icd->user_height;
>  	pix->field		= icd->vb_vidq.field;
>  	pix->pixelformat	= icd->current_fmt->host_fmt->fourcc;
> -	pix->bytesperline	= soc_mbus_bytes_per_line(pix->width,
> -						icd->current_fmt->host_fmt);
> +	pix->bytesperline	= icd->bytesperline;
>  	pix->colorspace		= icd->colorspace;
> -	if (pix->bytesperline < 0)
> -		return pix->bytesperline;
> -	pix->sizeimage		= pix->height * pix->bytesperline;
> +	pix->sizeimage		= icd->sizeimage;
>  	dev_dbg(&icd->dev, "current_fmt->fourcc: 0x%08x\n",
>  		icd->current_fmt->host_fmt->fourcc);
>  	return 0;
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 9386db8..de81370 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -30,6 +30,8 @@ struct soc_camera_device {
>  	s32 user_width;
>  	s32 user_height;
>  	enum v4l2_colorspace colorspace;
> +	__u32 bytesperline;	/* for padding, zero if unused */
> +	__u32 sizeimage;
>  	unsigned char iface;		/* Host number */
>  	unsigned char devnum;		/* Device number per host */
>  	struct soc_camera_sense *sense;	/* See comment in struct definition */
> -- 
> 1.7.1
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
