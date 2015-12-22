Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59920 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094AbbLVMq2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 07:46:28 -0500
Subject: Re: [PATCH] next: media: cx231xx: add #ifdef to fix compile error
To: Okash Khawaja <okash.khawaja@gmail.com>, mchehab@osg.samsung.com
References: <20151222102721.GA1892@bytefire-computer>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <5679461B.6020402@osg.samsung.com>
Date: Tue, 22 Dec 2015 09:46:19 -0300
MIME-Version: 1.0
In-Reply-To: <20151222102721.GA1892@bytefire-computer>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Okash,

On 12/22/2015 07:27 AM, Okash Khawaja wrote:
> Compiling linux-next gave this warning:
> 
> drivers/media/usb/cx231xx/cx231xx-cards.c: In function
> ‘cx231xx_usb_probe’:
> drivers/media/usb/cx231xx/cx231xx-cards.c:1754:36: error: ‘struct
> cx231xx’ has no member named ‘media_dev’
>   retval = media_device_register(dev->media_dev);
> 
> Looking at the refactoring in past two commits, following seems like a
> decent fix, i.e. to surround dev->media_dev by #ifdef
> CONFIG_MEDIA_CONTROLLER.
> 
> Signed-off-by: Okash Khawaja <okash.khawaja@gmail.com>
> ---
>  drivers/media/usb/cx231xx/cx231xx-cards.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
> index 35692d1..220a5db 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
> @@ -1751,7 +1751,9 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
>  	if (retval < 0)
>  		goto done;
>  
> +#ifdef CONFIG_MEDIA_CONTROLLER
>  	retval = media_device_register(dev->media_dev);
> +#endif
>  
>  done:
>  	if (retval < 0)
>

Thanks for your patch, I've posted the same fix already:

https://lkml.org/lkml/2015/12/21/270

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
