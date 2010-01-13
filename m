Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208Ab0AMUUH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 15:20:07 -0500
Date: Wed, 13 Jan 2010 21:20:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, jirislaby@gmail.com,
	Pekka Sarnila <sarnila@adit.fi>
Subject: Re: [PATCH 1/1] HID: ignore afatech 9016
In-Reply-To: <1263412773-23220-1-git-send-email-jslaby@suse.cz>
Message-ID: <alpine.LNX.2.00.1001132111570.30977@pobox.suse.cz>
References: <1263412773-23220-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


[ Adding Pekka (the author of the patch that added this quirk for AF9016) to 
  CC ... ]

On Wed, 13 Jan 2010, Jiri Slaby wrote:

> Let's ignore the device altogether by HID layer. It's handled by
> dvb-usb-remote driver properly already.
> 
> By now, FULLSPEED_INTERVAL quirk was used. It probably made things
> better, but the remote ctrl was still a perfect X killer. This was
> the last user of the particular quirk. So remove the quirk as well.
> 
> With input going through dvb-usb-remote, the remote works
> perfectly.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/hid/usbhid/hid-core.c   |    8 --------
>  drivers/hid/usbhid/hid-quirks.c |    2 +-
>  include/linux/hid.h             |    1 -
>  3 files changed, 1 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index e2997a8..36a1561 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -938,14 +938,6 @@ static int usbhid_start(struct hid_device *hid)
>  
>  		interval = endpoint->bInterval;
>  
> -		/* Some vendors give fullspeed interval on highspeed devides */
> -		if (hid->quirks & HID_QUIRK_FULLSPEED_INTERVAL &&
> -		    dev->speed == USB_SPEED_HIGH) {
> -			interval = fls(endpoint->bInterval*8);
> -			printk(KERN_INFO "%s: Fixing fullspeed to highspeed interval: %d -> %d\n",
> -			       hid->name, endpoint->bInterval, interval);
> -		}
> -
>  		/* Change the polling interval of mice. */
>  		if (hid->collection->usage == HID_GD_MOUSE && hid_mousepoll_interval > 0)
>  			interval = hid_mousepoll_interval;
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index 38773dc..788d9a3 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -41,7 +41,7 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RUMBLEPAD, HID_QUIRK_BADPAD },
>  	{ USB_VENDOR_ID_TOPMAX, USB_DEVICE_ID_TOPMAX_COBRAPAD, HID_QUIRK_BADPAD },
>  
> -	{ USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016, HID_QUIRK_FULLSPEED_INTERVAL },
> +	{ USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016, HID_QUIRK_IGNORE },

Hmm, why do we keep HID_QUIRK_IGNORE anyway, when we already have generic 
hid_ignore_list[]?

We don't set it for any device in the current codebase any more.

Thanks,x

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
