Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:55848 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaCGQp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 11:45:29 -0500
Message-ID: <5319F7E4.1000303@googlemail.com>
Date: Fri, 07 Mar 2014 17:46:28 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] [patch] [media] em28xx-cards: remove a wrong indent
 level
References: <20140305110937.GC16926@elgon.mountain>
In-Reply-To: <20140305110937.GC16926@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 05.03.2014 12:09, schrieb Dan Carpenter:
> This code is correct but the indenting is wrong and triggers a static
> checker warning "add curly braces?".
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: in v1 I added curly braces.
>
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 4d97a76cc3b0..33f06ffec4b2 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -3331,8 +3331,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
>  	if (has_video) {
>  	    if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
>  		dev->analog_xfer_bulk = 1;
> -		em28xx_info("analog set to %s mode.\n",
> -			    dev->analog_xfer_bulk ? "bulk" : "isoc");
> +	    em28xx_info("analog set to %s mode.\n",
> +			dev->analog_xfer_bulk ? "bulk" : "isoc");

Instead of moving em28xx_info(...) to the left the if section needs to
be moved to the right:

- 	    if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
- 		dev->analog_xfer_bulk = 1;
+ 		if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
+ 			dev->analog_xfer_bulk = 1;

While you are at it, could you also do fix the indention in the next
paragraph ?
Thanks !

Regards,
Frank

>  	}
>  	if (has_dvb) {
>  	    if (!dev->dvb_ep_isoc || (try_bulk && dev->dvb_ep_bulk))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

