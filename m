Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:45167 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751703AbdBMNmr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 08:42:47 -0500
Date: Mon, 13 Feb 2017 13:42:45 +0000
From: Sean Young <sean@mess.org>
To: vdr@helmutauer.de
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [MEDIA] add device ID to ati remote
Message-ID: <20170213134244.GA18860@gofer.mess.org>
References: <20170127080622.GA4153@mwanda>
 <ae72e45aeea9d3cbead7c50e1cbe4c5b.squirrel@helmutauer.de>
 <33044ec5031546f79ae9d37565240ed3.squirrel@helmutauer.de>
 <cfb14339f809faa9b5e40d2fa53f330b.squirrel@helmutauer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfb14339f809faa9b5e40d2fa53f330b.squirrel@helmutauer.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 07, 2017 at 09:42:47AM +0100, vdr@helmutauer.de wrote:
> 
> Author: Helmut Auer <vdr@xxx.de>
> Date:   Fri Jan 27 19:09:35 2017 +0100
> 
>     Adding 1 device ID to ati_remote driver.

If possible, a more descriptive message would be preferred, e.g. what
device do you have, what branding, what product did it come with.

> 
>     Signed-off-by: Helmut Auer <vdr@xxx.de>

Unless I'm mistaken, contributions can't be anonymous or use a fake email
address.

> 
> diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
> index 0884b7d..83022b1 100644
> --- a/drivers/media/rc/ati_remote.c
> +++ b/drivers/media/rc/ati_remote.c
> @@ -108,6 +108,7 @@
>  #define NVIDIA_REMOTE_PRODUCT_ID       0x0005
>  #define MEDION_REMOTE_PRODUCT_ID       0x0006
>  #define FIREFLY_REMOTE_PRODUCT_ID      0x0008
> +#define REYCOM_REMOTE_PRODUCT_ID       0x000c
> 
>  #define DRIVER_VERSION         "2.2.1"
>  #define DRIVER_AUTHOR           "Torrey Hoffman <thoffman@arnor.net>"
> @@ -227,6 +228,10 @@ static struct usb_device_id ati_remote_table[] = {
>                 USB_DEVICE(ATI_REMOTE_VENDOR_ID, FIREFLY_REMOTE_PRODUCT_ID),
>                 .driver_info = (unsigned long)&type_firefly
>         },
> +       {
> +               USB_DEVICE(ATI_REMOTE_VENDOR_ID, REYCOM_REMOTE_PRODUCT_ID),
> +               .driver_info = (unsigned long)&type_firefly
> +       },
>         {}      /* Terminating entry */
>  };

Your email client replaced all tabs with spaces so the patch no longer
applies.

Thanks,
Sean
