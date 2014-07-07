Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:24723 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaGGTDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jul 2014 15:03:51 -0400
Date: Mon, 07 Jul 2014 16:03:44 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC 1/1] em28xx: fix configuration warning
Message-id: <20140707160344.7e0370a7.m.chehab@samsung.com>
In-reply-to: <1404759115-11029-1-git-send-email-fabf@skynet.be>
References: <1404759115-11029-1-git-send-email-fabf@skynet.be>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabian,

Em Mon, 07 Jul 2014 20:51:55 +0200
Fabian Frederick <fabf@skynet.be> escreveu:

> This patch tries to solve a problem detected with random configuration.
> warning: (VIDEO_EM28XX_V4L2) selects VIDEO_MT9V011 which has unmet direct dependencies (MEDIA_SUPPORT && I2C && VIDEO_V4L2 && MEDIA_CAMERA_SUPPORT)

The above warning is bogus. The thing is that em28xx driver can be
used by webcams, analog TV and/or digital TV.

No idea how to prevent Kbuild to complain about that.

Perhaps something like that will shut it up
	depends on MEDIA_CAMERA_SUPPORT if MEDIA_CAMERA_SUPPORT

Regards,
Mauro

> 
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/media/usb/em28xx/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
> index f5d7198..d42e1de 100644
> --- a/drivers/media/usb/em28xx/Kconfig
> +++ b/drivers/media/usb/em28xx/Kconfig
> @@ -7,6 +7,7 @@ config VIDEO_EM28XX
>  config VIDEO_EM28XX_V4L2
>  	tristate "Empia EM28xx analog TV, video capture and/or webcam support"
>  	depends on VIDEO_EM28XX
> +	depends on MEDIA_CAMERA_SUPPORT
>  	select VIDEOBUF2_VMALLOC
>  	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
>  	select VIDEO_TVP5150 if MEDIA_SUBDRV_AUTOSELECT
