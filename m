Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:43192 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaBXSDA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Feb 2014 13:03:00 -0500
Message-ID: <530B8995.8030807@googlemail.com>
Date: Mon, 24 Feb 2014 19:04:05 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] em28xx-cards: don't print a misleading message
References: <20140217200419.GB9845@elgon.mountain>
In-Reply-To: <20140217200419.GB9845@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 17.02.2014 21:04, schrieb Dan Carpenter:
> There were some missing curly braces so it always says that the transfer
> mode changed even if it didn't.

It's not a transfer mode change, it's the initial selection (which never
changes).
The intention of this section is to print which interface (type) is
choosen for analog video.
The same is done for digital video (DVB) a few lines later.
I think we should just switch from info to debug level.

>   Also the indenting uses spaces instead
> of tabs.
Yes, indenting is wrong and that's what causes the confusion here. ;-)

>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 4d97a76cc3b0..e8eedd35eea5 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -3329,10 +3329,11 @@ static int em28xx_usb_probe(struct usb_interface *interface,
>  
>  	/* Select USB transfer types to use */
>  	if (has_video) {
> -	    if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
> -		dev->analog_xfer_bulk = 1;
> -		em28xx_info("analog set to %s mode.\n",
> -			    dev->analog_xfer_bulk ? "bulk" : "isoc");
> +		if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk)) {
> +			dev->analog_xfer_bulk = 1;
> +			em28xx_info("analog set to %s mode.\n",
> +				    dev->analog_xfer_bulk ? "bulk" : "isoc");
Now you will never hit the "isoc" path.

Regards,
Frank

> +		}
>  	}
>  	if (has_dvb) {
>  	    if (!dev->dvb_ep_isoc || (try_bulk && dev->dvb_ep_bulk))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

