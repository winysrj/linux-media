Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34069 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab2FMWz2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 18:55:28 -0400
Message-ID: <4FD91A5C.9060603@iki.fi>
Date: Thu, 14 Jun 2012 01:55:24 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] dvb_usb_v2 Allow d->props.bInterfaceNumber to set
 the correct  interface.
References: <1339626396.2421.75.camel@Route3278>
In-Reply-To: <1339626396.2421.75.camel@Route3278>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2012 01:26 AM, Malcolm Priestley wrote:
> Although the interface could be set in identify state, ideally it should be done in
> the probe.
>
> Allow d->props.bInterfaceNumber try to set the correct interface rather than return error.
>
>
> Signed-off-by: Malcolm Priestley<tvboxspy@gmail.com>
> ---
>   drivers/media/dvb/dvb-usb/dvb_usb_init.c |   11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-usb/dvb_usb_init.c b/drivers/media/dvb/dvb-usb/dvb_usb_init.c
> index c16a28a..b2eb8ac 100644
> --- a/drivers/media/dvb/dvb-usb/dvb_usb_init.c
> +++ b/drivers/media/dvb/dvb-usb/dvb_usb_init.c
> @@ -391,8 +391,15 @@ int dvb_usbv2_probe(struct usb_interface *intf,
>
>   	if (d->intf->cur_altsetting->desc.bInterfaceNumber !=
>   			d->props.bInterfaceNumber) {
> -		ret = -ENODEV;
> -		goto err_kfree;
> +		usb_reset_configuration(d->udev);
> +
> +		ret = usb_set_interface(d->udev,
> +			d->intf->cur_altsetting->desc.bInterfaceNumber,
> +				d->props.bInterfaceNumber);

I suspect it is wrong, as is changes alternate setting (to the 
bInterfaceNumber given as a property) whilst interface seems to be same 
what I understand. You are confusing with alternate setting and 
interface, right?

http://ftp.au.debian.org/linux-mandocs/2.6.12.6/usb_set_interface.html

After my explanation, are you really sure that this is correct?

USB device could have multiple interfaces. And each interface could have 
multiple alternate settings.

For the DVB device point of view those means generally that if we have 
multiple interfaces those are one for remote and one for DVB. And if we 
have multiple alternate settings inside DVB interface it is selecting 
for USB stream settings (BULK vs. ISOC, different ISOC profiles). That 
kind of alternate setting change belongs to streaming control callback 
of driver.

But I like the idea of switching to correct interface. But I doubt it is 
not possible, as USB core claims interfaces. And my opinion is that 
interface should be added as a USB match flag, instead of that kind 
driver checks.

> +		if (ret<  0) {
> +			ret = -ENODEV;
> +			goto err_kfree;
> +		}
>   	}
>
>   	mutex_init(&d->usb_mutex);

regards
Antti
-- 
http://palosaari.fi/
