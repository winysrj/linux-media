Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4403 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab3KFJI7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 04:08:59 -0500
Message-ID: <527A06F7.4050407@xs4all.nl>
Date: Wed, 06 Nov 2013 10:08:07 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx-video: Swap release order to avoid lock nesting
References: <1383727175-26052-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1383727175-26052-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/06/13 09:39, Ricardo Ribalda Delgado wrote:
> vb2_fop_release might take the video queue mutex lock.
> In order to avoid nesting mutexes the private mutex is taken after the
> fop_release has finished.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-video.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 9d10334..b5c3360 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -1663,8 +1663,8 @@ static int em28xx_v4l2_close(struct file *filp)
>  
>  	em28xx_videodbg("users=%d\n", dev->users);
>  
> -	mutex_lock(&dev->lock);
>  	vb2_fop_release(filp);
> +	mutex_lock(&dev->lock);
>  
>  	if (dev->users == 1) {
>  		/* the device is already disconnect,
> 

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
