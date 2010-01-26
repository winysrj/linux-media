Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab0AZA4m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 19:56:42 -0500
Date: Tue, 26 Jan 2010 01:56:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, jirislaby@gmail.com,
	Pekka Sarnila <sarnila@adit.fi>
Subject: Re: [PATCH v2 1/1] HID: ignore afatech 9016
In-Reply-To: <1263415146-26321-1-git-send-email-jslaby@suse.cz>
Message-ID: <alpine.LNX.2.00.1001260156010.30977@pobox.suse.cz>
References: <alpine.LNX.2.00.1001132111570.30977@pobox.suse.cz> <1263415146-26321-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 13 Jan 2010, Jiri Slaby wrote:

> Let's ignore the device altogether by the HID layer. It's handled
> by dvb-usb-remote driver already.
> 
> By now, FULLSPEED_INTERVAL quirk was used. It probably made things
> better, but the remote controller was still a perfect X killer.
> This was the last user of the particular quirk. So remove the quirk
> as well.
> 
> With input going through dvb-usb-remote, the remote works
> perfectly.
> 
> The device is 15a4:9016.

Pekka, did you have chance to verify whether it works fine also with your 
version of the remote, or you still need the FULLSPEED_INTERVAL quirk on 
your side?

Thanks.

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Pekka Sarnila <sarnila@adit.fi>
> ---
>  drivers/hid/hid-core.c          |    1 +
>  drivers/hid/usbhid/hid-core.c   |    8 --------
>  drivers/hid/usbhid/hid-quirks.c |    2 --
>  include/linux/hid.h             |    1 -
>  4 files changed, 1 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 08f8f23..0ae0bfd 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1534,6 +1534,7 @@ static const struct hid_device_id hid_ignore_list[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ACECAD, USB_DEVICE_ID_ACECAD_FLAIR) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ACECAD, USB_DEVICE_ID_ACECAD_302) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ADS_TECH, USB_DEVICE_ID_ADS_TECH_RADIO_SI470X) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_AIPTEK, USB_DEVICE_ID_AIPTEK_01) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_AIPTEK, USB_DEVICE_ID_AIPTEK_10) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_AIPTEK, USB_DEVICE_ID_AIPTEK_20) },
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
> index 38773dc..f2ae8a7 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -41,8 +41,6 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RUMBLEPAD, HID_QUIRK_BADPAD },
>  	{ USB_VENDOR_ID_TOPMAX, USB_DEVICE_ID_TOPMAX_COBRAPAD, HID_QUIRK_BADPAD },
>  
> -	{ USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016, HID_QUIRK_FULLSPEED_INTERVAL },
> -
>  	{ USB_VENDOR_ID_PANTHERLORD, USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYSTICK, HID_QUIRK_MULTI_INPUT | HID_QUIRK_SKIP_OUTPUT_REPORTS },
>  	{ USB_VENDOR_ID_PLAYDOTCOM, USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII, HID_QUIRK_MULTI_INPUT },
>  
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 8709365..4a33e16 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -311,7 +311,6 @@ struct hid_item {
>  #define HID_QUIRK_BADPAD			0x00000020
>  #define HID_QUIRK_MULTI_INPUT			0x00000040
>  #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
> -#define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
>  #define HID_QUIRK_NO_INIT_REPORTS		0x20000000
>  
>  /*
> -- 
> 1.6.5.7
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
