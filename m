Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:15941 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3JaKjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Oct 2013 06:39:55 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVJ007NH4AI9D00@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Oct 2013 06:39:54 -0400 (EDT)
Date: Thu, 31 Oct 2013 08:39:49 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] em28xx: fix device initialization in
 em28xx_v4l2_open() for radio and VBI mode
Message-id: <20131031083949.742098c3@samsung.com>
In-reply-to: <1381432824-7395-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1381432824-7395-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 10 Oct 2013 21:20:24 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> - bail out on unsupported VFL_TYPE
> - em28xx_set_mode() needs to be called for VBI and radio mode, too
> - em28xx_wake_i2c() needs to be called for VBI and radio mode, too
> - em28xx_resolution_set() also needs to be called for VBI
> 
> Compilation tested only and should be reviewed thoroughly !

Makes sense to me. I don't remember any real issue with radio and I2C
devices, but, in theory, that could happen with xc3028/5000 tuners.

I can't test it right now, through. So, I'll delay it for when I would
have some time for testing.

> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-video.c |   17 +++++++++++------
>  1 Datei geändert, 11 Zeilen hinzugefügt(+), 6 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index fc5d60e..962f4b2 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -1570,13 +1570,16 @@ static int em28xx_v4l2_open(struct file *filp)
>  	case VFL_TYPE_VBI:
>  		fh_type = V4L2_BUF_TYPE_VBI_CAPTURE;
>  		break;
> +	case VFL_TYPE_RADIO:
> +		break;
> +	default:
> +		return -EINVAL;
>  	}
>  
>  	em28xx_videodbg("open dev=%s type=%s users=%d\n",
>  			video_device_node_name(vdev), v4l2_type_names[fh_type],
>  			dev->users);
>  
> -
>  	if (mutex_lock_interruptible(&dev->lock))
>  		return -ERESTARTSYS;
>  	fh = kzalloc(sizeof(struct em28xx_fh), GFP_KERNEL);
> @@ -1590,15 +1593,17 @@ static int em28xx_v4l2_open(struct file *filp)
>  	fh->type = fh_type;
>  	filp->private_data = fh;
>  
> -	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && dev->users == 0) {
> +	if (dev->users == 0) {
>  		em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
> -		em28xx_resolution_set(dev);
>  
> -		/* Needed, since GPIO might have disabled power of
> -		   some i2c device
> +		if (vdev->vfl_type != VFL_TYPE_RADIO)
> +			em28xx_resolution_set(dev);
> +
> +		/*
> +		 * Needed, since GPIO might have disabled power of
> +		 * some i2c devices
>  		 */
>  		em28xx_wake_i2c(dev);
> -
>  	}
>  
>  	if (vdev->vfl_type == VFL_TYPE_RADIO) {


-- 

Cheers,
Mauro
