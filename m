Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab1HaUCY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 16:02:24 -0400
Message-ID: <4E5E934A.7000500@redhat.com>
Date: Wed, 31 Aug 2011 17:02:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 16/21] [staging] tm6000: Select interface on first open.
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de> <1312442059-23935-17-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-17-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-08-2011 04:14, Thierry Reding escreveu:
> Instead of selecting the default interface setting when preparing
> isochronous transfers, select it on the first call to open() to make
> sure it is available earlier.

Hmm... I fail to see what this is needed earlier. The ISOC endpont is used
only when the device is streaming.

Did you get any bug related to it? If so, please describe it better.

> ---
>  drivers/staging/tm6000/tm6000-video.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
> index 70fc19e..b59a0da 100644
> --- a/drivers/staging/tm6000/tm6000-video.c
> +++ b/drivers/staging/tm6000/tm6000-video.c
> @@ -595,11 +595,6 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
>  	tm6000_uninit_isoc(dev);
>  	/* Stop interrupt USB pipe */
>  	tm6000_ir_int_stop(dev);
> -
> -	usb_set_interface(dev->udev,
> -			  dev->isoc_in.bInterfaceNumber,
> -			  dev->isoc_in.bAlternateSetting);
> -
>  	/* Start interrupt USB pipe */
>  	tm6000_ir_int_start(dev);
>  
> @@ -1484,6 +1479,18 @@ static int tm6000_open(struct file *file)
>  		break;
>  	}
>  
> +	if (dev->users == 0) {
> +		int err = usb_set_interface(dev->udev,
> +				dev->isoc_in.bInterfaceNumber,
> +				dev->isoc_in.bAlternateSetting);
> +		if (err < 0) {
> +			dev_err(&vdev->dev, "failed to select interface %d, "
> +					"alt. setting %d\n",
> +					dev->isoc_in.bInterfaceNumber,
> +					dev->isoc_in.bAlternateSetting);
> +		}
> +	}
> +
>  	/* If more than one user, mutex should be added */
>  	dev->users++;
>  

